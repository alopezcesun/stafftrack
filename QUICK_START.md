# ⚡ QUICK START — Deploy to GitHub in 5 Minutes

## 📋 **Checklist Before You Start**

- [ ] You have a **GitHub account** (free at github.com)
- [ ] **Git is installed** on your computer (`git --version` in PowerShell)
- [ ] You can see `C:\stafftrack-local\index.html` file

---

## 🚀 **3-Step Deployment**

### **STEP 1: Create GitHub Repo (2 minutes)**

1. Go to **[github.com/new](https://github.com/new)**
2. Enter:
   - **Name:** `stafftrack`
   - **Public:** ✅ (must be public)
   - **Skip** "Initialize with README"
3. Click **"Create repository"**
4. **Copy the HTTPS URL** that appears (looks like `https://github.com/your-username/stafftrack.git`)

---

### **STEP 2: Get Firebase Config (2 minutes)**

1. Go to **[firebase.google.com](https://firebase.google.com)**
2. Click **"Go to console"**
3. Click **"Add project"** → Name it `stafftrack` → Create
4. Click **"Realtime Database"** → **"Create Database"** → Region `us-central1` → Test mode → Enable
5. Click **⚙️ Settings** → Find your Firebase config

**Your config looks like:**
```javascript
{
  apiKey: "AIzaSyD1234...",
  authDomain: "stafftrack-1234.firebaseapp.com",
  databaseURL: "https://stafftrack-1234.firebaseio.com",
  projectId: "stafftrack-1234",
  storageBucket: "stafftrack-1234.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123..."
}
```

---

### **STEP 3: Run Deployment (1 minute)**

1. Open **PowerShell** as Administrator
2. Run these commands:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
cd C:\stafftrack-local
.\DEPLOY.ps1
```

3. When asked, paste your **GitHub HTTPS URL** from Step 1
4. Script will deploy everything!

---

## ✅ **After Deployment**

1. Go to your GitHub repo: `https://github.com/YOUR-USERNAME/stafftrack`
2. Click **Settings** → **Pages**
3. Select: Branch `main` / `(root)` → **Save**
4. Wait 2-3 minutes

**Your app is now live at:**
```
https://YOUR-USERNAME.github.io/stafftrack/
```

---

## 🧪 **Test It**

1. Open your URL: `https://YOUR-USERNAME.github.io/stafftrack/`
2. Login: `admin` / `password123`
3. Add an employee
4. Open on your phone (same URL)
5. **See the employee already there!** ✅ Cloud sync works!

---

## 🐛 **Quick Troubleshooting**

| Problem | Solution |
|---------|----------|
| "Git not found" | Install Git: [git-scm.com](https://git-scm.com/download/win) |
| 404 error on GitHub Pages | Wait 3 min, then enable Pages in Settings |
| Data not syncing | Check Firebase config in index.html is correct |
| "Authentication failed" | Use Personal Access Token instead of password |

---

## 📚 **Full Guides**

- **Detailed setup:** See `GITHUB_SETUP_WINDOWS.md`
- **Firebase deep dive:** See `GITHUB_FIREBASE_DEPLOYMENT.md`
- **Employee edit feature:** See `EMPLOYEE_EDIT_FEATURE.md`

---

## 🆘 **Need Help?**

Run the deployment script again anytime:
```powershell
cd C:\stafftrack-local
.\DEPLOY.ps1
```

It's safe to run multiple times!

---

**Questions? Start with GITHUB_SETUP_WINDOWS.md for detailed guidance.** ✨
