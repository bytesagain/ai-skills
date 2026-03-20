#!/usr/bin/env bash
# Markpad — content tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/markpad"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "markpad v2.0.0"; }

_help() {
    echo "Markpad v2.0.0 — content toolkit"
    echo ""
    echo "Usage: markpad <command> [args]"
    echo ""
    echo "Commands:"
    echo "  draft              Draft"
    echo "  edit               Edit"
    echo "  optimize           Optimize"
    echo "  schedule           Schedule"
    echo "  hashtags           Hashtags"
    echo "  hooks              Hooks"
    echo "  cta                Cta"
    echo "  rewrite            Rewrite"
    echo "  translate          Translate"
    echo "  tone               Tone"
    echo "  headline           Headline"
    echo "  outline            Outline"
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
    echo "=== Markpad Stats ==="
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
            echo "=== Markpad Export ===" > "$out"
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
    echo "=== Markpad Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: markpad search <term>}"
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
    draft)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent draft entries:"
            tail -20 "$DATA_DIR/draft.log" 2>/dev/null || echo "  No entries yet. Use: markpad draft <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/draft.log"
            local total=$(wc -l < "$DATA_DIR/draft.log")
            echo "  [Markpad] draft: $input"
            echo "  Saved. Total draft entries: $total"
            _log "draft" "$input"
        fi
        ;;
    edit)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent edit entries:"
            tail -20 "$DATA_DIR/edit.log" 2>/dev/null || echo "  No entries yet. Use: markpad edit <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/edit.log"
            local total=$(wc -l < "$DATA_DIR/edit.log")
            echo "  [Markpad] edit: $input"
            echo "  Saved. Total edit entries: $total"
            _log "edit" "$input"
        fi
        ;;
    optimize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent optimize entries:"
            tail -20 "$DATA_DIR/optimize.log" 2>/dev/null || echo "  No entries yet. Use: markpad optimize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/optimize.log"
            local total=$(wc -l < "$DATA_DIR/optimize.log")
            echo "  [Markpad] optimize: $input"
            echo "  Saved. Total optimize entries: $total"
            _log "optimize" "$input"
        fi
        ;;
    schedule)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schedule entries:"
            tail -20 "$DATA_DIR/schedule.log" 2>/dev/null || echo "  No entries yet. Use: markpad schedule <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schedule.log"
            local total=$(wc -l < "$DATA_DIR/schedule.log")
            echo "  [Markpad] schedule: $input"
            echo "  Saved. Total schedule entries: $total"
            _log "schedule" "$input"
        fi
        ;;
    hashtags)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent hashtags entries:"
            tail -20 "$DATA_DIR/hashtags.log" 2>/dev/null || echo "  No entries yet. Use: markpad hashtags <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/hashtags.log"
            local total=$(wc -l < "$DATA_DIR/hashtags.log")
            echo "  [Markpad] hashtags: $input"
            echo "  Saved. Total hashtags entries: $total"
            _log "hashtags" "$input"
        fi
        ;;
    hooks)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent hooks entries:"
            tail -20 "$DATA_DIR/hooks.log" 2>/dev/null || echo "  No entries yet. Use: markpad hooks <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/hooks.log"
            local total=$(wc -l < "$DATA_DIR/hooks.log")
            echo "  [Markpad] hooks: $input"
            echo "  Saved. Total hooks entries: $total"
            _log "hooks" "$input"
        fi
        ;;
    cta)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent cta entries:"
            tail -20 "$DATA_DIR/cta.log" 2>/dev/null || echo "  No entries yet. Use: markpad cta <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/cta.log"
            local total=$(wc -l < "$DATA_DIR/cta.log")
            echo "  [Markpad] cta: $input"
            echo "  Saved. Total cta entries: $total"
            _log "cta" "$input"
        fi
        ;;
    rewrite)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent rewrite entries:"
            tail -20 "$DATA_DIR/rewrite.log" 2>/dev/null || echo "  No entries yet. Use: markpad rewrite <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/rewrite.log"
            local total=$(wc -l < "$DATA_DIR/rewrite.log")
            echo "  [Markpad] rewrite: $input"
            echo "  Saved. Total rewrite entries: $total"
            _log "rewrite" "$input"
        fi
        ;;
    translate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent translate entries:"
            tail -20 "$DATA_DIR/translate.log" 2>/dev/null || echo "  No entries yet. Use: markpad translate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/translate.log"
            local total=$(wc -l < "$DATA_DIR/translate.log")
            echo "  [Markpad] translate: $input"
            echo "  Saved. Total translate entries: $total"
            _log "translate" "$input"
        fi
        ;;
    tone)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent tone entries:"
            tail -20 "$DATA_DIR/tone.log" 2>/dev/null || echo "  No entries yet. Use: markpad tone <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/tone.log"
            local total=$(wc -l < "$DATA_DIR/tone.log")
            echo "  [Markpad] tone: $input"
            echo "  Saved. Total tone entries: $total"
            _log "tone" "$input"
        fi
        ;;
    headline)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent headline entries:"
            tail -20 "$DATA_DIR/headline.log" 2>/dev/null || echo "  No entries yet. Use: markpad headline <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/headline.log"
            local total=$(wc -l < "$DATA_DIR/headline.log")
            echo "  [Markpad] headline: $input"
            echo "  Saved. Total headline entries: $total"
            _log "headline" "$input"
        fi
        ;;
    outline)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent outline entries:"
            tail -20 "$DATA_DIR/outline.log" 2>/dev/null || echo "  No entries yet. Use: markpad outline <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/outline.log"
            local total=$(wc -l < "$DATA_DIR/outline.log")
            echo "  [Markpad] outline: $input"
            echo "  Saved. Total outline entries: $total"
            _log "outline" "$input"
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
        echo "Unknown: $1 — run 'markpad help'"
        exit 1
        ;;
esac