# Update Firebase Sync Code in index.html
$file = "c:\stafftrack-local\index.html"
$content = Get-Content $file -Raw

# Replace initFirebase function
$oldInitFirebase = @"
function initFirebase(){
  try{
    // Get Firebase config from script tag or use defaults
    const configEl=document.querySelector('script[type="application/json"][id="firebase-config"]');
    let config=null;
    if(configEl){
      try{config=JSON.parse(configEl.textContent);}catch(e){}
    }
    if(!config||!config.databaseURL){
      console.log('Firebase: Config not set. Using local storage only.');
      return;
    }
    // If you want to use the Firebase Realtime Database, uncomment the code below
    // For now, we're using the config that was already initialized at the top of the file
    console.log('Firebase Realtime Database configured. Data will sync every 15 seconds.');
  }catch(e){
    console.warn('Firebase init error:',e);
  }
}
"@

$newInitFirebase = @"
function initFirebase(){
  try{
    if(!window.app){console.log('Firebase app not initialized');return;}
    import('https://www.gstatic.com/firebasejs/12.12.1/firebase-database.js').then(({getDatabase,ref,onValue})=>{
      import('https://www.gstatic.com/firebasejs/12.12.1/firebase-auth.js').then(({getAuth,signInAnonymously,onAuthStateChanged})=>{
        window.firebaseDB=getDatabase(window.app);
        window.firebaseAuth=getAuth(window.app);
        signInAnonymously(window.firebaseAuth).catch(e=>console.log('Auth:',e));
        onAuthStateChanged(window.firebaseAuth,(user)=>{
          if(user){window.currentUser=user;console.log('✓ Firebase authenticated');setupRealtimeListeners();}
        });
      });
    });
  }catch(e){console.warn('Firebase init error:',e);}
}

function setupRealtimeListeners(){
  if(!window.firebaseDB||!window.currentUser)return;
  import('https://www.gstatic.com/firebasejs/12.12.1/firebase-database.js').then(({ref,onValue})=>{
    // Listen for employees
    onValue(ref(window.firebaseDB,'stafftrack/emps'),(snap)=>{
      if(isSyncingFromServer)return;
      if(snap.val()){isSyncingFromServer=true;sv(K.emps,snap.val());renderEmployees();refreshAll();isSyncingFromServer=false;}
    });
    // Listen for logs
    onValue(ref(window.firebaseDB,'stafftrack/logs'),(snap)=>{
      if(isSyncingFromServer)return;
      if(snap.val()){isSyncingFromServer=true;sv(K.logs,snap.val());renderLog();refreshAll();isSyncingFromServer=false;}
    });
    // Listen for users
    onValue(ref(window.firebaseDB,'stafftrack/users'),(snap)=>{
      if(isSyncingFromServer)return;
      if(snap.val()){isSyncingFromServer=true;sv(K.users,snap.val());if(document.getElementById('user-list'))renderUserList();isSyncingFromServer=false;}
    });
    // Listen for areas
    onValue(ref(window.firebaseDB,'stafftrack/areas'),(snap)=>{
      if(isSyncingFromServer)return;
      if(snap.val()){isSyncingFromServer=true;sv(K.areas,snap.val());populateAreaSelects();isSyncingFromServer=false;}
    });
    console.log('✓ Real-time listeners active');
  });
}
"@

# Replace syncToFirebase function
$oldSyncToFirebase = @"
function syncToFirebase(){
  try{
    // Get all data from localStorage
    const data={
      emps:ld(K.emps)||[],
      logs:ld(K.logs)||[],
      areas:ld(K.areas)||[],
      sessions:ld(K.sessions)||[],
      timestamp:new Date().toISOString()
    };
    // In production, you would send this to Firebase Realtime Database
    // Example: firebase.database().ref('stafftrack/'+userId).set(data)
    // For now, this is stored locally
    console.log('Data ready for Firebase sync',Object.keys(data));
  }catch(e){
    console.warn('Sync error:',e);
  }
}
"@

$newSyncToFirebase = @"
function syncToFirebase(){
  if(!window.firebaseDB||!window.currentUser||isSyncingFromServer)return;
  const updates={};
  if(ld(K.emps))updates['stafftrack/emps']=ld(K.emps);
  if(ld(K.logs))updates['stafftrack/logs']=ld(K.logs);
  if(ld(K.users))updates['stafftrack/users']=ld(K.users);
  if(ld(K.areas))updates['stafftrack/areas']=ld(K.areas);
  if(Object.keys(updates).length>0){
    import('https://www.gstatic.com/firebasejs/12.12.1/firebase-database.js').then(({update,ref})=>{
      update(ref(window.firebaseDB),updates).catch(e=>console.log('Sync error'));
    });
  }
}
"@

# Apply replacements
$content = $content -replace [regex]::Escape($oldInitFirebase), $newInitFirebase
$content = $content -replace [regex]::Escape($oldSyncToFirebase), $newSyncToFirebase

# Save file
Set-Content $file $content
Write-Host "✓ Firebase sync functions updated" -ForegroundColor Green
Write-Host "✓ Multi-device and user sync enabled" -ForegroundColor Green
