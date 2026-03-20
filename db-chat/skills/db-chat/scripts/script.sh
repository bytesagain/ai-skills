#!/usr/bin/env bash
# Db Chat — social tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/db-chat"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "db-chat v2.0.0"; }

_help() {
    echo "Db Chat v2.0.0 — social toolkit"
    echo ""
    echo "Usage: db-chat <command> [args]"
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
    echo "=== Db Chat Stats ==="
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
            echo "=== Db Chat Export ===" > "$out"
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
    echo "=== Db Chat Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: db-chat search <term>}"
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
            tail -20 "$DATA_DIR/connect.log" 2>/dev/null || echo "  No entries yet. Use: db-chat connect <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/connect.log"
            local total=$(wc -l < "$DATA_DIR/connect.log")
            echo "  [Db Chat] connect: $input"
            echo "  Saved. Total connect entries: $total"
            _log "connect" "$input"
        fi
        ;;
    sync)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent sync entries:"
            tail -20 "$DATA_DIR/sync.log" 2>/dev/null || echo "  No entries yet. Use: db-chat sync <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/sync.log"
            local total=$(wc -l < "$DATA_DIR/sync.log")
            echo "  [Db Chat] sync: $input"
            echo "  Saved. Total sync entries: $total"
            _log "sync" "$input"
        fi
        ;;
    monitor)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent monitor entries:"
            tail -20 "$DATA_DIR/monitor.log" 2>/dev/null || echo "  No entries yet. Use: db-chat monitor <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/monitor.log"
            local total=$(wc -l < "$DATA_DIR/monitor.log")
            echo "  [Db Chat] monitor: $input"
            echo "  Saved. Total monitor entries: $total"
            _log "monitor" "$input"
        fi
        ;;
    automate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent automate entries:"
            tail -20 "$DATA_DIR/automate.log" 2>/dev/null || echo "  No entries yet. Use: db-chat automate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/automate.log"
            local total=$(wc -l < "$DATA_DIR/automate.log")
            echo "  [Db Chat] automate: $input"
            echo "  Saved. Total automate entries: $total"
            _log "automate" "$input"
        fi
        ;;
    notify)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent notify entries:"
            tail -20 "$DATA_DIR/notify.log" 2>/dev/null || echo "  No entries yet. Use: db-chat notify <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/notify.log"
            local total=$(wc -l < "$DATA_DIR/notify.log")
            echo "  [Db Chat] notify: $input"
            echo "  Saved. Total notify entries: $total"
            _log "notify" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: db-chat report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Db Chat] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    schedule)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schedule entries:"
            tail -20 "$DATA_DIR/schedule.log" 2>/dev/null || echo "  No entries yet. Use: db-chat schedule <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schedule.log"
            local total=$(wc -l < "$DATA_DIR/schedule.log")
            echo "  [Db Chat] schedule: $input"
            echo "  Saved. Total schedule entries: $total"
            _log "schedule" "$input"
        fi
        ;;
    template)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent template entries:"
            tail -20 "$DATA_DIR/template.log" 2>/dev/null || echo "  No entries yet. Use: db-chat template <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/template.log"
            local total=$(wc -l < "$DATA_DIR/template.log")
            echo "  [Db Chat] template: $input"
            echo "  Saved. Total template entries: $total"
            _log "template" "$input"
        fi
        ;;
    webhook)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent webhook entries:"
            tail -20 "$DATA_DIR/webhook.log" 2>/dev/null || echo "  No entries yet. Use: db-chat webhook <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/webhook.log"
            local total=$(wc -l < "$DATA_DIR/webhook.log")
            echo "  [Db Chat] webhook: $input"
            echo "  Saved. Total webhook entries: $total"
            _log "webhook" "$input"
        fi
        ;;
    status)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent status entries:"
            tail -20 "$DATA_DIR/status.log" 2>/dev/null || echo "  No entries yet. Use: db-chat status <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/status.log"
            local total=$(wc -l < "$DATA_DIR/status.log")
            echo "  [Db Chat] status: $input"
            echo "  Saved. Total status entries: $total"
            _log "status" "$input"
        fi
        ;;
    analytics)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent analytics entries:"
            tail -20 "$DATA_DIR/analytics.log" 2>/dev/null || echo "  No entries yet. Use: db-chat analytics <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/analytics.log"
            local total=$(wc -l < "$DATA_DIR/analytics.log")
            echo "  [Db Chat] analytics: $input"
            echo "  Saved. Total analytics entries: $total"
            _log "analytics" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: db-chat export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Db Chat] export: $input"
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
        echo "Unknown: $1 — run 'db-chat help'"
        exit 1
        ;;
esac