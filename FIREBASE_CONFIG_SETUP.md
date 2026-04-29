# 🔧 Firebase Configuration Setup

This file explains exactly how to configure Firebase for StaffTrack.

---

## 📍 **Where to Put Your Firebase Config**

In `index.html`, search for this section (around line 310):

```html
<!-- Firebase SDK -->
<script src="https://www.gstatic.com/firebaseapps/9.23.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebaseapps/9.23.0/firebase-database.js"></script>
<script src="https://www.gstatic.com/firebaseapps/9.23.0/firebase-auth.js"></script>
</head>
<body>
```

And then find this section (further down):

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

---

## 🔑 **How to Get Your Firebase Config**

### **Step 1: Go to Firebase Project**
- [firebase.google.com/console](https://firebase.google.com/console)
- Select your `stafftrack` project

### **Step 2: Find Project Settings**
- Click **⚙️ Gear icon** (top left)
- Select **"Project settings"**

### **Step 3: Find Your Config**
Scroll down and look for a code block that starts with:

```javascript
const firebaseConfig = {
```

It will show all your credentials.

### **Step 4: Copy the 7 Values**

You need exactly these 7 values:

| Placeholder | Firebase Shows As | Example |
|-------------|-------------------|---------|
| `YOUR_API_KEY_HERE` | `apiKey` | `AIzaSyD1234567890abcdefghijk` |
| `YOUR_PROJECT` (in authDomain) | `authDomain` | `stafftrack-12345.firebaseapp.com` |
| `YOUR_PROJECT` (in databaseURL) | `databaseURL` | `https://stafftrack-12345.firebaseio.com` |
| `YOUR_PROJECT` (in projectId) | `projectId` | `stafftrack-12345` |
| `YOUR_PROJECT` (in storageBucket) | `storageBucket` | `stafftrack-12345.appspot.com` |
| `YOUR_SENDER_ID` | `messagingSenderId` | `123456789012` |
| `YOUR_APP_ID` | `appId` | `1:123456789012:web:abcdef123456` |

---

## ✏️ **How to Update index.html**

### **Method 1: Use Notepad (Easiest)**

1. Open `C:\stafftrack-local\index.html` with **Notepad**
2. Press **Ctrl+H** (Find & Replace)
3. Replace each placeholder:

| Find | Replace With |
|------|--------------|
| `YOUR_API_KEY_HERE` | Your actual API key |
| `stafftrack-xxxxx.firebaseapp.com` | Your authDomain |
| `https://stafftrack-xxxxx.firebaseio.com` | Your databaseURL |
| `YOUR_PROJECT` | Your projectId |
| `YOUR_SENDER_ID` | Your messagingSenderId |
| `YOUR_APP_ID` | Your appId |

4. Click **Replace All**
5. **Save** (Ctrl+S)

### **Method 2: Manual Edit**

1. Open `index.html`
2. Find the Firebase config section (near line 310)
3. Manually replace each value between the quotes

**Before:**
```html
<script id="firebase-config" type="application/json">
{
  "apiKey": "YOUR_API_KEY_HERE",
  "authDomain": "YOUR_PROJECT.firebaseapp.com",
  ...
}
</script>
```

**After:**
```html
<script id="firebase-config" type="application/json">
{
  "apiKey": "AIzaSyD1234567890abcdefghijk",
  "authDomain": "stafftrack-12345.firebaseapp.com",
  ...
}
</script>
```

---

## ✅ **How to Verify Your Config is Correct**

1. Deploy to GitHub (run `.\DEPLOY.ps1`)
2. Open your app: `https://username.github.io/stafftrack/`
3. Open **Developer Console** (F12)
4. Look for message: **"Firebase initialized ✓"**
5. Add an employee
6. Check **Firebase Console** → **Realtime Database** → **Data tab**
7. **See your employee data there?** ✅ Config is correct!

---

## 🔐 **Security Rules in Firebase**

After configuring, set these rules for your database:

1. **Firebase Console** → **Realtime Database** → **Rules tab**
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

---

## 🆘 **Troubleshooting Configuration**

### **Problem: "Firebase is not initialized"**
- **Solution:** Check that index.html has your config with all 7 correct values
- **Check:** Go to Firebase Console → Project Settings → Verify values

### **Problem: "Database URL not found"**
- **Solution:** Make sure you created a Realtime Database in Firebase
- **Check:** Firebase Console → Realtime Database (should show a database URL)

### **Problem: "Cannot read from database"**
- **Solution:** Check your security rules allow reads
- **Check:** Firebase Console → Realtime Database → Rules tab

### **Problem: "Cannot write to database"**
- **Solution:** Check your security rules allow writes
- **Check:** Firebase Console → Realtime Database → Rules tab

### **Problem: Console shows "projectId.includes is not a function"**
- **Solution:** Your config has an error in the JSON
- **Check:** Open config in JSON validator: [jsonlint.com](https://www.jsonlint.com/)

---

## 🆘 **Getting Help**

If your config isn't working:

1. **Copy your entire Firebase config** from Firebase Console
2. **Paste it into:** [jsonlint.com](https://www.jsonlint.com/)
3. **Is JSON valid?** If not, fix syntax errors
4. **If valid:** Check the config values match the placeholders exactly

---

## 📚 **Example: Complete Firebase Config**

Here's what a **complete, working** Firebase config looks like:

```html
<!-- Firebase Configuration Placeholder -->
<script id="firebase-config" type="application/json">
{
  "apiKey": "AIzaSyD1234567890abcdefghijklmnopqrst",
  "authDomain": "stafftrack-12345.firebaseapp.com",
  "databaseURL": "https://stafftrack-12345.firebaseio.com",
  "projectId": "stafftrack-12345",
  "storageBucket": "stafftrack-12345.appspot.com",
  "messagingSenderId": "123456789012",
  "appId": "1:123456789012:web:abcdef123456abcdef"
}
</script>
```

---

## ✨ **You're All Set!**

Once your config is in place and verified:
1. Run `.\DEPLOY.ps1`
2. Enable GitHub Pages
3. Your app is live with cloud database! 🎉

---

**Need more help? See GITHUB_SETUP_WINDOWS.md for complete setup guide.** ✨
