#!/usr/bin/env bash
# Cleaning — home tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/cleaning"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "cleaning v2.0.0"; }

_help() {
    echo "Cleaning v2.0.0 — home toolkit"
    echo ""
    echo "Usage: cleaning <command> [args]"
    echo ""
    echo "Commands:"
    echo "  add                Add"
    echo "  inventory          Inventory"
    echo "  schedule           Schedule"
    echo "  remind             Remind"
    echo "  checklist          Checklist"
    echo "  usage              Usage"
    echo "  cost               Cost"
    echo "  maintain           Maintain"
    echo "  log                Log"
    echo "  report             Report"
    echo "  seasonal           Seasonal"
    echo "  tips               Tips"
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
    echo "=== Cleaning Stats ==="
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
            echo "=== Cleaning Export ===" > "$out"
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
    echo "=== Cleaning Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: cleaning search <term>}"
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
    add)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent add entries:"
            tail -20 "$DATA_DIR/add.log" 2>/dev/null || echo "  No entries yet. Use: cleaning add <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/add.log"
            local total=$(wc -l < "$DATA_DIR/add.log")
            echo "  [Cleaning] add: $input"
            echo "  Saved. Total add entries: $total"
            _log "add" "$input"
        fi
        ;;
    inventory)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent inventory entries:"
            tail -20 "$DATA_DIR/inventory.log" 2>/dev/null || echo "  No entries yet. Use: cleaning inventory <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/inventory.log"
            local total=$(wc -l < "$DATA_DIR/inventory.log")
            echo "  [Cleaning] inventory: $input"
            echo "  Saved. Total inventory entries: $total"
            _log "inventory" "$input"
        fi
        ;;
    schedule)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schedule entries:"
            tail -20 "$DATA_DIR/schedule.log" 2>/dev/null || echo "  No entries yet. Use: cleaning schedule <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schedule.log"
            local total=$(wc -l < "$DATA_DIR/schedule.log")
            echo "  [Cleaning] schedule: $input"
            echo "  Saved. Total schedule entries: $total"
            _log "schedule" "$input"
        fi
        ;;
    remind)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent remind entries:"
            tail -20 "$DATA_DIR/remind.log" 2>/dev/null || echo "  No entries yet. Use: cleaning remind <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/remind.log"
            local total=$(wc -l < "$DATA_DIR/remind.log")
            echo "  [Cleaning] remind: $input"
            echo "  Saved. Total remind entries: $total"
            _log "remind" "$input"
        fi
        ;;
    checklist)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent checklist entries:"
            tail -20 "$DATA_DIR/checklist.log" 2>/dev/null || echo "  No entries yet. Use: cleaning checklist <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/checklist.log"
            local total=$(wc -l < "$DATA_DIR/checklist.log")
            echo "  [Cleaning] checklist: $input"
            echo "  Saved. Total checklist entries: $total"
            _log "checklist" "$input"
        fi
        ;;
    usage)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent usage entries:"
            tail -20 "$DATA_DIR/usage.log" 2>/dev/null || echo "  No entries yet. Use: cleaning usage <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/usage.log"
            local total=$(wc -l < "$DATA_DIR/usage.log")
            echo "  [Cleaning] usage: $input"
            echo "  Saved. Total usage entries: $total"
            _log "usage" "$input"
        fi
        ;;
    cost)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent cost entries:"
            tail -20 "$DATA_DIR/cost.log" 2>/dev/null || echo "  No entries yet. Use: cleaning cost <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/cost.log"
            local total=$(wc -l < "$DATA_DIR/cost.log")
            echo "  [Cleaning] cost: $input"
            echo "  Saved. Total cost entries: $total"
            _log "cost" "$input"
        fi
        ;;
    maintain)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent maintain entries:"
            tail -20 "$DATA_DIR/maintain.log" 2>/dev/null || echo "  No entries yet. Use: cleaning maintain <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/maintain.log"
            local total=$(wc -l < "$DATA_DIR/maintain.log")
            echo "  [Cleaning] maintain: $input"
            echo "  Saved. Total maintain entries: $total"
            _log "maintain" "$input"
        fi
        ;;
    log)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent log entries:"
            tail -20 "$DATA_DIR/log.log" 2>/dev/null || echo "  No entries yet. Use: cleaning log <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/log.log"
            local total=$(wc -l < "$DATA_DIR/log.log")
            echo "  [Cleaning] log: $input"
            echo "  Saved. Total log entries: $total"
            _log "log" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: cleaning report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Cleaning] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    seasonal)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent seasonal entries:"
            tail -20 "$DATA_DIR/seasonal.log" 2>/dev/null || echo "  No entries yet. Use: cleaning seasonal <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/seasonal.log"
            local total=$(wc -l < "$DATA_DIR/seasonal.log")
            echo "  [Cleaning] seasonal: $input"
            echo "  Saved. Total seasonal entries: $total"
            _log "seasonal" "$input"
        fi
        ;;
    tips)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent tips entries:"
            tail -20 "$DATA_DIR/tips.log" 2>/dev/null || echo "  No entries yet. Use: cleaning tips <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/tips.log"
            local total=$(wc -l < "$DATA_DIR/tips.log")
            echo "  [Cleaning] tips: $input"
            echo "  Saved. Total tips entries: $total"
            _log "tips" "$input"
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
        echo "Unknown: $1 — run 'cleaning help'"
        exit 1
        ;;
esac