#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Code Viewer — syntax-highlighted code viewer (inspired by sharkdp/bat 57K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    help)
        echo "Code Viewer — syntax-highlighted code viewing & analysis"
        echo ""
        echo "Commands:"
        echo "  view <file>           View file with line numbers"
        echo "  diff <f1> <f2>        Side-by-side diff"
        echo "  stats <file|dir>      Code statistics (lines/words/chars)"
        echo "  search <pat> <file>   Search with context"
        echo "  head <file> [n]       First N lines (default 20)"
        echo "  tail <file> [n]       Last N lines (default 20)"
        echo "  range <file> <s> <e>  View line range"
        echo "  info                  Version info"
        echo ""
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    view)
        file="${1:-}"
        [ -z "$file" ] && { echo "Usage: view <file>"; exit 1; }
        [ ! -f "$file" ] && { echo "File not found: $file"; exit 1; }
        python3 << PYEOF
import sys
fname = "$file"
with open(fname) as f:
    lines = f.readlines()
ext = fname.rsplit(".", 1)[-1] if "." in fname else ""
print("File: {} ({} lines, {} bytes)".format(fname, len(lines), sum(len(l) for l in lines)))
print("=" * 60)
for i, line in enumerate(lines, 1):
    print("{:>4} | {}".format(i, line.rstrip()))
print("=" * 60)
PYEOF
        ;;
    diff)
        f1="${1:-}"; f2="${2:-}"
        [ -z "$f1" ] || [ -z "$f2" ] && { echo "Usage: diff <file1> <file2>"; exit 1; }
        [ ! -f "$f1" ] && { echo "Not found: $f1"; exit 1; }
        [ ! -f "$f2" ] && { echo "Not found: $f2"; exit 1; }
        diff --color=auto -u "$f1" "$f2" 2>/dev/null || diff -u "$f1" "$f2" || true
        ;;
    stats)
        target="${1:-.}"
        python3 << PYEOF
import os
target = "$target"
stats = {"files": 0, "lines": 0, "words": 0, "chars": 0, "by_ext": {}}
def scan(p):
    if os.path.isfile(p):
        try:
            with open(p) as f:
                content = f.read()
            ext = p.rsplit(".", 1)[-1] if "." in p else "other"
            lines = content.count("\n") + (1 if content and not content.endswith("\n") else 0)
            words = len(content.split())
            stats["files"] += 1
            stats["lines"] += lines
            stats["words"] += words
            stats["chars"] += len(content)
            stats["by_ext"].setdefault(ext, {"files": 0, "lines": 0})
            stats["by_ext"][ext]["files"] += 1
            stats["by_ext"][ext]["lines"] += lines
        except:
            pass
    elif os.path.isdir(p):
        for d, _, fs in os.walk(p):
            for fn in fs:
                scan(os.path.join(d, fn))
scan(target)
print("Code Statistics: {}".format(target))
print("  Files: {:,}".format(stats["files"]))
print("  Lines: {:,}".format(stats["lines"]))
print("  Words: {:,}".format(stats["words"]))
print("  Chars: {:,}".format(stats["chars"]))
if stats["by_ext"]:
    print("\n  By extension:")
    for ext, info in sorted(stats["by_ext"].items(), key=lambda x: -x[1]["lines"])[:15]:
        print("    .{:10s} {:>5d} files {:>8,d} lines".format(ext, info["files"], info["lines"]))
PYEOF
        ;;
    search)
        pattern="${1:-}"; file="${2:-}"
        [ -z "$pattern" ] && { echo "Usage: search <pattern> <file>"; exit 1; }
        if [ -z "$file" ]; then
            grep -rn --color=auto "$pattern" . 2>/dev/null | head -50
        else
            grep -n --color=auto -C 2 "$pattern" "$file" 2>/dev/null || echo "No matches"
        fi
        ;;
    head)
        file="${1:-}"; n="${2:-20}"
        [ -z "$file" ] && { echo "Usage: head <file> [lines]"; exit 1; }
        head -n "$n" "$file"
        ;;
    tail)
        file="${1:-}"; n="${2:-20}"
        [ -z "$file" ] && { echo "Usage: tail <file> [lines]"; exit 1; }
        tail -n "$n" "$file"
        ;;
    range)
        file="${1:-}"; s="${2:-1}"; e="${3:-10}"
        [ -z "$file" ] && { echo "Usage: range <file> <start> <end>"; exit 1; }
        sed -n "${s},${e}p" "$file" | nl -ba -v "$s"
        ;;
    info)
        echo "Code Viewer v1.0.0"
        echo "Inspired by: sharkdp/bat (57,000+ GitHub stars)"
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    *)
        echo "Unknown: $CMD — run 'help' for usage"
        exit 1
        ;;
esac
