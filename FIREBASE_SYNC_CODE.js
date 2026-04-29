// Multi-Device & User Sync Update
// Insert this into index.html after line 2057 (after the Employee Editing section)
// Replace the initFirebase, setupRealtimeListeners, and syncToFirebase functions

// ═══════════════════════════════════════
//  FIREBASE REALTIME SYNC
// ═══════════════════════════════════════
let firebaseDB=null;
let isSyncingFromServer=false;

// Import Firebase Database and Auth libraries
import { getDatabase, ref, set, onValue, update } from "https://www.gstatic.com/firebasejs/12.12.1/firebase-database.js";
import { getAuth, signInAnonymously, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/12.12.1/firebase-auth.js";

function initFirebase(){
  try{
    if(!window.app){
      console.log('Firebase app not initialized');
      return;
    }
    // Get Database and Auth
    const db=getDatabase(window.app);
    const auth=getAuth(window.app);
    
    window.firebaseDB=db;
    window.firebaseAuth=auth;
    
    // Anonymous auth for real-time database
    signInAnonymously(auth).catch(e=>console.log('Auth error:',e));
    
    // Setup listeners when authenticated
    onAuthStateChanged(auth,(user)=>{
      if(user){
        window.currentUser=user;
        console.log('✓ Firebase multi-device sync ready');
        setupRealtimeListeners();
      }
    });
  }catch(e){
    console.warn('Firebase init error:',e);
  }
}

function setupRealtimeListeners(){
  if(!window.firebaseDB||!window.currentUser)return;
  try{
    // EMPLOYEES - Real-time sync from all devices
    const empsRef=ref(window.firebaseDB,'stafftrack/emps');
    onValue(empsRef,(snapshot)=>{
      if(isSyncingFromServer)return;
      const data=snapshot.val();
      if(data){
        isSyncingFromServer=true;
        sv(K.emps,data);
        renderEmployees();
        refreshAll();
        isSyncingFromServer=false;
        console.log('✓ Employees synced');
      }
    });
    
    // LOGS - Real-time sync from all devices
    const logsRef=ref(window.firebaseDB,'stafftrack/logs');
    onValue(logsRef,(snapshot)=>{
      if(isSyncingFromServer)return;
      const data=snapshot.val();
      if(data){
        isSyncingFromServer=true;
        sv(K.logs,data);
        renderLog();
        refreshAll();
        isSyncingFromServer=false;
        console.log('✓ Logs synced');
      }
    });
    
    // USERS - Real-time sync from all devices
    const usersRef=ref(window.firebaseDB,'stafftrack/users');
    onValue(usersRef,(snapshot)=>{
      if(isSyncingFromServer)return;
      const data=snapshot.val();
      if(data){
        isSyncingFromServer=true;
        sv(K.users,data);
        if(document.getElementById('user-list'))renderUserList();
        isSyncingFromServer=false;
        console.log('✓ Users synced');
      }
    });
    
    // AREAS - Real-time sync from all devices
    const areasRef=ref(window.firebaseDB,'stafftrack/areas');
    onValue(areasRef,(snapshot)=>{
      if(isSyncingFromServer)return;
      const data=snapshot.val();
      if(data){
        isSyncingFromServer=true;
        sv(K.areas,data);
        populateAreaSelects();
        isSyncingFromServer=false;
        console.log('✓ Areas synced');
      }
    });
    
    console.log('✓ Multi-device listeners activated');
  }catch(e){
    console.warn('Listener error:',e);
  }
}

function syncToFirebase(){
  if(!window.firebaseDB||!window.currentUser||isSyncingFromServer)return;
  try{
    const updates={};
    
    // Sync employees
    const emps=ld(K.emps);
    if(emps)updates['stafftrack/emps']=emps;
    
    // Sync logs
    const logs=ld(K.logs);
    if(logs)updates['stafftrack/logs']=logs;
    
    // Sync users
    const users=ld(K.users);
    if(users)updates['stafftrack/users']=users;
    
    // Sync areas
    const areas=ld(K.areas);
    if(areas)updates['stafftrack/areas']=areas;
    
    // Send to Firebase
    if(Object.keys(updates).length>0){
      update(ref(window.firebaseDB),updates).then(()=>{
        console.log('✓ Data synced to Firebase');
      }).catch(e=>{
        console.warn('Sync failed:',e);
      });
    }
  }catch(e){
    console.warn('Sync error:',e);
  }
}

// Auto-sync every 15 seconds
setInterval(()=>{
  syncToFirebase();
},15000);

// Manual sync button
function manualSyncNow(){
  syncToFirebase();
  const msg=document.getElementById('settings-msg');
  if(msg)showMsg(msg,'Data synced to cloud!','ok');
}
