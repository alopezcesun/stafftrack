/**
 * StaffTrack Local File Server  v2.0
 * Runs on http://localhost:3456
 */

const http = require('http');
const fs   = require('fs');
const path = require('path');
const os   = require('os');

let XLSX = null;
try { XLSX = require('xlsx'); } catch (_) {}

const PORT        = 3456;
const CONFIG_FILE = path.join(__dirname, 'config.json');
const DATA_FILE   = path.join(__dirname, 'attendance-data.json');
const SCHED_LOG   = path.join(__dirname, 'schedule-log.json');

// ── Config ────────────────────────────────────────────────────────────────────
function loadConfig() {
  try {
    if (fs.existsSync(CONFIG_FILE))
      return JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
  } catch (_) {}
  const defaultPath = path.join(os.homedir(), 'Desktop', 'StaffTrack');
  const cfg = {
    savePath: defaultPath,
    schedEnabled: false,
    schedTime: '18:00',
    schedFilename: 'StaffTrack_Daily',
    schedAppendDate: true,
    schedLastRun: null
  };
  saveConfig(cfg);
  return cfg;
}

function saveConfig(cfg) {
  fs.writeFileSync(CONFIG_FILE, JSON.stringify(cfg, null, 2));
}

// ── Schedule log ──────────────────────────────────────────────────────────────
function loadSchedLog() {
  try {
    if (fs.existsSync(SCHED_LOG))
      return JSON.parse(fs.readFileSync(SCHED_LOG, 'utf8'));
  } catch (_) {}
  return [];
}

function appendSchedLog(entry) {
  const log = loadSchedLog();
  log.unshift(entry);
  fs.writeFileSync(SCHED_LOG, JSON.stringify(log.slice(0, 90), null, 2));
}

// ── Attendance data ───────────────────────────────────────────────────────────
function loadAttendanceData() {
  try {
    if (fs.existsSync(DATA_FILE))
      return JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
  } catch (_) {}
  return null;
}

function saveAttendanceData(data) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
}

