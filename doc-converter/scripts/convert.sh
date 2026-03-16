#!/usr/bin/env bash
# doc-converter: Document format converter
# Usage: bash convert.sh <command> [input]

set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$COMMAND" in
  md2html)
    python3 << 'PYEOF'
import re
inp = """{}"""
if not inp.strip():
    inp = "# Hello\n\nThis is **bold** and *italic*.\n\n- Item 1\n- Item 2"
print("=" * 60)
print("  MARKDOWN -> HTML")
print("=" * 60)
print()
text = inp
text = re.sub(r'^### (.+)$', r'<h3>\1</h3>', text, flags=re.MULTILINE)
text = re.sub(r'^## (.+)$', r'<h2>\1</h2>', text, flags=re.MULTILINE)
text = re.sub(r'^# (.+)$', r'<h1>\1</h1>', text, flags=re.MULTILINE)
text = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', text)
text = re.sub(r'\*(.+?)\*', r'<em>\1</em>', text)
text = re.sub(r'`(.+?)`', r'<code>\1</code>', text)
text = re.sub(r'^\- (.+)$', r'<li>\1</li>', text, flags=re.MULTILINE)
text = re.sub(r'\[(.+?)\]\((.+?)\)', r'<a href="\2">\1</a>', text)
lines = text.split('\n')
in_list = False
result = []
for line in lines:
    if '<li>' in line and not in_list:
        result.append('<ul>')
        in_list = True
    elif '<li>' not in line and in_list:
        result.append('</ul>')
        in_list = False
    if line.strip() and '<' not in line:
        result.append('<p>{}</p>'.format(line))
    else:
        result.append(line)
if in_list:
    result.append('</ul>')
print('\n'.join(result))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  html2md)
    python3 << 'PYEOF'
import re
inp = """{}"""
if not inp.strip():
    inp = "<h1>Title</h1><p>Text with <strong>bold</strong></p>"
print("=" * 60)
print("  HTML -> MARKDOWN")
print("=" * 60)
print()
text = inp
text = re.sub(r'<h1>(.*?)</h1>', r'# \1', text)
text = re.sub(r'<h2>(.*?)</h2>', r'## \1', text)
text = re.sub(r'<h3>(.*?)</h3>', r'### \1', text)
text = re.sub(r'<strong>(.*?)</strong>', r'**\1**', text)
text = re.sub(r'<b>(.*?)</b>', r'**\1**', text)
text = re.sub(r'<em>(.*?)</em>', r'*\1*', text)
text = re.sub(r'<i>(.*?)</i>', r'*\1*', text)
text = re.sub(r'<code>(.*?)</code>', r'`\1`', text)
text = re.sub(r'<a href="(.*?)">(.*?)</a>', r'[\2](\1)', text)
text = re.sub(r'<li>(.*?)</li>', r'- \1', text)
text = re.sub(r'<br\s*/?>', '\n', text)
text = re.sub(r'<p>(.*?)</p>', r'\1\n', text)
text = re.sub(r'</?(?:ul|ol|div|span|html|body|head)>', '', text)
text = re.sub(r'<[^>]+>', '', text)
print(text.strip())
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  json2csv)
    python3 << 'PYEOF'
import json, csv, io
inp = """{}"""
if not inp.strip():
    inp = '[{{"name":"Alice","age":30}},{{"name":"Bob","age":25}}]'
print("=" * 60)
print("  JSON -> CSV")
print("=" * 60)
print()
try:
    data = json.loads(inp)
    if isinstance(data, list) and len(data) > 0 and isinstance(data[0], dict):
        headers = list(data[0].keys())
        output = io.StringIO()
        writer = csv.DictWriter(output, fieldnames=headers)
        writer.writeheader()
        for row in data:
            writer.writerow(row)
        print(output.getvalue())
    else:
        print("Error: Input must be a JSON array of objects")
except Exception as e:
    print("Parse error: {}".format(str(e)))
    print("Provide valid JSON array: [{{}}, {{}}]")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  csv2json)
    python3 << 'PYEOF'
import json, csv, io
inp = """{}"""
if not inp.strip():
    inp = "name,age\nAlice,30\nBob,25"
print("=" * 60)
print("  CSV -> JSON")
print("=" * 60)
print()
try:
    reader = csv.DictReader(io.StringIO(inp))
    data = list(reader)
    print(json.dumps(data, indent=2, ensure_ascii=False))
