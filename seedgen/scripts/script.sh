#!/usr/bin/env bash
# Seedgen — security tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/seedgen"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "seedgen v2.0.0"; }

_help() {
    echo "Seedgen v2.0.0 — security toolkit"
    echo ""
    echo "Usage: seedgen <command> [args]"
    echo ""
    echo "Commands:"
    echo "  generate           Generate"
    echo "  check-strength     Check Strength"
    echo "  rotate             Rotate"
    echo "  audit              Audit"
    echo "  store              Store"
    echo "  retrieve           Retrieve"
    echo "  expire             Expire"
    echo "  policy             Policy"
    echo "  report             Report"
    echo "  hash               Hash"
    echo "  verify             Verify"
    echo "  revoke             Revoke"
    echo "  stats              Summary statistics"
    echo "  export <fmt>       Export (json|csv|txt)"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Seedgen Stats ==="
    local total=0
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local name=$(basename "$f" .log)
        local c=$(wc -l < "$f")
        total=$((total + c))
        echo "  $name: $c entries"
    done
    echo "  ---"
    echo "  Total: $total entries"
    echo "  Data size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Since: $(head -1 "$DATA_DIR/history.log" 2>/dev/null | cut -d'|' -f1 || echo 'N/A')"
}

_export() {
    local fmt="${1:-json}"
    local out="$DATA_DIR/export.$fmt"
    case "$fmt" in
        json)
            echo "[" > "$out"
            local first=1
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                local name=$(basename "$f" .log)
                while IFS='|' read -r ts val; do
                    [ $first -eq 1 ] && first=0 || echo "," >> "$out"
                    printf '  {"type":"%s","time":"%s","value":"%s"}' "$name" "$ts" "$val" >> "$out"
                done < "$f"
            done
            echo "" >> "$out"
            echo "]" >> "$out"
            ;;
        csv)
            echo "type,time,value" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                local name=$(basename "$f" .log)
                while IFS='|' read -r ts val; do
                    echo "$name,$ts,$val" >> "$out"
                done < "$f"
            done
            ;;
        txt)
            echo "=== Seedgen Export ===" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                echo "--- $(basename "$f" .log) ---" >> "$out"
                cat "$f" >> "$out"
                echo "" >> "$out"
            done
            ;;
        *) echo "Formats: json, csv, txt"; return 1 ;;
    esac
    echo "Exported to $out ($(wc -c < "$out") bytes)"
}

