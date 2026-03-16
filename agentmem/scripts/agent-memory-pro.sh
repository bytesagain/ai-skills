#!/usr/bin/env bash
# Agent Memory — Persistent memory system for AI agents
# Powered by BytesAgain

MEMORY_DIR="$HOME/agent-memory"
CMD="${1:-help}"
shift 2>/dev/null

case "$CMD" in
  init)
    python3 << 'PYEOF'
import os, datetime

base = os.path.expanduser("~/agent-memory")
dirs = ["learnings", "facts", "decisions", "archive", "exports"]

print("=" * 60)
print("  AGENT MEMORY — Initialization")
print("=" * 60)
print()

for d in dirs:
    path = os.path.join(base, d)
    os.makedirs(path, exist_ok=True)
    print("  [+] Created: {}".format(path))

index_path = os.path.join(base, "index.md")
if not os.path.exists(index_path):
    with open(index_path, "w") as f:
        f.write("# Agent Memory Index\n\n")
        f.write("Created: {}\n\n".format(datetime.datetime.now().strftime("%Y-%m-%d %H:%M")))
        f.write("## Categories\n\n")
        for d in dirs:
            f.write("- {}\n".format(d))
    print("  [+] Created: {}".format(index_path))

print()
print("  Memory system initialized at: {}".format(base))
print("  {} categories ready".format(len(dirs)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  save)
    CATEGORY="${1:-learnings}"
    CONTENT="${2:-}"
    if [ -z "$CONTENT" ]; then
      echo "Usage: agent-memory.sh save <category> \"<memory content>\""
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/agent-memory")
category = "${CATEGORY}"
content = """${CONTENT}"""
now = datetime.datetime.now()
date_str = now.strftime("%Y-%m-%d")
time_str = now.strftime("%H:%M:%S")

cat_dir = os.path.join(base, category)
os.makedirs(cat_dir, exist_ok=True)

filepath = os.path.join(cat_dir, "{}.md".format(date_str))
entry = "\n## {} — {}\n\n{}\n".format(date_str, time_str, content)

with open(filepath, "a") as f:
    f.write(entry)

print("=" * 60)
print("  AGENT MEMORY — Save")
print("=" * 60)
print()
print("  Category : {}".format(category))
print("  Timestamp: {} {}".format(date_str, time_str))
print("  Content  : {}".format(content[:80]))
print("  Saved to : {}".format(filepath))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  recall)
    KEYWORD="${1:-}"
    if [ -z "$KEYWORD" ]; then
      echo "Usage: agent-memory.sh recall <keyword>"
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os, glob

base = os.path.expanduser("~/agent-memory")
keyword = "${KEYWORD}".lower()
results = []

print("=" * 60)
print("  AGENT MEMORY — Recall")
print("=" * 60)
print()
print("  Searching for: '{}'".format(keyword))
print()

for root, dirs, files in os.walk(base):
    for fname in files:
        if not fname.endswith(".md") or fname == "index.md":
            continue
        fpath = os.path.join(root, fname)
        try:
            with open(fpath, "r") as f:
                content = f.read()
            if keyword in content.lower():
                cat = os.path.basename(os.path.dirname(fpath))
                lines = [l.strip() for l in content.split("\n") if keyword in l.lower() and l.strip()]
                for line in lines[:3]:
                    results.append((cat, fname, line[:100]))
        except Exception:
            pass

if results:
    print("  Found {} match(es):".format(len(results)))
    print()
    for cat, fname, line in results[:10]:
        print("  [{}/{}]".format(cat, fname))
        print("    {}".format(line))
        print()
else:
    print("  No memories found matching '{}'".format(keyword))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  review)
    python3 << 'PYEOF'
import os, datetime

base = os.path.expanduser("~/agent-memory")
now = datetime.datetime.now()
recent = []

print("=" * 60)
print("  AGENT MEMORY — Review Recent")
print("=" * 60)
print()

for root, dirs, files in os.walk(base):
    for fname in sorted(files, reverse=True):
        if not fname.endswith(".md") or fname == "index.md":
            continue
        fpath = os.path.join(root, fname)
        try:
            mtime = os.path.getmtime(fpath)
            age_hours = (now - datetime.datetime.fromtimestamp(mtime)).total_seconds() / 3600
            if age_hours <= 72:
                cat = os.path.basename(os.path.dirname(fpath))
                with open(fpath, "r") as f:
                    content = f.read()
                lines = [l for l in content.strip().split("\n") if l.strip() and not l.startswith("#")]
                preview = lines[0][:80] if lines else "(empty)"
                recent.append((age_hours, cat, fname, preview))
        except Exception:
            pass

recent.sort()
if recent:
    print("  Last 72 hours — {} file(s):".format(len(recent)))
    print()
    for hours, cat, fname, preview in recent[:15]:
        print("  [{:>5.1f}h ago] {}/{}".format(hours, cat, fname))
        print("             {}".format(preview))
        print()
else:
    print("  No recent memories found (last 72 hours)")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  consolidate)
    python3 << 'PYEOF'
import os, hashlib

base = os.path.expanduser("~/agent-memory")
seen_hashes = {}
duplicates = 0
total = 0

print("=" * 60)
print("  AGENT MEMORY — Consolidate")
print("=" * 60)
print()

