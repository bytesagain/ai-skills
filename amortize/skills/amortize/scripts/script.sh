#!/usr/bin/env bash
set -euo pipefail

# amortize - skill script
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

DATA_DIR="${HOME}/.amortize"
mkdir -p "$DATA_DIR"

show_help() {
    cat << 'HELPEOF'
amortize - command-line tool

Commands:
  calculate      Run calculate operation
  add            Run add operation
  list           Run list operation
  report         Run report operation
  export         Run export operation
  import         Run import operation
  config         Run config operation
  compare        Run compare operation
  forecast       Run forecast operation
  stats          Run stats operation
  stats      Show statistics
  export     Export data (json|csv|txt)
  search     Search entries
  recent     Show recent entries
  status     Show current status
  help       Show this help
  version    Show version

Data stored in: ~/.amortize/
HELPEOF
}

show_version() {
    echo "amortize v1.0.0 - Powered by BytesAgain"
}

cmd_stats() {
    echo "=== amortize Statistics ==="
    local total=0
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local name=$(basename "$f" .log)
        local c=$(wc -l < "$f" 2>/dev/null || echo 0)
        total=$((total + c))
        echo "  $name: $c entries"
    done
    echo "  Total: $total entries"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1 || echo 'N/A')"
}

cmd_export() {
    local fmt="${1:-json}"
    local out="amortize-export.$fmt"
    case "$fmt" in
        json)
            echo "[" > "$out"
            local first=1
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                while IFS= read -r line; do
                    [ $first -eq 1 ] && first=0 || echo "," >> "$out"
                    local ts=$(echo "$line" | cut -d'|' -f1)
                    local cmd=$(echo "$line" | cut -d'|' -f2)
                    local data=$(echo "$line" | cut -d'|' -f3-)
                    printf '  {"timestamp":"%s","command":"%s","data":"%s"}' "$ts" "$cmd" "$data" >> "$out"
                done < "$f"
            done
            echo "" >> "$out"; echo "]" >> "$out"
            ;;
        csv)
            echo "timestamp,command,data" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                while IFS= read -r line; do
                    echo "$line" | awk -F'|' '{printf "\"%s\",\"%s\",\"%s\"
", $1, $2, $3}' >> "$out"
                done < "$f"
            done
            ;;
        *) echo "Format: json or csv"; return 1 ;;
    esac
    echo "Exported to $out"
}

cmd_search() {
    local term="${1:-}"
    [ -z "$term" ] && { echo "Usage: amortize search <term>"; return 1; }
    echo "=== Search: $term ==="
    local found=0
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local matches=$(grep -i "$term" "$f" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            echo "--- $(basename "$f" .log) ---"
            echo "$matches"
            found=$((found + 1))
        fi
    done
    [ $found -eq 0 ] && echo "No matches."
}

cmd_recent() {
    local n="${1:-10}"
    echo "=== Recent $n entries ==="
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        tail -n "$n" "$f" 2>/dev/null
    done | sort -t'|' -k1 | tail -n "$n"
}

cmd_status() {
    echo "=== amortize Status ==="
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l || echo 0)"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1 || echo 'N/A')"
}

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    calculate)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|calculate|${*}" >> "$DATA_DIR/calculate.log"
        local total=$(wc -l < "$DATA_DIR/calculate.log" 2>/dev/null || echo 0)
        echo "[amortize] calculate recorded (entry #$total)"
        ;;
    add)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|add|${*}" >> "$DATA_DIR/add.log"
        local total=$(wc -l < "$DATA_DIR/add.log" 2>/dev/null || echo 0)
        echo "[amortize] add recorded (entry #$total)"
        ;;
    list)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|list|${*}" >> "$DATA_DIR/list.log"
        local total=$(wc -l < "$DATA_DIR/list.log" 2>/dev/null || echo 0)
        echo "[amortize] list recorded (entry #$total)"
        ;;
    report)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|report|${*}" >> "$DATA_DIR/report.log"
        local total=$(wc -l < "$DATA_DIR/report.log" 2>/dev/null || echo 0)
        echo "[amortize] report recorded (entry #$total)"
        ;;
    export)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|export|${*}" >> "$DATA_DIR/export.log"
        local total=$(wc -l < "$DATA_DIR/export.log" 2>/dev/null || echo 0)
        echo "[amortize] export recorded (entry #$total)"
        ;;
    import)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|import|${*}" >> "$DATA_DIR/import.log"
        local total=$(wc -l < "$DATA_DIR/import.log" 2>/dev/null || echo 0)
        echo "[amortize] import recorded (entry #$total)"
        ;;
    config)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|config|${*}" >> "$DATA_DIR/config.log"
        local total=$(wc -l < "$DATA_DIR/config.log" 2>/dev/null || echo 0)
        echo "[amortize] config recorded (entry #$total)"
        ;;
    compare)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|compare|${*}" >> "$DATA_DIR/compare.log"
        local total=$(wc -l < "$DATA_DIR/compare.log" 2>/dev/null || echo 0)
        echo "[amortize] compare recorded (entry #$total)"
        ;;
    forecast)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|forecast|${*}" >> "$DATA_DIR/forecast.log"
        local total=$(wc -l < "$DATA_DIR/forecast.log" 2>/dev/null || echo 0)
        echo "[amortize] forecast recorded (entry #$total)"
        ;;
    stats)
        local ts=$(date '+%Y-%m-%d %H:%M')
        echo "$ts|stats|${*}" >> "$DATA_DIR/stats.log"
        local total=$(wc -l < "$DATA_DIR/stats.log" 2>/dev/null || echo 0)
        echo "[amortize] stats recorded (entry #$total)"
        ;;
    stats) cmd_stats ;;
    export) cmd_export "$@" ;;
    search) cmd_search "$@" ;;
    recent) cmd_recent "$@" ;;
    status) cmd_status ;;
    help|--help|-h) show_help ;;
    version|--version|-v) show_version ;;
    *) echo "Unknown: $CMD"; echo "Run 'amortize help'"; exit 1 ;;
esac
