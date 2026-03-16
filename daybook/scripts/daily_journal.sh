#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Daily journal — write, reflect, remember
set -euo pipefail
JOURNAL_DIR="${JOURNAL_DIR:-$HOME/.journal}"
mkdir -p "$JOURNAL_DIR"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Daily Journal — write, reflect, remember
Commands:
  write [text]       Write today's entry
  today              View today's entry
  yesterday          View yesterday
  list [n]           List recent entries (default 10)
  search <query>     Search all entries
  mood <1-5> [note]  Log mood (1=bad, 5=great)
  streak             Writing streak
  gratitude [text]   Gratitude log
  prompt             Random writing prompt
  stats              Journal statistics
  export [format]    Export (md/json/html)
  info               Version info
Powered by BytesAgain | bytesagain.com";;
write)
    today=$(date +%Y-%m-%d)
    f="$JOURNAL_DIR/${today}.md"
    if [ -n "$*" ]; then
        echo -e "\n## $(date +%H:%M)\n$*" >> "$f"
        echo "✍️ Added to ${today}"
    else
        cat > "$f" << ENTRY
# Journal — $today ($(date +%A))

## $(date +%H:%M)

Write your thoughts here...
ENTRY
        echo "✍️ Entry created: $f"
    fi;;
today)
    f="$JOURNAL_DIR/$(date +%Y-%m-%d).md"
    if [ -f "$f" ]; then cat "$f"
    else echo "📝 No entry for today. Use 'write' to start."; fi;;
yesterday)
    d=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d 2>/dev/null || echo "")
    [ -z "$d" ] && { echo "Date calculation failed"; exit 1; }
    f="$JOURNAL_DIR/${d}.md"
    if [ -f "$f" ]; then cat "$f"
    else echo "No entry for $d"; fi;;
list)
    n="${1:-10}"
    echo "📚 Recent Entries:"
    ls -t "$JOURNAL_DIR"/*.md 2>/dev/null | head -"$n" | while read f; do
        d=$(basename "$f" .md)
        words=$(wc -w < "$f")
        preview=$(grep -v "^#" "$f" | head -1 | cut -c1-50)
        echo "  📄 $d (${words}w) $preview"
    done
    echo "  Total: $(ls "$JOURNAL_DIR"/*.md 2>/dev/null | wc -l) entries";;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    echo "🔍 Search: $q"
    grep -rl "$q" "$JOURNAL_DIR"/*.md 2>/dev/null | while read f; do
        d=$(basename "$f" .md)
        match=$(grep -m1 "$q" "$f")
        echo "  📄 $d: ${match:0:60}"
    done;;
mood)
    score="${1:-3}"; note="${2:-}"
    today=$(date +%Y-%m-%d)
    moods="😢 😕 😐 🙂 😄"
    emoji=$(echo "$moods" | cut -d' ' -f"$score")
    echo "${today}|${score}|${emoji}|${note}" >> "$JOURNAL_DIR/moods.csv"
    echo "$emoji Mood logged: $score/5 $note";;
streak)
    python3 << PYEOF
import os, time
d = "$JOURNAL_DIR"
files = sorted([f[:-3] for f in os.listdir(d) if f.endswith(".md")])
streak = 0
today = time.strftime("%Y-%m-%d")
for i in range(len(files)-1, -1, -1):
    expected = time.strftime("%Y-%m-%d", time.localtime(time.time() - (len(files)-1-i)*86400))
    # Simple: count consecutive recent days
    pass
# Simpler: just count backwards from today
streak = 0
for i in range(365):
    d_str = time.strftime("%Y-%m-%d", time.localtime(time.time() - i*86400))
    if os.path.isfile(os.path.join(d, d_str+".md")):
        streak += 1
    else:
        if i > 0: break
print("🔥 Writing streak: {} days".format(streak))
bar = "📝" * min(streak, 15)
print("   {}".format(bar if bar else "Start writing today!"))
PYEOF
;;
gratitude)
    text="${*:-I'm grateful for today}"
    today=$(date +%Y-%m-%d)
    echo "${today}|${text}" >> "$JOURNAL_DIR/gratitude.csv"
    echo "🙏 Gratitude logged: $text";;
prompt)
    python3 -c "
import random
prompts = [
    'What made you smile today?',
    'What did you learn this week?',
    'What are you looking forward to?',
    'Describe a challenge you overcame recently.',
    'What would your ideal day look like?',
    'Write about someone who inspires you.',
    'What habit do you want to build?',
    'What are 3 things you are grateful for?',
    'Describe your happiest memory this month.',
    'What advice would you give your past self?',
    'What is one thing you would change about today?',
    'Write about a book/movie that changed your perspective.',
    'What does success mean to you right now?',
    'Describe your perfect morning routine.',
    'What makes you feel most alive?',
]
p = random.choice(prompts)
print('💡 Writing Prompt:')
print('   {}'.format(p))
";;
stats)
    total=$(ls "$JOURNAL_DIR"/*.md 2>/dev/null | wc -l)
    words=$(cat "$JOURNAL_DIR"/*.md 2>/dev/null | wc -w)
    moods=$(wc -l < "$JOURNAL_DIR/moods.csv" 2>/dev/null || echo 0)
    echo "📊 Journal Stats:"
    echo "  Entries: $total"
    echo "  Total words: $words"
    echo "  Avg words/entry: $((words / (total > 0 ? total : 1)))"
    echo "  Mood logs: $moods"
    echo "  Gratitude logs: $(wc -l < "$JOURNAL_DIR/gratitude.csv" 2>/dev/null || echo 0)";;
export)
    fmt="${1:-md}"
    case "$fmt" in
        md) echo "# Journal Export"; echo ""; for f in "$JOURNAL_DIR"/*.md; do [ -f "$f" ] && cat "$f" && echo -e "\n---\n"; done;;
        html) echo "<html><body><h1>Journal</h1>"; for f in "$JOURNAL_DIR"/*.md; do [ -f "$f" ] && echo "<article><pre>" && cat "$f" && echo "</pre></article><hr>"; done; echo "</body></html>";;
        json) python3 -c "
import json, os, glob
entries = []
for f in sorted(glob.glob('$JOURNAL_DIR/*.md')):
    with open(f) as fh: entries.append({'date': os.path.basename(f)[:-3], 'content': fh.read()})
print(json.dumps(entries, indent=2, ensure_ascii=False))
";;
    esac;;
info) echo "Daily Journal v1.0.0"; echo "Write, reflect, remember"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
