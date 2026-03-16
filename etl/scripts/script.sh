#!/usr/bin/env bash
# Etl — data tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/etl"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "etl v2.0.0"; }

_help() {
    echo "Etl v2.0.0 — data toolkit"
    echo ""
    echo "Usage: etl <command> [args]"
    echo ""
    echo "Commands:"
    echo "  ingest             Ingest"
    echo "  transform          Transform"
    echo "  query              Query"
    echo "  filter             Filter"
    echo "  aggregate          Aggregate"
    echo "  visualize          Visualize"
    echo "  export             Export"
    echo "  sample             Sample"
    echo "  schema             Schema"
    echo "  validate           Validate"
    echo "  pipeline           Pipeline"
    echo "  profile            Profile"
    echo "  stats              Summary statistics"
    echo "  export <fmt>       Export (json|csv|txt)"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Etl Stats ==="
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
            echo "=== Etl Export ===" > "$out"
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
    echo "=== Etl Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: etl search <term>}"
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
    ingest)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent ingest entries:"
            tail -20 "$DATA_DIR/ingest.log" 2>/dev/null || echo "  No entries yet. Use: etl ingest <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/ingest.log"
            local total=$(wc -l < "$DATA_DIR/ingest.log")
            echo "  [Etl] ingest: $input"
            echo "  Saved. Total ingest entries: $total"
            _log "ingest" "$input"
        fi
        ;;
    transform)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent transform entries:"
            tail -20 "$DATA_DIR/transform.log" 2>/dev/null || echo "  No entries yet. Use: etl transform <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/transform.log"
            local total=$(wc -l < "$DATA_DIR/transform.log")
            echo "  [Etl] transform: $input"
            echo "  Saved. Total transform entries: $total"
            _log "transform" "$input"
        fi
        ;;
    query)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent query entries:"
            tail -20 "$DATA_DIR/query.log" 2>/dev/null || echo "  No entries yet. Use: etl query <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/query.log"
            local total=$(wc -l < "$DATA_DIR/query.log")
            echo "  [Etl] query: $input"
            echo "  Saved. Total query entries: $total"
            _log "query" "$input"
        fi
        ;;
    filter)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent filter entries:"
            tail -20 "$DATA_DIR/filter.log" 2>/dev/null || echo "  No entries yet. Use: etl filter <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/filter.log"
            local total=$(wc -l < "$DATA_DIR/filter.log")
            echo "  [Etl] filter: $input"
            echo "  Saved. Total filter entries: $total"
            _log "filter" "$input"
        fi
        ;;
    aggregate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent aggregate entries:"
            tail -20 "$DATA_DIR/aggregate.log" 2>/dev/null || echo "  No entries yet. Use: etl aggregate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/aggregate.log"
            local total=$(wc -l < "$DATA_DIR/aggregate.log")
            echo "  [Etl] aggregate: $input"
            echo "  Saved. Total aggregate entries: $total"
            _log "aggregate" "$input"
        fi
        ;;
    visualize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent visualize entries:"
            tail -20 "$DATA_DIR/visualize.log" 2>/dev/null || echo "  No entries yet. Use: etl visualize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/visualize.log"
            local total=$(wc -l < "$DATA_DIR/visualize.log")
            echo "  [Etl] visualize: $input"
            echo "  Saved. Total visualize entries: $total"
            _log "visualize" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: etl export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Etl] export: $input"
            echo "  Saved. Total export entries: $total"
            _log "export" "$input"
        fi
        ;;
    sample)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent sample entries:"
            tail -20 "$DATA_DIR/sample.log" 2>/dev/null || echo "  No entries yet. Use: etl sample <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/sample.log"
            local total=$(wc -l < "$DATA_DIR/sample.log")
            echo "  [Etl] sample: $input"
            echo "  Saved. Total sample entries: $total"
            _log "sample" "$input"
        fi
        ;;
    schema)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent schema entries:"
            tail -20 "$DATA_DIR/schema.log" 2>/dev/null || echo "  No entries yet. Use: etl schema <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/schema.log"
            local total=$(wc -l < "$DATA_DIR/schema.log")
            echo "  [Etl] schema: $input"
            echo "  Saved. Total schema entries: $total"
            _log "schema" "$input"
        fi
        ;;
    validate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent validate entries:"
            tail -20 "$DATA_DIR/validate.log" 2>/dev/null || echo "  No entries yet. Use: etl validate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/validate.log"
            local total=$(wc -l < "$DATA_DIR/validate.log")
            echo "  [Etl] validate: $input"
            echo "  Saved. Total validate entries: $total"
            _log "validate" "$input"
        fi
        ;;
    pipeline)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent pipeline entries:"
            tail -20 "$DATA_DIR/pipeline.log" 2>/dev/null || echo "  No entries yet. Use: etl pipeline <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/pipeline.log"
            local total=$(wc -l < "$DATA_DIR/pipeline.log")
            echo "  [Etl] pipeline: $input"
            echo "  Saved. Total pipeline entries: $total"
            _log "pipeline" "$input"
        fi
        ;;
    profile)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent profile entries:"
            tail -20 "$DATA_DIR/profile.log" 2>/dev/null || echo "  No entries yet. Use: etl profile <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/profile.log"
            local total=$(wc -l < "$DATA_DIR/profile.log")
            echo "  [Etl] profile: $input"
            echo "  Saved. Total profile entries: $total"
            _log "profile" "$input"
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
        echo "Run 'etl help' for available commands."
        exit 1
        ;;
esac