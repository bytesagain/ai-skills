#!/usr/bin/env bash
# Todo Planner — productivity tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/todo-planner"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "todo-planner v2.0.0"; }

_help() {
    echo "Todo Planner v2.0.0 — productivity toolkit"
    echo ""
    echo "Usage: todo-planner <command> [args]"
    echo ""
    echo "Commands:"
    echo "  add                Add"
    echo "  plan               Plan"
    echo "  track              Track"
    echo "  review             Review"
    echo "  streak             Streak"
    echo "  remind             Remind"
    echo "  prioritize         Prioritize"
    echo "  archive            Archive"
    echo "  tag                Tag"
    echo "  timeline           Timeline"
    echo "  report             Report"
    echo "  weekly-review      Weekly Review"
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
    echo "=== Todo Planner Stats ==="
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
            echo "=== Todo Planner Export ===" > "$out"
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
    echo "=== Todo Planner Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: todo-planner search <term>}"
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
            tail -20 "$DATA_DIR/add.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner add <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/add.log"
            local total=$(wc -l < "$DATA_DIR/add.log")
            echo "  [Todo Planner] add: $input"
            echo "  Saved. Total add entries: $total"
            _log "add" "$input"
        fi
        ;;
    plan)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent plan entries:"
            tail -20 "$DATA_DIR/plan.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner plan <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/plan.log"
            local total=$(wc -l < "$DATA_DIR/plan.log")
            echo "  [Todo Planner] plan: $input"
            echo "  Saved. Total plan entries: $total"
            _log "plan" "$input"
        fi
        ;;
    track)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent track entries:"
            tail -20 "$DATA_DIR/track.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner track <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/track.log"
            local total=$(wc -l < "$DATA_DIR/track.log")
            echo "  [Todo Planner] track: $input"
            echo "  Saved. Total track entries: $total"
            _log "track" "$input"
        fi
        ;;
    review)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent review entries:"
            tail -20 "$DATA_DIR/review.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner review <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/review.log"
            local total=$(wc -l < "$DATA_DIR/review.log")
            echo "  [Todo Planner] review: $input"
            echo "  Saved. Total review entries: $total"
            _log "review" "$input"
        fi
        ;;
    streak)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent streak entries:"
            tail -20 "$DATA_DIR/streak.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner streak <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/streak.log"
            local total=$(wc -l < "$DATA_DIR/streak.log")
            echo "  [Todo Planner] streak: $input"
            echo "  Saved. Total streak entries: $total"
            _log "streak" "$input"
        fi
        ;;
    remind)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent remind entries:"
            tail -20 "$DATA_DIR/remind.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner remind <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/remind.log"
            local total=$(wc -l < "$DATA_DIR/remind.log")
            echo "  [Todo Planner] remind: $input"
            echo "  Saved. Total remind entries: $total"
            _log "remind" "$input"
        fi
        ;;
    prioritize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent prioritize entries:"
            tail -20 "$DATA_DIR/prioritize.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner prioritize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/prioritize.log"
            local total=$(wc -l < "$DATA_DIR/prioritize.log")
            echo "  [Todo Planner] prioritize: $input"
            echo "  Saved. Total prioritize entries: $total"
            _log "prioritize" "$input"
        fi
        ;;
    archive)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent archive entries:"
            tail -20 "$DATA_DIR/archive.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner archive <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/archive.log"
            local total=$(wc -l < "$DATA_DIR/archive.log")
            echo "  [Todo Planner] archive: $input"
            echo "  Saved. Total archive entries: $total"
            _log "archive" "$input"
        fi
        ;;
    tag)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent tag entries:"
            tail -20 "$DATA_DIR/tag.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner tag <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/tag.log"
            local total=$(wc -l < "$DATA_DIR/tag.log")
            echo "  [Todo Planner] tag: $input"
            echo "  Saved. Total tag entries: $total"
            _log "tag" "$input"
        fi
        ;;
    timeline)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent timeline entries:"
            tail -20 "$DATA_DIR/timeline.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner timeline <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/timeline.log"
            local total=$(wc -l < "$DATA_DIR/timeline.log")
            echo "  [Todo Planner] timeline: $input"
            echo "  Saved. Total timeline entries: $total"
            _log "timeline" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Todo Planner] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    weekly-review)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent weekly-review entries:"
            tail -20 "$DATA_DIR/weekly-review.log" 2>/dev/null || echo "  No entries yet. Use: todo-planner weekly-review <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/weekly-review.log"
            local total=$(wc -l < "$DATA_DIR/weekly-review.log")
            echo "  [Todo Planner] weekly-review: $input"
            echo "  Saved. Total weekly-review entries: $total"
            _log "weekly-review" "$input"
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
        echo "Unknown: $1 — run 'todo-planner help'"
        exit 1
        ;;
esac