// ── Helpers ───────────────────────────────────────────────────────────────────
function dateStr(d)  { return (d || new Date()).toISOString().slice(0, 10); }
function timeStr(d)  { return (d || new Date()).toTimeString().slice(0, 5); }
function nowISO()    { return new Date().toISOString(); }
function sanitize(n) { return path.basename(n).replace(/[<>:"/\\|?*\x00-\x1f]/g, '_'); }
function ensureDir(p) {
  if (!fs.existsSync(p)) { fs.mkdirSync(p, { recursive: true }); console.log('📁  Created: ' + p); }
}

// ── Build Excel from snapshot ─────────────────────────────────────────────────
function buildExcelBuffer(snapshot) {
  if (!XLSX) return null;
  const logs  = snapshot.logs  || [];
  const areas = snapshot.areas || [];

  function fmt(iso) {
    if (!iso) return '—';
    const d = new Date(iso);
    return d.toLocaleDateString('en-US', { month:'short', day:'numeric', year:'numeric' })
      + ' ' + d.toLocaleTimeString('en-US', { hour:'2-digit', minute:'2-digit' });
  }
  function dur(a, b) {
    if (!a || !b) return '—';
    const ms = new Date(b) - new Date(a);
    const h  = Math.floor(ms / 3600000);
    const m  = Math.floor((ms % 3600000) / 60000);
    return h > 0 ? h + 'h ' + m + 'm' : m + 'm';
  }
  function toDate(iso) { return iso ? new Date(iso).toLocaleDateString('en-CA') : ''; }

  const rows = logs.map(l => ({
    'Employee No':   l.empNo,
    'Employee Name': l.empName,
    'Area':          l.area,
    'Check In':      fmt(l.inTime),
    'Check Out':     fmt(l.outTime),
    'Duration':      dur(l.inTime, l.outTime),
    'Status':        l.outTime ? 'Checked Out' : 'Checked In'
  }));

  const ws = XLSX.utils.json_to_sheet(rows);
  ws['!cols'] = [{wch:14},{wch:24},{wch:14},{wch:22},{wch:22},{wch:12},{wch:14}];

  const td = dateStr();
  const sumRows = areas.map(a => ({
    'Area':              a,
    'Currently Present': logs.filter(l => l.area===a && !l.outTime && toDate(l.inTime)===td).length,
    'Check-ins Today':   logs.filter(l => l.area===a && toDate(l.inTime)===td).length,
    'Total Records':     logs.filter(l => l.area===a).length,
  }));
  const ws2 = XLSX.utils.json_to_sheet(sumRows);
  ws2['!cols'] = [{wch:20},{wch:18},{wch:18},{wch:14}];

  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws,  'Attendance Log');
  XLSX.utils.book_append_sheet(wb, ws2, 'Summary by Area');
  return XLSX.write(wb, { bookType: 'xlsx', type: 'buffer' });
}

// ── Scheduled export ──────────────────────────────────────────────────────────
function runScheduledExport(reason) {
  const cfg      = loadConfig();
  const snapshot = loadAttendanceData();
  const now      = new Date();
  console.log('\n⏰  [' + now.toLocaleTimeString() + '] Running ' + (reason||'scheduled') + ' export...');

  if (!snapshot) {
    const msg = 'No attendance snapshot — open the app to sync data.';
    console.warn('⚠️  ' + msg);
    appendSchedLog({ ts: nowISO(), status: 'skipped', reason: msg });
    return;
  }

  const base     = cfg.schedFilename || 'StaffTrack_Daily';
  const fname    = sanitize((cfg.schedAppendDate !== false ? base + '_' + dateStr(now) : base) + '.xlsx');
  const savePath = cfg.savePath;

  try {
    ensureDir(savePath);
    const fullPath = path.join(savePath, fname);
    const buf = buildExcelBuffer(snapshot);

    if (buf) {
      fs.writeFileSync(fullPath, buf);
      const kb = (buf.length / 1024).toFixed(1);
      console.log('✅  Scheduled export → ' + fullPath + '  (' + kb + ' KB)');
      appendSchedLog({ ts: nowISO(), status: 'ok', path: fullPath, filename: fname, kb });
    } else {
      const note = 'xlsx package not installed.\nRun: npm install xlsx\nthen restart the server.';
      const notePath = path.join(savePath, 'INSTALL_XLSX_' + dateStr(now) + '.txt');
      fs.writeFileSync(notePath, note);
      console.warn('⚠️  xlsx not installed. See: ' + notePath);
      appendSchedLog({ ts: nowISO(), status: 'needs-xlsx', path: notePath });
    }
  } catch (e) {
    console.error('❌  Scheduled export error:', e.message);
    appendSchedLog({ ts: nowISO(), status: 'error', error: e.message });
  }

  const cfg2 = loadConfig();
  cfg2.schedLastRun = dateStr(now);
  saveConfig(cfg2);
}

// ── Scheduler tick (every 30s) ────────────────────────────────────────────────
let lastFiredMinute = '';

function schedulerTick() {
  const cfg = loadConfig();
  if (!cfg.schedEnabled || !cfg.schedTime) return;
  const now   = new Date();
  const nowHM = timeStr(now);
  const today = dateStr(now);
  if (nowHM === cfg.schedTime && cfg.schedLastRun !== today && lastFiredMinute !== nowHM) {
    lastFiredMinute = nowHM;
    runScheduledExport('scheduled');
  }
}

setInterval(schedulerTick, 30000);

// ── CORS ──────────────────────────────────────────────────────────────────────
function cors(res) {
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, X-Filename, X-Save-Path');
}

function collectBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on('data', c => chunks.push(c));
    req.on('end',  () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

// ── HTTP Server ───────────────────────────────────────────────────────────────
const server = http.createServer(async (req, res) => {
  cors(res);
  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }
  const url = req.url.split('?')[0];

  // GET /status
  if (req.method === 'GET' && url === '/status') {
    const cfg = loadConfig();
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      ok: true, savePath: cfg.savePath, version: '2.0.0',
      schedEnabled: cfg.schedEnabled, schedTime: cfg.schedTime,
      schedFilename: cfg.schedFilename, schedAppendDate: cfg.schedAppendDate,
      schedLastRun: cfg.schedLastRun,
      recentLog: loadSchedLog().slice(0, 10),
      xlsxAvailable: !!XLSX
    }));
    return;
  }

  // POST /config
  if (req.method === 'POST' && url === '/config') {
    try {
      const data = JSON.parse((await collectBody(req)).toString());
      const cfg  = loadConfig();
      if (data.savePath        !== undefined) cfg.savePath        = data.savePath;
      if (data.schedEnabled    !== undefined) cfg.schedEnabled    = data.schedEnabled;
      if (data.schedTime       !== undefined) cfg.schedTime       = data.schedTime;
      if (data.schedFilename   !== undefined) cfg.schedFilename   = data.schedFilename;
      if (data.schedAppendDate !== undefined) cfg.schedAppendDate = data.schedAppendDate;
      saveConfig(cfg);
      console.log('⚙️  Config updated → sched=' + cfg.schedEnabled + ' time=' + cfg.schedTime + ' path=' + cfg.savePath);
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ok: true }));
    } catch (e) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ok: false, error: e.message }));
    }
    return;
  }

  // POST /save  — manual/on-demand export from browser
  if (req.method === 'POST' && url === '/save') {
    try {
      const body     = await collectBody(req);
      const cfg      = loadConfig();
      const hPath    = req.headers['x-save-path'];
      const savePath = (hPath && hPath.trim()) ? hPath.trim() : cfg.savePath;
      ensureDir(savePath);
      const filename = sanitize(req.headers['x-filename'] || ('StaffTrack_' + dateStr() + '.xlsx'));
      const fullPath = path.join(savePath, filename);
      fs.writeFileSync(fullPath, body);
      console.log('✅  Saved → ' + fullPath + '  (' + (body.length/1024).toFixed(1) + ' KB)');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ok: true, path: fullPath, filename }));
    } catch (e) {
      console.error('❌  Save error:', e.message);
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ok: false, error: e.message }));
    }
    return;
  }

  // POST /data  — attendance snapshot pushed from browser for scheduled exports
  if (req.method === 'POST' && url === '/data') {
    try {
      const data = JSON.parse((await collectBody(req)).toString());
      saveAttendanceData(data);
      console.log('📊  Snapshot updated (' + (data.logs||[]).length + ' records)');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ok: true, records: (data.logs||[]).length }));
    } catch (e) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ok: false, error: e.message }));
    }
    return;
  }

  // POST /run-now  — trigger immediate export
  if (req.method === 'POST' && url === '/run-now') {
    runScheduledExport('manual');
    const cfg = loadConfig();
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: true, message: 'Export triggered', savePath: cfg.savePath }));
    return;
  }

  // GET /schedule-log
  if (req.method === 'GET' && url === '/schedule-log') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: true, log: loadSchedLog() }));
    return;
  }

  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ ok: false, error: 'Not found' }));
});

