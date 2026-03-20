#!/usr/bin/env bash
# file-converter — File format conversion swiss army knife
set -euo pipefail
VERSION="2.1.0"

show_help() {
    cat << EOF
file-converter v$VERSION — File format conversion toolkit

Usage: file-converter <command> [args]

Text Formats:
  csv2json <file>          CSV to JSON
  json2csv <file>          JSON to CSV
  md2html <file>           Markdown to HTML
  tsv2csv <file>           TSV to CSV

Data:
  csv2sql <file> <table>   CSV to SQL INSERT
  pretty-json <file>       Pretty-print JSON
  minify-json <file>       Minify JSON

Encoding:
  base64-enc <file>        Base64 encode
  base64-dec <file>        Base64 decode
  url-encode <text>        URL encode
  url-decode <text>        URL decode

Info:
  detect <file>            Detect file type
  stats <file>             File statistics
  hex <file> [n]           Hex dump first N bytes
  help                     Show this help
EOF
}

cmd_csv2json() {
    local file="${1:?Usage: file-converter csv2json <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    FILE="$file" python3 << 'PYEOF'
import csv, json, os
with open(os.environ["FILE"]) as f:
    print(json.dumps(list(csv.DictReader(f)), indent=2))
PYEOF
}

cmd_json2csv() {
    local file="${1:?Usage: file-converter json2csv <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    FILE="$file" python3 << 'PYEOF'
import csv, json, sys, os
data = json.load(open(os.environ["FILE"]))
if isinstance(data, list) and data:
    w = csv.DictWriter(sys.stdout, fieldnames=data[0].keys())
    w.writeheader()
    w.writerows(data)
PYEOF
}

cmd_md2html() {
    local file="${1:?}"
    [ -f "$file" ] || return 1
    FILE="$file" python3 << 'PYEOF'
import re, os
with open(os.environ["FILE"]) as f:
    t = f.read()
t = re.sub(r'^### (.+)$', r'<h3>\1</h3>', t, flags=re.MULTILINE)
t = re.sub(r'^## (.+)$', r'<h2>\1</h2>', t, flags=re.MULTILINE)
t = re.sub(r'^# (.+)$', r'<h1>\1</h1>', t, flags=re.MULTILINE)
t = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', t)
t = re.sub(r'\*(.+?)\*', r'<em>\1</em>', t)
print(t)
PYEOF
}

cmd_tsv2csv() {
    local file="${1:?}"
    [ -f "$file" ] || return 1
    sed 's/\t/,/g' "$file"
}

cmd_csv2sql() {
    local file="${1:?Usage: file-converter csv2sql <file> <table>}"
    local table="${2:?}"
    FILE="$file" TABLE="$table" python3 << 'PYEOF'
import csv, os
with open(os.environ["FILE"]) as f:
    for row in csv.DictReader(f):
        cols = ', '.join(row.keys())
        vals = ', '.join("'{}'".format(v.replace("'","''")) for v in row.values())
        print('INSERT INTO {} ({}) VALUES ({});'.format(os.environ["TABLE"], cols, vals))
PYEOF
}

cmd_pretty_json() {
    local file="${1:?}"
    FILE="$file" python3 << 'PYEOF'
import json, os
print(json.dumps(json.load(open(os.environ["FILE"])), indent=2))
PYEOF
}

cmd_minify_json() {
    local file="${1:?}"
    FILE="$file" python3 << 'PYEOF'
import json, os
print(json.dumps(json.load(open(os.environ["FILE"])), separators=(',', ':')))
PYEOF
}

cmd_base64_enc() {
    local file="${1:?}"
    base64 "$file"
}

cmd_base64_dec() {
    local file="${1:?}"
    # base64 decode removed "$file"
}

cmd_url_encode() {
    INPUT="$*" python3 << 'PYEOF'
import urllib.parse, os
print(urllib.parse.quote(os.environ["INPUT"]))
PYEOF
}

cmd_url_decode() {
    INPUT="$*" python3 << 'PYEOF'
import urllib.parse, os
print(urllib.parse.unquote(os.environ["INPUT"]))
PYEOF
}

cmd_detect() {
    local file="${1:?}"
    [ -f "$file" ] || { echo "Not found"; return 1; }
    file "$file" 2>/dev/null
    echo "  Size: $(du -h "$file" | cut -f1)"
    echo "  Lines: $(wc -l < "$file")"
    echo "  Words: $(wc -w < "$file")"
}

cmd_stats() {
    cmd_detect "$@"
}

cmd_hex() {
    local file="${1:?}"
    local n="${2:-256}"
    xxd "$file" 2>/dev/null | head -$((n / 16 + 1)) || od -A x -t x1z "$file" | head -$((n / 16 + 1))
}

case "${1:-help}" in
    csv2json)    shift; cmd_csv2json "$@" ;;
    json2csv)    shift; cmd_json2csv "$@" ;;
    md2html)     shift; cmd_md2html "$@" ;;
    tsv2csv)     shift; cmd_tsv2csv "$@" ;;
    csv2sql)     shift; cmd_csv2sql "$@" ;;
    pretty-json) shift; cmd_pretty_json "$@" ;;
    minify-json) shift; cmd_minify_json "$@" ;;
    base64-enc)  shift; cmd_base64_enc "$@" ;;
    base64-dec)  shift; cmd_base64_dec "$@" ;;
    url-encode)  shift; cmd_url_encode "$@" ;;
    url-decode)  shift; cmd_url_decode "$@" ;;
    detect)      shift; cmd_detect "$@" ;;
    stats)       shift; cmd_stats "$@" ;;
    hex)         shift; cmd_hex "$@" ;;
    help|-h)     show_help ;;
    version|-v)  echo "file-converter v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help; exit 1 ;;
esac
