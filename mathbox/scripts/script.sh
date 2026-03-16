#!/usr/bin/env bash
# Mathbox — education tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/mathbox"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "mathbox v2.0.0"; }

_help() {
    echo "Mathbox v2.0.0 — education toolkit"
    echo ""
    echo "Usage: mathbox <command> [args]"
    echo ""
    echo "Commands:"
    echo "  study              Study"
    echo "  quiz               Quiz"
    echo "  review             Review"
    echo "  flashcard          Flashcard"
    echo "  progress           Progress"
    echo "  schedule           Schedule"
    echo "  goal               Goal"
    echo "  practice           Practice"
    echo "  test               Test"
    echo "  explain            Explain"
    echo "  summarize          Summarize"
    echo "  bookmark           Bookmark"
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
    echo "=== Mathbox Stats ==="
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
            echo "=== Mathbox Export ===" > "$out"
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
    echo "=== Mathbox Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: mathbox search <term>}"
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
    study)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent study entries:"
            tail -20 "$DATA_DIR/study.log" 2>/dev/null || echo "  No entries yet. Use: mathbox study <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/study.log"
            local total=$(wc -l < "$DATA_DIR/study.log")
            echo "  [Mathbox] study: $input"
            echo "  Saved. Total study entries: $total"
            _log "study" "$input"
        fi
        ;;
    quiz)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent quiz entries:"
            tail -20 "$DATA_DIR/quiz.log" 2>/dev/null || echo "  No entries yet. Use: mathbox quiz <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/quiz.log"
            local total=$(wc -l < "$DATA_DIR/quiz.log")
            echo "  [Mathbox] quiz: $input"
            echo "  Saved. Total quiz entries: $total"
            _log "quiz" "$input"
        fi
        ;;
    review)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent review entries:"
            tail -20 "$DATA_DIR/review.log" 2>/dev/null || echo "  No entries yet. Use: mathbox review <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/review.log"
            local total=$(wc -l < "$DATA_DIR/review.log")
            echo "  [Mathbox] review: $input"
            echo "  Saved. Total review entries: $total"
            _log "review" "$input"
        fi
        ;;
    flashcard)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent flashcard entries:"
            tail -20 "$DATA_DIR/flashcard.log" 2>/dev/null || echo "  No entries yet. Use: mathbox flashcard <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/flashcard.log"
            local total=$(wc -l < "$DATA_DIR/flashcard.log")
            echo "  [Mathbox] flashcard: $input"
            echo "  Saved. Total flashcard entries: $total"
            _log "flashcard" "$input"
        fi
        ;;
    progress)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent progress entries:"
            tail -20 "$DATA_DIR/progress.log" 2>/dev/null || echo "  No entries yet. Use: mathbox progress <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/progress.log"
            local total=$(wc -l < "$DATA_DIR/progress.log")
            echo "  [Mathbox] progress: $input"
            echo "  Saved. Total progress entries: $total"
            _log "progress" "$input"
        fi
        ;;
    schedule)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schedule entries:"
            tail -20 "$DATA_DIR/schedule.log" 2>/dev/null || echo "  No entries yet. Use: mathbox schedule <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schedule.log"
            local total=$(wc -l < "$DATA_DIR/schedule.log")
            echo "  [Mathbox] schedule: $input"
            echo "  Saved. Total schedule entries: $total"
            _log "schedule" "$input"
        fi
        ;;
    goal)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent goal entries:"
            tail -20 "$DATA_DIR/goal.log" 2>/dev/null || echo "  No entries yet. Use: mathbox goal <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/goal.log"
            local total=$(wc -l < "$DATA_DIR/goal.log")
            echo "  [Mathbox] goal: $input"
            echo "  Saved. Total goal entries: $total"
            _log "goal" "$input"
        fi
        ;;
    practice)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent practice entries:"
            tail -20 "$DATA_DIR/practice.log" 2>/dev/null || echo "  No entries yet. Use: mathbox practice <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/practice.log"
            local total=$(wc -l < "$DATA_DIR/practice.log")
            echo "  [Mathbox] practice: $input"
            echo "  Saved. Total practice entries: $total"
            _log "practice" "$input"
        fi
        ;;
    test)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent test entries:"
            tail -20 "$DATA_DIR/test.log" 2>/dev/null || echo "  No entries yet. Use: mathbox test <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/test.log"
            local total=$(wc -l < "$DATA_DIR/test.log")
            echo "  [Mathbox] test: $input"
            echo "  Saved. Total test entries: $total"
            _log "test" "$input"
        fi
        ;;
    explain)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent explain entries:"
            tail -20 "$DATA_DIR/explain.log" 2>/dev/null || echo "  No entries yet. Use: mathbox explain <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/explain.log"
            local total=$(wc -l < "$DATA_DIR/explain.log")
            echo "  [Mathbox] explain: $input"
            echo "  Saved. Total explain entries: $total"
            _log "explain" "$input"
        fi
        ;;
    summarize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent summarize entries:"
            tail -20 "$DATA_DIR/summarize.log" 2>/dev/null || echo "  No entries yet. Use: mathbox summarize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/summarize.log"
            local total=$(wc -l < "$DATA_DIR/summarize.log")
            echo "  [Mathbox] summarize: $input"
            echo "  Saved. Total summarize entries: $total"
            _log "summarize" "$input"
        fi
        ;;
    bookmark)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent bookmark entries:"
            tail -20 "$DATA_DIR/bookmark.log" 2>/dev/null || echo "  No entries yet. Use: mathbox bookmark <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/bookmark.log"
            local total=$(wc -l < "$DATA_DIR/bookmark.log")
            echo "  [Mathbox] bookmark: $input"
            echo "  Saved. Total bookmark entries: $total"
            _log "bookmark" "$input"
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
        echo "Unknown: $1 — run 'mathbox help'"
        exit 1
        ;;
esac