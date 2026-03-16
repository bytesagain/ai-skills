#!/usr/bin/env bash
# Currency — travel tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/currency"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "currency v2.0.0"; }

_help() {
    echo "Currency v2.0.0 — travel toolkit"
    echo ""
    echo "Usage: currency <command> [args]"
    echo ""
    echo "Commands:"
    echo "  plan               Plan"
    echo "  search             Search"
    echo "  book               Book"
    echo "  pack-list          Pack List"
    echo "  budget             Budget"
    echo "  convert            Convert"
    echo "  weather            Weather"
    echo "  route              Route"
    echo "  checklist          Checklist"
    echo "  journal            Journal"
    echo "  compare            Compare"
    echo "  remind             Remind"
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
    echo "=== Currency Stats ==="
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
            echo "=== Currency Export ===" > "$out"
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
    echo "=== Currency Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: currency search <term>}"
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
    plan)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent plan entries:"
            tail -20 "$DATA_DIR/plan.log" 2>/dev/null || echo "  No entries yet. Use: currency plan <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/plan.log"
            local total=$(wc -l < "$DATA_DIR/plan.log")
            echo "  [Currency] plan: $input"
            echo "  Saved. Total plan entries: $total"
            _log "plan" "$input"
        fi
        ;;
    search)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent search entries:"
            tail -20 "$DATA_DIR/search.log" 2>/dev/null || echo "  No entries yet. Use: currency search <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/search.log"
            local total=$(wc -l < "$DATA_DIR/search.log")
            echo "  [Currency] search: $input"
            echo "  Saved. Total search entries: $total"
            _log "search" "$input"
        fi
        ;;
    book)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent book entries:"
            tail -20 "$DATA_DIR/book.log" 2>/dev/null || echo "  No entries yet. Use: currency book <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/book.log"
            local total=$(wc -l < "$DATA_DIR/book.log")
            echo "  [Currency] book: $input"
            echo "  Saved. Total book entries: $total"
            _log "book" "$input"
        fi
        ;;
    pack-list)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent pack-list entries:"
            tail -20 "$DATA_DIR/pack-list.log" 2>/dev/null || echo "  No entries yet. Use: currency pack-list <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/pack-list.log"
            local total=$(wc -l < "$DATA_DIR/pack-list.log")
            echo "  [Currency] pack-list: $input"
            echo "  Saved. Total pack-list entries: $total"
            _log "pack-list" "$input"
        fi
        ;;
    budget)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent budget entries:"
            tail -20 "$DATA_DIR/budget.log" 2>/dev/null || echo "  No entries yet. Use: currency budget <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/budget.log"
            local total=$(wc -l < "$DATA_DIR/budget.log")
            echo "  [Currency] budget: $input"
            echo "  Saved. Total budget entries: $total"
            _log "budget" "$input"
        fi
        ;;
    convert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent convert entries:"
            tail -20 "$DATA_DIR/convert.log" 2>/dev/null || echo "  No entries yet. Use: currency convert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/convert.log"
            local total=$(wc -l < "$DATA_DIR/convert.log")
            echo "  [Currency] convert: $input"
            echo "  Saved. Total convert entries: $total"
            _log "convert" "$input"
        fi
        ;;
    weather)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent weather entries:"
            tail -20 "$DATA_DIR/weather.log" 2>/dev/null || echo "  No entries yet. Use: currency weather <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/weather.log"
            local total=$(wc -l < "$DATA_DIR/weather.log")
            echo "  [Currency] weather: $input"
            echo "  Saved. Total weather entries: $total"
            _log "weather" "$input"
        fi
        ;;
    route)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent route entries:"
            tail -20 "$DATA_DIR/route.log" 2>/dev/null || echo "  No entries yet. Use: currency route <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/route.log"
            local total=$(wc -l < "$DATA_DIR/route.log")
            echo "  [Currency] route: $input"
            echo "  Saved. Total route entries: $total"
            _log "route" "$input"
        fi
        ;;
    checklist)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent checklist entries:"
            tail -20 "$DATA_DIR/checklist.log" 2>/dev/null || echo "  No entries yet. Use: currency checklist <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/checklist.log"
            local total=$(wc -l < "$DATA_DIR/checklist.log")
            echo "  [Currency] checklist: $input"
            echo "  Saved. Total checklist entries: $total"
            _log "checklist" "$input"
        fi
        ;;
    journal)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent journal entries:"
            tail -20 "$DATA_DIR/journal.log" 2>/dev/null || echo "  No entries yet. Use: currency journal <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/journal.log"
            local total=$(wc -l < "$DATA_DIR/journal.log")
            echo "  [Currency] journal: $input"
            echo "  Saved. Total journal entries: $total"
            _log "journal" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: currency compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Currency] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
        fi
        ;;
    remind)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent remind entries:"
            tail -20 "$DATA_DIR/remind.log" 2>/dev/null || echo "  No entries yet. Use: currency remind <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/remind.log"
            local total=$(wc -l < "$DATA_DIR/remind.log")
            echo "  [Currency] remind: $input"
            echo "  Saved. Total remind entries: $total"
            _log "remind" "$input"
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
        echo "Unknown: $1 — run 'currency help'"
        exit 1
        ;;
esac