#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# File organizer — sort, clean, deduplicate files
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "File Organizer — sort, clean, organize files
Commands:
  sort <dir>            Auto-sort by file type
  preview <dir>         Preview sort (dry run)
  duplicates <dir>      Find duplicate files
  empty <dir>           Find empty files/dirs
  large <dir> [size]    Find large files (default >100M)
  old <dir> [days]      Find old files (default >365)
  rename <dir> <pat>    Batch rename files
  flatten <dir>         Move all files to root
  tree <dir> [depth]    Show directory tree
  stats <dir>           Directory statistics
  info                  Version info
Powered by BytesAgain | bytesagain.com";;
sort)
    dir="${1:-.}"
    echo "📂 Auto-sorting $dir by type..."
    python3 << PYEOF
import os, shutil
dir_path = "$dir"
type_map = {
    'images': ['.jpg','.jpeg','.png','.gif','.bmp','.svg','.webp','.ico'],
    'documents': ['.pdf','.doc','.docx','.xls','.xlsx','.ppt','.pptx','.odt','.txt','.md','.csv'],
    'videos': ['.mp4','.avi','.mkv','.mov','.wmv','.flv','.webm'],
    'audio': ['.mp3','.wav','.flac','.aac','.ogg','.m4a'],
    'archives': ['.zip','.tar','.gz','.bz2','.rar','.7z','.xz'],
    'code': ['.py','.js','.ts','.go','.rs','.java','.c','.cpp','.h','.sh','.rb','.php'],
    'data': ['.json','.xml','.yaml','.yml','.toml','.ini','.conf','.env'],
}
moved = 0
for f in os.listdir(dir_path):
    fp = os.path.join(dir_path, f)
    if not os.path.isfile(fp): continue
    ext = os.path.splitext(f)[1].lower()
    dest = 'other'
    for category, exts in type_map.items():
        if ext in exts:
            dest = category; break
    dest_dir = os.path.join(dir_path, dest)
    os.makedirs(dest_dir, exist_ok=True)
    shutil.move(fp, os.path.join(dest_dir, f))
    moved += 1
print("  ✅ Moved {} files into categories".format(moved))
PYEOF
;;
preview)
    dir="${1:-.}"
    echo "📂 Preview sort for $dir (dry run):"
    python3 -c "
import os
type_map = {'.jpg':'images','.png':'images','.pdf':'documents','.py':'code','.js':'code',
            '.mp4':'videos','.mp3':'audio','.zip':'archives','.json':'data','.md':'documents'}
from collections import Counter
cats = Counter()
for f in os.listdir('$dir'):
    if os.path.isfile(os.path.join('$dir',f)):
        ext = os.path.splitext(f)[1].lower()
        cats[type_map.get(ext,'other')] += 1
for c, n in cats.most_common():
    print('  {} → {} files'.format(c, n))
print('  Total: {} files'.format(sum(cats.values())))
";;
duplicates)
    dir="${1:-.}"
    echo "🔍 Finding duplicates in $dir..."
    python3 << PYEOF
import os, hashlib
from collections import defaultdict
hashes = defaultdict(list)
for root, dirs, files in os.walk("$dir"):
    for f in files:
        fp = os.path.join(root, f)
        try:
            size = os.path.getsize(fp)
            if size > 0:
                with open(fp, 'rb') as fh:
                    h = hashlib.md5(fh.read(8192)).hexdigest()
                hashes[(size, h)].append(fp)
        except: pass
dups = {k: v for k, v in hashes.items() if len(v) > 1}
if dups:
    total_waste = 0
    for (size, _), files in sorted(dups.items(), key=lambda x: -x[0][0]):
        print("  Duplicates ({:.1f} KB each):".format(size/1024))
        for f in files: print("    {}".format(f))
        total_waste += size * (len(files) - 1)
    print("\n  Total wasted: {:.1f} MB".format(total_waste/1048576))
else: print("  No duplicates found")
PYEOF
;;
empty)
    dir="${1:-.}"
    echo "📂 Empty items in $dir:"
    echo "  Empty files:"
    find "$dir" -type f -empty 2>/dev/null | head -20 | while read f; do echo "    $f"; done
    echo "  Empty dirs:"
    find "$dir" -type d -empty 2>/dev/null | head -20 | while read f; do echo "    $f"; done;;
large)
    dir="${1:-.}"; size="${2:-100M}"
    echo "📦 Files larger than $size in $dir:"
    find "$dir" -type f -size "+$size" -exec ls -lh {} \; 2>/dev/null | awk '{print $5, $9}' | sort -rh | head -20;;
old)
    dir="${1:-.}"; days="${2:-365}"
    echo "📅 Files older than $days days in $dir:"
    find "$dir" -type f -mtime +"$days" 2>/dev/null | head -20 | while read f; do
        echo "  $(stat -c '%y' "$f" 2>/dev/null | cut -d' ' -f1) $f"
    done;;
rename)
    dir="${1:-.}"; pattern="${2:-}"
    [ -z "$pattern" ] && { echo "Usage: rename <dir> <pattern>"; echo "  Patterns: lowercase, uppercase, date-prefix, number"; exit 1; }
    echo "📝 Renaming files in $dir ($pattern):"
    case "$pattern" in
        lowercase) for f in "$dir"/*; do [ -f "$f" ] && mv "$f" "$(dirname "$f")/$(basename "$f" | tr '[:upper:]' '[:lower:]')" 2>/dev/null && echo "  ✅ $(basename "$f")"; done;;
        uppercase) for f in "$dir"/*; do [ -f "$f" ] && mv "$f" "$(dirname "$f")/$(basename "$f" | tr '[:lower:]' '[:upper:]')" 2>/dev/null && echo "  ✅ $(basename "$f")"; done;;
        date-prefix) for f in "$dir"/*; do [ -f "$f" ] && mv "$f" "$(dirname "$f")/$(date +%Y%m%d)_$(basename "$f")" 2>/dev/null && echo "  ✅ $(basename "$f")"; done;;
        *) echo "Unknown pattern: $pattern";;
    esac;;
flatten)
    dir="${1:-.}"
    echo "📂 Flattening $dir (moving all files to root)..."
    find "$dir" -mindepth 2 -type f 2>/dev/null | while read f; do
        mv "$f" "$dir/" 2>/dev/null && echo "  ✅ $(basename "$f")"
    done;;
tree)
    dir="${1:-.}"; depth="${2:-3}"
    if command -v tree >/dev/null 2>&1; then
        tree -L "$depth" "$dir"
    else
        find "$dir" -maxdepth "$depth" | head -50 | sed 's|[^/]*/|  |g'
    fi;;
stats)
    dir="${1:-.}"
    echo "📊 Directory Stats: $dir"
    echo "  Files: $(find "$dir" -type f 2>/dev/null | wc -l)"
    echo "  Dirs: $(find "$dir" -type d 2>/dev/null | wc -l)"
    echo "  Total size: $(du -sh "$dir" 2>/dev/null | cut -f1)"
    echo "  By type:"
    find "$dir" -type f 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | while read c e; do
        echo "    .$e: $c files"
    done;;
info) echo "File Organizer v1.0.0"; echo "Sort, clean, organize your files"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