except Exception as e:
    print("Parse error: {}".format(str(e)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  yaml2json)
    python3 << 'PYEOF'
import json, re
inp = """{}"""
if not inp.strip():
    inp = "name: Alice\nage: 30\ncity: Beijing"
print("=" * 60)
print("  YAML -> JSON (simple)")
print("=" * 60)
print()
result = {{}}
for line in inp.strip().split('\n'):
    line = line.strip()
    if ':' in line and not line.startswith('#'):
        key, _, val = line.partition(':')
        key = key.strip()
        val = val.strip()
        if val.lower() == 'true':
            result[key] = True
        elif val.lower() == 'false':
            result[key] = False
        elif val.isdigit():
            result[key] = int(val)
        else:
            try:
                result[key] = float(val)
            except ValueError:
                result[key] = val.strip('"').strip("'")
print(json.dumps(result, indent=2, ensure_ascii=False))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  json2yaml)
    python3 << 'PYEOF'
import json
inp = """{}"""
if not inp.strip():
    inp = '{{"name": "Alice", "age": 30}}'
print("=" * 60)
print("  JSON -> YAML")
print("=" * 60)
print()
def to_yaml(obj, indent=0):
    prefix = "  " * indent
    if isinstance(obj, dict):
        lines = []
        for k, v in obj.items():
            if isinstance(v, (dict, list)):
                lines.append("{}{}:".format(prefix, k))
                lines.append(to_yaml(v, indent + 1))
            else:
                lines.append("{}{}: {}".format(prefix, k, v))
        return '\n'.join(lines)
    elif isinstance(obj, list):
        lines = []
        for item in obj:
            if isinstance(item, (dict, list)):
                lines.append("{}- ".format(prefix))
                lines.append(to_yaml(item, indent + 1))
            else:
                lines.append("{}- {}".format(prefix, item))
        return '\n'.join(lines)
    else:
        return "{}{}".format(prefix, obj)
try:
    data = json.loads(inp)
    print(to_yaml(data))
except Exception as e:
    print("Parse error: {}".format(str(e)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  table)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "Name,Age,City\nAlice,30,Beijing\nBob,25,Shanghai"
print("=" * 60)
print("  TEXT -> MARKDOWN TABLE")
print("=" * 60)
print()
lines = [l for l in inp.strip().split('\n') if l.strip()]
sep = ','
for s in ['\t', '|', ';']:
    if s in inp:
        sep = s
        break
rows = []
for line in lines:
    cells = [c.strip() for c in line.split(sep)]
    rows.append(cells)
if rows:
    max_cols = max(len(r) for r in rows)
    for r in rows:
        while len(r) < max_cols:
            r.append('')
    widths = [max(len(r[i]) for r in rows) for i in range(max_cols)]
    header = '| ' + ' | '.join(rows[0][i].ljust(widths[i]) for i in range(max_cols)) + ' |'
    divider = '|' + '|'.join('-' * (w + 2) for w in widths) + '|'
    print(header)
    print(divider)
    for row in rows[1:]:
        line = '| ' + ' | '.join(row[i].ljust(widths[i]) for i in range(max_cols)) + ' |'
        print(line)
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  clean)
    python3 << 'PYEOF'
import re
inp = """{}"""
if not inp.strip():
    inp = "  Hello   world  \n\n\n  extra   spaces  "
print("=" * 60)
print("  FORMAT CLEANER")
print("=" * 60)
print()
text = inp
text = re.sub(r'[ \t]+', ' ', text)
text = re.sub(r'\n{3,}', '\n\n', text)
text = re.sub(r'[^\S\n]+$', '', text, flags=re.MULTILINE)
text = re.sub(r'^[^\S\n]+', '', text, flags=re.MULTILINE)
text = text.strip()
print(text)
print()
print("Characters: {} -> {}".format(len(inp), len(text)))
print("Reduction: {:.1f}%".format((1 - len(text) / max(len(inp), 1)) * 100))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
========================================
  Doc Converter - Format Transformer
========================================

Commands:
  md2html     Markdown -> HTML
  html2md     HTML -> Markdown
  json2csv    JSON array -> CSV
  csv2json    CSV -> JSON array
  yaml2json   YAML -> JSON
  json2yaml   JSON -> YAML
  table       Text -> Markdown table
  clean       Clean up formatting

Usage:
  bash convert.sh <command> <input>

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
    ;;
esac
