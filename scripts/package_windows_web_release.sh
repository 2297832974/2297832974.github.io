#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
RELEASE_NAME="token-buy-windows-lan-release"
RELEASE_DIR="$DIST_DIR/$RELEASE_NAME"
ZIP_PATH="$DIST_DIR/${RELEASE_NAME}.zip"

cd "$ROOT_DIR"

echo "Building Flutter web release..."
fvm flutter build web

rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

cp -R "$ROOT_DIR/build/web" "$RELEASE_DIR/web"
cp "$ROOT_DIR/scripts/windows_web_release/start_server.bat" "$RELEASE_DIR/start_server.bat"
cp "$ROOT_DIR/scripts/windows_web_release/serve_web.ps1" "$RELEASE_DIR/serve_web.ps1"

cat > "$RELEASE_DIR/README.txt" <<'EOF'
token-buy Windows LAN Release

Usage:
1. Double-click start_server.bat
2. Wait for the terminal to print "Phone URL"
3. Open that URL on a phone browser in the same LAN

Optional:
- You can also run: start_server.bat 9000
- That starts the server on port 9000 instead of 8080

Notes:
- Keep the terminal window open while users access the page
- If Windows Firewall prompts, allow access on the local network
- Press Ctrl+C in the terminal to stop the server
EOF

mkdir -p "$DIST_DIR"
rm -f "$ZIP_PATH"

cd "$DIST_DIR"
zip -rq "$ZIP_PATH" "$RELEASE_NAME"

echo "Created release folder: $RELEASE_DIR"
echo "Created release zip: $ZIP_PATH"