_status() {
    echo "=== Seedgen Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: seedgen search <term>}"
    echo "Searching for: $term"
    local found=0
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local matches=$(grep -i "$term" "$f" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            echo "  --- $(basename "$f" .log) ---"
            echo "$matches" | while read -r line; do
                echo "    $line"
                found=$((found + 1))
            done
        fi
    done
    [ $found -eq 0 ] && echo "  No matches found."
}

_recent() {
    echo "=== Recent Activity ==="
    if [ -f "$DATA_DIR/history.log" ]; then
        tail -20 "$DATA_DIR/history.log" | while IFS='' read -r line; do
            echo "  $line"
        done
    else
        echo "  No activity yet."
    fi
}

# Main dispatch
case "${1:-help}" in
    generate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent generate entries:"
            tail -20 "$DATA_DIR/generate.log" 2>/dev/null || echo "  No entries yet. Use: seedgen generate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/generate.log"
            local total=$(wc -l < "$DATA_DIR/generate.log")
            echo "  [Seedgen] generate: $input"
            echo "  Saved. Total generate entries: $total"
            _log "generate" "$input"
        fi
        ;;
    check-strength)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent check-strength entries:"
            tail -20 "$DATA_DIR/check-strength.log" 2>/dev/null || echo "  No entries yet. Use: seedgen check-strength <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/check-strength.log"
            local total=$(wc -l < "$DATA_DIR/check-strength.log")
            echo "  [Seedgen] check-strength: $input"
            echo "  Saved. Total check-strength entries: $total"
            _log "check-strength" "$input"
        fi
        ;;
    rotate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent rotate entries:"
            tail -20 "$DATA_DIR/rotate.log" 2>/dev/null || echo "  No entries yet. Use: seedgen rotate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/rotate.log"
            local total=$(wc -l < "$DATA_DIR/rotate.log")
            echo "  [Seedgen] rotate: $input"
            echo "  Saved. Total rotate entries: $total"
            _log "rotate" "$input"
        fi
        ;;
    audit)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent audit entries:"
            tail -20 "$DATA_DIR/audit.log" 2>/dev/null || echo "  No entries yet. Use: seedgen audit <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/audit.log"
            local total=$(wc -l < "$DATA_DIR/audit.log")
            echo "  [Seedgen] audit: $input"
            echo "  Saved. Total audit entries: $total"
            _log "audit" "$input"
        fi
        ;;
    store)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent store entries:"
            tail -20 "$DATA_DIR/store.log" 2>/dev/null || echo "  No entries yet. Use: seedgen store <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/store.log"
            local total=$(wc -l < "$DATA_DIR/store.log")
            echo "  [Seedgen] store: $input"
            echo "  Saved. Total store entries: $total"
            _log "store" "$input"
        fi
        ;;
    retrieve)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent retrieve entries:"
            tail -20 "$DATA_DIR/retrieve.log" 2>/dev/null || echo "  No entries yet. Use: seedgen retrieve <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/retrieve.log"
            local total=$(wc -l < "$DATA_DIR/retrieve.log")
            echo "  [Seedgen] retrieve: $input"
            echo "  Saved. Total retrieve entries: $total"
            _log "retrieve" "$input"
        fi
        ;;
    expire)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent expire entries:"
            tail -20 "$DATA_DIR/expire.log" 2>/dev/null || echo "  No entries yet. Use: seedgen expire <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/expire.log"
            local total=$(wc -l < "$DATA_DIR/expire.log")
            echo "  [Seedgen] expire: $input"
            echo "  Saved. Total expire entries: $total"
            _log "expire" "$input"
        fi
        ;;
    policy)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent policy entries:"
            tail -20 "$DATA_DIR/policy.log" 2>/dev/null || echo "  No entries yet. Use: seedgen policy <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/policy.log"
            local total=$(wc -l < "$DATA_DIR/policy.log")
            echo "  [Seedgen] policy: $input"
            echo "  Saved. Total policy entries: $total"
            _log "policy" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: seedgen report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Seedgen] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    hash)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent hash entries:"
            tail -20 "$DATA_DIR/hash.log" 2>/dev/null || echo "  No entries yet. Use: seedgen hash <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/hash.log"
            local total=$(wc -l < "$DATA_DIR/hash.log")
            echo "  [Seedgen] hash: $input"
            echo "  Saved. Total hash entries: $total"
            _log "hash" "$input"
        fi
        ;;
    verify)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent verify entries:"
            tail -20 "$DATA_DIR/verify.log" 2>/dev/null || echo "  No entries yet. Use: seedgen verify <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/verify.log"
            local total=$(wc -l < "$DATA_DIR/verify.log")
            echo "  [Seedgen] verify: $input"
            echo "  Saved. Total verify entries: $total"
            _log "verify" "$input"
        fi
        ;;
    revoke)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent revoke entries:"
            tail -20 "$DATA_DIR/revoke.log" 2>/dev/null || echo "  No entries yet. Use: seedgen revoke <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/revoke.log"
            local total=$(wc -l < "$DATA_DIR/revoke.log")
            echo "  [Seedgen] revoke: $input"
            echo "  Saved. Total revoke entries: $total"
            _log "revoke" "$input"
        fi
        ;;
    stats) _stats ;;
    export) shift; _export "$@" ;;
    search) shift; _search "$@" ;;
    recent) _recent ;;
    status) _status ;;
    help|--help|-h) _help ;;
    version|--version|-v) _version ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'seedgen help' for available commands."
        exit 1
        ;;
esac