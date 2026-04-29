# StaffTrack — Local Version Setup

This version saves Excel exports **directly to a folder on your computer** using a small local server companion.

---

## Requirements

- **Node.js** (free) — download from https://nodejs.org  
  Choose the **LTS** version. Install with all defaults.

---

## How to Start (Windows)

1. Open the `stafftrack-local` folder
2. **Double-click `START-SERVER.bat`**  
   A black terminal window will open — keep it running in the background
3. Open `index.html` in your browser (Chrome, Edge, or Firefox)
4. Log in — you'll see a **green "Local server connected"** badge in the top bar

That's it. Every time you export, the file goes straight to your configured folder.

---

## How to Start (Mac / Linux)

1. Open Terminal
2. `cd` into the `stafftrack-local` folder
3. Run: `bash start-server.sh`  
   Keep the terminal open while using the app
4. Open `index.html` in your browser

---

## Configuring the Save Folder

1. In StaffTrack, go to **Settings → File Save Settings**
2. Enter your desired path in the **Save Path** field, e.g.:
   - Windows: `C:\Users\Abraham\Documents\StaffTrack`
   - Mac:      `/Users/abraham/Documents/StaffTrack`
3. Click **Save Settings**
4. The server will create the folder automatically if it doesn't exist

---

## What the Server Does

The server (`server.js`) is a tiny local HTTP server that:
- Listens only on `localhost:3456` — not accessible from the internet
- Receives Excel files sent by the app
- Writes them to your configured folder
- Creates the folder if it doesn't exist
- Has no dependencies — uses only built-in Node.js modules

---

## Folder Structure

```
stafftrack-local/
├── index.html          ← The app (open this in your browser)
├── server.js           ← Local file-save server
├── package.json        ← Node.js project info
├── config.json         ← Auto-created: stores your save path
├── START-SERVER.bat    ← Windows: double-click to start
├── start-server.sh     ← Mac/Linux: run in terminal
└── README.md           ← This file
```

---

## Troubleshooting

| Problem | Solution |
|---|---|
| Red/amber badge — server not connected | Make sure you double-clicked `START-SERVER.bat` and the window is still open |
| "Port 3456 already in use" | Another instance is running — close extra terminal windows |
| Files not appearing in folder | Check the Save Path in Settings — make sure it's a valid path |
| Node.js not found | Install from https://nodejs.org (LTS version) |
| Antivirus blocks server | Add an exception for `node.exe` or the stafftrack-local folder |

---

## Auto-start on Windows Boot (optional)

To have the server start automatically when Windows starts:

1. Press `Win + R`, type `shell:startup`, press Enter
2. Create a shortcut to `START-SERVER.bat` in that folder
3. The server will now start silently every time you log in
