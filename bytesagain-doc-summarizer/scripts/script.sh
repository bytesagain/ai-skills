#!/usr/bin/env bash
# bytesagain-doc-summarizer — Document summarizer and analyzer
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-doc-summarizer — Summarize and analyze text documents"
    echo ""
    echo "Usage:"
    echo "  bytesagain-doc-summarizer summary <file>          Quick summary"
    echo "  bytesagain-doc-summarizer bullets <file>          Bullet points"
    echo "  bytesagain-doc-summarizer keywords <file>         Extract keywords"
    echo "  bytesagain-doc-summarizer stats <file>            Text statistics"
    echo "  bytesagain-doc-summarizer outline <file>          Document outline"
    echo "  bytesagain-doc-summarizer compare <file1> <file2> Compare two docs"
    echo ""
}

cmd_summary() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: summary <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    python3 << 'PYEOF'
import re, os

with open("$file", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Basic cleanup
text = re.sub(r'\s+', ' ', text).strip()
sentences = re.split(r'[.!?。！？]+', text)
sentences = [s.strip() for s in sentences if len(s.strip()) > 20]
words = text.split()
word_count = len(words)

print(f"\n📄 Summary: {os.path.basename('$file')}")
print(f"{'─'*50}")

# First, middle, last sentences as basic extractive summary
if len(sentences) >= 3:
    selected = [sentences[0], sentences[len(sentences)//2], sentences[-1]]
elif sentences:
    selected = sentences[:3]
else:
    selected = ["(No readable sentences found)"]

print(f"\n📝 Key Points:\n")
for i, s in enumerate(selected[:5], 1):
    print(f"  {i}. {s[:200].strip()}")

print(f"\n📊 Stats: {word_count} words | {len(sentences)} sentences | ~{word_count//200} min read")
PYEOF
}

cmd_bullets() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: bullets <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    python3 << 'PYEOF'
import re, os

with open("$file", encoding="utf-8", errors="ignore") as f:
    text = f.read()

text = re.sub(r'\s+', ' ', text).strip()
sentences = re.split(r'[.!?。！？]+', text)
sentences = [s.strip() for s in sentences if len(s.strip()) > 30]

# Score sentences by position and length
scored = []
total = len(sentences)
for i, s in enumerate(sentences):
    score = 0
    if i < total * 0.2: score += 3  # early = important
    if i > total * 0.8: score += 2  # conclusion = important
    if any(kw in s.lower() for kw in ['important','key','main','first','however','therefore','finally','conclusion','result','因此','结论','关键','重要','首先','总结']):
        score += 2
    if 50 < len(s) < 200: score += 1
    scored.append((score, i, s))

scored.sort(key=lambda x: (-x[0], x[1]))
top = sorted(scored[:8], key=lambda x: x[1])

print(f"\n📋 Key Bullets: {os.path.basename('$file')}\n")
for _, _, s in top:
    print(f"  • {s[:180].strip()}")
print()
PYEOF
}

cmd_keywords() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: keywords <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    python3 << 'PYEOF'
import re, os
from collections import Counter

with open("$file", encoding="utf-8", errors="ignore") as f:
    text = f.read().lower()

# Remove common stop words
stop_en = set("the a an and or but in on at to for of with is are was were be been have has had do does did will would could should may might must shall can cannot".split())
stop_zh = set("的了是在我有和就不都一上他来到时大地为子中你说生国年着就那和要她出也得里后自以会家可下而过天去能对小多然于心学么之都好看起发当没成只如事把还用第样道想作种开美总从无情己面最女但现前些所同日手又行意动方期它头经长儿回位分爱老因很给名法间斯知世什两次使身者被高已亿其结跟着接近所以因此".split())

words = re.findall(r'[a-z]{3,}|[\u4e00-\u9fff]{2,}', text)
filtered = [w for w in words if w not in stop_en and w not in stop_zh]
counts = Counter(filtered)

print(f"\n🔑 Keywords: {os.path.basename('$file')}\n")
print(f"  {'Keyword':<20} {'Count':>6}  Frequency")
print(f"  {'─'*20} {'─'*6}  {'─'*20}")
total = len(filtered)
for word, count in counts.most_common(20):
    bar = '█' * min(int(count/max(counts.values())*20), 20)
    pct = count/total*100
    print(f"  {word:<20} {count:>6}  {bar} {pct:.1f}%")
PYEOF
}

