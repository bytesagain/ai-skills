#!/usr/bin/env bash
# Receipt — finance tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/receipt"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "receipt v2.0.0"; }

_help() {
    echo "Receipt v2.0.0 — finance toolkit"
    echo ""
    echo "Usage: receipt <command> [args]"
    echo ""
    echo "Commands:"
    echo "  record             Record"
    echo "  categorize         Categorize"
    echo "  balance            Balance"
    echo "  trend              Trend"
    echo "  forecast           Forecast"
    echo "  export-report      Export Report"
    echo "  budget-check       Budget Check"
    echo "  summary            Summary"
    echo "  alert              Alert"
    echo "  history            History"
    echo "  compare            Compare"
    echo "  tax-note           Tax Note"
    echo "  stats              Summary statistics"
    echo "  export <fmt>       Export (json|csv|txt)"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Receipt Stats ==="
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
            echo "=== Receipt Export ===" > "$out"
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
    echo "=== Receipt Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: receipt search <term>}"
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
    record)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent record entries:"
            tail -20 "$DATA_DIR/record.log" 2>/dev/null || echo "  No entries yet. Use: receipt record <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/record.log"
            local total=$(wc -l < "$DATA_DIR/record.log")
            echo "  [Receipt] record: $input"
            echo "  Saved. Total record entries: $total"
            _log "record" "$input"
        fi
        ;;
    categorize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent categorize entries:"
            tail -20 "$DATA_DIR/categorize.log" 2>/dev/null || echo "  No entries yet. Use: receipt categorize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/categorize.log"
            local total=$(wc -l < "$DATA_DIR/categorize.log")
            echo "  [Receipt] categorize: $input"
            echo "  Saved. Total categorize entries: $total"
            _log "categorize" "$input"
        fi
        ;;
    balance)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent balance entries:"
            tail -20 "$DATA_DIR/balance.log" 2>/dev/null || echo "  No entries yet. Use: receipt balance <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/balance.log"
            local total=$(wc -l < "$DATA_DIR/balance.log")
            echo "  [Receipt] balance: $input"
            echo "  Saved. Total balance entries: $total"
            _log "balance" "$input"
        fi
        ;;
    trend)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent trend entries:"
            tail -20 "$DATA_DIR/trend.log" 2>/dev/null || echo "  No entries yet. Use: receipt trend <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/trend.log"
            local total=$(wc -l < "$DATA_DIR/trend.log")
            echo "  [Receipt] trend: $input"
            echo "  Saved. Total trend entries: $total"
            _log "trend" "$input"
        fi
        ;;
    forecast)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent forecast entries:"
            tail -20 "$DATA_DIR/forecast.log" 2>/dev/null || echo "  No entries yet. Use: receipt forecast <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/forecast.log"
            local total=$(wc -l < "$DATA_DIR/forecast.log")
            echo "  [Receipt] forecast: $input"
            echo "  Saved. Total forecast entries: $total"
            _log "forecast" "$input"
        fi
        ;;
    export-report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export-report entries:"
            tail -20 "$DATA_DIR/export-report.log" 2>/dev/null || echo "  No entries yet. Use: receipt export-report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export-report.log"
            local total=$(wc -l < "$DATA_DIR/export-report.log")
            echo "  [Receipt] export-report: $input"
            echo "  Saved. Total export-report entries: $total"
            _log "export-report" "$input"
        fi
        ;;
    budget-check)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent budget-check entries:"
            tail -20 "$DATA_DIR/budget-check.log" 2>/dev/null || echo "  No entries yet. Use: receipt budget-check <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/budget-check.log"
            local total=$(wc -l < "$DATA_DIR/budget-check.log")
            echo "  [Receipt] budget-check: $input"
            echo "  Saved. Total budget-check entries: $total"
            _log "budget-check" "$input"
        fi
        ;;
    summary)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent summary entries:"
            tail -20 "$DATA_DIR/summary.log" 2>/dev/null || echo "  No entries yet. Use: receipt summary <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/summary.log"
            local total=$(wc -l < "$DATA_DIR/summary.log")
            echo "  [Receipt] summary: $input"
            echo "  Saved. Total summary entries: $total"
            _log "summary" "$input"
        fi
        ;;
    alert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent alert entries:"
            tail -20 "$DATA_DIR/alert.log" 2>/dev/null || echo "  No entries yet. Use: receipt alert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/alert.log"
            local total=$(wc -l < "$DATA_DIR/alert.log")
            echo "  [Receipt] alert: $input"
            echo "  Saved. Total alert entries: $total"
            _log "alert" "$input"
        fi
        ;;
    history)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent history entries:"
            tail -20 "$DATA_DIR/history.log" 2>/dev/null || echo "  No entries yet. Use: receipt history <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/history.log"
            local total=$(wc -l < "$DATA_DIR/history.log")
            echo "  [Receipt] history: $input"
            echo "  Saved. Total history entries: $total"
            _log "history" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: receipt compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Receipt] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
        fi
        ;;
    tax-note)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent tax-note entries:"
            tail -20 "$DATA_DIR/tax-note.log" 2>/dev/null || echo "  No entries yet. Use: receipt tax-note <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/tax-note.log"
            local total=$(wc -l < "$DATA_DIR/tax-note.log")
            echo "  [Receipt] tax-note: $input"
            echo "  Saved. Total tax-note entries: $total"
            _log "tax-note" "$input"
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
        echo "Run 'receipt help' for available commands."
        exit 1
        ;;
esac