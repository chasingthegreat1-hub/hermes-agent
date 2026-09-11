#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-/home/chase/HERMES_KNOWLEDGE_VAULT.png}"
STAGE="/home/chase/hermes-vault-pwa-stage"
DEST="/var/lib/caddy/hermes-vault-pwa"
ENDPOINT="https://10.250.10.10:9443"

echo "===== HERMES VAULT PWA ASSET SYNC ====="

if [[ ! -f "$SRC" ]]; then
    echo "ERROR: Source artwork not found: $SRC"
    exit 1
fi

echo
echo "===== SOURCE ====="
file "$SRC"
sha256sum "$SRC"

echo
echo "===== CLEAN STAGING ====="
rm -rf "$STAGE"
mkdir -p "$STAGE"

echo
echo "===== GENERATE ICONS ====="
ffmpeg -hide_banner -loglevel error -y -i "$SRC" -vf "scale=180:180:flags=lanczos" -frames:v 1 -update 1 "$STAGE/apple-touch-icon.png"
ffmpeg -hide_banner -loglevel error -y -i "$SRC" -vf "scale=96:96:flags=lanczos" -frames:v 1 -update 1 "$STAGE/favicon-96x96.png"
ffmpeg -hide_banner -loglevel error -y -i "$SRC" -vf "scale=512:512:flags=lanczos" -frames:v 1 -update 1 "$STAGE/logo-dock.png"

echo
echo "===== CREATE MANIFEST ====="
python3 -c 'import json,sys; from pathlib import Path; Path(sys.argv[1]).write_text(json.dumps({"short_name":"HERMES Vault","name":"HERMES-AI Knowledge Vault","icons":[{"src":"/.client/logo-dock.png","type":"image/png","sizes":"512x512"}],"capture_links":"new-client","start_url":"/#boot","display":"standalone","display_override":["window-controls-overlay"],"scope":"/","theme_color":"#000000","background_color":"#000000","description":"Shared HERMES-AI TAC SOP knowledge workspace"}, indent=2) + "\n")' "$STAGE/manifest.json"

python3 -m json.tool "$STAGE/manifest.json" >/dev/null

echo
echo "===== DEPLOY ====="
sudo mkdir -p "$DEST"
for file in apple-touch-icon.png favicon-96x96.png logo-dock.png manifest.json; do
    sudo install -o caddy -g caddy -m 0644 "$STAGE/$file" "$DEST/$file"
done

echo
echo "===== DEPLOYED ASSETS ====="
sudo ls -lh "$DEST"

echo
echo "===== LIVE VERIFICATION ====="
curl -kfsSI "$ENDPOINT/.client/apple-touch-icon.png" >/dev/null
curl -kfsSI "$ENDPOINT/.client/favicon-96x96.png" >/dev/null
curl -kfsSI "$ENDPOINT/.client/logo-dock.png" >/dev/null
curl -kfsS "$ENDPOINT/.client/manifest.json" >/dev/null
curl -kfsSI "$ENDPOINT/.client/main.css" >/dev/null
curl -kfsSI "$ENDPOINT/" >/dev/null

echo "VAULT_PWA_ASSET_SYNC=PASS"
