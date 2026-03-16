#!/usr/bin/env bash
# Agent Learner — ai tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/agent-learner"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "agent-learner v2.0.0"; }

_help() {
    echo "Agent Learner v2.0.0 — ai toolkit"
    echo ""
    echo "Usage: agent-learner <command> [args]"
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
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Agent Learner Stats ==="
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
            echo "=== Agent Learner Export ===" > "$out"
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
    echo "=== Agent Learner Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: agent-learner search <term>}"
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
    configure)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent configure entries:"
            tail -20 "$DATA_DIR/configure.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner configure <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/configure.log"
            local total=$(wc -l < "$DATA_DIR/configure.log")
            echo "  [Agent Learner] configure: $input"
            echo "  Saved. Total configure entries: $total"
            _log "configure" "$input"
        fi
        ;;
    benchmark)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent benchmark entries:"
            tail -20 "$DATA_DIR/benchmark.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner benchmark <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/benchmark.log"
            local total=$(wc -l < "$DATA_DIR/benchmark.log")
            echo "  [Agent Learner] benchmark: $input"
            echo "  Saved. Total benchmark entries: $total"
            _log "benchmark" "$input"
        fi
        ;;
    compare)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent compare entries:"
            tail -20 "$DATA_DIR/compare.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner compare <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/compare.log"
            local total=$(wc -l < "$DATA_DIR/compare.log")
            echo "  [Agent Learner] compare: $input"
            echo "  Saved. Total compare entries: $total"
            _log "compare" "$input"
        fi
        ;;
    prompt)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent prompt entries:"
            tail -20 "$DATA_DIR/prompt.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner prompt <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/prompt.log"
            local total=$(wc -l < "$DATA_DIR/prompt.log")
            echo "  [Agent Learner] prompt: $input"
            echo "  Saved. Total prompt entries: $total"
            _log "prompt" "$input"
        fi
        ;;
    evaluate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent evaluate entries:"
            tail -20 "$DATA_DIR/evaluate.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner evaluate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/evaluate.log"
            local total=$(wc -l < "$DATA_DIR/evaluate.log")
            echo "  [Agent Learner] evaluate: $input"
            echo "  Saved. Total evaluate entries: $total"
            _log "evaluate" "$input"
        fi
        ;;
    fine-tune)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent fine-tune entries:"
            tail -20 "$DATA_DIR/fine-tune.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner fine-tune <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/fine-tune.log"
            local total=$(wc -l < "$DATA_DIR/fine-tune.log")
            echo "  [Agent Learner] fine-tune: $input"
            echo "  Saved. Total fine-tune entries: $total"
            _log "fine-tune" "$input"
        fi
        ;;
    analyze)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent analyze entries:"
            tail -20 "$DATA_DIR/analyze.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner analyze <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/analyze.log"
            local total=$(wc -l < "$DATA_DIR/analyze.log")
            echo "  [Agent Learner] analyze: $input"
            echo "  Saved. Total analyze entries: $total"
            _log "analyze" "$input"
        fi
        ;;
    cost)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent cost entries:"
            tail -20 "$DATA_DIR/cost.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner cost <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/cost.log"
            local total=$(wc -l < "$DATA_DIR/cost.log")
            echo "  [Agent Learner] cost: $input"
            echo "  Saved. Total cost entries: $total"
            _log "cost" "$input"
        fi
        ;;
    usage)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent usage entries:"
            tail -20 "$DATA_DIR/usage.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner usage <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/usage.log"
            local total=$(wc -l < "$DATA_DIR/usage.log")
            echo "  [Agent Learner] usage: $input"
            echo "  Saved. Total usage entries: $total"
            _log "usage" "$input"
        fi
        ;;
    optimize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent optimize entries:"
            tail -20 "$DATA_DIR/optimize.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner optimize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/optimize.log"
            local total=$(wc -l < "$DATA_DIR/optimize.log")
            echo "  [Agent Learner] optimize: $input"
            echo "  Saved. Total optimize entries: $total"
            _log "optimize" "$input"
        fi
        ;;
    test)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent test entries:"
            tail -20 "$DATA_DIR/test.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner test <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/test.log"
            local total=$(wc -l < "$DATA_DIR/test.log")
            echo "  [Agent Learner] test: $input"
            echo "  Saved. Total test entries: $total"
            _log "test" "$input"
        fi
        ;;
    report)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent report entries:"
            tail -20 "$DATA_DIR/report.log" 2>/dev/null || echo "  No entries yet. Use: agent-learner report <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/report.log"
            local total=$(wc -l < "$DATA_DIR/report.log")
            echo "  [Agent Learner] report: $input"
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
        echo "Run 'agent-learner help' for available commands."
        exit 1
        ;;
esac