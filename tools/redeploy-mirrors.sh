#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# absent — redeploy the static build to ALL mirror workers
#
# usage:
#   CLOUDFLARE_API_TOKEN=xxxx ./tools/redeploy-mirrors.sh
#   CLOUDFLARE_API_TOKEN=xxxx ./tools/redeploy-mirrors.sh --dry-run
#
# reads the live mirror list straight from index.html (MIRROR_LINKS)
# and runs one `wrangler deploy` per worker, in parallel batches.
# new mirrors: append the URL to MIRROR_LINKS in index.html
# (keep it base64-encoded!) and re-run this script.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

cd "$(dirname "$0")/.."

: "${CLOUDFLARE_API_TOKEN:?export CLOUDFLARE_API_TOKEN=xxxx first}"
DRY="${1:-}"

if [ "$DRY" = "--dry-run" ]; then
  echo "dry run — no deploys"
fi

# extract the base64 mirror list from index.html and decode it
LINKS=$(node -e "
const fs=require('fs');
const html=fs.readFileSync('index.html','utf8');
const m=html.match(/MIRROR_LINKS = JSON.parse\(atob\('([^']+)'\)\)/);
if(!m){console.error('MIRROR_LINKS not found');process.exit(1)}
console.log(Buffer.from(m[1],'base64').toString());
")

COUNT=$(echo "$LINKS" | node -e "let d='';process.stdin.on('data',c=>d+=c).on('end',()=>console.log(JSON.parse(d).length))")
echo "found $COUNT mirrors"

echo "$LINKS" | node -e "
let d='';process.stdin.on('data',c=>d+=c).on('end',()=>{
  const links=JSON.parse(d);
  links.forEach(u=>{
    try{const h=new URL(u).hostname;console.log(h)}catch(e){console.error('bad url: '+u)}
  });
})" | xargs -P 4 -I{} sh -c '
  NAME=$(echo "{}" | cut -d. -f1)
  echo "▶ deploying {}  →  worker: $NAME"
  if [ "'"${DRY}"'" != "--dry-run" ]; then
    npx wrangler deploy --name "$NAME" --compatibility-date 2024-09-23 >/dev/null 2>&1 \
      && echo "  ✅ {} done" \
      || echo "  ❌ {} failed"
  fi
'

echo ""
echo "all mirrors processed. new links? add them to MIRROR_LINKS in index.html and re-run."
