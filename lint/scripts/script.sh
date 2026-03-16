#!/usr/bin/env bash
# Lint — devtools tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/lint"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "lint v2.0.0"; }

_help() {
    echo "Lint v2.0.0 — devtools toolkit"
    echo ""
    echo "Usage: lint <command> [args]"
    echo ""
    echo "Commands:"
    echo "  check              Check"
    echo "  validate           Validate"
    echo "  generate           Generate"
    echo "  format             Format"
    echo "  lint               Lint"
    echo "  explain            Explain"
    echo "  convert            Convert"
    echo "  template           Template"
    echo "  diff               Diff"
    echo "  preview            Preview"
    echo "  fix                Fix"
    echo "  report             Report"
    echo "  stats              Summary statistics"
    echo "  export <fmt>       Export (json|csv|txt)"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Lint Stats ==="
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
            echo "=== Lint Export ===" > "$out"
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
    echo "=== Lint Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: lint search <term>}"
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
    check)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent check entries:"
            tail -20 "$DATA_DIR/check.log" 2>/dev/null || echo "  No entries yet. Use: lint check <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/check.log"
            local total=$(wc -l < "$DATA_DIR/check.log")
            echo "  [Lint] check: $input"
            echo "  Saved. Total check entries: $total"
            _log "check" "$input"
        fi
        ;;
    validate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent validate entries:"
            tail -20 "$DATA_DIR/validate.log" 2>/dev/null || echo "  No entries yet. Use: lint validate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/validate.log"
            local total=$(wc -l < "$DATA_DIR/validate.log")
            echo "  [Lint] validate: $input"
            echo "  Saved. Total validate entries: $total"
            _log "validate" "$input"
        fi
        ;;
    generate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent generate entries:"
            tail -20 "$DATA_DIR/generate.log" 2>/dev/null || echo "  No entries yet. Use: lint generate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/generate.log"
            local total=$(wc -l < "$DATA_DIR/generate.log")
            echo "  [Lint] generate: $input"
            echo "  Saved. Total generate entries: $total"
            _log "generate" "$input"
        fi
        ;;
    format)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent format entries:"
            tail -20 "$DATA_DIR/format.log" 2>/dev/null || echo "  No entries yet. Use: lint format <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/format.log"
            local total=$(wc -l < "$DATA_DIR/format.log")
            echo "  [Lint] format: $input"
            echo "  Saved. Total format entries: $total"
            _log "format" "$input"
        fi
        ;;
    lint)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent lint entries:"
            tail -20 "$DATA_DIR/lint.log" 2>/dev/null || echo "  No entries yet. Use: lint lint <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/lint.log"
            local total=$(wc -l < "$DATA_DIR/lint.log")
            echo "  [Lint] lint: $input"
            echo "  Saved. Total lint entries: $total"
            _log "lint" "$input"
        fi
        ;;
    explain)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent explain entries:"
            tail -20 "$DATA_DIR/explain.log" 2>/dev/null || echo "  No entries yet. Use: lint explain <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/explain.log"
            local total=$(wc -l < "$DATA_DIR/explain.log")
            echo "  [Lint] explain: $input"
            echo "  Saved. Total explain entries: $total"
            _log "explain" "$input"
        fi
        ;;
    convert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent convert entries:"
            tail -20 "$DATA_DIR/convert.log" 2>/dev/null || echo "  No entries yet. Use: lint convert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/convert.log"
            local total=$(wc -l < "$DATA_DIR/convert.log")
            echo "  [Lint] convert: $input"
            echo "  Saved. Total convert entries: $total"
            _log "convert" "$input"
        fi
        ;;
    template)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent template entries:"
            tail -20 "$DATA_DIR/template.log" 2>/dev/null || echo "  No entries yet. Use: lint template <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/template.log"
            local total=$(wc -l < "$DATA_DIR/template.log")
            echo "  [Lint] template: $input"
            echo "  Saved. Total template entries: $total"
            _log "template" "$input"
        fi
        ;;
    diff)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent diff entries:"
            tail -20 "$DATA_DIR/diff.log" 2>/dev/null || echo "  No entries yet. Use: lint diff <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/diff.log"
            local total=$(wc -l < "$DATA_DIR/diff.log")
            echo "  [Lint] diff: $input"
            echo "  Saved. Total diff entries: $total"
            _log "diff" "$input"
        fi
        ;;
    preview)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent preview entries:"
            tail -20 "$DATA_DIR/preview.log" 2>/dev/null || echo "  No entries yet. Use: lint preview <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/preview.log"
            local total=$(wc -l < "$DATA_DIR/preview.log")
            echo "  [Lint] preview: $input"
            echo "  Saved. Total preview entries: $total"
            _log "preview" "$input"
        fi
        ;;
    fix)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent fix entries:"
            tail -20 "$DATA_DIR/fix.log" 2>/dev/null || echo "  No entries yet. Use: lint fix <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/fix.log"
            local total=$(wc -l < "$DATA_DIR/fix.log")
            echo "  [Lint] fix: $input"
            echo "  Saved. Total fix entries: $total"
            _log "fix" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: lint report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Lint] report: $input"
            echo "  Saved. Total report entries: $total"
            _log "report" "$input"
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
        echo "Run 'lint help' for available commands."
        exit 1
        ;;
esac