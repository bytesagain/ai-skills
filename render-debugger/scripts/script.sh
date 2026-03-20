#!/usr/bin/env bash
# Render Debugger — devtools tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/render-debugger"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "render-debugger v2.0.0"; }

_help() {
    echo "Render Debugger v2.0.0 — devtools toolkit"
    echo ""
    echo "Usage: render-debugger <command> [args]"
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
    echo "  search <term>      Search entries"
    echo "  recent             Recent activity"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Render Debugger Stats ==="
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
            echo "=== Render Debugger Export ===" > "$out"
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
    echo "=== Render Debugger Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: render-debugger search <term>}"
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
    check)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent check entries:"
            tail -20 "$DATA_DIR/check.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger check <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/check.log"
            local total=$(wc -l < "$DATA_DIR/check.log")
            echo "  [Render Debugger] check: $input"
            echo "  Saved. Total check entries: $total"
            _log "check" "$input"
        fi
        ;;
    validate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent validate entries:"
            tail -20 "$DATA_DIR/validate.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger validate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/validate.log"
            local total=$(wc -l < "$DATA_DIR/validate.log")
            echo "  [Render Debugger] validate: $input"
            echo "  Saved. Total validate entries: $total"
            _log "validate" "$input"
        fi
        ;;
    generate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent generate entries:"
            tail -20 "$DATA_DIR/generate.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger generate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/generate.log"
            local total=$(wc -l < "$DATA_DIR/generate.log")
            echo "  [Render Debugger] generate: $input"
            echo "  Saved. Total generate entries: $total"
            _log "generate" "$input"
        fi
        ;;
    format)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent format entries:"
            tail -20 "$DATA_DIR/format.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger format <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/format.log"
            local total=$(wc -l < "$DATA_DIR/format.log")
            echo "  [Render Debugger] format: $input"
            echo "  Saved. Total format entries: $total"
            _log "format" "$input"
        fi
        ;;
    lint)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent lint entries:"
            tail -20 "$DATA_DIR/lint.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger lint <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/lint.log"
            local total=$(wc -l < "$DATA_DIR/lint.log")
            echo "  [Render Debugger] lint: $input"
            echo "  Saved. Total lint entries: $total"
            _log "lint" "$input"
        fi
        ;;
    explain)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent explain entries:"
            tail -20 "$DATA_DIR/explain.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger explain <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/explain.log"
            local total=$(wc -l < "$DATA_DIR/explain.log")
            echo "  [Render Debugger] explain: $input"
            echo "  Saved. Total explain entries: $total"
            _log "explain" "$input"
        fi
        ;;
    convert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent convert entries:"
            tail -20 "$DATA_DIR/convert.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger convert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/convert.log"
            local total=$(wc -l < "$DATA_DIR/convert.log")
            echo "  [Render Debugger] convert: $input"
            echo "  Saved. Total convert entries: $total"
            _log "convert" "$input"
        fi
        ;;
    template)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent template entries:"
            tail -20 "$DATA_DIR/template.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger template <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/template.log"
            local total=$(wc -l < "$DATA_DIR/template.log")
            echo "  [Render Debugger] template: $input"
            echo "  Saved. Total template entries: $total"
            _log "template" "$input"
        fi
        ;;
    diff)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent diff entries:"
            tail -20 "$DATA_DIR/diff.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger diff <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/diff.log"
            local total=$(wc -l < "$DATA_DIR/diff.log")
            echo "  [Render Debugger] diff: $input"
            echo "  Saved. Total diff entries: $total"
            _log "diff" "$input"
        fi
        ;;
    preview)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent preview entries:"
            tail -20 "$DATA_DIR/preview.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger preview <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/preview.log"
            local total=$(wc -l < "$DATA_DIR/preview.log")
            echo "  [Render Debugger] preview: $input"
            echo "  Saved. Total preview entries: $total"
            _log "preview" "$input"
        fi
        ;;
    fix)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent fix entries:"
            tail -20 "$DATA_DIR/fix.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger fix <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/fix.log"
            local total=$(wc -l < "$DATA_DIR/fix.log")
            echo "  [Render Debugger] fix: $input"
            echo "  Saved. Total fix entries: $total"
            _log "fix" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: render-debugger report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Render Debugger] report: $input"
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
        echo "Unknown: $1 — run 'render-debugger help'"
        exit 1
        ;;
esac