# Deploy multi-device sync to GitHub
# Run this script to push the updated index.html with real-time sync enabled

$gitPath = "C:\Program Files\Git\cmd\git.exe"
if(-not (Test-Path $gitPath)){
    $gitPath = "C:\Program Files (x86)\Git\cmd\git.exe"
}

if(-not (Test-Path $gitPath)){
    Write-Host "Git not found in standard locations" -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

cd C:\stafftrack-local

# Stage, commit, and push
& $gitPath add index.html
& $gitPath commit -m "Enable real-time multi-device and user synchronization"
& $gitPath push origin main

Write-Host ""
Write-Host "✓ Multi-device sync code deployed to GitHub!" -ForegroundColor Green
Write-Host "✓ Your site will be updated in 1-2 minutes" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Update Firebase Rules" -ForegroundColor Cyan
Write-Host "  Go to: https://firebase.google.com/console" -ForegroundColor Gray
Write-Host "  Project: jtj-stafftrack" -ForegroundColor Gray
Write-Host "  Realtime Database > Rules" -ForegroundColor Gray
