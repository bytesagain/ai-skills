#!/usr/bin/env bash
# Backuptool — sysops tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/backuptool"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "backuptool v2.0.0"; }

_help() {
    echo "Backuptool v2.0.0 — sysops toolkit"
    echo ""
    echo "Usage: backuptool <command> [args]"
    echo ""
    echo "Commands:"
    echo "  scan               Scan"
    echo "  monitor            Monitor"
    echo "  report             Report"
    echo "  alert              Alert"
    echo "  top                Top"
    echo "  usage              Usage"
    echo "  check              Check"
    echo "  fix                Fix"
    echo "  cleanup            Cleanup"
    echo "  backup             Backup"
    echo "  restore            Restore"
    echo "  log                Log"
    echo "  benchmark          Benchmark"
    echo "  compare            Compare"
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
    echo "=== Backuptool Stats ==="
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
            echo "=== Backuptool Export ===" > "$out"
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
    echo "=== Backuptool Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: backuptool search <term>}"
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
    scan)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent scan entries:"
            tail -20 "$DATA_DIR/scan.log" 2>/dev/null || echo "  No entries yet. Use: backuptool scan <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/scan.log"
            local total=$(wc -l < "$DATA_DIR/scan.log")
            echo "  [Backuptool] scan: $input"
            echo "  Saved. Total scan entries: $total"
            _log "scan" "$input"
        fi
        ;;
    monitor)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent monitor entries:"
            tail -20 "$DATA_DIR/monitor.log" 2>/dev/null || echo "  No entries yet. Use: backuptool monitor <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/monitor.log"
            local total=$(wc -l < "$DATA_DIR/monitor.log")
            echo "  [Backuptool] monitor: $input"
            echo "  Saved. Total monitor entries: $total"
            _log "monitor" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: backuptool report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Backuptool] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    alert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent alert entries:"
            tail -20 "$DATA_DIR/alert.log" 2>/dev/null || echo "  No entries yet. Use: backuptool alert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/alert.log"
            local total=$(wc -l < "$DATA_DIR/alert.log")
            echo "  [Backuptool] alert: $input"
            echo "  Saved. Total alert entries: $total"
            _log "alert" "$input"
        fi
        ;;
    top)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent top entries:"
            tail -20 "$DATA_DIR/top.log" 2>/dev/null || echo "  No entries yet. Use: backuptool top <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/top.log"
            local total=$(wc -l < "$DATA_DIR/top.log")
            echo "  [Backuptool] top: $input"
            echo "  Saved. Total top entries: $total"
            _log "top" "$input"
        fi
        ;;
    usage)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent usage entries:"
            tail -20 "$DATA_DIR/usage.log" 2>/dev/null || echo "  No entries yet. Use: backuptool usage <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/usage.log"
            local total=$(wc -l < "$DATA_DIR/usage.log")
            echo "  [Backuptool] usage: $input"
            echo "  Saved. Total usage entries: $total"
            _log "usage" "$input"
        fi
        ;;
    check)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent check entries:"
            tail -20 "$DATA_DIR/check.log" 2>/dev/null || echo "  No entries yet. Use: backuptool check <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/check.log"
            local total=$(wc -l < "$DATA_DIR/check.log")
            echo "  [Backuptool] check: $input"
            echo "  Saved. Total check entries: $total"
            _log "check" "$input"
        fi
        ;;
    fix)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent fix entries:"
            tail -20 "$DATA_DIR/fix.log" 2>/dev/null || echo "  No entries yet. Use: backuptool fix <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/fix.log"
            local total=$(wc -l < "$DATA_DIR/fix.log")
            echo "  [Backuptool] fix: $input"
            echo "  Saved. Total fix entries: $total"
            _log "fix" "$input"
        fi
        ;;
    cleanup)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent cleanup entries:"
            tail -20 "$DATA_DIR/cleanup.log" 2>/dev/null || echo "  No entries yet. Use: backuptool cleanup <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/cleanup.log"
            local total=$(wc -l < "$DATA_DIR/cleanup.log")
            echo "  [Backuptool] cleanup: $input"
            echo "  Saved. Total cleanup entries: $total"
            _log "cleanup" "$input"
        fi
        ;;
    backup)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent backup entries:"
            tail -20 "$DATA_DIR/backup.log" 2>/dev/null || echo "  No entries yet. Use: backuptool backup <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/backup.log"
            local total=$(wc -l < "$DATA_DIR/backup.log")
            echo "  [Backuptool] backup: $input"
            echo "  Saved. Total backup entries: $total"
            _log "backup" "$input"
        fi
        ;;
    restore)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent restore entries:"
            tail -20 "$DATA_DIR/restore.log" 2>/dev/null || echo "  No entries yet. Use: backuptool restore <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/restore.log"
            local total=$(wc -l < "$DATA_DIR/restore.log")
            echo "  [Backuptool] restore: $input"
            echo "  Saved. Total restore entries: $total"
            _log "restore" "$input"
        fi
        ;;
    log)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent log entries:"
            tail -20 "$DATA_DIR/log.log" 2>/dev/null || echo "  No entries yet. Use: backuptool log <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/log.log"
            local total=$(wc -l < "$DATA_DIR/log.log")
            echo "  [Backuptool] log: $input"
            echo "  Saved. Total log entries: $total"
            _log "log" "$input"
        fi
        ;;
    benchmark)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent benchmark entries:"
            tail -20 "$DATA_DIR/benchmark.log" 2>/dev/null || echo "  No entries yet. Use: backuptool benchmark <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/benchmark.log"
            local total=$(wc -l < "$DATA_DIR/benchmark.log")
            echo "  [Backuptool] benchmark: $input"
            echo "  Saved. Total benchmark entries: $total"
            _log "benchmark" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: backuptool compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Backuptool] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
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
        echo "Unknown: $1 — run 'backuptool help'"
        exit 1
        ;;
esac