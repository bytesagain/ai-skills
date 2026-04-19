#!/usr/bin/env bash
# word-counter v2.0.0 - Deep Text Analytics
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"

_py_word() {
    python3 -u - "$@" << 'PYEOF'
import sys, os, re
from collections import Counter

file_path = sys.argv[1]
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Stats
chars = len(text)
words = len(re.findall(r'\w+', text))
lines = text.count('\n')
read_time = round(words / 200) # Avg 200wpm

# Frequency (top 5)
words_list = re.findall(r'\b\w{4,}\b', text.lower()) # words > 3 chars
common = Counter(words_list).most_common(5)

print(f"📊 Text Analysis for: {os.path.basename(file_path)}")
print("─" * 40)
print(f"Words:      {words}")
print(f"Characters: {chars}")
print(f"Lines:      {lines}")
print(f"Est. Read:  {read_time} min")
print("\n🔥 Top Keywords:")
for w, c in common:
    print(f"  {w:15s} {c} times")
PYEOF
}

case "${1:-help}" in
    scan) _py_word "$2" ;;
    *) echo "Usage: script.sh scan <file>" ;;
esac
echo -e "\n📖 More skills: bytesagain.com"
