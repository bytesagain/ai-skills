#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Clipboard manager — history, search, pin
set -euo pipefail
CLIP_DIR="${CLIP_DIR:-$HOME/.cliphistory}"
mkdir -p "$CLIP_DIR"
DB="$CLIP_DIR/history.txt"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Clipboard Manager — clipboard history & tools
Commands:
  copy <text>       Save to clipboard history
  paste             Show last copied
  list [n]          Show recent history (default 10)
  search <query>    Search clipboard history
  pin <id>          Pin item (permanent)
  pins              Show pinned items
  clear             Clear history
  stats             Usage statistics
  info              Version info
Powered by BytesAgain | bytesagain.com";;
copy)
    text="$*"; [ -z "$text" ] && { echo "Usage: copy <text>"; exit 1; }
    echo "$(date +%s)|$(date '+%Y-%m-%d %H:%M')|$text" >> "$DB"
    echo "📋 Copied: ${text:0:50}";;
paste)
    [ ! -f "$DB" ] && { echo "History empty"; exit 0; }
    tail -1 "$DB" | cut -d'|' -f3-;;
list)
    n="${1:-10}"; [ ! -f "$DB" ] && { echo "History empty"; exit 0; }
    echo "📋 Clipboard History (last $n):"
    tail -n "$n" "$DB" | nl -ba | while IFS= read -r line; do
        echo "  $line" | cut -d'|' -f1-2
        echo "    $(echo "$line" | cut -d'|' -f3- | head -c 60)"
    done;;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    echo "🔍 Search: $q"
    grep -i "$q" "$DB" 2>/dev/null | while IFS='|' read -r id ts text; do
        echo "  $ts: ${text:0:60}"
    done;;
pin)
    id="${1:-}"; [ -z "$id" ] && { echo "Usage: pin <text>"; exit 1; }
    echo "$(date +%s)|$(date '+%Y-%m-%d %H:%M')|$*" >> "$CLIP_DIR/pins.txt"
    echo "📌 Pinned";;
pins)
    [ ! -f "$CLIP_DIR/pins.txt" ] && { echo "No pins"; exit 0; }
    echo "📌 Pinned Items:"
    cat "$CLIP_DIR/pins.txt" | while IFS='|' read -r id ts text; do
        echo "  $ts: $text"
    done;;
clear)
    echo -n > "$DB"; echo "🗑 History cleared";;
stats)
    total=$(wc -l < "$DB" 2>/dev/null || echo 0)
    pins=$(wc -l < "$CLIP_DIR/pins.txt" 2>/dev/null || echo 0)
    echo "📊 Clipboard Stats: $total entries, $pins pinned";;
info) echo "Clipboard Manager v1.0.0"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
