#!/usr/bin/env bash
# Quicknote — productivity tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/quicknote"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "quicknote v2.0.0"; }

_help() {
    echo "Quicknote v2.0.0 — productivity toolkit"
    echo ""
    echo "Usage: quicknote <command> [args]"
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
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Quicknote Stats ==="
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
            echo "=== Quicknote Export ===" > "$out"
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
    echo "=== Quicknote Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: quicknote search <term>}"
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
    add)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent add entries:"
            tail -20 "$DATA_DIR/add.log" 2>/dev/null || echo "  No entries yet. Use: quicknote add <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/add.log"
            local total=$(wc -l < "$DATA_DIR/add.log")
            echo "  [Quicknote] add: $input"
            echo "  Saved. Total add entries: $total"
            _log "add" "$input"
        fi
        ;;
    plan)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent plan entries:"
            tail -20 "$DATA_DIR/plan.log" 2>/dev/null || echo "  No entries yet. Use: quicknote plan <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/plan.log"
            local total=$(wc -l < "$DATA_DIR/plan.log")
            echo "  [Quicknote] plan: $input"
            echo "  Saved. Total plan entries: $total"
            _log "plan" "$input"
        fi
        ;;
    track)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent track entries:"
            tail -20 "$DATA_DIR/track.log" 2>/dev/null || echo "  No entries yet. Use: quicknote track <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/track.log"
            local total=$(wc -l < "$DATA_DIR/track.log")
            echo "  [Quicknote] track: $input"
            echo "  Saved. Total track entries: $total"
            _log "track" "$input"
        fi
        ;;
    review)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent review entries:"
            tail -20 "$DATA_DIR/review.log" 2>/dev/null || echo "  No entries yet. Use: quicknote review <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/review.log"
            local total=$(wc -l < "$DATA_DIR/review.log")
            echo "  [Quicknote] review: $input"
            echo "  Saved. Total review entries: $total"
            _log "review" "$input"
        fi
        ;;
    streak)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent streak entries:"
            tail -20 "$DATA_DIR/streak.log" 2>/dev/null || echo "  No entries yet. Use: quicknote streak <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/streak.log"
            local total=$(wc -l < "$DATA_DIR/streak.log")
            echo "  [Quicknote] streak: $input"
            echo "  Saved. Total streak entries: $total"
            _log "streak" "$input"
        fi
        ;;
    remind)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent remind entries:"
            tail -20 "$DATA_DIR/remind.log" 2>/dev/null || echo "  No entries yet. Use: quicknote remind <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/remind.log"
            local total=$(wc -l < "$DATA_DIR/remind.log")
            echo "  [Quicknote] remind: $input"
            echo "  Saved. Total remind entries: $total"
            _log "remind" "$input"
        fi
        ;;
    prioritize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent prioritize entries:"
            tail -20 "$DATA_DIR/prioritize.log" 2>/dev/null || echo "  No entries yet. Use: quicknote prioritize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/prioritize.log"
            local total=$(wc -l < "$DATA_DIR/prioritize.log")
            echo "  [Quicknote] prioritize: $input"
            echo "  Saved. Total prioritize entries: $total"
            _log "prioritize" "$input"
        fi
        ;;
    archive)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent archive entries:"
            tail -20 "$DATA_DIR/archive.log" 2>/dev/null || echo "  No entries yet. Use: quicknote archive <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/archive.log"
            local total=$(wc -l < "$DATA_DIR/archive.log")
            echo "  [Quicknote] archive: $input"
            echo "  Saved. Total archive entries: $total"
            _log "archive" "$input"
        fi
        ;;
    tag)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent tag entries:"
            tail -20 "$DATA_DIR/tag.log" 2>/dev/null || echo "  No entries yet. Use: quicknote tag <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/tag.log"
            local total=$(wc -l < "$DATA_DIR/tag.log")
            echo "  [Quicknote] tag: $input"
            echo "  Saved. Total tag entries: $total"
            _log "tag" "$input"
        fi
        ;;
    timeline)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent timeline entries:"
            tail -20 "$DATA_DIR/timeline.log" 2>/dev/null || echo "  No entries yet. Use: quicknote timeline <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/timeline.log"
            local total=$(wc -l < "$DATA_DIR/timeline.log")
            echo "  [Quicknote] timeline: $input"
            echo "  Saved. Total timeline entries: $total"
            _log "timeline" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: quicknote report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Quicknote] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    weekly-review)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent weekly-review entries:"
            tail -20 "$DATA_DIR/weekly-review.log" 2>/dev/null || echo "  No entries yet. Use: quicknote weekly-review <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/weekly-review.log"
            local total=$(wc -l < "$DATA_DIR/weekly-review.log")
            echo "  [Quicknote] weekly-review: $input"
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
        echo "Unknown command: $1"
        echo "Run 'quicknote help' for available commands."
        exit 1
        ;;
esac