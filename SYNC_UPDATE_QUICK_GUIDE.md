## 🎯 QUICK UPDATE: Multi-Device Sync for StaffTrack

Your app is live! Here's how to enable real-time multi-device sync:

### **STEP 1: Open index.html**
- File: `c:\stafftrack-local\index.html`
- Open in Notepad++ or VS Code
- Use Ctrl+G to go to line: **2066**

### **STEP 2: Find This Section**
```
// ═══════════════════════════════════════
//  FIREBASE REALTIME SYNC
// ═══════════════════════════════════════
let firebaseDB=null;
let isSyncingFromServer=false;

function initFirebase(){
```

### **STEP 3: Replace With This**
Copy everything from `c:\stafftrack-local\FIREBASE_SYNC_CODE.js` and replace the Firebase sync section.

**Lines to REPLACE:** 2060-2118
**Lines to KEEP:** Everything before and after

### **STEP 4: Save & Deploy**
```powershell
cd C:\stafftrack-local
git add index.html
git commit -m "Enable multi-device sync"
git push origin main
```

### **STEP 5: Update Firebase Rules** 
Go to Firebase Console → Realtime Database → Rules → Paste this:

```json
{
  "rules": {
    "stafftrack": {
      ".read": true,
      ".write": true,
      "emps": { ".indexOn": ["no"] },
      "logs": { ".indexOn": ["empNo"] },
      "users": { ".indexOn": ["username"] }
    }
  }
}
```
Click **Publish**

---

## ✅ Done!

Now all devices will sync automatically in **real-time**!

**Test it:**
1. Open on Computer: `https://your-username.github.io/stafftrack/`
2. Open on Phone: Same URL
3. Add employee on Computer
4. See it instantly on Phone (no refresh needed!)

---

## 📁 Files to Reference

- **FIREBASE_SYNC_CODE.js** - The new Firebase code to insert
- **MULTI_DEVICE_SYNC_GUIDE.md** - Detailed instructions
- **index.html** - Your main app (lines 2066-2118 to replace)
