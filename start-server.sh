#!/bin/bash
echo ""
echo " ========================================="
echo "  StaffTrack Local Server v2.0"
echo " ========================================="
echo ""

if ! command -v node &> /dev/null; then
    echo " ERROR: Node.js not installed. Get it from https://nodejs.org"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

if [ ! -d "node_modules/xlsx" ]; then
    echo " Installing required packages (first time only)..."
    npm install --silent
    echo " Done."
    echo ""
fi

echo " Starting server — keep this window open."
echo ""
node server.js
