#!/usr/bin/env bash
# slug-checker v1.0.0 — Check ClawHub slug availability
# Built by BytesAgain | bytesagain.com
set -euo pipefail

VERSION="1.0.0"
SLUG_NAME="slug-checker"
DATA_DIR="$HOME/.slug-checker"
RESULTS="$DATA_DIR/results.json"
CACHE="$DATA_DIR/cache.json"
mkdir -p "$DATA_DIR"

# Init cache if missing
[ -f "$CACHE" ] || echo '{}' > "$CACHE"
[ -f "$RESULTS" ] || echo '{"free":[],"taken":[],"ours":[],"error":[]}' > "$RESULTS"

_check_api() {
    local slug="$1"
    local code
    code=$(curl -s -o /dev/null -w "%{http_code}" "https://clawhub.ai/api/v1/skills/$slug" 2>/dev/null || echo "000")
    case "$code" in
        404) echo "free" ;;
        200) echo "taken" ;;
        429) echo "ratelimited" ;;
        *)   echo "error" ;;
    esac
}

_check_browser() {
    local slug="$1"
    local tmpfile="$DATA_DIR/page.txt"

    export NODE_PATH="/home/admin/.npm-global/lib/node_modules"
    node -e "
const puppeteer = require('puppeteer-core');
(async()=>{
    const b = await puppeteer.launch({executablePath:'/usr/lib64/chromium-browser/headless_shell',args:['--no-sandbox','--disable-gpu','--disable-dev-shm-usage']});
    const p = await b.newPage();
    await p.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
    await p.goto('https://clawhub.ai/skills/$slug',{waitUntil:'networkidle2',timeout:15000});
    const t = await p.evaluate(()=>document.body.innerText.substring(0,2000));
    require('fs').writeFileSync('$tmpfile', t);
    await b.close();
})();
" 2>/dev/null

    if [ ! -f "$tmpfile" ]; then
        echo "error"
        return
    fi

    local text
    text=$(cat "$tmpfile")
    local textlen=${#text}

    if echo "$text" | grep -q "Loading skill" || [ "$textlen" -lt 200 ]; then
        echo "free"
    elif echo "$text" | grep -qi "${MY_ACCOUNTS:-bytesagain}"; then
        echo "ours"
    else
        local owner
        owner=$(echo "$text" | grep -o '@[a-zA-Z0-9_]*' | head -1 || echo "@unknown")
        echo "taken:$owner"
    fi
    rm -f "$tmpfile"
}

cmd_check() {
    local slug="${1:?Usage: $SLUG_NAME check <slug>}"
    echo "Checking: $slug"

    # Try API first
    local api_result
    api_result=$(_check_api "$slug")

    if [ "$api_result" = "ratelimited" ]; then
        echo "  API: 429 rate limited, trying browser..."
        local br_result
        br_result=$(_check_browser "$slug")
        echo "  Browser: $br_result"
    else
        echo "  Result: $api_result"
    fi
}

cmd_batch() {
    local file="${1:?Usage: $SLUG_NAME batch <file>}"
    [ -f "$file" ] || { echo "File not found: $file"; return 1; }

    local total free taken ours errors ratelimited
    total=0; free=0; taken=0; ours=0; errors=0; ratelimited=0

    local free_list="" taken_list="" ours_list="" rl_list=""

    while IFS= read -r slug; do
        slug=$(echo "$slug" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
        [ -z "$slug" ] && continue
        total=$((total + 1))

        local result
        result=$(_check_api "$slug")

        case "$result" in
            free)
                free=$((free + 1))
                free_list="$free_list $slug"
                ;;
            taken)
                taken=$((taken + 1))
                taken_list="$taken_list $slug"
                ;;
            ratelimited)
                ratelimited=$((ratelimited + 1))
                rl_list="$rl_list $slug"
                ;;
            *)
                errors=$((errors + 1))
                ;;
        esac
        sleep 0.3
    done < "$file"

    # Browser fallback for rate-limited slugs
    if [ "$ratelimited" -gt 0 ]; then
        echo "API rate limited on $ratelimited slugs, checking via browser..."
        for slug in $rl_list; do
            local br_result
            br_result=$(_check_browser "$slug")
            case "$br_result" in
                free) free=$((free + 1)); free_list="$free_list $slug" ;;
                ours) ours=$((ours + 1)); ours_list="$ours_list $slug" ;;
                taken*) taken=$((taken + 1)); taken_list="$taken_list $slug" ;;
                *) errors=$((errors + 1)) ;;
            esac
            sleep 0.8
        done
    fi

    # Save results
    python3 << PYEOF
import json
r = {"free": "$free_list".split(), "taken": "$taken_list".split(), "ours": "$ours_list".split()}
with open("$RESULTS", "w") as f:
    json.dump(r, f, indent=2)
PYEOF

    echo ""
    echo "=== Results: $total slugs ==="
    echo "  🟢 Free:  $free"
    echo "  🔴 Taken: $taken"
    echo "  🔵 Ours:  $ours"
    echo "  ❌ Error: $errors"
}

cmd_report() {
    if [ ! -f "$RESULTS" ]; then
        echo "No results yet. Run: $SLUG_NAME batch <file>"
        return
    fi
    python3 -c "
import json
r = json.load(open('$RESULTS'))
print('Free (%d):' % len(r.get('free',[])))
for s in r.get('free',[]): print('  ' + s)
print('Taken (%d):' % len(r.get('taken',[])))
for s in r.get('taken',[]): print('  ' + s)
print('Ours (%d):' % len(r.get('ours',[])))
for s in r.get('ours',[]): print('  ' + s)
"
}

cmd_free() {
    [ -f "$RESULTS" ] || { echo "No results."; return; }
    python3 -c "
import json
for s in json.load(open('$RESULTS')).get('free',[]):
    print(s)
"
}

cmd_taken() {
    [ -f "$RESULTS" ] || { echo "No results."; return; }
    python3 -c "
import json
for s in json.load(open('$RESULTS')).get('taken',[]):
    print(s)
"
}

cmd_status() {
    echo "$SLUG_NAME v$VERSION"
    echo "Data: $DATA_DIR"
    if [ -f "$RESULTS" ]; then
        python3 -c "
import json, os
r = json.load(open('$RESULTS'))
print('Last scan: %d free, %d taken, %d ours' % (len(r.get('free',[])), len(r.get('taken',[])), len(r.get('ours',[]))))
print('File: %d bytes' % os.path.getsize('$RESULTS'))
"
    else
        echo "No scan results yet."
    fi
}

cmd_help() {
    echo "$SLUG_NAME v$VERSION — Check ClawHub slug availability"
    echo ""
    echo "Commands:"
    echo "  check <slug>     Check single slug"
    echo "  batch <file>     Batch check from file (one per line)"
    echo "  report           Show last batch results"
    echo "  free             List free slugs from last batch"
    echo "  taken            List taken slugs from last batch"
    echo "  status           Show status"
    echo "  help             Show this help"
}

case "${1:-help}" in
    check)   shift; cmd_check "$@" ;;
    batch)   shift; cmd_batch "$@" ;;
    report)  cmd_report ;;
    free)    cmd_free ;;
    taken)   cmd_taken ;;
    status)  cmd_status ;;
    help|*)  cmd_help ;;
esac
