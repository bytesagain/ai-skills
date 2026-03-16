#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# File Finder — fast file search (inspired by sharkdp/fd 42K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    help)
        echo "File Finder — fast file search & analysis"
        echo ""
        echo "Commands:"
        echo "  find <pattern> [dir]    Find files by name pattern"
        echo "  ext <ext> [dir]         Find by extension"
        echo "  large [dir] [mb]        Find large files (default >10MB)"
        echo "  recent [dir] [days]     Recently modified (default 7 days)"
        echo "  empty [dir]             Find empty files/dirs"
        echo "  dup [dir]               Find duplicate files (by size+hash)"
        echo "  tree [dir] [depth]      Directory tree"
        echo "  summary [dir]           Directory summary"
        echo "  info                    Version info"
        echo ""
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    find)
        pattern="${1:-*}"; dir="${2:-.}"
        find "$dir" -name "*${pattern}*" -type f 2>/dev/null | head -100
        ;;
    ext)
        ext="${1:-}"; dir="${2:-.}"
        [ -z "$ext" ] && { echo "Usage: ext <extension> [dir]"; exit 1; }
        find "$dir" -name "*.${ext}" -type f 2>/dev/null | head -100
        ;;
    large)
        dir="${1:-.}"; mb="${2:-10}"
        python3 << PYEOF
import os
target = "$dir"
mb = int("$mb")
files = []
for root, dirs, fnames in os.walk(target):
    for fn in fnames:
        fp = os.path.join(root, fn)
        try:
            sz = os.path.getsize(fp)
            if sz > mb * 1048576:
                files.append((sz, fp))
        except:
            pass
files.sort(reverse=True)
print("Files > {}MB in {}:".format(mb, target))
for sz, fp in files[:30]:
    if sz > 1073741824:
        print("  {:>8.1f} GB  {}".format(sz/1073741824, fp))
    else:
        print("  {:>8.1f} MB  {}".format(sz/1048576, fp))
if not files:
    print("  (none found)")
else:
    print("\nTotal: {} files, {:.1f} GB".format(len(files), sum(s for s,_ in files)/1073741824))
PYEOF
        ;;
    recent)
        dir="${1:-.}"; days="${2:-7}"
        find "$dir" -type f -mtime -"$days" 2>/dev/null | head -50 | while read -r f; do
            echo "  $(stat -c '%y' "$f" 2>/dev/null | cut -c1-16) $f"
        done
        ;;
    empty)
        dir="${1:-.}"
        echo "Empty files:"
        find "$dir" -type f -empty 2>/dev/null | head -20
        echo ""
        echo "Empty directories:"
        find "$dir" -type d -empty 2>/dev/null | head -20
        ;;
    dup)
        dir="${1:-.}"
        python3 << PYEOF
import os, hashlib
from collections import defaultdict
target = "$dir"
by_size = defaultdict(list)
for root, dirs, fnames in os.walk(target):
    for fn in fnames:
        fp = os.path.join(root, fn)
        try:
            sz = os.path.getsize(fp)
            if sz > 0:
                by_size[sz].append(fp)
        except:
            pass
dups = []
for sz, files in by_size.items():
    if len(files) < 2:
        continue
    by_hash = defaultdict(list)
    for fp in files:
        try:
            with open(fp, "rb") as f:
                h = hashlib.md5(f.read(65536)).hexdigest()
            by_hash[h].append(fp)
        except:
            pass
    for h, group in by_hash.items():
        if len(group) > 1:
            dups.append((sz, group))
if dups:
    dups.sort(key=lambda x: -x[0])
    total_waste = 0
    print("Duplicate files in {}:".format(target))
    for sz, group in dups[:20]:
        waste = sz * (len(group) - 1)
        total_waste += waste
        print("\n  Size: {:,} bytes ({} copies)".format(sz, len(group)))
        for fp in group:
            print("    {}".format(fp))
    print("\nTotal waste: {:.1f} MB in {} groups".format(total_waste/1048576, len(dups)))
else:
    print("No duplicates found in {}".format(target))
PYEOF
        ;;
    tree)
        dir="${1:-.}"; depth="${2:-3}"
        if command -v tree >/dev/null 2>&1; then
            tree -L "$depth" "$dir"
        else
            find "$dir" -maxdepth "$depth" -print 2>/dev/null | sed 's|[^/]*/|  |g'
        fi
        ;;
    summary)
        dir="${1:-.}"
        python3 << PYEOF
import os
from collections import defaultdict
target = "$dir"
ext_stats = defaultdict(lambda: {"count": 0, "size": 0})
total_files = 0
total_size = 0
total_dirs = 0
for root, dirs, fnames in os.walk(target):
    total_dirs += len(dirs)
    for fn in fnames:
        fp = os.path.join(root, fn)
        try:
            sz = os.path.getsize(fp)
            ext = fn.rsplit(".", 1)[-1].lower() if "." in fn else "(none)"
            ext_stats[ext]["count"] += 1
            ext_stats[ext]["size"] += sz
            total_files += 1
            total_size += sz
        except:
            pass
print("Directory Summary: {}".format(target))
print("  Total files: {:,}".format(total_files))
print("  Total dirs: {:,}".format(total_dirs))
print("  Total size: {:.1f} MB".format(total_size/1048576))
print("\n  By extension:")
print("  {:10s} {:>6s} {:>10s}".format("Ext", "Files", "Size"))
print("  " + "-" * 30)
for ext, info in sorted(ext_stats.items(), key=lambda x: -x[1]["size"])[:15]:
    print("  .{:9s} {:>6,d} {:>8.1f} MB".format(ext, info["count"], info["size"]/1048576))
PYEOF
        ;;
    info)
        echo "File Finder v1.0.0"
        echo "Inspired by: sharkdp/fd (42,000+ GitHub stars)"
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    *)
        echo "Unknown: $CMD — run 'help' for usage"; exit 1
        ;;
esac
