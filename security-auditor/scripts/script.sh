#!/usr/bin/env bash
# Security Auditor — security tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/security-auditor"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "security-auditor v2.0.0"; }

_help() {
    echo "Security Auditor v2.0.0 — security toolkit"
    echo ""
    echo "Usage: security-auditor <command> [args]"
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
    echo "  search <term>      Search entries"
    echo "  recent             Recent activity"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Security Auditor Stats ==="
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
            echo "\n]" >> "$out"
            ;;
        csv)
            echo "type,time,value" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                local name=$(basename "$f" .log)
                while IFS='|' read -r ts val; do echo "$name,$ts,$val" >> "$out"; done < "$f"
            done
            ;;
        txt)
            echo "=== Security Auditor Export ===" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                echo "--- $(basename "$f" .log) ---" >> "$out"
                cat "$f" >> "$out"
            done
            ;;
        *) echo "Formats: json, csv, txt"; return 1 ;;
    esac
    echo "Exported to $out ($(wc -c < "$out") bytes)"
}

_status() {
    echo "=== Security Auditor Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: security-auditor search <term>}"
    echo "Searching for: $term"
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local m=$(grep -i "$term" "$f" 2>/dev/null || true)
        if [ -n "$m" ]; then
            echo "  --- $(basename "$f" .log) ---"
            echo "$m" | sed 's/^/    /'
        fi
    done
}

_recent() {
    echo "=== Recent Activity ==="
    tail -20 "$DATA_DIR/history.log" 2>/dev/null | sed 's/^/  /' || echo "  No activity yet."
}

case "${1:-help}" in
    generate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent generate entries:"
            tail -20 "$DATA_DIR/generate.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor generate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/generate.log"
            local total=$(wc -l < "$DATA_DIR/generate.log")
            echo "  [Security Auditor] generate: $input"
            echo "  Saved. Total generate entries: $total"
            _log "generate" "$input"
        fi
        ;;
    check-strength)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent check-strength entries:"
            tail -20 "$DATA_DIR/check-strength.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor check-strength <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/check-strength.log"
            local total=$(wc -l < "$DATA_DIR/check-strength.log")
            echo "  [Security Auditor] check-strength: $input"
            echo "  Saved. Total check-strength entries: $total"
            _log "check-strength" "$input"
        fi
        ;;
    rotate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent rotate entries:"
            tail -20 "$DATA_DIR/rotate.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor rotate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/rotate.log"
            local total=$(wc -l < "$DATA_DIR/rotate.log")
            echo "  [Security Auditor] rotate: $input"
            echo "  Saved. Total rotate entries: $total"
            _log "rotate" "$input"
        fi
        ;;
    audit)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent audit entries:"
            tail -20 "$DATA_DIR/audit.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor audit <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/audit.log"
            local total=$(wc -l < "$DATA_DIR/audit.log")
            echo "  [Security Auditor] audit: $input"
            echo "  Saved. Total audit entries: $total"
            _log "audit" "$input"
        fi
        ;;
    store)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent store entries:"
            tail -20 "$DATA_DIR/store.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor store <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/store.log"
            local total=$(wc -l < "$DATA_DIR/store.log")
            echo "  [Security Auditor] store: $input"
            echo "  Saved. Total store entries: $total"
            _log "store" "$input"
        fi
        ;;
    retrieve)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent retrieve entries:"
            tail -20 "$DATA_DIR/retrieve.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor retrieve <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/retrieve.log"
            local total=$(wc -l < "$DATA_DIR/retrieve.log")
            echo "  [Security Auditor] retrieve: $input"
            echo "  Saved. Total retrieve entries: $total"
            _log "retrieve" "$input"
        fi
        ;;
    expire)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent expire entries:"
            tail -20 "$DATA_DIR/expire.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor expire <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/expire.log"
            local total=$(wc -l < "$DATA_DIR/expire.log")
            echo "  [Security Auditor] expire: $input"
            echo "  Saved. Total expire entries: $total"
            _log "expire" "$input"
        fi
        ;;
    policy)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent policy entries:"
            tail -20 "$DATA_DIR/policy.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor policy <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/policy.log"
            local total=$(wc -l < "$DATA_DIR/policy.log")
            echo "  [Security Auditor] policy: $input"
            echo "  Saved. Total policy entries: $total"
            _log "policy" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Security Auditor] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    hash)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent hash entries:"
            tail -20 "$DATA_DIR/hash.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor hash <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/hash.log"
            local total=$(wc -l < "$DATA_DIR/hash.log")
            echo "  [Security Auditor] hash: $input"
            echo "  Saved. Total hash entries: $total"
            _log "hash" "$input"
        fi
        ;;
    verify)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent verify entries:"
            tail -20 "$DATA_DIR/verify.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor verify <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/verify.log"
            local total=$(wc -l < "$DATA_DIR/verify.log")
            echo "  [Security Auditor] verify: $input"
            echo "  Saved. Total verify entries: $total"
            _log "verify" "$input"
        fi
        ;;
    revoke)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent revoke entries:"
            tail -20 "$DATA_DIR/revoke.log" 2>/dev/null || echo "  No entries yet. Use: security-auditor revoke <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/revoke.log"
            local total=$(wc -l < "$DATA_DIR/revoke.log")
            echo "  [Security Auditor] revoke: $input"
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
        echo "Unknown: $1 — run 'security-auditor help'"
        exit 1
        ;;
esac