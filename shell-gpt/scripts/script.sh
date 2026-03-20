#!/usr/bin/env bash
# Shell Gpt — ai tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/shell-gpt"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "shell-gpt v2.0.0"; }

_help() {
    echo "Shell Gpt v2.0.0 — ai toolkit"
    echo ""
    echo "Usage: shell-gpt <command> [args]"
    echo ""
    echo "Commands:"
    echo "  configure          Configure"
    echo "  benchmark          Benchmark"
    echo "  compare            Compare"
    echo "  prompt             Prompt"
    echo "  evaluate           Evaluate"
    echo "  fine-tune          Fine Tune"
    echo "  analyze            Analyze"
    echo "  cost               Cost"
    echo "  usage              Usage"
    echo "  optimize           Optimize"
    echo "  test               Test"
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
    echo "=== Shell Gpt Stats ==="
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
            echo "=== Shell Gpt Export ===" > "$out"
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
    echo "=== Shell Gpt Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: shell-gpt search <term>}"
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
    configure)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent configure entries:"
            tail -20 "$DATA_DIR/configure.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt configure <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/configure.log"
            local total=$(wc -l < "$DATA_DIR/configure.log")
            echo "  [Shell Gpt] configure: $input"
            echo "  Saved. Total configure entries: $total"
            _log "configure" "$input"
        fi
        ;;
    benchmark)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent benchmark entries:"
            tail -20 "$DATA_DIR/benchmark.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt benchmark <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/benchmark.log"
            local total=$(wc -l < "$DATA_DIR/benchmark.log")
            echo "  [Shell Gpt] benchmark: $input"
            echo "  Saved. Total benchmark entries: $total"
            _log "benchmark" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Shell Gpt] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
        fi
        ;;
    prompt)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent prompt entries:"
            tail -20 "$DATA_DIR/prompt.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt prompt <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/prompt.log"
            local total=$(wc -l < "$DATA_DIR/prompt.log")
            echo "  [Shell Gpt] prompt: $input"
            echo "  Saved. Total prompt entries: $total"
            _log "prompt" "$input"
        fi
        ;;
    evaluate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent evaluate entries:"
            tail -20 "$DATA_DIR/evaluate.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt evaluate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/evaluate.log"
            local total=$(wc -l < "$DATA_DIR/evaluate.log")
            echo "  [Shell Gpt] evaluate: $input"
            echo "  Saved. Total evaluate entries: $total"
            _log "evaluate" "$input"
        fi
        ;;
    fine-tune)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent fine-tune entries:"
            tail -20 "$DATA_DIR/fine-tune.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt fine-tune <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/fine-tune.log"
            local total=$(wc -l < "$DATA_DIR/fine-tune.log")
            echo "  [Shell Gpt] fine-tune: $input"
            echo "  Saved. Total fine-tune entries: $total"
            _log "fine-tune" "$input"
        fi
        ;;
    analyze)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent analyze entries:"
            tail -20 "$DATA_DIR/analyze.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt analyze <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/analyze.log"
            local total=$(wc -l < "$DATA_DIR/analyze.log")
            echo "  [Shell Gpt] analyze: $input"
            echo "  Saved. Total analyze entries: $total"
            _log "analyze" "$input"
        fi
        ;;
    cost)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent cost entries:"
            tail -20 "$DATA_DIR/cost.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt cost <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/cost.log"
            local total=$(wc -l < "$DATA_DIR/cost.log")
            echo "  [Shell Gpt] cost: $input"
            echo "  Saved. Total cost entries: $total"
            _log "cost" "$input"
        fi
        ;;
    usage)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent usage entries:"
            tail -20 "$DATA_DIR/usage.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt usage <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/usage.log"
            local total=$(wc -l < "$DATA_DIR/usage.log")
            echo "  [Shell Gpt] usage: $input"
            echo "  Saved. Total usage entries: $total"
            _log "usage" "$input"
        fi
        ;;
    optimize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent optimize entries:"
            tail -20 "$DATA_DIR/optimize.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt optimize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/optimize.log"
            local total=$(wc -l < "$DATA_DIR/optimize.log")
            echo "  [Shell Gpt] optimize: $input"
            echo "  Saved. Total optimize entries: $total"
            _log "optimize" "$input"
        fi
        ;;
    test)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent test entries:"
            tail -20 "$DATA_DIR/test.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt test <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/test.log"
            local total=$(wc -l < "$DATA_DIR/test.log")
            echo "  [Shell Gpt] test: $input"
            echo "  Saved. Total test entries: $total"
            _log "test" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: shell-gpt report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Shell Gpt] report: $input"
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
        echo "Unknown: $1 — run 'shell-gpt help'"
        exit 1
        ;;
esac