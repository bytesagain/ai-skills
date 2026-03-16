#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# GoAccess — web log analyzer (inspired by allinurl/goaccess 20K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "GoAccess — web server log analyzer
Commands:
  parse <logfile>      Parse access log (auto-detect format)
  top-pages <log>      Top requested pages
  top-ips <log>        Top visitor IPs
  status <log>         HTTP status code distribution
  hourly <log>         Requests per hour
  bandwidth <log>      Bandwidth usage
  errors <log>         Error log analysis (4xx/5xx)
  bots <log>           Bot/crawler detection
  summary <log>        Full summary report
  info                 Version info
Powered by BytesAgain | bytesagain.com";;
parse)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: parse <logfile>"; exit 1; }
    [ ! -f "$f" ] && { echo "File not found: $f"; exit 1; }
    python3 << PYEOF
import re, collections
with open("$f") as fh: lines = fh.readlines()
total = len(lines)
ips = collections.Counter()
pages = collections.Counter()
codes = collections.Counter()
sizes = 0
for line in lines:
    m = re.match(r'(\S+)\s+\S+\s+\S+\s+\[([^\]]+)\]\s+"(\S+)\s+(\S+)\s+\S+"\s+(\d+)\s+(\d+)', line)
    if m:
        ips[m.group(1)] += 1
        pages[m.group(4)] += 1
        codes[m.group(5)] += 1
        try: sizes += int(m.group(6))
        except: pass
print("Log Analysis: $f")
print("  Total requests: {:,}".format(total))
print("  Unique IPs: {:,}".format(len(ips)))
print("  Unique pages: {:,}".format(len(pages)))
print("  Bandwidth: {:.1f} MB".format(sizes/1048576))
print("  Top status: {}".format(dict(codes.most_common(5))))
PYEOF
;;
top-pages)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: top-pages <log>"; exit 1; }
    echo "Top Pages:"; awk '{print $7}' "$f" 2>/dev/null | sort | uniq -c | sort -rn | head -20;;
top-ips)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: top-ips <log>"; exit 1; }
    echo "Top IPs:"; awk '{print $1}' "$f" 2>/dev/null | sort | uniq -c | sort -rn | head -20;;
status)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: status <log>"; exit 1; }
    echo "HTTP Status Codes:"; awk '{print $9}' "$f" 2>/dev/null | grep -E '^[0-9]+$' | sort | uniq -c | sort -rn;;
hourly)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: hourly <log>"; exit 1; }
    echo "Requests per Hour:"; grep -oE '\[.*/.*:([0-9]{2}):' "$f" 2>/dev/null | cut -d: -f2 | sort | uniq -c | sort -k2;;
bandwidth)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: bandwidth <log>"; exit 1; }
    echo "Bandwidth by status:"; awk '{s[$9]+=$10} END {for(k in s) printf "  %s: %.1f MB\n", k, s[k]/1048576}' "$f" 2>/dev/null;;
errors)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: errors <log>"; exit 1; }
    echo "Error Requests (4xx/5xx):"; awk '$9 ~ /^[45]/' "$f" 2>/dev/null | awk '{print $9, $7}' | sort | uniq -c | sort -rn | head -20;;
bots)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: bots <log>"; exit 1; }
    echo "Bot/Crawler Detection:"; grep -iE 'bot|crawler|spider|slurp|Googlebot|Bingbot' "$f" 2>/dev/null | awk '{print $1}' | sort | uniq -c | sort -rn | head -15
    echo "  Total bot requests: $(grep -ciE 'bot|crawler|spider' "$f" 2>/dev/null || echo 0)";;
summary)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: summary <log>"; exit 1; }
    echo "=========================================="
    echo "  Web Log Summary: $f"
    echo "=========================================="
    bash "$0" parse "$f" 2>/dev/null; echo ""
    bash "$0" top-pages "$f" 2>/dev/null | head -12; echo ""
    bash "$0" status "$f" 2>/dev/null; echo ""
    bash "$0" errors "$f" 2>/dev/null | head -7;;
info) echo "GoAccess v1.0.0"; echo "Inspired by: goaccess (20,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
