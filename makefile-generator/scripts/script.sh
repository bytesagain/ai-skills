#!/usr/bin/env bash
# Makefile Generator — social tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/makefile-generator"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "makefile-generator v2.0.0"; }

_help() {
    echo "Makefile Generator v2.0.0 — social toolkit"
    echo ""
    echo "Usage: makefile-generator <command> [args]"
    echo ""
    echo "Commands:"
    echo "  connect            Connect"
    echo "  sync               Sync"
    echo "  monitor            Monitor"
    echo "  automate           Automate"
    echo "  notify             Notify"
    echo "  report             Report"
    echo "  schedule           Schedule"
    echo "  template           Template"
    echo "  webhook            Webhook"
    echo "  status             Status"
    echo "  analytics          Analytics"
    echo "  export             Export"
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
    echo "=== Makefile Generator Stats ==="
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
            echo "=== Makefile Generator Export ===" > "$out"
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
    echo "=== Makefile Generator Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: makefile-generator search <term>}"
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
    connect)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent connect entries:"
            tail -20 "$DATA_DIR/connect.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator connect <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/connect.log"
            local total=$(wc -l < "$DATA_DIR/connect.log")
            echo "  [Makefile Generator] connect: $input"
            echo "  Saved. Total connect entries: $total"
            _log "connect" "$input"
        fi
        ;;
    sync)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent sync entries:"
            tail -20 "$DATA_DIR/sync.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator sync <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/sync.log"
            local total=$(wc -l < "$DATA_DIR/sync.log")
            echo "  [Makefile Generator] sync: $input"
            echo "  Saved. Total sync entries: $total"
            _log "sync" "$input"
        fi
        ;;
    monitor)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent monitor entries:"
            tail -20 "$DATA_DIR/monitor.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator monitor <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/monitor.log"
            local total=$(wc -l < "$DATA_DIR/monitor.log")
            echo "  [Makefile Generator] monitor: $input"
            echo "  Saved. Total monitor entries: $total"
            _log "monitor" "$input"
        fi
        ;;
    automate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent automate entries:"
            tail -20 "$DATA_DIR/automate.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator automate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/automate.log"
            local total=$(wc -l < "$DATA_DIR/automate.log")
            echo "  [Makefile Generator] automate: $input"
            echo "  Saved. Total automate entries: $total"
            _log "automate" "$input"
        fi
        ;;
    notify)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent notify entries:"
            tail -20 "$DATA_DIR/notify.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator notify <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/notify.log"
            local total=$(wc -l < "$DATA_DIR/notify.log")
            echo "  [Makefile Generator] notify: $input"
            echo "  Saved. Total notify entries: $total"
            _log "notify" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Makefile Generator] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    schedule)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schedule entries:"
            tail -20 "$DATA_DIR/schedule.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator schedule <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schedule.log"
            local total=$(wc -l < "$DATA_DIR/schedule.log")
            echo "  [Makefile Generator] schedule: $input"
            echo "  Saved. Total schedule entries: $total"
            _log "schedule" "$input"
        fi
        ;;
    template)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent template entries:"
            tail -20 "$DATA_DIR/template.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator template <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/template.log"
            local total=$(wc -l < "$DATA_DIR/template.log")
            echo "  [Makefile Generator] template: $input"
            echo "  Saved. Total template entries: $total"
            _log "template" "$input"
        fi
        ;;
    webhook)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent webhook entries:"
            tail -20 "$DATA_DIR/webhook.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator webhook <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/webhook.log"
            local total=$(wc -l < "$DATA_DIR/webhook.log")
            echo "  [Makefile Generator] webhook: $input"
            echo "  Saved. Total webhook entries: $total"
            _log "webhook" "$input"
        fi
        ;;
    status)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent status entries:"
            tail -20 "$DATA_DIR/status.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator status <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/status.log"
            local total=$(wc -l < "$DATA_DIR/status.log")
            echo "  [Makefile Generator] status: $input"
            echo "  Saved. Total status entries: $total"
            _log "status" "$input"
        fi
        ;;
    analytics)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent analytics entries:"
            tail -20 "$DATA_DIR/analytics.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator analytics <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/analytics.log"
            local total=$(wc -l < "$DATA_DIR/analytics.log")
            echo "  [Makefile Generator] analytics: $input"
            echo "  Saved. Total analytics entries: $total"
            _log "analytics" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: makefile-generator export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Makefile Generator] export: $input"
            echo "  Saved. Total export entries: $total"
            _log "export" "$input"
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
        echo "Unknown: $1 — run 'makefile-generator help'"
        exit 1
        ;;
esac