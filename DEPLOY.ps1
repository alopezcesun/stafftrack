# ============================================================
# StaffTrack - GitHub + Firebase Deployment Script
# ============================================================

$ErrorActionPreference = "Stop"

function Write-Step($message) {
    Write-Host ""
    Write-Host "== $message ==" -ForegroundColor Cyan
}

function Write-Info($message) {
    Write-Host "   $message" -ForegroundColor Gray
}

function Write-Success($message) {
    Write-Host "[OK] $message" -ForegroundColor Green
}

function Write-ErrorMsg($message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
}

# Configuration
$REPO_DIR = "C:\stafftrack-local"
$REPO_URL = ""

# Header
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " StaffTrack - GitHub + Firebase Deployment   " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# STEP 1 - Repo URL
Write-Step "STEP 1: Enter GitHub Repository URL"
$REPO_URL = Read-Host "Enter repo URL"

if ([string]::IsNullOrWhiteSpace($REPO_URL)) {
    Write-ErrorMsg "Repository URL is required."
    exit 1
}

if ($REPO_URL -notmatch "github\.com") {
    Write-ErrorMsg "Invalid GitHub URL."
    exit 1
}

Write-Success "Repository URL validated"

# STEP 2 - Directory
Write-Step "STEP 2: Preparing Directory"

if (-not (Test-Path $REPO_DIR)) {
    Write-ErrorMsg "Directory not found: $REPO_DIR"
    exit 1
}

Set-Location $REPO_DIR
Write-Info "Location: $REPO_DIR"

# STEP 3 - Git Check
Write-Step "STEP 3: Checking Git"

try {
    git --version | Out-Null
    Write-Success "Git installed"
} catch {
    Write-ErrorMsg "Git not installed"
    exit 1
}

# STEP 4 - Init Git
Write-Step "STEP 4: Initializing Git"

if (-not (Test-Path ".git")) {
    git init
    Write-Success "Git initialized"
} else {
    Write-Info "Git already initialized"
}

# STEP 5 - Stage + Commit
Write-Step "STEP 5: Commit Changes"

git add .

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Deploy StaffTrack ($timestamp)" 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Info "No changes to commit"
} else {
    Write-Success "Commit created"
}

# STEP 6 - Remote
Write-Step "STEP 6: Configure Remote"

$existingRemote = git remote get-url origin 2>$null

if ($existingRemote) {
    git remote remove origin
    Write-Info "Old remote removed"
}

git remote add origin $REPO_URL
Write-Success "Remote configured"

# STEP 7 - Push
Write-Step "STEP 7: Push to GitHub"

git branch -M main
git push -u origin main

if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Push failed"
    exit 1
}

Write-Success "Pushed to GitHub"

# ============================================================
# 🔥 FIREBASE DEPLOY SECTION
# ============================================================

Write-Step "STEP 8: Firebase Deployment"

# Check Firebase CLI
try {
    firebase --version | Out-Null
    Write-Success "Firebase CLI installed"
} catch {
    Write-ErrorMsg "Firebase CLI not installed"
    Write-Info "Install with: npm install -g firebase-tools"
    exit 0
}

# Check firebase.json
if (-not (Test-Path "firebase.json")) {
    Write-ErrorMsg "firebase.json not found"
    Write-Info "Run: firebase init"
    exit 0
}

# Check login
Write-Info "Checking Firebase login..."
firebase login:list | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Info "Opening login..."
    firebase login
}

# Optional project selection
Write-Info "Current Firebase project:"
firebase use

$changeProject = Read-Host "Change Firebase project? (y/n)"
if ($changeProject -match "^[Yy]$") {
    firebase use --add
}

# Deploy
Write-Step "Deploying to Firebase"

firebase deploy

if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Firebase deploy failed"
    exit 1
}

Write-Success "Firebase deploy complete"

# ============================================================
# FINAL OUTPUT
# ============================================================

$username = [regex]::Match($REPO_URL, 'github\.com/([^/]+)/').Groups[1].Value

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "         DEPLOYMENT COMPLETE                 " -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host ""
Write-Host "GitHub Pages:" -ForegroundColor Cyan
Write-Host "https://$username.github.io/stafftrack/" -ForegroundColor Green

Write-Host ""
Write-Host "Firebase Hosting:" -ForegroundColor Cyan
Write-Host "Check your Firebase console for URL" -ForegroundColor Green

Write-Host ""

Read-Host "Press Enter to exit"