#!/usr/bin/env bash
# Vitamin — health tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/vitamin"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "vitamin v2.0.0"; }

_help() {
    echo "Vitamin v2.0.0 — health toolkit"
    echo ""
    echo "Usage: vitamin <command> [args]"
    echo ""
    echo "Commands:"
    echo "  log                Log"
    echo "  track              Track"
    echo "  chart              Chart"
    echo "  goal               Goal"
    echo "  remind             Remind"
    echo "  weekly             Weekly"
    echo "  monthly            Monthly"
    echo "  compare            Compare"
    echo "  export             Export"
    echo "  streak             Streak"
    echo "  milestone          Milestone"
    echo "  trend              Trend"
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
    echo "=== Vitamin Stats ==="
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
            echo "=== Vitamin Export ===" > "$out"
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
    echo "=== Vitamin Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: vitamin search <term>}"
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
    log)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent log entries:"
            tail -20 "$DATA_DIR/log.log" 2>/dev/null || echo "  No entries yet. Use: vitamin log <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/log.log"
            local total=$(wc -l < "$DATA_DIR/log.log")
            echo "  [Vitamin] log: $input"
            echo "  Saved. Total log entries: $total"
            _log "log" "$input"
        fi
        ;;
    track)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent track entries:"
            tail -20 "$DATA_DIR/track.log" 2>/dev/null || echo "  No entries yet. Use: vitamin track <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/track.log"
            local total=$(wc -l < "$DATA_DIR/track.log")
            echo "  [Vitamin] track: $input"
            echo "  Saved. Total track entries: $total"
            _log "track" "$input"
        fi
        ;;
    chart)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent chart entries:"
            tail -20 "$DATA_DIR/chart.log" 2>/dev/null || echo "  No entries yet. Use: vitamin chart <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/chart.log"
            local total=$(wc -l < "$DATA_DIR/chart.log")
            echo "  [Vitamin] chart: $input"
            echo "  Saved. Total chart entries: $total"
            _log "chart" "$input"
        fi
        ;;
    goal)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent goal entries:"
            tail -20 "$DATA_DIR/goal.log" 2>/dev/null || echo "  No entries yet. Use: vitamin goal <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/goal.log"
            local total=$(wc -l < "$DATA_DIR/goal.log")
            echo "  [Vitamin] goal: $input"
            echo "  Saved. Total goal entries: $total"
            _log "goal" "$input"
        fi
        ;;
    remind)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent remind entries:"
            tail -20 "$DATA_DIR/remind.log" 2>/dev/null || echo "  No entries yet. Use: vitamin remind <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/remind.log"
            local total=$(wc -l < "$DATA_DIR/remind.log")
            echo "  [Vitamin] remind: $input"
            echo "  Saved. Total remind entries: $total"
            _log "remind" "$input"
        fi
        ;;
    weekly)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent weekly entries:"
            tail -20 "$DATA_DIR/weekly.log" 2>/dev/null || echo "  No entries yet. Use: vitamin weekly <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/weekly.log"
            local total=$(wc -l < "$DATA_DIR/weekly.log")
            echo "  [Vitamin] weekly: $input"
            echo "  Saved. Total weekly entries: $total"
            _log "weekly" "$input"
        fi
        ;;
    monthly)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent monthly entries:"
            tail -20 "$DATA_DIR/monthly.log" 2>/dev/null || echo "  No entries yet. Use: vitamin monthly <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/monthly.log"
            local total=$(wc -l < "$DATA_DIR/monthly.log")
            echo "  [Vitamin] monthly: $input"
            echo "  Saved. Total monthly entries: $total"
            _log "monthly" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: vitamin compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Vitamin] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: vitamin export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Vitamin] export: $input"
            echo "  Saved. Total export entries: $total"
            _log "export" "$input"
        fi
        ;;
    streak)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent streak entries:"
            tail -20 "$DATA_DIR/streak.log" 2>/dev/null || echo "  No entries yet. Use: vitamin streak <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/streak.log"
            local total=$(wc -l < "$DATA_DIR/streak.log")
            echo "  [Vitamin] streak: $input"
            echo "  Saved. Total streak entries: $total"
            _log "streak" "$input"
        fi
        ;;
    milestone)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent milestone entries:"
            tail -20 "$DATA_DIR/milestone.log" 2>/dev/null || echo "  No entries yet. Use: vitamin milestone <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/milestone.log"
            local total=$(wc -l < "$DATA_DIR/milestone.log")
            echo "  [Vitamin] milestone: $input"
            echo "  Saved. Total milestone entries: $total"
            _log "milestone" "$input"
        fi
        ;;
    trend)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent trend entries:"
            tail -20 "$DATA_DIR/trend.log" 2>/dev/null || echo "  No entries yet. Use: vitamin trend <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/trend.log"
            local total=$(wc -l < "$DATA_DIR/trend.log")
            echo "  [Vitamin] trend: $input"
            echo "  Saved. Total trend entries: $total"
            _log "trend" "$input"
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
        echo "Unknown: $1 — run 'vitamin help'"
        exit 1
        ;;
esac