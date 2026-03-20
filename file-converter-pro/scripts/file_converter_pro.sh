#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# File Converter Pro — universal file format conversion (inspired by ConvertX 16K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true
case "$CMD" in
    help)
        echo "File Converter Pro — format conversion toolkit"
        echo "Commands:"
        echo "  json2csv <file>      JSON to CSV"
        echo "  csv2json <file>      CSV to JSON"
        echo "  json2yaml <file>     JSON to YAML-like"
        echo "  md2html <file>       Markdown to HTML"
        echo "  base64enc <file>     Encode file to Base64"
        echo "  base64dec <file>     Decode Base64 to file"
        echo "  xml2json <file>      XML to JSON (basic)"
        echo "  tsv2csv <file>       TSV to CSV"
        echo "  detect <file>        Detect file format"
        echo "  info                 Version info"
        echo "Powered by BytesAgain | bytesagain.com";;
    json2csv)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: json2csv <file>"; exit 1; }
        python3 << PYEOF
import json, csv, sys, io
with open("$file") as f: data = json.load(f)
if isinstance(data, list) and data:
    keys = list(data[0].keys()) if isinstance(data[0], dict) else ["value"]
    out = io.StringIO()
    w = csv.DictWriter(out, fieldnames=keys)
    w.writeheader()
    for row in data:
        if isinstance(row, dict): w.writerow(row)
        else: w.writerow({"value": row})
    print(out.getvalue())
else:
    print("Expected JSON array of objects")
PYEOF
        ;;
    csv2json)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: csv2json <file>"; exit 1; }
        python3 -c "
import csv, json
with open('$file') as f:
    reader = csv.DictReader(f)
    print(json.dumps(list(reader), indent=2, ensure_ascii=False))
";;
    json2yaml)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: json2yaml <file>"; exit 1; }
        python3 << PYEOF
import json
def to_yaml(obj, indent=0):
    sp = "  " * indent
    if isinstance(obj, dict):
        lines = []
        for k, v in obj.items():
            if isinstance(v, (dict, list)):
                lines.append("{}{}:".format(sp, k))
                lines.append(to_yaml(v, indent+1))
            else:
                lines.append("{}{}: {}".format(sp, k, v))
        return "\n".join(lines)
    elif isinstance(obj, list):
        return "\n".join(["{}{}".format(sp, "- " + (to_yaml(i, 0) if isinstance(i, (dict,list)) else str(i))) for i in obj])
    return str(obj)
with open("$file") as f: data = json.load(f)
print(to_yaml(data))
PYEOF
        ;;
    md2html)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: md2html <file>"; exit 1; }
        python3 << PYEOF
import re
with open("$file") as f: md = f.read()
html = md
html = re.sub(r'^### (.+)$', r'<h3>\1</h3>', html, flags=re.MULTILINE)
html = re.sub(r'^## (.+)$', r'<h2>\1</h2>', html, flags=re.MULTILINE)
html = re.sub(r'^# (.+)$', r'<h1>\1</h1>', html, flags=re.MULTILINE)
html = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', html)
html = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html)
html = re.sub(r'`(.+?)`', r'<code>\1</code>', html)
html = re.sub(r'^\- (.+)$', r'<li>\1</li>', html, flags=re.MULTILINE)
html = re.sub(r'\[(.+?)\]\((.+?)\)', r'<a href="\2">\1</a>', html)
print("<html><body>{}</body></html>".format(html))
PYEOF
        ;;
    base64enc)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: base64enc <file>"; exit 1; }
        base64 "$file";;
    base64dec)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: base64dec <file>"; exit 1; }
        base64 -d "$file";;
    xml2json)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: xml2json <file>"; exit 1; }
        python3 << PYEOF
import re, json
with open("$file") as f: xml = f.read()
# Simple XML to dict
tags = re.findall(r'<(\w+)>(.*?)</\1>', xml, re.DOTALL)
result = {}
for tag, content in tags:
    inner = re.findall(r'<(\w+)>(.*?)</\1>', content)
    if inner:
        result[tag] = {k: v for k, v in inner}
    else:
        result[tag] = content.strip()
print(json.dumps(result, indent=2, ensure_ascii=False))
PYEOF
        ;;
    tsv2csv)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: tsv2csv <file>"; exit 1; }
        sed 's/\t/,/g' "$file";;
    detect)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: detect <file>"; exit 1; }
        file_cmd=$(file "$file" 2>/dev/null || echo "unknown")
        echo "File: $file"
        echo "Type: $file_cmd"
        echo "Size: $(wc -c < "$file") bytes"
        echo "Lines: $(wc -l < "$file")";;
    info) echo "File Converter Pro v1.0.0"; echo "Inspired by: ConvertX (16,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
    *) echo "Unknown: $CMD"; exit 1;;
esac