cmd_stats() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: stats <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    python3 << 'PYEOF'
import re, os

with open("$file", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.split('\n')
words = text.split()
sentences = re.split(r'[.!?。！？]+', text)
sentences = [s for s in sentences if s.strip()]
chars = len(text)
chars_no_space = len(text.replace(' ','').replace('\n',''))
paragraphs = [p for p in text.split('\n\n') if p.strip()]
avg_word_len = sum(len(w) for w in words) / max(len(words), 1)
avg_sent_len = len(words) / max(len(sentences), 1)
read_time = len(words) // 200

print(f"\n📊 Document Stats: {os.path.basename('$file')}")
print(f"{'─'*40}")
print(f"  File size:       {os.path.getsize('$file'):,} bytes")
print(f"  Characters:      {chars:,} (no spaces: {chars_no_space:,})")
print(f"  Words:           {len(words):,}")
print(f"  Sentences:       {len(sentences):,}")
print(f"  Lines:           {len(lines):,}")
print(f"  Paragraphs:      {len(paragraphs):,}")
print(f"  Avg word length: {avg_word_len:.1f} chars")
print(f"  Avg sent length: {avg_sent_len:.1f} words")
print(f"  Reading time:    ~{read_time} min ({len(words)//130} min at 130wpm)")
print()
PYEOF
}

cmd_outline() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: outline <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    python3 << 'PYEOF'
import re, os

with open("$file", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"\n📑 Outline: {os.path.basename('$file')}\n")
found = False
for line in lines:
    stripped = line.rstrip()
    # Markdown headers
    if re.match(r'^#{1,4} ', stripped):
        level = len(re.match(r'^(#+)', stripped).group(1))
        text = stripped.lstrip('#').strip()
        indent = '  ' * (level - 1)
        marker = ['#','##','###','####'][level-1]
        print(f"{indent}{marker} {text}")
        found = True
    # Numbered sections
    elif re.match(r'^\d+[\.\)]\s+[A-Z\u4e00-\u9fff]', stripped):
        print(f"  {stripped[:100]}")
        found = True
    # ALL CAPS lines (likely headings)
    elif stripped.isupper() and 5 < len(stripped) < 60:
        print(f"\n▸ {stripped}")
        found = True

if not found:
    print("  No clear outline structure detected.")
    print("  Tip: Add Markdown headers (# H1, ## H2) to your document")
PYEOF
}

cmd_compare() {
    local f1="${1:-}"; local f2="${2:-}"
    [ -z "$f1" ] || [ -z "$f2" ] && echo "Usage: compare <file1> <file2>" && exit 1
    python3 << 'PYEOF'
import re, os
from collections import Counter

def get_words(path):
    with open(path, encoding="utf-8", errors="ignore") as f:
        text = f.read().lower()
    return Counter(re.findall(r'[a-z]{3,}|[\u4e00-\u9fff]{2,}', text))

w1 = get_words("$f1")
w2 = get_words("$f2")
all_words = set(w1) | set(w2)
only1 = set(w1) - set(w2)
only2 = set(w2) - set(w1)
shared = set(w1) & set(w2)

t1 = sum(w1.values()); t2 = sum(w2.values())
overlap = len(shared) / max(len(all_words), 1) * 100

print(f"\n🔍 Document Comparison")
print(f"  File 1: {os.path.basename('$f1')} ({t1} words)")
print(f"  File 2: {os.path.basename('$f2')} ({t2} words)")
print(f"\n  Vocabulary overlap: {overlap:.1f}%")
print(f"  Shared terms: {len(shared)}")
print(f"  Unique to file1: {len(only1)}")
print(f"  Unique to file2: {len(only2)}")
print(f"\n  Top unique terms in {os.path.basename('$f1')}:")
for w, c in sorted(only1, key=lambda x: -w1[x])[:8]:
    print(f"    {w}: {w1[w]}")
print(f"\n  Top unique terms in {os.path.basename('$f2')}:")
for w, c in sorted(only2, key=lambda x: -w2[x])[:8]:
    print(f"    {w}: {w2[w]}")
PYEOF
}

case "$CMD" in
    summary)  cmd_summary "$@" ;;
    bullets)  cmd_bullets "$@" ;;
    keywords) cmd_keywords "$@" ;;
    stats)    cmd_stats "$@" ;;
    outline)  cmd_outline "$@" ;;
    compare)  cmd_compare "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
