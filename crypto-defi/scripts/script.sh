#!/usr/bin/env bash
# Crypto Defi — crypto tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/crypto-defi"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "crypto-defi v2.0.0"; }

_help() {
    echo "Crypto Defi v2.0.0 — crypto toolkit"
    echo ""
    echo "Usage: crypto-defi <command> [args]"
    echo ""
    echo "Commands:"
    echo "  track              Track"
    echo "  portfolio          Portfolio"
    echo "  alert              Alert"
    echo "  price              Price"
    echo "  compare            Compare"
    echo "  history            History"
    echo "  gas                Gas"
    echo "  whale-watch        Whale Watch"
    echo "  report             Report"
    echo "  watchlist          Watchlist"
    echo "  analyze            Analyze"
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
    echo "=== Crypto Defi Stats ==="
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
            echo "=== Crypto Defi Export ===" > "$out"
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
    echo "=== Crypto Defi Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: crypto-defi search <term>}"
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
    track)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent track entries:"
            tail -20 "$DATA_DIR/track.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi track <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/track.log"
            local total=$(wc -l < "$DATA_DIR/track.log")
            echo "  [Crypto Defi] track: $input"
            echo "  Saved. Total track entries: $total"
            _log "track" "$input"
        fi
        ;;
    portfolio)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent portfolio entries:"
            tail -20 "$DATA_DIR/portfolio.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi portfolio <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/portfolio.log"
            local total=$(wc -l < "$DATA_DIR/portfolio.log")
            echo "  [Crypto Defi] portfolio: $input"
            echo "  Saved. Total portfolio entries: $total"
            _log "portfolio" "$input"
        fi
        ;;
    alert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent alert entries:"
            tail -20 "$DATA_DIR/alert.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi alert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/alert.log"
            local total=$(wc -l < "$DATA_DIR/alert.log")
            echo "  [Crypto Defi] alert: $input"
            echo "  Saved. Total alert entries: $total"
            _log "alert" "$input"
        fi
        ;;
    price)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent price entries:"
            tail -20 "$DATA_DIR/price.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi price <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/price.log"
            local total=$(wc -l < "$DATA_DIR/price.log")
            echo "  [Crypto Defi] price: $input"
            echo "  Saved. Total price entries: $total"
            _log "price" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Crypto Defi] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
        fi
        ;;
    history)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent history entries:"
            tail -20 "$DATA_DIR/history.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi history <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/history.log"
            local total=$(wc -l < "$DATA_DIR/history.log")
            echo "  [Crypto Defi] history: $input"
            echo "  Saved. Total history entries: $total"
            _log "history" "$input"
        fi
        ;;
    gas)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent gas entries:"
            tail -20 "$DATA_DIR/gas.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi gas <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/gas.log"
            local total=$(wc -l < "$DATA_DIR/gas.log")
            echo "  [Crypto Defi] gas: $input"
            echo "  Saved. Total gas entries: $total"
            _log "gas" "$input"
        fi
        ;;
    whale-watch)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent whale-watch entries:"
            tail -20 "$DATA_DIR/whale-watch.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi whale-watch <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/whale-watch.log"
            local total=$(wc -l < "$DATA_DIR/whale-watch.log")
            echo "  [Crypto Defi] whale-watch: $input"
            echo "  Saved. Total whale-watch entries: $total"
            _log "whale-watch" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Crypto Defi] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
        fi
        ;;
    watchlist)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent watchlist entries:"
            tail -20 "$DATA_DIR/watchlist.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi watchlist <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/watchlist.log"
            local total=$(wc -l < "$DATA_DIR/watchlist.log")
            echo "  [Crypto Defi] watchlist: $input"
            echo "  Saved. Total watchlist entries: $total"
            _log "watchlist" "$input"
        fi
        ;;
    analyze)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent analyze entries:"
            tail -20 "$DATA_DIR/analyze.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi analyze <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/analyze.log"
            local total=$(wc -l < "$DATA_DIR/analyze.log")
            echo "  [Crypto Defi] analyze: $input"
            echo "  Saved. Total analyze entries: $total"
            _log "analyze" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: crypto-defi export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Crypto Defi] export: $input"
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
        echo "Run 'crypto-defi help' for available commands."
        exit 1
        ;;
esac