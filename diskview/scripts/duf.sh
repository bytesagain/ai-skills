#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# duf — Disk Usage/Free utility (inspired by muesli/duf 14K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "duf — Disk Usage/Free analyzer
Commands:
  overview            Disk usage overview (all mounts)
  usage [path]        Directory usage breakdown
  top [n] [path]      Top n largest files
  find-big [size]     Find files larger than size (e.g. 100M)
  duplicates [path]   Find duplicate files
  clean [path]        Suggest cleanup targets
  watch [path]        Monitor disk usage changes
  export [format]     Export report (md/json)
  info                Version info
Powered by BytesAgain | bytesagain.com";;
overview)
    echo "📊 Disk Usage Overview:"
    df -h 2>/dev/null | head -1
    df -h 2>/dev/null | tail -n +2 | sort -k5 -rn | while read fs size used avail pct mount; do
        bar=""
        pct_num=${pct%%%}
        filled=$((pct_num / 5))
        for i in $(seq 1 20); do
            if [ "$i" -le "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
        done
        icon="✅"; [ "$pct_num" -gt 80 ] && icon="⚠"; [ "$pct_num" -gt 95 ] && icon="🚨"
        echo "  $icon $mount"
        echo "    $bar $pct ($used/$size)"
    done;;
usage)
    path="${1:-/}"
    echo "📂 Directory Usage: $path"
    du -sh "$path"/* 2>/dev/null | sort -rh | head -15;;
top)
    n="${1:-10}"; path="${2:-.}"
    echo "📦 Top $n largest files in $path:"
    find "$path" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -"$n";;
find-big)
    size="${1:-100M}"; path="${2:-.}"
    echo "🔍 Files larger than $size in $path:"
    find "$path" -type f -size +"$size" -exec ls -lh {} \; 2>/dev/null | awk '{print $5, $9}' | sort -rh | head -20;;
duplicates)
    path="${1:-.}"
    echo "🔍 Finding duplicates in $path (by size+name)..."
    find "$path" -type f 2>/dev/null | while read f; do
        echo "$(stat -c%s "$f" 2>/dev/null || stat -f%z "$f" 2>/dev/null) $(basename "$f")"
    done | sort | uniq -d | head -20;;
clean)
    path="${1:-/}"
    echo "🧹 Cleanup Suggestions:"
    echo "  Temp files:"
    du -sh /tmp 2>/dev/null | awk '{print "    /tmp: " $1}'
    echo "  Log files:"
    du -sh /var/log 2>/dev/null | awk '{print "    /var/log: " $1}'
    echo "  Cache:"
    du -sh ~/.cache 2>/dev/null | awk '{print "    ~/.cache: " $1}'
    echo "  Package cache:"
    du -sh /var/cache/apt 2>/dev/null | awk '{print "    apt: " $1}'
    du -sh /var/cache/yum 2>/dev/null | awk '{print "    yum: " $1}'
    echo "  Old kernels:"
    dpkg -l 'linux-image-*' 2>/dev/null | grep ^ii | wc -l | awk '{print "    " $1 " kernel(s) installed"}';;
watch)
    path="${1:-/}"
    echo "👁 Watching $path (5 checks, 10s interval):"
    for i in $(seq 1 5); do
        used=$(df "$path" 2>/dev/null | tail -1 | awk '{print $5}')
        echo "  $(date '+%H:%M:%S') $used"
        sleep 10
    done;;
export)
    fmt="${1:-md}"
    case "$fmt" in
        md) echo "# Disk Report $(date '+%Y-%m-%d')"; echo ""; df -h 2>/dev/null | while read line; do echo "    $line"; done;;
        json) df -h 2>/dev/null | tail -n +2 | python3 -c "
import json, sys
disks = []
for line in sys.stdin:
    parts = line.split()
    if len(parts) >= 6:
        disks.append({'fs':parts[0],'size':parts[1],'used':parts[2],'avail':parts[3],'pct':parts[4],'mount':parts[5]})
print(json.dumps(disks, indent=2))
";;
        *) echo "Format: md or json";;
    esac;;
info) echo "duf v1.0.0"; echo "Inspired by: muesli/duf (14,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
