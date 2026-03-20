#!/usr/bin/env bash
# doc-summarizer — Document analysis and summarization toolkit
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${DOCSUM_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/doc-summarizer}"
mkdir -p "$DATA_DIR/summaries"

show_help() {
    cat << EOF
doc-summarizer v$VERSION

Usage: doc-summarizer <command> [args]

Summarize:
  file <path>                    Summarize a document
  stdin                          Summarize piped input
  url <url>                      Summarize web page (needs curl)
  diff <file1> <file2>           Summarize differences

Analysis:
  stats <file>                   Word/line/paragraph stats
  keywords <file> [n]            Extract top N keywords
  readability <file>             Readability score
  structure <file>               Document structure analysis
  toc <file>                     Generate table of contents

Transform:
  bullets <file>                 Convert to bullet points
  tldr <file>                    One-paragraph TLDR
  outline <file>                 Extract outline/headers
  compress <file> <ratio>        Compress to ratio (0.1-0.9)
  translate-summary <file> <lang> Summarize in another language

Output:
  save <name>                    Save summary
  list                           List saved summaries
  export <name> <format>         Export (md|txt|json)
  history                        Recent operations

EOF
}

cmd_file() {
    local file="${1:?Usage: doc-summarizer file <path>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    local lines=$(wc -l < "$file")
    local words=$(wc -w < "$file")
    local chars=$(wc -c < "$file")
    local paras=$(grep -c '^$' "$file" 2>/dev/null || echo 0)
    
    echo "  ═══ Document Summary ═══"
    echo "  File:       $(basename "$file")"
    echo "  Lines:      $lines"
    echo "  Words:      $words"
    echo "  Characters: $chars"
    echo "  Paragraphs: ~$paras"
    echo ""
    echo "  First 5 lines:"
    head -5 "$file" | sed 's/^/    /'
    echo ""
    echo "  Last 3 lines:"
    tail -3 "$file" | sed 's/^/    /'
    
    # Extract headers if markdown
    local headers=$(grep -c '^#' "$file" 2>/dev/null || echo 0)
    if [ "$headers" -gt 0 ]; then
        echo ""
        echo "  Headers ($headers):"
        grep '^#' "$file" | head -10 | sed 's/^/    /'
    fi
    _log "file" "$(basename "$file") ($words words)"
}

cmd_stats() {
    local file="${1:?Usage: doc-summarizer stats <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    python3 << PYEOF
import re, collections
with open('$file') as f:
    text = f.read()

lines = text.split('\n')
words = text.split()
sentences = re.split(r'[.!?]+', text)
paras = text.split('\n\n')

print("  Document Statistics:")
print("  Lines:      {}".format(len(lines)))
print("  Words:      {}".format(len(words)))
print("  Sentences:  {}".format(len([s for s in sentences if s.strip()])))
print("  Paragraphs: {}".format(len([p for p in paras if p.strip()])))
print("  Characters: {}".format(len(text)))
print("  Avg words/sentence: {:.1f}".format(len(words) / max(len(sentences), 1)))
print("  Avg words/paragraph: {:.1f}".format(len(words) / max(len(paras), 1)))

# Top words
stop = {'the','a','an','in','on','at','to','for','of','and','is','it','that','this','with','as','by','from','or','are','was','be','not','but','have','has'}
wc = collections.Counter(w.lower().strip('.,!?;:()[]"') for w in words if len(w) > 2 and w.lower() not in stop)
print("")
print("  Top 10 words:")
for word, count in wc.most_common(10):
    print("    {:15s} {}".format(word, count))
PYEOF
    _log "stats" "$(basename "$file")"
}

cmd_keywords() {
    local file="${1:?Usage: doc-summarizer keywords <file> [n]}"
    local n="${2:-15}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    python3 << PYEOF
import collections, re
with open('$file') as f:
    text = f.read().lower()
stop = {'the','a','an','in','on','at','to','for','of','and','is','it','that','this','with','as','by','from','or','are','was','be','not','but','have','has','do','did','will','would','can','could','should','their','they','them','its','our','your','my','me','we','he','she','him','her','i','you','all','each','any','no','so','if','than'}
words = re.findall(r'\b[a-z]{3,}\b', text)
wc = collections.Counter(w for w in words if w not in stop)
print("  Top {} keywords:".format($n))
for word, count in wc.most_common($n):
    bar = '#' * min(count, 30)
    print("    {:15s} {:3d} {}".format(word, count, bar))
PYEOF
}

