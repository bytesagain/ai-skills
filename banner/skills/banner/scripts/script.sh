#!/usr/bin/env bash
# Banner — design tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/banner"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

_version() { echo "banner v2.0.0"; }

_help() {
    echo "Banner v2.0.0 — design toolkit"
    echo ""
    echo "Usage: banner <command> [args]"
    echo ""
    echo "Commands:"
    echo "  palette            Palette"
    echo "  preview            Preview"
    echo "  generate           Generate"
    echo "  convert            Convert"
    echo "  harmonize          Harmonize"
    echo "  contrast           Contrast"
    echo "  export             Export"
    echo "  random             Random"
    echo "  browse             Browse"
    echo "  mix                Mix"
    echo "  gradient           Gradient"
    echo "  swatch             Swatch"
    echo "  stats              Summary statistics"
    echo "  export <fmt>       Export (json|csv|txt)"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Banner Stats ==="
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
            echo "=== Banner Export ===" > "$out"
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
    echo "=== Banner Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    local last=$(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo "never")
    echo "  Last activity: $last"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: banner search <term>}"
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
    palette)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent palette entries:"
            tail -20 "$DATA_DIR/palette.log" 2>/dev/null || echo "  No entries yet. Use: banner palette <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/palette.log"
            local total=$(wc -l < "$DATA_DIR/palette.log")
            echo "  [Banner] palette: $input"
            echo "  Saved. Total palette entries: $total"
            _log "palette" "$input"
        fi
        ;;
    preview)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent preview entries:"
            tail -20 "$DATA_DIR/preview.log" 2>/dev/null || echo "  No entries yet. Use: banner preview <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/preview.log"
            local total=$(wc -l < "$DATA_DIR/preview.log")
            echo "  [Banner] preview: $input"
            echo "  Saved. Total preview entries: $total"
            _log "preview" "$input"
        fi
        ;;
    generate)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent generate entries:"
            tail -20 "$DATA_DIR/generate.log" 2>/dev/null || echo "  No entries yet. Use: banner generate <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/generate.log"
            local total=$(wc -l < "$DATA_DIR/generate.log")
            echo "  [Banner] generate: $input"
            echo "  Saved. Total generate entries: $total"
            _log "generate" "$input"
        fi
        ;;
    convert)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent convert entries:"
            tail -20 "$DATA_DIR/convert.log" 2>/dev/null || echo "  No entries yet. Use: banner convert <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/convert.log"
            local total=$(wc -l < "$DATA_DIR/convert.log")
            echo "  [Banner] convert: $input"
            echo "  Saved. Total convert entries: $total"
            _log "convert" "$input"
        fi
        ;;
    harmonize)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent harmonize entries:"
            tail -20 "$DATA_DIR/harmonize.log" 2>/dev/null || echo "  No entries yet. Use: banner harmonize <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/harmonize.log"
            local total=$(wc -l < "$DATA_DIR/harmonize.log")
            echo "  [Banner] harmonize: $input"
            echo "  Saved. Total harmonize entries: $total"
            _log "harmonize" "$input"
        fi
        ;;
    contrast)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent contrast entries:"
            tail -20 "$DATA_DIR/contrast.log" 2>/dev/null || echo "  No entries yet. Use: banner contrast <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/contrast.log"
            local total=$(wc -l < "$DATA_DIR/contrast.log")
            echo "  [Banner] contrast: $input"
            echo "  Saved. Total contrast entries: $total"
            _log "contrast" "$input"
        fi
        ;;
    export)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent export entries:"
            tail -20 "$DATA_DIR/export.log" 2>/dev/null || echo "  No entries yet. Use: banner export <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/export.log"
            local total=$(wc -l < "$DATA_DIR/export.log")
            echo "  [Banner] export: $input"
            echo "  Saved. Total export entries: $total"
            _log "export" "$input"
        fi
        ;;
    random)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent random entries:"
            tail -20 "$DATA_DIR/random.log" 2>/dev/null || echo "  No entries yet. Use: banner random <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/random.log"
            local total=$(wc -l < "$DATA_DIR/random.log")
            echo "  [Banner] random: $input"
            echo "  Saved. Total random entries: $total"
            _log "random" "$input"
        fi
        ;;
    browse)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent browse entries:"
            tail -20 "$DATA_DIR/browse.log" 2>/dev/null || echo "  No entries yet. Use: banner browse <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/browse.log"
            local total=$(wc -l < "$DATA_DIR/browse.log")
            echo "  [Banner] browse: $input"
            echo "  Saved. Total browse entries: $total"
            _log "browse" "$input"
        fi
        ;;
    mix)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent mix entries:"
            tail -20 "$DATA_DIR/mix.log" 2>/dev/null || echo "  No entries yet. Use: banner mix <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/mix.log"
            local total=$(wc -l < "$DATA_DIR/mix.log")
            echo "  [Banner] mix: $input"
            echo "  Saved. Total mix entries: $total"
            _log "mix" "$input"
        fi
        ;;
    gradient)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent gradient entries:"
            tail -20 "$DATA_DIR/gradient.log" 2>/dev/null || echo "  No entries yet. Use: banner gradient <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/gradient.log"
            local total=$(wc -l < "$DATA_DIR/gradient.log")
            echo "  [Banner] gradient: $input"
            echo "  Saved. Total gradient entries: $total"
            _log "gradient" "$input"
        fi
        ;;
    swatch)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent swatch entries:"
            tail -20 "$DATA_DIR/swatch.log" 2>/dev/null || echo "  No entries yet. Use: banner swatch <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/swatch.log"
            local total=$(wc -l < "$DATA_DIR/swatch.log")
            echo "  [Banner] swatch: $input"
            echo "  Saved. Total swatch entries: $total"
            _log "swatch" "$input"
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
        echo "Run 'banner help' for available commands."
        exit 1
        ;;
esac