// ── Start ─────────────────────────────────────────────────────────────────────
server.listen(PORT, '127.0.0.1', () => {
  const cfg = loadConfig();
  const schedStr = cfg.schedEnabled ? 'ENABLED  daily at ' + cfg.schedTime : 'DISABLED';
  console.log('');
  console.log('┌────────────────────────────────────────────────────┐');
  console.log('│       StaffTrack Local File Server  v2.0           │');
  console.log('├────────────────────────────────────────────────────┤');
  console.log('│  Listening on  http://localhost:' + PORT + '               │');
  console.log('│  Save path:  ' + cfg.savePath.substring(0,36).padEnd(36) + '  │');
  console.log('│  Scheduler:  ' + schedStr.substring(0,36).padEnd(36) + '  │');
  console.log('├────────────────────────────────────────────────────┤');
  console.log('│  Open index.html in browser  |  Ctrl+C to stop     │');
  console.log('└────────────────────────────────────────────────────┘');
  console.log('');
  if (!XLSX) {
    console.log('💡  TIP: Run  npm install xlsx  to enable server-side scheduled exports.');
    console.log('');
  }
  schedulerTick();
});

server.on('error', e => {
  if (e.code === 'EADDRINUSE') {
    console.error('\n❌  Port ' + PORT + ' is already in use. Close the other window and retry.\n');
  } else { console.error('Server error:', e); }
  process.exit(1);
});
