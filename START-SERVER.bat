@echo off
title StaffTrack Local Server v2.0
color 0A
echo.
echo  =========================================
echo   StaffTrack Local Server v2.0
echo  =========================================
echo.
echo  Checking Node.js...

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo  ERROR: Node.js is not installed.
    echo  Download from https://nodejs.org ^(LTS version^)
    echo.
    pause
    exit /b 1
)

echo  Node.js found.
echo.

REM Install xlsx if node_modules not present
if not exist "%~dp0node_modules\xlsx" (
    echo  Installing required packages ^(first time only^)...
    cd /d "%~dp0"
    npm install --silent
    echo  Packages installed.
    echo.
)

echo  Starting server...
echo  Do NOT close this window while using the app.
echo.
cd /d "%~dp0"
node server.js
pause
