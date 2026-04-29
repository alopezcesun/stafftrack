# ╔════════════════════════════════════════════════════════════════╗
# ║         StaffTrack GitHub Deployment Script                     ║
# ║         For Windows PowerShell                                   ║
# ╚════════════════════════════════════════════════════════════════╝

# ⚠️  BEFORE RUNNING THIS SCRIPT:
# 1. Create GitHub repo at https://github.com/new (name: stafftrack)
# 2. Update Firebase config in index.html
# 3. Get your HTTPS repo URL from GitHub

Write-Host "
╔════════════════════════════════════════════════════════════════╗
║     🚀 StaffTrack — GitHub Deployment Script                 ║
║        Deploys your app to GitHub Pages + Firebase            ║
╚════════════════════════════════════════════════════════════════╝
" -ForegroundColor Cyan

# Configuration
$REPO_DIR = "C:\stafftrack-local"
$REPO_URL = ""

# Get repo URL from user
Write-Host "`n📋 STEP 1: Enter Your GitHub Repository URL" -ForegroundColor Yellow
Write-Host "   Example: https://github.com/your-username/stafftrack.git" -ForegroundColor Gray
$REPO_URL = Read-Host "   Enter repo URL"

if ([string]::IsNullOrWhiteSpace($REPO_URL)) {
    Write-Host "❌ Error: Repository URL is required!" -ForegroundColor Red
    exit 1
}

Write-Host "`n🔍 Verifying repository URL..." -ForegroundColor Cyan
if (-not $REPO_URL.Contains("github.com")) {
    Write-Host "❌ Error: Invalid GitHub URL!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ URL looks good!" -ForegroundColor Green

# Navigate to directory
Write-Host "`n📂 STEP 2: Preparing Directory" -ForegroundColor Yellow
Set-Location $REPO_DIR
Write-Host "   Location: $REPO_DIR" -ForegroundColor Gray
Write-Host "   Contents:" -ForegroundColor Gray
Get-ChildItem -Name | ForEach-Object { Write-Host "   - $_" -ForegroundColor Gray }

# Initialize Git
Write-Host "`n🔄 STEP 3: Initializing Git Repository" -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "   ℹ️  Git already initialized, skipping..." -ForegroundColor Gray
} else {
    git init
    Write-Host "✅ Git initialized" -ForegroundColor Green
}

# Add files
Write-Host "`n📦 STEP 4: Staging Files" -ForegroundColor Yellow
git add .
Write-Host "✅ Files staged" -ForegroundColor Green

# Commit
Write-Host "`n💾 STEP 5: Creating Commit" -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Deploy StaffTrack: Firebase + Mobile layout ($timestamp)"
Write-Host "✅ Commit created" -ForegroundColor Green

# Add remote
Write-Host "`n🔗 STEP 6: Connecting to GitHub" -ForegroundColor Yellow

# Check if remote already exists
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists -and $remoteExists -ne "") {
    Write-Host "   ℹ️  Remote already configured, updating..." -ForegroundColor Gray
    git remote remove origin
}

git remote add origin $REPO_URL
Write-Host "✅ Remote added" -ForegroundColor Green

# Push to GitHub
Write-Host "`n📤 STEP 7: Pushing to GitHub" -ForegroundColor Yellow
Write-Host "   ⚠️  You may be prompted for authentication" -ForegroundColor Yellow
Write-Host "   💡 If asked for password, use a Personal Access Token:" -ForegroundColor Gray
Write-Host "      1. GitHub Settings → Developer settings → Tokens" -ForegroundColor Gray
Write-Host "      2. Create token with 'repo' scope" -ForegroundColor Gray
Write-Host "      3. Paste token as password" -ForegroundColor Gray

git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Push successful!" -ForegroundColor Green
} else {
    Write-Host "❌ Push failed. Check your credentials and try again." -ForegroundColor Red
    exit 1
}

# Enable GitHub Pages
Write-Host "`n🌐 STEP 8: GitHub Pages Setup" -ForegroundColor Yellow
Write-Host "   Manual action required:" -ForegroundColor Yellow
Write-Host "   1. Go to: https://github.com/YOUR-USERNAME/stafftrack" -ForegroundColor Gray
Write-Host "   2. Click: Settings → Pages" -ForegroundColor Gray
Write-Host "   3. Select: Deploy from branch" -ForegroundColor Gray
Write-Host "   4. Choose: main / (root)" -ForegroundColor Gray
Write-Host "   5. Click: Save" -ForegroundColor Gray

# Extract username from URL
$username = [regex]::Match($REPO_URL, 'github\.com/([^/]+)/').Groups[1].Value

Write-Host "`n" -ForegroundColor Green
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    ✅ DEPLOYMENT COMPLETE!                     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📍 Your app will be live at:" -ForegroundColor Cyan
Write-Host "   https://$username.github.io/stafftrack/" -ForegroundColor Green

Write-Host "`n⏳ After enabling GitHub Pages (Step 8):" -ForegroundColor Yellow
Write-Host "   • Wait 2-3 minutes for build to complete" -ForegroundColor Gray
Write-Host "   • Then visit your URL above" -ForegroundColor Gray
Write-Host "   • Login with: admin / password123" -ForegroundColor Gray

Write-Host "`n🔄 To deploy future changes:" -ForegroundColor Yellow
Write-Host "   cd C:\stafftrack-local" -ForegroundColor Gray
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'Describe your changes'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray

Write-Host "`n📚 Documentation:" -ForegroundColor Cyan
Write-Host "   • Detailed guide: GITHUB_SETUP_WINDOWS.md" -ForegroundColor Gray
Write-Host "   • Firebase guide: GITHUB_FIREBASE_DEPLOYMENT.md" -ForegroundColor Gray

Write-Host "`n✨ Ready to deploy!`n" -ForegroundColor Green

# Offer to open GitHub repo
$open = Read-Host "Open GitHub repository in browser? (y/n)"
if ($open -eq "y" -or $open -eq "Y") {
    $repoPage = $REPO_URL -replace "\.git$", ""
    Start-Process $repoPage
}

Read-Host "Press Enter to exit"
