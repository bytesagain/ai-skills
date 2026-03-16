#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Memos — quick notes & knowledge base (inspired by usememos/memos 57K+ stars)
set -euo pipefail
MEMO_DIR="${MEMO_DIR:-$HOME/.memos}"
mkdir -p "$MEMO_DIR"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Memos — quick notes manager
Commands:
  add <text>        Add a memo
  list [n]          List recent memos (default 10)
  search <query>    Search memos
  tag <tag>         List memos by tag (#tag)
  tags              Show all tags
  edit <id>         Edit a memo
  delete <id>       Delete a memo
  export [format]   Export all (md/json)
  stats             Memo statistics
  info              Version info
Powered by BytesAgain | bytesagain.com";;
add)
    text="$*"
    [ -z "$text" ] && text="Empty memo"
    id=$(date +%s)
    ts=$(date '+%Y-%m-%d %H:%M')
    echo "$id|$ts|$text" >> "$MEMO_DIR/memos.txt"
    echo "✅ Memo #$id saved ($ts)";;
list)
    n="${1:-10}"
    [ ! -f "$MEMO_DIR/memos.txt" ] && { echo "No memos yet"; exit 0; }
    echo "📝 Recent Memos:"
    tail -n "$n" "$MEMO_DIR/memos.txt" | while IFS='|' read -r id ts text; do
        echo "  [$id] $ts: $text"
    done
    echo "  Total: $(wc -l < "$MEMO_DIR/memos.txt") memos";;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    [ ! -f "$MEMO_DIR/memos.txt" ] && { echo "No memos"; exit 0; }
    echo "🔍 Search: $q"
    grep -i "$q" "$MEMO_DIR/memos.txt" | while IFS='|' read -r id ts text; do
        echo "  [$id] $ts: $text"
    done;;
tag)
    t="${1:-}"; [ -z "$t" ] && { echo "Usage: tag <tag>"; exit 1; }
    [ ! -f "$MEMO_DIR/memos.txt" ] && { echo "No memos"; exit 0; }
    echo "🏷 Tag: #$t"
    grep -i "#$t" "$MEMO_DIR/memos.txt" | while IFS='|' read -r id ts text; do
        echo "  [$id] $ts: $text"
    done;;
tags)
    [ ! -f "$MEMO_DIR/memos.txt" ] && { echo "No memos"; exit 0; }
    echo "🏷 All Tags:"
    grep -oE '#[a-zA-Z0-9_]+' "$MEMO_DIR/memos.txt" 2>/dev/null | sort | uniq -c | sort -rn | while read cnt tag; do
        echo "  $tag ($cnt)"
    done;;
edit)
    id="${1:-}"; [ -z "$id" ] && { echo "Usage: edit <id> <new text>"; exit 1; }
    shift; text="$*"
    [ -z "$text" ] && { echo "Provide new text"; exit 1; }
    if grep -q "^$id|" "$MEMO_DIR/memos.txt" 2>/dev/null; then
        ts=$(date '+%Y-%m-%d %H:%M')
        sed -i "s|^$id|.*|$id|$ts|$text (edited)|" "$MEMO_DIR/memos.txt"
        echo "✅ Memo #$id updated"
    else echo "❌ Memo #$id not found"; fi;;
delete)
    id="${1:-}"; [ -z "$id" ] && { echo "Usage: delete <id>"; exit 1; }
    if grep -q "^$id|" "$MEMO_DIR/memos.txt" 2>/dev/null; then
        sed -i "/^$id|/d" "$MEMO_DIR/memos.txt"
        echo "🗑 Memo #$id deleted"
    else echo "❌ Not found"; fi;;
export)
    fmt="${1:-md}"
    [ ! -f "$MEMO_DIR/memos.txt" ] && { echo "No memos"; exit 0; }
    case "$fmt" in
        md) echo "# Memos Export"; echo ""; while IFS='|' read -r id ts text; do echo "- **$ts**: $text"; done < "$MEMO_DIR/memos.txt";;
        json) python3 -c "
import json
memos = []
with open('$MEMO_DIR/memos.txt') as f:
    for line in f:
        parts = line.strip().split('|', 2)
        if len(parts) == 3:
            memos.append({'id': parts[0], 'time': parts[1], 'text': parts[2]})
print(json.dumps(memos, indent=2, ensure_ascii=False))
";;
        *) echo "Format: md or json";;
    esac;;
stats)
    [ ! -f "$MEMO_DIR/memos.txt" ] && { echo "No memos"; exit 0; }
    total=$(wc -l < "$MEMO_DIR/memos.txt")
    tags=$(grep -oE '#[a-zA-Z0-9_]+' "$MEMO_DIR/memos.txt" 2>/dev/null | sort -u | wc -l)
    today=$(grep "$(date +%Y-%m-%d)" "$MEMO_DIR/memos.txt" 2>/dev/null | wc -l)
    echo "📊 Memo Stats:"
    echo "  Total: $total"
    echo "  Today: $today"
    echo "  Tags: $tags"
    echo "  File: $MEMO_DIR/memos.txt";;
info) echo "Memos v1.0.0"; echo "Inspired by: usememos/memos (57,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
