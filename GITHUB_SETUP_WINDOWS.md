# 🚀 GitHub Deployment Setup — Step by Step for Windows

**This guide will get your StaffTrack app live on GitHub in about 10 minutes.**

---

## ✅ **What You'll Do**

1. ✅ Create GitHub account (2 minutes)
2. ✅ Get Firebase config (2 minutes)
3. ✅ Update index.html with Firebase credentials (2 minutes)
4. ✅ Run deployment script (3 minutes)
5. ✅ Your app is LIVE on the internet! 🎉

---

## 📋 **Prerequisites**

Make sure you have:
- [ ] **GitHub Account** — [Sign up free at github.com](https://github.com)
- [ ] **Git installed** — [Download from git-scm.com](https://git-scm.com/download/win)

**Verify Git is installed:**
```powershell
git --version
```

If you see a version number, you're good!

---

## 🔧 **Step 1: Get Your Firebase Config**

### **1A. Go to Firebase Console**
1. Open [firebase.google.com](https://firebase.google.com)
2. Click **"Go to console"** (top right)
3. Click **"Add project"**
4. Enter project name: `stafftrack`
5. Click **Create project**
6. Wait 1-2 minutes for creation

### **1B. Set Up Realtime Database**
1. In Firebase Console, click **"Realtime Database"** (left sidebar)
2. Click **"Create Database"**
3. Choose:
   - Region: `us-central1`
   - **Start in test mode** (for now)
4. Click **Enable**

### **1C: Get Your Config Keys**
1. Click the **⚙️ Gear icon** (Project Settings)
2. Find this section and look for your **config code**:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY_HERE",
  authDomain: "YOUR_PROJECT.firebaseapp.com",
  databaseURL: "https://YOUR_PROJECT.firebaseio.com",
  projectId: "YOUR_PROJECT",
  storageBucket: "YOUR_PROJECT.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};
```

**Copy this entire config** — you'll need it in Step 3.

---

## 🔑 **Step 2: Create GitHub Repository**

### **2A. Create Repo on GitHub**
1. Go to [github.com/new](https://github.com/new)
2. Fill in:
   - **Repository name:** `stafftrack` (must be lowercase)
   - **Description:** "Employee Check-In System"
   - **Public** (required for GitHub Pages)
   - **DO NOT** check "Initialize with README"
3. Click **"Create repository"**

**You'll see this page with commands — keep it open!**

---

## 📝 **Step 3: Update Firebase Config in index.html**

1. Open `c:\stafftrack-local\index.html` in Notepad (or VS Code)
2. Press **Ctrl+F** and search for: `YOUR_PROJECT`
3. You'll find this section near the top of the file:

```html
<!-- Firebase Configuration Placeholder -->
<script id="firebase-config" type="application/json">
{
  "apiKey": "YOUR_API_KEY_HERE",
  "authDomain": "YOUR_PROJECT.firebaseapp.com",
  "databaseURL": "https://YOUR_PROJECT.firebaseio.com",
  "projectId": "YOUR_PROJECT",
  "storageBucket": "YOUR_PROJECT.appspot.com",
  "messagingSenderId": "YOUR_SENDER_ID",
  "appId": "YOUR_APP_ID"
}
</script>
```

4. **Replace with your actual Firebase config** from Step 1C
5. **Save the file** (Ctrl+S)

**Example of filled-in config:**
```html
<script id="firebase-config" type="application/json">
{
  "apiKey": "AIzaSyD1234567890abcdefghijk",
  "authDomain": "stafftrack-12345.firebaseapp.com",
  "databaseURL": "https://stafftrack-12345.firebaseio.com",
  "projectId": "stafftrack-12345",
  "storageBucket": "stafftrack-12345.appspot.com",
  "messagingSenderId": "123456789",
  "appId": "1:123456789:web:abcdefgh1234567"
}
</script>
```

---

## 🚀 **Step 4: Run Deployment Script**

### **4A. Download the deployment script**

Save this as a file named **`DEPLOY.ps1`** in `c:\stafftrack-local\` folder:

```powershell
# StaffTrack GitHub Deployment Script
# Run in PowerShell as Administrator

$REPO_URL = "YOUR_GITHUB_REPO_URL_HERE"
$REPO_DIR = "C:\stafftrack-local"

# Navigate to repo folder
Set-Location $REPO_DIR

Write-Host "🔄 Initializing Git..." -ForegroundColor Cyan
git init
git add .
git commit -m "Initial commit: StaffTrack with Firebase integration"

Write-Host "🔗 Adding GitHub remote..." -ForegroundColor Cyan
git remote add origin $REPO_URL

Write-Host "📤 Pushing to GitHub (this may prompt for authentication)..." -ForegroundColor Cyan
git branch -M main
git push -u origin main

Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "⏳ Wait 2-3 minutes for GitHub Pages to build..." -ForegroundColor Yellow
Write-Host "🌐 Your site will be available at: https://YOUR-USERNAME.github.io/stafftrack/" -ForegroundColor Green

Pause
```

### **4B. Get Your Repository URL**

1. Go back to your GitHub repo page (from Step 2A)
2. Click **"Code"** (green button, top right)
3. Copy the HTTPS URL (like `https://github.com/YOUR-USERNAME/stafftrack.git`)
4. Replace `YOUR_GITHUB_REPO_URL_HERE` in the script above with this URL

**Example:**
```powershell
$REPO_URL = "https://github.com/john-smith/stafftrack.git"
```

### **4C. Run the Script**

1. Open **PowerShell** (right-click → "Run as Administrator")
2. Run:
```powershell
cd C:\stafftrack-local
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\DEPLOY.ps1
```

3. **If prompted for GitHub password:** Use a Personal Access Token instead:
   - Go to GitHub → Settings → Developer settings → Personal access tokens
   - Click "Generate new token"
   - Check `repo` scope
   - Copy the token
   - Paste as password when prompted

**Script will:**
- ✅ Initialize Git
- ✅ Add all files
- ✅ Commit changes
- ✅ Push to GitHub
- ✅ Tell you when it's done

---

## 🎯 **Step 5: Enable GitHub Pages**

1. Go to your GitHub repo
2. Click **Settings** (top right)
3. Click **Pages** (left sidebar)
4. Under "Build and deployment":
   - **Source:** Select "Deploy from a branch"
   - **Branch:** Select `main` / `/(root)`
5. Click **Save**

**Wait 2-3 minutes** — GitHub builds your site

Your app is now live at:
```
https://YOUR-USERNAME.github.io/stafftrack/
```

**Test it:**
1. Open the URL in your browser
2. Login with: `admin` / `password123`
3. Add an employee
4. Check Firebase Console to see data syncing! ✅

---

## 🔄 **Making Changes After Deployment**

Every time you want to update your app:

```powershell
cd C:\stafftrack-local
git add .
git commit -m "Describe your changes here"
git push origin main
```

GitHub automatically redeploys your site within 2-3 minutes!

---

## 📱 **Test Multi-Device Access**

### **Device 1 (Your Work PC):**
1. Open `https://YOUR-USERNAME.github.io/stafftrack/`
2. Login: `admin` / `password123`
3. Add employee "Test Device 1"
4. Close browser

### **Device 2 (Your Phone/Tablet on 4G):**
1. Open same URL
2. Login
3. **See "Test Device 1" already in list!** ✅ Cloud sync works!
4. Check them in
5. Close browser

### **Back to Device 1:**
1. Refresh browser
2. **See check-in recorded!** ✅ Multi-device sync works!

---

## 🐛 **Troubleshooting**

### **Problem: "Git is not recognized"**
- **Solution:** Install Git from [git-scm.com](https://git-scm.com/download/win)
- Restart PowerShell after installation

### **Problem: GitHub pages shows 404**
- **Solution:** 
  - Wait 3-5 minutes after first push
  - Check Settings → Pages is enabled
  - Verify branch is `main`
  - Check repository is **public**

### **Problem: Data not syncing**
- **Solution:**
  - Check Firebase config in index.html is correct
  - Open browser console (F12) → look for Firebase errors
  - Check Firebase Database has data: Console → Realtime Database → Data tab

### **Problem: "Authentication failed"**
- **Solution:**
  - Use Personal Access Token instead of password
  - Or use SSH key for authentication

### **Problem: "fatal: could not read Username"**
- **Solution:** In PowerShell, run:
```powershell
git config --global credential.helper store
```

Then run the deployment script again.

---

## 🔐 **Security: Protect Your Firebase**

### **Set Security Rules:**

1. Firebase Console → Realtime Database → **Rules** tab
2. Replace with:

```json
{
  "rules": {
    "stafftrack": {
      ".read": true,
      ".write": true,
      ".validate": "newData.val() != null"
    }
  }
}
```

3. Click **Publish**

**For production (recommended):**

```json
{
  "rules": {
    "stafftrack": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
```

Then add Firebase login to your app.

---

## 📊 **What's Now Deployed**

✅ **GitHub Pages Hosting** — Your app runs on: `https://username.github.io/stafftrack/`
✅ **Firebase Realtime Database** — All data syncs to cloud
✅ **Mobile Responsive** — Works on phone, tablet, desktop
✅ **Multi-Device Sync** — Everyone sees same data in real-time
✅ **Free Hosting** — No monthly cost
✅ **HTTPS** — Secure connection included

---

## 🎉 **You're Done!**

Your app is now:
- ✅ Live on the internet
- ✅ Accessible from any device
- ✅ Syncing data to cloud
- ✅ Mobile-friendly
- ✅ Ready for your team!

**Share this URL with your team:**
```
https://YOUR-USERNAME.github.io/stafftrack/
```

---

## 📞 **Next Steps**

1. ✅ Test on multiple devices
2. ✅ Add your team as GitHub collaborators (Settings → Collaborators)
3. ✅ Share the live URL
4. ✅ Celebrate! 🎉

---

**Questions? Check the troubleshooting section or GitHub/Firebase docs!**