cmd_readability() {
    local file="${1:?Usage: doc-summarizer readability <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    python3 << PYEOF
import re
with open('$file') as f:
    text = f.read()
words = text.split()
sentences = [s for s in re.split(r'[.!?]+', text) if s.strip()]
syllables = sum(max(1, len(re.findall(r'[aeiouy]+', w.lower()))) for w in words)

wc = len(words)
sc = max(len(sentences), 1)
avg_sl = wc / sc
avg_syl = syllables / max(wc, 1)

# Flesch Reading Ease
fre = 206.835 - 1.015 * avg_sl - 84.6 * avg_syl
# Flesch-Kincaid Grade
fkg = 0.39 * avg_sl + 11.8 * avg_syl - 15.59

levels = [(90,'Very Easy'),(80,'Easy'),(70,'Fairly Easy'),(60,'Standard'),(50,'Fairly Hard'),(30,'Hard'),(0,'Very Hard')]
level = next(l for s,l in levels if fre >= s)

print("  Readability Analysis:")
print("  Flesch Reading Ease: {:.1f} ({})".format(fre, level))
print("  Flesch-Kincaid Grade: {:.1f}".format(fkg))
print("  Avg sentence length: {:.1f} words".format(avg_sl))
print("  Avg syllables/word:  {:.1f}".format(avg_syl))
PYEOF
}

cmd_structure() {
    local file="${1:?}"
    [ -f "$file" ] || return 1
    echo "  Document Structure:"
    echo "  ─────────────────"
    local h1=$(grep -c '^# ' "$file" 2>/dev/null || echo 0)
    local h2=$(grep -c '^## ' "$file" 2>/dev/null || echo 0)
    local h3=$(grep -c '^### ' "$file" 2>/dev/null || echo 0)
    local code=$(grep -c '```' "$file" 2>/dev/null || echo 0)
    local links=$(grep -coP '\[.*\]\(.*\)' "$file" 2>/dev/null || echo 0)
    local lists=$(grep -c '^\s*[-*]' "$file" 2>/dev/null || echo 0)
    echo "  H1: $h1 | H2: $h2 | H3: $h3"
    echo "  Code blocks: $((code/2)) | Links: $links | List items: $lists"
}

cmd_toc() {
    local file="${1:?}"
    [ -f "$file" ] || return 1
    echo "  Table of Contents:"
    grep '^#' "$file" | while IFS= read -r line; do
        local depth=$(echo "$line" | grep -oP '^#+' | wc -c)
        local indent=$(printf '%*s' "$((depth * 2 - 2))" "")
        local text=$(echo "$line" | sed 's/^#* *//')
        echo "  $indent- $text"
    done
}

cmd_bullets() {
    local file="${1:?}"
    [ -f "$file" ] || return 1
    echo "  Key Points:"
    grep -v '^$\|^#\|^---\|^```' "$file" | head -20 | while IFS= read -r line; do
        [ ${#line} -gt 10 ] && echo "  • $line"
    done
}

cmd_outline() {
    local file="${1:?}"
    cmd_toc "$file"
}

cmd_compress() {
    local file="${1:?Usage: doc-summarizer compress <file> <ratio>}"
    local ratio="${2:-0.3}"
    [ -f "$file" ] || return 1
    local total=$(wc -l < "$file")
    local keep
    keep=$(TOTAL="$total" RATIO="$ratio" python3 << 'PYEOF'
import os
total = int(os.environ["TOTAL"])
ratio = float(os.environ["RATIO"])
print(max(3, int(total * ratio)))
PYEOF
    )
    echo "  Compressed ($ratio): keeping $keep of $total lines"
    head -"$keep" "$file" | sed 's/^/  /'
}

cmd_save() {
    local name="${1:?Usage: doc-summarizer save <name>}"
    cat > "$DATA_DIR/summaries/$name.md"
    echo "  Saved: $name"
}

cmd_list() {
    echo "  Saved summaries:"
    ls -1 "$DATA_DIR/summaries/"*.md 2>/dev/null | while read -r f; do
        printf "  %-20s %s\n" "$(basename "$f" .md)" "$(wc -w < "$f") words"
    done || echo "  (none)"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    file)        shift; cmd_file "$@" ;;
    stdin)       cat > /tmp/docsum_stdin.tmp; cmd_file /tmp/docsum_stdin.tmp ;;
    url)         shift; curl -sL "$1" > /tmp/docsum_url.tmp; cmd_file /tmp/docsum_url.tmp ;;
    diff)        shift; diff --brief "$1" "$2" 2>/dev/null; diff "$1" "$2" | head -30 ;;
    stats)       shift; cmd_stats "$@" ;;
    keywords)    shift; cmd_keywords "$@" ;;
    readability) shift; cmd_readability "$@" ;;
    structure)   shift; cmd_structure "$@" ;;
    toc)         shift; cmd_toc "$@" ;;
    bullets)     shift; cmd_bullets "$@" ;;
    tldr)        shift; cmd_file "$@" ;;
    outline)     shift; cmd_outline "$@" ;;
    compress)    shift; cmd_compress "$@" ;;
    save)        shift; cmd_save "$@" ;;
    list)        cmd_list ;;
    export)      shift; cat "$DATA_DIR/summaries/${1:?}.md" 2>/dev/null || echo "Not found" ;;
    history)     [ -f "$DATA_DIR/history.log" ] && tail -20 "$DATA_DIR/history.log" || echo "No history" ;;
    help|-h)     show_help ;;
    version|-v)  echo "doc-summarizer v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help; exit 1 ;;
esac
