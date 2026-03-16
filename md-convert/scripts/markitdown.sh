#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Markitdown — file format converter to Markdown (inspired by microsoft/markitdown 90K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) cat << 'EOF'
Markitdown — convert files to Markdown
Commands:
  html2md <file>       HTML to Markdown
  csv2md <file>        CSV to Markdown table
  json2md <file>       JSON to Markdown
  tsv2md <file>        TSV to Markdown table
  xml2md <file>        XML to Markdown
  text2md <file>       Plain text to formatted MD
  url2md <url>         Web page to Markdown
  batch <dir> <ext>    Convert all files in directory
  info                 Version info
Powered by BytesAgain | bytesagain.com
EOF
;;
html2md)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: html2md <file>"; exit 1; }
    python3 << PYEOF
import re
with open("$f") as fh: html = fh.read()
md = html
md = re.sub(r'<h1[^>]*>(.*?)</h1>', r'# \1\n', md, flags=re.DOTALL)
md = re.sub(r'<h2[^>]*>(.*?)</h2>', r'## \1\n', md, flags=re.DOTALL)
md = re.sub(r'<h3[^>]*>(.*?)</h3>', r'### \1\n', md, flags=re.DOTALL)
md = re.sub(r'<strong>(.*?)</strong>', r'**\1**', md)
md = re.sub(r'<b>(.*?)</b>', r'**\1**', md)
md = re.sub(r'<em>(.*?)</em>', r'*\1*', md)
md = re.sub(r'<i>(.*?)</i>', r'*\1*', md)
md = re.sub(r'<code>(.*?)</code>', r'`+"`"+r'\1`+"`"+r'`', md)
md = re.sub(r'<a\s+href="([^"]*)"[^>]*>(.*?)</a>', r'[\2](\1)', md)
md = re.sub(r'<li>(.*?)</li>', r'- \1', md, flags=re.DOTALL)
md = re.sub(r'<br\s*/?>', '\n', md)
md = re.sub(r'<p>(.*?)</p>', r'\1\n', md, flags=re.DOTALL)
md = re.sub(r'<[^>]+>', '', md)
md = re.sub(r'\n{3,}', '\n\n', md)
print(md.strip())
PYEOF
;;
csv2md)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: csv2md <file>"; exit 1; }
    python3 -c "
import csv
with open('$f') as fh:
    reader = csv.reader(fh)
    rows = list(reader)
if rows:
    header = rows[0]
    print('| ' + ' | '.join(header) + ' |')
    print('|' + '|'.join(['---']*len(header)) + '|')
    for row in rows[1:]:
        print('| ' + ' | '.join(row) + ' |')
";;
json2md)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: json2md <file>"; exit 1; }
    python3 << PYEOF
import json
with open("$f") as fh: d = json.load(fh)
def to_md(obj, depth=0):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if isinstance(v, (dict, list)):
                print("{}**{}**:".format("  "*depth, k))
                to_md(v, depth+1)
            else:
                print("{}- **{}**: {}".format("  "*depth, k, v))
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            if isinstance(item, (dict, list)):
                print("{}{}. ".format("  "*depth, i+1))
                to_md(item, depth+1)
            else:
                print("{}- {}".format("  "*depth, item))
to_md(d)
PYEOF
;;
tsv2md)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: tsv2md <file>"; exit 1; }
    python3 -c "
with open('$f') as fh:
    lines = [l.strip().split('\t') for l in fh if l.strip()]
if lines:
    print('| ' + ' | '.join(lines[0]) + ' |')
    print('|' + '|'.join(['---']*len(lines[0])) + '|')
    for row in lines[1:]:
        print('| ' + ' | '.join(row) + ' |')
";;
xml2md)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: xml2md <file>"; exit 1; }
    python3 << PYEOF
import re
with open("$f") as fh: xml = fh.read()
tags = re.findall(r'<(\w+)[^>]*>(.*?)</\1>', xml, re.DOTALL)
for tag, content in tags:
    inner = re.findall(r'<(\w+)>(.*?)</\1>', content)
    if inner:
        print("## {}".format(tag))
        for k, v in inner:
            print("- **{}**: {}".format(k, v.strip()))
        print()
    else:
        print("**{}**: {}".format(tag, content.strip()))
PYEOF
;;
text2md)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: text2md <file>"; exit 1; }
    python3 << PYEOF
with open("$f") as fh: text = fh.read()
lines = text.split("\n")
in_list = False
for line in lines:
    stripped = line.strip()
    if not stripped:
        print(); in_list = False; continue
    if stripped.startswith(("- ", "* ", "• ")):
        print("- {}".format(stripped[2:])); in_list = True
    elif stripped[0].isdigit() and ". " in stripped[:4]:
        print(stripped); in_list = True
    elif len(stripped) < 60 and stripped == stripped.upper():
        print("\n## {}".format(stripped.title()))
    elif not in_list:
        print(stripped)
    else:
        print("  {}".format(stripped))
PYEOF
;;
url2md)
    url="${1:-}"; [ -z "$url" ] && { echo "Usage: url2md <url>"; exit 1; }
    python3 << PYEOF
import re
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
url = "$url"
if not url.startswith("http"): url = "https://" + url
resp = urlopen(Request(url, headers={"User-Agent":"Mozilla/5.0"}), timeout=15)
html = resp.read().decode("utf-8","ignore")
title = re.search(r'<title>(.*?)</title>', html, re.DOTALL)
if title: print("# {}\n".format(title.group(1).strip()))
body = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL)
body = re.sub(r'<style[^>]*>.*?</style>', '', body, flags=re.DOTALL)
body = re.sub(r'<h([1-3])[^>]*>(.*?)</h\1>', lambda m: "#"*int(m.group(1))+" "+m.group(2)+"\n", body, flags=re.DOTALL)
body = re.sub(r'<p>(.*?)</p>', r'\1\n', body, flags=re.DOTALL)
body = re.sub(r'<a\s+href="([^"]*)"[^>]*>(.*?)</a>', r'[\2](\1)', body)
body = re.sub(r'<[^>]+>', '', body)
body = re.sub(r'\n{3,}', '\n\n', body)
print(body.strip()[:3000])
PYEOF
;;
batch)
    dir="${1:-.}"; ext="${2:-html}"
    find "$dir" -name "*.$ext" | while read f; do
        echo "--- Converting: $f ---"
        case "$ext" in
            html|htm) bash "$0" html2md "$f" ;;
            csv) bash "$0" csv2md "$f" ;;
            json) bash "$0" json2md "$f" ;;
            tsv) bash "$0" tsv2md "$f" ;;
            xml) bash "$0" xml2md "$f" ;;
            *) bash "$0" text2md "$f" ;;
        esac
        echo ""
    done ;;
info) echo "Markitdown v1.0.0"; echo "Inspired by: microsoft/markitdown (90,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
