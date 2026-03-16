#!/usr/bin/env bash
# Process — sysops tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/process"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "process v2.0.0"; }

_help() {
    echo "Process v2.0.0 — sysops toolkit"
    echo ""
    echo "Usage: process <command> [args]"
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
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Process Stats ==="
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
            echo "=== Process Export ===" > "$out"
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
    echo "=== Process Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: process search <term>}"
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
    scan)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent scan entries:"
            tail -20 "$DATA_DIR/scan.log" 2>/dev/null || echo "  No entries yet. Use: process scan <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/scan.log"
            local total=$(wc -l < "$DATA_DIR/scan.log")
            echo "  [Process] scan: $input"
            echo "  Saved. Total scan entries: $total"
            _log "scan" "$input"
        fi
        ;;
    monitor)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent monitor entries:"
            tail -20 "$DATA_DIR/monitor.log" 2>/dev/null || echo "  No entries yet. Use: process monitor <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/monitor.log"
            local total=$(wc -l < "$DATA_DIR/monitor.log")
            echo "  [Process] monitor: $input"
            echo "  Saved. Total monitor entries: $total"
            _log "monitor" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: process report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Process] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    alert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent alert entries:"
            tail -20 "$DATA_DIR/alert.log" 2>/dev/null || echo "  No entries yet. Use: process alert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/alert.log"
            local total=$(wc -l < "$DATA_DIR/alert.log")
            echo "  [Process] alert: $input"
            echo "  Saved. Total alert entries: $total"
            _log "alert" "$input"
        fi
        ;;
    top)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent top entries:"
            tail -20 "$DATA_DIR/top.log" 2>/dev/null || echo "  No entries yet. Use: process top <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/top.log"
            local total=$(wc -l < "$DATA_DIR/top.log")
            echo "  [Process] top: $input"
            echo "  Saved. Total top entries: $total"
            _log "top" "$input"
        fi
        ;;
    usage)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent usage entries:"
            tail -20 "$DATA_DIR/usage.log" 2>/dev/null || echo "  No entries yet. Use: process usage <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/usage.log"
            local total=$(wc -l < "$DATA_DIR/usage.log")
            echo "  [Process] usage: $input"
            echo "  Saved. Total usage entries: $total"
            _log "usage" "$input"
        fi
        ;;
    check)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent check entries:"
            tail -20 "$DATA_DIR/check.log" 2>/dev/null || echo "  No entries yet. Use: process check <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/check.log"
            local total=$(wc -l < "$DATA_DIR/check.log")
            echo "  [Process] check: $input"
            echo "  Saved. Total check entries: $total"
            _log "check" "$input"
        fi
        ;;
    fix)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent fix entries:"
            tail -20 "$DATA_DIR/fix.log" 2>/dev/null || echo "  No entries yet. Use: process fix <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/fix.log"
            local total=$(wc -l < "$DATA_DIR/fix.log")
            echo "  [Process] fix: $input"
            echo "  Saved. Total fix entries: $total"
            _log "fix" "$input"
        fi
        ;;
    cleanup)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent cleanup entries:"
            tail -20 "$DATA_DIR/cleanup.log" 2>/dev/null || echo "  No entries yet. Use: process cleanup <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/cleanup.log"
            local total=$(wc -l < "$DATA_DIR/cleanup.log")
            echo "  [Process] cleanup: $input"
            echo "  Saved. Total cleanup entries: $total"
            _log "cleanup" "$input"
        fi
        ;;
    backup)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent backup entries:"
            tail -20 "$DATA_DIR/backup.log" 2>/dev/null || echo "  No entries yet. Use: process backup <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/backup.log"
            local total=$(wc -l < "$DATA_DIR/backup.log")
            echo "  [Process] backup: $input"
            echo "  Saved. Total backup entries: $total"
            _log "backup" "$input"
        fi
        ;;
    restore)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent restore entries:"
            tail -20 "$DATA_DIR/restore.log" 2>/dev/null || echo "  No entries yet. Use: process restore <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/restore.log"
            local total=$(wc -l < "$DATA_DIR/restore.log")
            echo "  [Process] restore: $input"
            echo "  Saved. Total restore entries: $total"
            _log "restore" "$input"
        fi
        ;;
    log)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent log entries:"
            tail -20 "$DATA_DIR/log.log" 2>/dev/null || echo "  No entries yet. Use: process log <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/log.log"
            local total=$(wc -l < "$DATA_DIR/log.log")
            echo "  [Process] log: $input"
            echo "  Saved. Total log entries: $total"
            _log "log" "$input"
        fi
        ;;
    benchmark)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent benchmark entries:"
            tail -20 "$DATA_DIR/benchmark.log" 2>/dev/null || echo "  No entries yet. Use: process benchmark <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/benchmark.log"
            local total=$(wc -l < "$DATA_DIR/benchmark.log")
            echo "  [Process] benchmark: $input"
            echo "  Saved. Total benchmark entries: $total"
            _log "benchmark" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: process compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Process] compare: $input"
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
        echo "Unknown command: $1"
        echo "Run 'process help' for available commands."
        exit 1
        ;;
esac