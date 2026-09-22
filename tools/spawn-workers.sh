#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#  ABSENT worker farm — spawn fresh links on Cloudflare (free plan)
#
#  Usage:
#    bash tools/spawn-workers.sh 10            # spawn 10 workers
#    bash tools/spawn-workers.sh --delete absent-12345   # remove one
#    bash tools/spawn-workers.sh 3 --dry-run   # preview, no deploy
#
#  One-time setup:
#    export CLOUDFLARE_API_TOKEN=your-token    # "Edit Cloudflare Workers" template
#    (or run once: npx --yes wrangler login)
# ══════════════════════════════════════════════════════════════════
set -euo pipefail
cd "$(dirname "$0")/.."

LINKS="tools/links.txt"
command -v npx >/dev/null 2>&1 || { echo "[!] node/npm not found — install node first"; exit 1; }

if [ "${1:-}" = "--delete" ]; then
  NAME="${2:?usage: --delete absent-xxxxx}"
  echo "[*] deleting worker: $NAME"
  printf 'y\n' | npx --yes wrangler delete --name "$NAME" 2>&1 | tail -2
  if [ -f "$LINKS" ]; then
    grep -v "/$NAME\." "$LINKS" > "$LINKS.tmp" 2>/dev/null && mv "$LINKS.tmp" "$LINKS" || true
  fi
  echo "[+] deleted. slot freed."
  exit 0
fi

if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
  echo "[!] CLOUDFLARE_API_TOKEN is not set."
  echo "    Fix:  export CLOUDFLARE_API_TOKEN=your-token"
  echo "    (create it: Cloudflare dashboard -> My Profile -> API Tokens -> 'Edit Cloudflare Workers' template)"
  echo "    Or log in once instead:  npx --yes wrangler login"
  exit 1
fi

COUNT="${1:-10}"
case "$COUNT" in ''|*[!0-9]*) echo "[!] count must be a number (got: $COUNT)"; exit 1;; esac
[ "$COUNT" -ge 1 ] && [ "$COUNT" -le 90 ] || { echo "[!] spawn 1-90 at a time (free plan caps ~100 workers/account)"; exit 1; }

DRY=0; [ "${2:-}" = "--dry-run" ] && DRY=1
mkdir -p tools
touch "$LINKS"

echo "════════════════════════════════════════════"
echo " † ABSENT worker farm — spawning $COUNT link(s)"
echo "════════════════════════════════════════════"

SPAWNED=0
gen_name() {
  local RAND
  RAND=$(head -c 256 /dev/urandom | LC_ALL=C tr -dc 'a-z0-9') || RAND=""
  if [ "${#RAND}" -lt 5 ]; then RAND="$RANDOM$RANDOM$RANDOM"; fi
  echo "absent-${RAND:0:5}"
}
for i in $(seq 1 "$COUNT"); do
  NAME="$(gen_name)"
  if grep -q "/$NAME\." "$LINKS" 2>/dev/null; then i=$((i-1)); continue; fi
  if [ "$DRY" = "1" ]; then echo "  [dry] would deploy: npx --yes wrangler deploy --name $NAME"; continue; fi
  echo "[${i}/${COUNT}] deploying ${NAME} ..."
  OUT=$(npx --yes wrangler deploy --name "$NAME" 2>&1) || { echo "$OUT" | tail -5; echo "[!] deploy failed for $NAME — skipping"; continue; }
  URL=$(echo "$OUT" | grep -o "https://${NAME}[^ ]*workers\.dev" | head -1 || true)
  if [ -n "$URL" ]; then
    echo "    ✅ $URL"
    echo "$URL" >> "$LINKS"
    SPAWNED=$((SPAWNED+1))
  else
    echo "    [?] deployed but no URL parsed — check output above"
    echo "$OUT" | tail -5
  fi
done

if [ "$DRY" = "1" ]; then echo "[dry] nothing deployed."; exit 0; fi

echo ""
echo "════════════════════════════════════════════"
echo " done — $SPAWNED new link(s), saved to $LINKS:"
echo "════════════════════════════════════════════"
tail -n "$SPAWNED" "$LINKS" 2>/dev/null || tail -5 "$LINKS"
echo ""
echo " blocked later? free the slot:  bash tools/spawn-workers.sh --delete absent-xxxxx"
