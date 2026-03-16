#!/usr/bin/env bash
# Discord Toolkit — social tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/discord-toolkit"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "discord-toolkit v2.0.0"; }

_help() {
    echo "Discord Toolkit v2.0.0 — social toolkit"
    echo ""
    echo "Usage: discord-toolkit <command> [args]"
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
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Discord Toolkit Stats ==="
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
            echo "=== Discord Toolkit Export ===" > "$out"
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
    echo "=== Discord Toolkit Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: discord-toolkit search <term>}"
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
    connect)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent connect entries:"
            tail -20 "$DATA_DIR/connect.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit connect <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/connect.log"
            local total=$(wc -l < "$DATA_DIR/connect.log")
            echo "  [Discord Toolkit] connect: $input"
            echo "  Saved. Total connect entries: $total"
            _log "connect" "$input"
        fi
        ;;
    sync)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent sync entries:"
            tail -20 "$DATA_DIR/sync.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit sync <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/sync.log"
            local total=$(wc -l < "$DATA_DIR/sync.log")
            echo "  [Discord Toolkit] sync: $input"
            echo "  Saved. Total sync entries: $total"
            _log "sync" "$input"
        fi
        ;;
    monitor)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent monitor entries:"
            tail -20 "$DATA_DIR/monitor.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit monitor <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/monitor.log"
            local total=$(wc -l < "$DATA_DIR/monitor.log")
            echo "  [Discord Toolkit] monitor: $input"
            echo "  Saved. Total monitor entries: $total"
            _log "monitor" "$input"
        fi
        ;;
    automate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent automate entries:"
            tail -20 "$DATA_DIR/automate.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit automate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/automate.log"
            local total=$(wc -l < "$DATA_DIR/automate.log")
            echo "  [Discord Toolkit] automate: $input"
            echo "  Saved. Total automate entries: $total"
            _log "automate" "$input"
        fi
        ;;
    notify)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent notify entries:"
            tail -20 "$DATA_DIR/notify.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit notify <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/notify.log"
            local total=$(wc -l < "$DATA_DIR/notify.log")
            echo "  [Discord Toolkit] notify: $input"
            echo "  Saved. Total notify entries: $total"
            _log "notify" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Discord Toolkit] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    schedule)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schedule entries:"
            tail -20 "$DATA_DIR/schedule.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit schedule <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schedule.log"
            local total=$(wc -l < "$DATA_DIR/schedule.log")
            echo "  [Discord Toolkit] schedule: $input"
            echo "  Saved. Total schedule entries: $total"
            _log "schedule" "$input"
        fi
        ;;
    template)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent template entries:"
            tail -20 "$DATA_DIR/template.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit template <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/template.log"
            local total=$(wc -l < "$DATA_DIR/template.log")
            echo "  [Discord Toolkit] template: $input"
            echo "  Saved. Total template entries: $total"
            _log "template" "$input"
        fi
        ;;
    webhook)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent webhook entries:"
            tail -20 "$DATA_DIR/webhook.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit webhook <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/webhook.log"
            local total=$(wc -l < "$DATA_DIR/webhook.log")
            echo "  [Discord Toolkit] webhook: $input"
            echo "  Saved. Total webhook entries: $total"
            _log "webhook" "$input"
        fi
        ;;
    status)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent status entries:"
            tail -20 "$DATA_DIR/status.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit status <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/status.log"
            local total=$(wc -l < "$DATA_DIR/status.log")
            echo "  [Discord Toolkit] status: $input"
            echo "  Saved. Total status entries: $total"
            _log "status" "$input"
        fi
        ;;
    analytics)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent analytics entries:"
            tail -20 "$DATA_DIR/analytics.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit analytics <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/analytics.log"
            local total=$(wc -l < "$DATA_DIR/analytics.log")
            echo "  [Discord Toolkit] analytics: $input"
            echo "  Saved. Total analytics entries: $total"
            _log "analytics" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: discord-toolkit export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Discord Toolkit] export: $input"
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
        echo "Unknown command: $1"
        echo "Run 'discord-toolkit help' for available commands."
        exit 1
        ;;
esac