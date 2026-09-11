#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/hermes_cli/web_dist"
DEST="/var/lib/caddy/hermes-pwa-public"

FILES=(
  apple-touch-icon.png
  pwa-192.png
  pwa-512.png
  manifest.webmanifest
)

echo "===== HERMES PWA ASSET SYNC ====="

for file in "${FILES[@]}"; do
    if [[ ! -f "$DIST/$file" ]]; then
        echo "ERROR: Missing $DIST/$file"
        echo "Build the web frontend first."
        exit 1
    fi
done

sudo mkdir -p "$DEST"

for file in "${FILES[@]}"; do
    sudo install -o caddy -g caddy -m 0644 \
      "$DIST/$file" \
      "$DEST/$file"
done

echo
echo "===== DEPLOYED FILES ====="
sudo ls -lh "$DEST"

echo
echo "===== LIVE INSTALL-ASSET CHECK ====="
curl -kfsSI https://10.250.10.10:9444/apple-touch-icon.png >/dev/null
curl -kfsSI https://10.250.10.10:9444/pwa-192.png >/dev/null
curl -kfsSI https://10.250.10.10:9444/pwa-512.png >/dev/null
curl -kfsS https://10.250.10.10:9444/manifest.webmanifest >/dev/null

echo "PWA_ASSET_SYNC=PASS"