for root, dirs, files in os.walk(base):
    if "archive" in root or "exports" in root:
        continue
    for fname in files:
        if not fname.endswith(".md") or fname == "index.md":
            continue
        fpath = os.path.join(root, fname)
        total += 1
        try:
            with open(fpath, "r") as f:
                content = f.read()
            h = hashlib.md5(content.encode()).hexdigest()
            if h in seen_hashes:
                duplicates += 1
                print("  [DUP] {} == {}".format(fpath, seen_hashes[h]))
            else:
                seen_hashes[h] = fpath
        except Exception:
            pass

print()
print("  Total files scanned : {}".format(total))
print("  Unique files        : {}".format(total - duplicates))
print("  Duplicates found    : {}".format(duplicates))
print()
if duplicates == 0:
    print("  Memory store is clean. No action needed.")
else:
    print("  Review duplicates above and remove manually if desired.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  export)
    python3 << 'PYEOF'
import os, datetime, json

base = os.path.expanduser("~/agent-memory")
export_dir = os.path.join(base, "exports")
os.makedirs(export_dir, exist_ok=True)
now = datetime.datetime.now()
timestamp = now.strftime("%Y%m%d_%H%M%S")
export_file = os.path.join(export_dir, "memory_export_{}.md".format(timestamp))
entries = []

print("=" * 60)
print("  AGENT MEMORY — Export")
print("=" * 60)
print()

with open(export_file, "w") as out:
    out.write("# Agent Memory Export\n\n")
    out.write("Exported: {}\n\n".format(now.strftime("%Y-%m-%d %H:%M:%S")))
    for root, dirs, files in os.walk(base):
        if "exports" in root:
            continue
        for fname in sorted(files):
            if not fname.endswith(".md") or fname == "index.md":
                continue
            fpath = os.path.join(root, fname)
            cat = os.path.basename(os.path.dirname(fpath))
            try:
                with open(fpath, "r") as f:
                    content = f.read()
                out.write("## {}/{}\n\n".format(cat, fname))
                out.write(content)
                out.write("\n---\n\n")
                entries.append(fpath)
            except Exception:
                pass

print("  Exported {} file(s) to:".format(len(entries)))
print("  {}".format(export_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  stats)
    python3 << 'PYEOF'
import os

base = os.path.expanduser("~/agent-memory")

print("=" * 60)
print("  AGENT MEMORY — Statistics")
print("=" * 60)
print()

if not os.path.exists(base):
    print("  Memory not initialized. Run 'init' first.")
else:
    total_files = 0
    total_size = 0
    categories = {}
    for root, dirs, files in os.walk(base):
        if "exports" in root:
            continue
        for fname in files:
            if not fname.endswith(".md") or fname == "index.md":
                continue
            fpath = os.path.join(root, fname)
            cat = os.path.basename(os.path.dirname(fpath))
            size = os.path.getsize(fpath)
            total_files += 1
            total_size += size
            categories[cat] = categories.get(cat, 0) + 1

    print("  Total memory files : {}".format(total_files))
    print("  Total size         : {:.1f} KB".format(total_size / 1024))
    print()
    if categories:
        print("  By Category:")
        for cat, count in sorted(categories.items(), key=lambda x: -x[1]):
            bar = "#" * min(count, 30)
            print("    {:15s} {:3d} {}".format(cat, count, bar))
    else:
        print("  No memories stored yet.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  forget)
    KEYWORD="${1:-}"
    if [ -z "$KEYWORD" ]; then
      echo "Usage: agent-memory.sh forget <keyword>"
      echo "  Lists matching files for manual removal."
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os

base = os.path.expanduser("~/agent-memory")
keyword = "${KEYWORD}".lower()
matches = []

print("=" * 60)
print("  AGENT MEMORY — Forget")
print("=" * 60)
print()
print("  Searching for entries matching: '{}'".format(keyword))
print()

for root, dirs, files in os.walk(base):
    if "exports" in root:
        continue
    for fname in files:
        if not fname.endswith(".md") or fname == "index.md":
            continue
        fpath = os.path.join(root, fname)
        try:
            with open(fpath, "r") as f:
                content = f.read()
            if keyword in content.lower():
                cat = os.path.basename(os.path.dirname(fpath))
                matches.append((cat, fname, fpath))
        except Exception:
            pass

if matches:
    print("  Found {} file(s) containing '{}':".format(len(matches), keyword))
    print()
    for cat, fname, fpath in matches:
        print("    rm {}".format(fpath))
    print()
    print("  Run the commands above to remove matching files.")
else:
    print("  No memories found matching '{}'".format(keyword))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  *)
    echo "=================================================="
    echo "  AGENT MEMORY — Persistent Memory for AI Agents"
    echo "=================================================="
    echo ""
    echo "  Commands:"
    echo "    init         Setup memory directory structure"
    echo "    save         Store a new learning"
    echo "    recall       Search memories by keyword"
    echo "    review       Review recent memories (72h)"
    echo "    consolidate  Merge duplicates and clean up"
    echo "    export       Export all memories to file"
    echo "    stats        Show memory statistics"
    echo "    forget       Find entries to remove"
    echo ""
    echo "  Usage:"
    echo "    bash agent-memory.sh <command> [args]"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
