#!/usr/bin/env bash
# mining -- Analyze mining operations. Use when you need to understand mining mechanisms, evaluate protocol security, or reference on-chain concepts.
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"
DATA_DIR="${MINING_DIR:-$HOME/.mining}"

_ensure_dirs() { mkdir -p "$DATA_DIR"; }

_save_entry() {
    _ensure_dirs
    local cmd="$1" val="$2"
    local ts=$(date '+%Y-%m-%d %H:%M:%S')
    printf '{"ts":"%s","cmd":"%s","val":"%s"}\n' "$ts" "$cmd" "$val" >> "$DATA_DIR/data.jsonl"
}

show_help() {
    cat << EOF
mining v$VERSION -- Analyze mining operations. Use when you need to understand mining mechanisms, evaluate protocol security, or reference on-chain concepts.

Usage: mining <command> [args]

Commands:
  status          Show current status
  add             Add new entry
  list            List all entries
  search          Search entries
  remove          Remove entry by number
  export          Export data to file
  stats           Show statistics
  config          View or set config
  help              Show this help
  version           Show version

Data: $DATA_DIR
Powered by BytesAgain | bytesagain.com
EOF
}

cmd_status() {
    echo "=== mining Status ==="
    echo "  Version: $VERSION"
    echo "  Data dir: $DATA_DIR"
    local entries=$(cat "$DATA_DIR"/*.jsonl 2>/dev/null | wc -l || echo 0)
    echo "  Entries: $entries"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1 || echo empty)"
}

cmd_add() {
    local value="${1:?Usage: mining add <entry>}"
    shift || true
    _save_entry "add" "$value $*"
    local count=$(wc -l < "$DATA_DIR/data.jsonl" 2>/dev/null || echo 0)
    echo "Added: $value (entry #$count)"
}

cmd_list() {
    echo "=== Mining Entries ==="
    if [ -f "$DATA_DIR/data.jsonl" ]; then
        local count=$(wc -l < "$DATA_DIR/data.jsonl")
        echo "Total: $count"
        echo "---"
        tail -20 "$DATA_DIR/data.jsonl" | while IFS= read -r line; do
            local ts=$(echo "$line" | grep -o '"ts":"[^"]*' | cut -d'"' -f4)
            local cmd=$(echo "$line" | grep -o '"cmd":"[^"]*' | cut -d'"' -f4)
            local val=$(echo "$line" | grep -o '"val":"[^"]*' | cut -d'"' -f4)
            echo "  [$ts] $cmd: $val"
        done
    else
        echo "No entries yet."
    fi
}

cmd_search() {
    local term="${1:?Usage: mining search <term>}"
    if [ -f "$DATA_DIR/data.jsonl" ]; then
        local matches=$(grep -ic "$term" "$DATA_DIR/data.jsonl" 2>/dev/null || echo 0)
        echo "Found: $matches matches"
        grep -i "$term" "$DATA_DIR/data.jsonl" 2>/dev/null | head -20 | while IFS= read -r line; do
            local val=$(echo "$line" | grep -o '"val":"[^"]*' | cut -d'"' -f4)
            local ts=$(echo "$line" | grep -o '"ts":"[^"]*' | cut -d'"' -f4)
            echo "  [$ts] $val"
        done
    else
        echo "No data to search."
    fi
}

cmd_remove() {
    local num="${1:?Usage: mining remove <line-number>}"
    if [ -f "$DATA_DIR/data.jsonl" ]; then
        local total=$(wc -l < "$DATA_DIR/data.jsonl")
        if [ "$num" -ge 1 ] 2>/dev/null && [ "$num" -le "$total" ] 2>/dev/null; then
            sed -i "${num}d" "$DATA_DIR/data.jsonl"
            echo "Removed #$num ($((total-1)) remaining)"
        else echo "Invalid: $num (total: $total)"; fi
    else echo "No data."; fi
}

cmd_export() {
    local fmt="${1:-json}"
    local out="mining-export.$fmt"
    if [ ! -f "$DATA_DIR/data.jsonl" ]; then echo "No data."; return 0; fi
    case "$fmt" in
        json) cp "$DATA_DIR/data.jsonl" "$out" ;;
        csv)
            echo "timestamp,command,value" > "$out"
            while IFS= read -r line; do
                ts=$(echo "$line" | grep -o '"ts":"[^"]*' | cut -d'"' -f4)
                c2=$(echo "$line" | grep -o '"cmd":"[^"]*' | cut -d'"' -f4)
                vl=$(echo "$line" | grep -o '"val":"[^"]*' | cut -d'"' -f4)
                echo "$ts,$c2,$vl" >> "$out"
            done < "$DATA_DIR/data.jsonl"
            ;;
        *) echo "Formats: json, csv"; return 1 ;;
    esac
    echo "Exported: $out ($(wc -c < "$out") bytes)"
}

cmd_stats() {
    echo "=== Mining Stats ==="
    if [ -f "$DATA_DIR/data.jsonl" ]; then
        local total=$(wc -l < "$DATA_DIR/data.jsonl")
        local bytes=$(wc -c < "$DATA_DIR/data.jsonl")
        echo "  Entries: $total"
        echo "  Size: $bytes bytes"
        echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    else echo "  No data yet."; fi
}

cmd_config() {
    local key="${1:-}" val="${2:-}"
    local cfg="$DATA_DIR/config.txt"
    if [ -z "$key" ]; then
        echo "=== Config ==="
        if [ -f "$cfg" ]; then
            while IFS="=" read -r k v; do echo "  $k=$v"; done < "$cfg"
        else echo "  (empty — use config <key> <value>)"; fi
    elif [ -z "$val" ]; then
        grep "^${key}=" "$cfg" 2>/dev/null | cut -d= -f2- || echo "(not set)"
    else
        if [ -f "$cfg" ] && grep -q "^${key}=" "$cfg" 2>/dev/null; then
            sed -i "s|^${key}=.*|${key}=${val}|" "$cfg"
        else
            echo "${key}=${val}" >> "$cfg"
        fi
        echo "Set: $key=$val"
    fi
}

CMD="${1:-help}"
shift 2>/dev/null || true
_ensure_dirs

case "$CMD" in
    status) cmd_status "$@" ;;
    add) cmd_add "$@" ;;
    list) cmd_list "$@" ;;
    search) cmd_search "$@" ;;
    remove) cmd_remove "$@" ;;
    export) cmd_export "$@" ;;
    stats) cmd_stats "$@" ;;
    config) cmd_config "$@" ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "mining v$VERSION -- Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: mining help"; exit 1 ;;
esac
