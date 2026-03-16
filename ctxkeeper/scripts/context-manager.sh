#!/usr/bin/env bash
# Context Manager — Smart context window management for AI
# Powered by BytesAgain

CTX_DIR="$HOME/context-manager"
CMD="${1:-help}"
shift 2>/dev/null

case "$CMD" in
  summarize)
    INPUT_FILE="${1:-}"
    if [ -z "$INPUT_FILE" ]; then
      echo "Usage: context-manager.sh summarize <file>"
      echo "  Compresses a text/conversation file into a summary."
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os

filepath = "${INPUT_FILE}"
filepath = os.path.expanduser(filepath)

print("=" * 60)
print("  CONTEXT MANAGER — Summarize")
print("=" * 60)
print()

if not os.path.exists(filepath):
    print("  Error: File not found: {}".format(filepath))
else:
    with open(filepath) as f:
        content = f.read()
    lines = [l for l in content.strip().split("\n") if l.strip()]
    words = content.split()
    chars = len(content)
    est_tokens = len(words) * 4 // 3

    print("  Input file  : {}".format(filepath))
    print("  Lines       : {}".format(len(lines)))
    print("  Words       : {}".format(len(words)))
    print("  Est. tokens : {}".format(est_tokens))
    print()

    # Extract key sentences (first, last, and any with key markers)
    key_lines = []
    markers = ["important", "key", "summary", "conclusion", "decision", "action", "todo"]
    for i, line in enumerate(lines):
        lower = line.lower()
        if i == 0 or i == len(lines) - 1:
            key_lines.append(line)
        elif any(m in lower for m in markers):
            key_lines.append(line)

    if key_lines:
        summary_text = "\n".join(key_lines[:10])
        reduction = 100 - (len(summary_text) * 100 // max(chars, 1))
        print("  Key content ({} lines, ~{}% reduction):".format(len(key_lines[:10]), reduction))
        print()
        for line in key_lines[:10]:
            print("  > {}".format(line[:80]))

        out_path = filepath + ".summary"
        with open(out_path, "w") as f:
            f.write("# Summary of {}\n\n".format(os.path.basename(filepath)))
            f.write(summary_text)
        print()
        print("  Summary saved: {}".format(out_path))
    else:
        print("  No key content markers found. File may be too short.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  prioritize)
    INPUT_FILE="${1:-}"
    if [ -z "$INPUT_FILE" ]; then
      echo "Usage: context-manager.sh prioritize <file>"
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os

filepath = os.path.expanduser("${INPUT_FILE}")

print("=" * 60)
print("  CONTEXT MANAGER — Prioritize")
print("=" * 60)
print()

if not os.path.exists(filepath):
    print("  Error: File not found: {}".format(filepath))
else:
    with open(filepath) as f:
        lines = [l.strip() for l in f.readlines() if l.strip()]

    high = []
    medium = []
    low = []
    high_kw = ["urgent", "critical", "important", "must", "error", "bug", "fix", "action", "deadline"]
    med_kw = ["should", "consider", "review", "update", "check", "note"]

    for line in lines:
        lower = line.lower()
        if any(k in lower for k in high_kw):
            high.append(line)
        elif any(k in lower for k in med_kw):
            medium.append(line)
        else:
            low.append(line)

    print("  HIGH priority ({} items):".format(len(high)))
    for l in high[:5]:
        print("    [!] {}".format(l[:70]))
    print()
    print("  MEDIUM priority ({} items):".format(len(medium)))
    for l in medium[:5]:
        print("    [-] {}".format(l[:70]))
    print()
    print("  LOW priority ({} items):".format(len(low)))
    for l in low[:5]:
        print("    [ ] {}".format(l[:70]))
    print()
    print("  Recommendation: Keep HIGH + MEDIUM in context, archive LOW.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  archive)
    INPUT_FILE="${1:-}"
    if [ -z "$INPUT_FILE" ]; then
      echo "Usage: context-manager.sh archive <file>"
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os, shutil, datetime

filepath = os.path.expanduser("${INPUT_FILE}")
base = os.path.expanduser("~/context-manager")
archive_dir = os.path.join(base, "archive")
os.makedirs(archive_dir, exist_ok=True)

print("=" * 60)
print("  CONTEXT MANAGER — Archive")
print("=" * 60)
print()

if not os.path.exists(filepath):
    print("  Error: File not found: {}".format(filepath))
else:
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    fname = os.path.basename(filepath)
    dest = os.path.join(archive_dir, "{}_{}".format(timestamp, fname))
    shutil.copy2(filepath, dest)
    size = os.path.getsize(filepath)
    print("  Archived: {}".format(fname))
    print("  Size    : {:.1f} KB".format(size / 1024))
    print("  Dest    : {}".format(dest))
    print()
    print("  Original file preserved. Delete manually if desired.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  restore)
    KEYWORD="${1:-}"
    python3 << PYEOF
import os

base = os.path.expanduser("~/context-manager")
archive_dir = os.path.join(base, "archive")
keyword = "${KEYWORD}"

print("=" * 60)
print("  CONTEXT MANAGER — Restore")
print("=" * 60)
print()

if not os.path.exists(archive_dir):
    print("  No archive found. Nothing to restore.")
else:
    files = sorted(os.listdir(archive_dir), reverse=True)
    if keyword:
        files = [f for f in files if keyword.lower() in f.lower()]

    if not files:
        print("  No archived files found{}.".format(" matching '{}'".format(keyword) if keyword else ""))
    else:
        print("  Available archives{}:".format(" matching '{}'".format(keyword) if keyword else ""))
        print()
        for f in files[:15]:
            fpath = os.path.join(archive_dir, f)
            size = os.path.getsize(fpath)
            print("    {:.1f}KB  {}".format(size / 1024, f))
        print()
        print("  To restore, copy the file:")
        print("  cp {}/{} ./".format(archive_dir, files[0]))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  budget)
    INPUT_FILE="${1:-}"
    python3 << PYEOF
import os

filepath = "${INPUT_FILE}"

print("=" * 60)
print("  CONTEXT MANAGER — Token Budget")
print("=" * 60)
print()

if filepath and os.path.exists(os.path.expanduser(filepath)):
    filepath = os.path.expanduser(filepath)
    with open(filepath) as f:
        content = f.read()
    words = len(content.split())
    chars = len(content)
    est_tokens = words * 4 // 3

    print("  File     : {}".format(filepath))
    print("  Words    : {:,}".format(words))
    print("  Chars    : {:,}".format(chars))
    print("  Est. tokens: {:,}".format(est_tokens))
    print()

    limits = [("GPT-3.5", 4096), ("GPT-4", 8192), ("GPT-4-32k", 32768), ("Claude", 100000), ("GPT-4o", 128000)]
    print("  Context window usage:")
    for name, limit in limits:
        pct = est_tokens * 100 // limit
        bar_len = min(pct // 5, 20)
        bar = "#" * bar_len + "." * (20 - bar_len)
        status = "OK" if pct < 80 else "WARNING" if pct < 100 else "OVER"
        print("    {:12s} [{:20s}] {:3d}% {}".format(name, bar, pct, status))
else:
    print("  Usage: context-manager.sh budget <file>")
    print("  Estimates token count and context window usage.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  optimize)
    INPUT_FILE="${1:-}"
    if [ -z "$INPUT_FILE" ]; then
      echo "Usage: context-manager.sh optimize <file>"
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os

filepath = os.path.expanduser("${INPUT_FILE}")

print("=" * 60)
print("  CONTEXT MANAGER — Optimize")
print("=" * 60)
print()

if not os.path.exists(filepath):
    print("  Error: File not found: {}".format(filepath))
else:
    with open(filepath) as f:
        content = f.read()
    lines = content.split("\n")
    total = len(lines)
    empty_lines = sum(1 for l in lines if not l.strip())
    long_lines = sum(1 for l in lines if len(l) > 200)
    dup_lines = total - len(set(lines))

    print("  File        : {}".format(filepath))
    print("  Total lines : {}".format(total))
    print()
    print("  Optimization Suggestions:")
    print()

    savings = 0
    if empty_lines > total * 0.2:
        print("  [!] {} empty lines ({:.0f}%) — consolidate whitespace".format(
            empty_lines, empty_lines * 100.0 / max(total, 1)))
        savings += empty_lines
    if long_lines > 0:
        print("  [!] {} lines over 200 chars — consider summarizing".format(long_lines))
        savings += long_lines * 2
    if dup_lines > 0:
        print("  [!] {} duplicate lines — remove redundancy".format(dup_lines))
        savings += dup_lines

    if savings == 0:
        print("  Context looks well-optimized. No major issues found.")
    else:
        est_reduction = min(savings * 100 // max(total, 1), 50)
        print()
        print("  Estimated reduction: ~{}% of content".format(est_reduction))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  split)
    INPUT_FILE="${1:-}"
    CHUNK_SIZE="${2:-50}"
    if [ -z "$INPUT_FILE" ]; then
      echo "Usage: context-manager.sh split <file> [lines_per_chunk]"
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os

filepath = os.path.expanduser("${INPUT_FILE}")
chunk_size = int("${CHUNK_SIZE}")
base = os.path.expanduser("~/context-manager")
chunks_dir = os.path.join(base, "chunks")
os.makedirs(chunks_dir, exist_ok=True)

print("=" * 60)
print("  CONTEXT MANAGER — Split")
print("=" * 60)
print()

if not os.path.exists(filepath):
    print("  Error: File not found: {}".format(filepath))
else:
    with open(filepath) as f:
        lines = f.readlines()

    fname = os.path.basename(filepath).replace(".md", "").replace(".txt", "")
    chunks = []
    for i in range(0, len(lines), chunk_size):
        chunk = lines[i:i+chunk_size]
        chunk_name = "{}_chunk_{}.md".format(fname, len(chunks) + 1)
        chunk_path = os.path.join(chunks_dir, chunk_name)
        with open(chunk_path, "w") as f:
            f.writelines(chunk)
        chunks.append((chunk_name, len(chunk)))

    print("  Input  : {} ({} lines)".format(filepath, len(lines)))
    print("  Chunks : {} x {} lines".format(len(chunks), chunk_size))
    print("  Output : {}".format(chunks_dir))
    print()
    for name, size in chunks:
        print("    {} ({} lines)".format(name, size))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  merge)
    python3 << 'PYEOF'
import os, glob

base = os.path.expanduser("~/context-manager")
chunks_dir = os.path.join(base, "chunks")

print("=" * 60)
print("  CONTEXT MANAGER — Merge")
print("=" * 60)
print()

if not os.path.exists(chunks_dir):
    print("  No chunks directory found. Use 'split' first.")
else:
    chunk_files = sorted(glob.glob(os.path.join(chunks_dir, "*.md")))
    if not chunk_files:
        print("  No chunk files found in {}".format(chunks_dir))
    else:
        merged = []
        seen = set()
        dups = 0
        for cf in chunk_files:
            with open(cf) as f:
                for line in f:
                    if line.strip() in seen and line.strip():
                        dups += 1
                    else:
                        merged.append(line)
                        if line.strip():
                            seen.add(line.strip())

        out_path = os.path.join(base, "merged_context.md")
        with open(out_path, "w") as f:
            f.writelines(merged)

        print("  Merged {} chunk(s)".format(len(chunk_files)))
        print("  Duplicates removed: {}".format(dups))
        print("  Output lines: {}".format(len(merged)))
        print("  Saved to: {}".format(out_path))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  *)
    echo "=================================================="
    echo "  CONTEXT MANAGER — Smart Context for AI"
    echo "=================================================="
    echo ""
    echo "  Commands:"
    echo "    summarize   Compress conversation context"
    echo "    prioritize  Rank context by relevance"
    echo "    archive     Move old context to storage"
    echo "    restore     Bring back archived context"
    echo "    budget      Show token usage estimate"
    echo "    optimize    Suggest context reduction"
    echo "    split       Break large context into chunks"
    echo "    merge       Combine related contexts"
    echo ""
    echo "  Usage:"
    echo "    bash context-manager.sh <command> [args]"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
