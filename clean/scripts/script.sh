#!/usr/bin/env bash
# clean -- Scan and clean up files including duplicates, temp files, and caches using system tools. Use when you need to find and remove junk files,
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"
DATA_DIR="${CLEAN_DIR:-$HOME/.clean}"

_ensure_dirs() { mkdir -p "$DATA_DIR"; }

_save_entry() {
    _ensure_dirs
    local cmd="$1" val="$2"
    local ts=$(date '+%Y-%m-%d %H:%M:%S')
    printf '{"ts":"%s","cmd":"%s","val":"%s"}\n' "$ts" "$cmd" "$val" >> "$DATA_DIR/data.jsonl"
}

show_help() {
    cat << EOF
clean v$VERSION -- Scan and clean up files including duplicates, temp files, and caches using system tools. Use when you need to find and remove junk files,

Usage: clean <command> [args]

Commands:
  status          Show current status
  add             Add new entry
  list            List all entries
  search          Search entries
  clean           Clean old data
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
    echo "=== clean Status ==="
    echo "  Version: $VERSION"
    echo "  Data dir: $DATA_DIR"
    local entries=$(cat "$DATA_DIR"/*.jsonl 2>/dev/null | wc -l || echo 0)
    echo "  Entries: $entries"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1 || echo empty)"
}

cmd_add() {
    local value="${1:?Usage: clean add <entry>}"
    shift || true
    _save_entry "add" "$value $*"
    local count=$(wc -l < "$DATA_DIR/data.jsonl" 2>/dev/null || echo 0)
    echo "Added: $value (entry #$count)"
}

cmd_list() {
    echo "=== Clean Entries ==="
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
    local term="${1:?Usage: clean search <term>}"
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

cmd_clean() {
    local days="${1:-30}"
    if [ -f "$DATA_DIR/data.jsonl" ]; then
        local before=$(wc -l < "$DATA_DIR/data.jsonl")
        local cutoff=$(date -d "$days days ago" +%%Y-%%m-%%d 2>/dev/null || date +%%Y-%%m-%%d)
        local tmp="$DATA_DIR/data.tmp"
        while IFS= read -r line; do
            local ts=$(echo "$line" | grep -o '"ts":"[^"]*' | cut -d'"' -f4)
            [[ "$ts" > "$cutoff" ]] && echo "$line"
        done < "$DATA_DIR/data.jsonl" > "$tmp"
        mv "$tmp" "$DATA_DIR/data.jsonl"
        local after=$(wc -l < "$DATA_DIR/data.jsonl")
        echo "Cleaned: $((before - after)) removed, $after remaining"
    else echo "Nothing to clean."; fi
}

cmd_remove() {
    local num="${1:?Usage: clean remove <line-number>}"
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
    local out="clean-export.$fmt"
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
    echo "=== Clean Stats ==="
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
    clean) cmd_clean "$@" ;;
    remove) cmd_remove "$@" ;;
    export) cmd_export "$@" ;;
    stats) cmd_stats "$@" ;;
    config) cmd_config "$@" ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "clean v$VERSION -- Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: clean help"; exit 1 ;;
esac
