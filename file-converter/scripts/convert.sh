#!/usr/bin/env bash
# File Converter — Powered by BytesAgain
set -euo pipefail

COMMAND="${1:-help}"
INPUT="${2:-}"
BRAND="Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"

case "$COMMAND" in

detect)
  [ -z "$INPUT" ] && echo "Usage: convert.sh detect <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, os, json

fpath = sys.argv[1]
if not os.path.isfile(fpath):
    print("Error: file not found: {}".format(fpath))
    sys.exit(1)

with open(fpath, "r") as f:
    content = f.read(2048)

detected = "unknown"
stripped = content.strip()
if stripped.startswith("{") or stripped.startswith("["):
    try:
        json.loads(content)
        detected = "JSON"
    except:
        detected = "possibly JSON (parse error)"
elif stripped.startswith("<?xml") or (stripped.startswith("<") and ">" in stripped):
    detected = "XML"
elif stripped.startswith("---"):
    detected = "YAML (frontmatter)"
elif ":" in stripped.split("\n")[0] and not stripped.startswith("{"):
    detected = "YAML"
elif "," in stripped.split("\n")[0] and "\n" in stripped:
    detected = "CSV"
elif "|" in stripped.split("\n")[0] and "---" in stripped:
    detected = "Markdown table"
else:
    ext = os.path.splitext(fpath)[1].lower()
    ext_map = {".json": "JSON", ".yaml": "YAML", ".yml": "YAML", ".xml": "XML",
               ".csv": "CSV", ".md": "Markdown", ".js": "JavaScript", ".css": "CSS"}
    detected = ext_map.get(ext, "unknown (ext: {})".format(ext))

print("=" * 50)
print("  File Format Detection")
print("=" * 50)
print("  File:   {}".format(os.path.basename(fpath)))
print("  Size:   {} bytes".format(os.path.getsize(fpath)))
print("  Format: {}".format(detected))
print("=" * 50)
PYEOF
  echo "$BRAND"
  ;;

json2yaml)
  [ -z "$INPUT" ] && echo "Usage: convert.sh json2yaml <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, json

fpath = sys.argv[1]
if fpath == "-":
    data = json.load(sys.stdin)
else:
    with open(fpath, "r") as f:
        data = json.load(f)

def to_yaml(obj, indent=0):
    prefix = "  " * indent
    if isinstance(obj, dict):
        if not obj:
            print("{}{{}}".format(prefix))
            return
        for k, v in obj.items():
            if isinstance(v, (dict, list)):
                print("{}{}:".format(prefix, k))
                to_yaml(v, indent + 1)
            else:
                val = "true" if v is True else "false" if v is False else "null" if v is None else '"{}"'.format(v) if isinstance(v, str) else str(v)
                print("{}{}: {}".format(prefix, k, val))
    elif isinstance(obj, list):
        if not obj:
            print("{}[]".format(prefix))
            return
        for item in obj:
            if isinstance(item, (dict, list)):
                print("{}-".format(prefix))
                to_yaml(item, indent + 1)
            else:
                val = "true" if item is True else "false" if item is False else "null" if item is None else '"{}"'.format(item) if isinstance(item, str) else str(item)
                print("{}- {}".format(prefix, val))
    else:
        print("{}{}".format(prefix, obj))

to_yaml(data)
PYEOF
  echo "# $BRAND"
  ;;

yaml2json)
  [ -z "$INPUT" ] && echo "Usage: convert.sh yaml2json <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, json

fpath = sys.argv[1]

def parse_simple_yaml(text):
    result = {}
    for line in text.strip().split("\n"):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            key, _, val = line.partition(":")
            key = key.strip()
            val = val.strip()
            if val == "" or val == "~" or val == "null":
                result[key] = None
            elif val.lower() == "true":
                result[key] = True
            elif val.lower() == "false":
                result[key] = False
            elif val.startswith('"') and val.endswith('"'):
                result[key] = val[1:-1]
            elif val.startswith("'") and val.endswith("'"):
                result[key] = val[1:-1]
            else:
                try:
                    result[key] = int(val)
                except ValueError:
                    try:
                        result[key] = float(val)
                    except ValueError:
                        result[key] = val
    return result

if fpath == "-":
    content = sys.stdin.read()
else:
    with open(fpath, "r") as f:
        content = f.read()

try:
    import yaml
    data = yaml.safe_load(content)
except ImportError:
    data = parse_simple_yaml(content)

print(json.dumps(data, indent=2, ensure_ascii=False))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

csv2md)
  [ -z "$INPUT" ] && echo "Usage: convert.sh csv2md <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, csv

fpath = sys.argv[1]
if fpath == "-":
    reader = csv.reader(sys.stdin)
else:
    reader = csv.reader(open(fpath, "r"))

rows = list(reader)
if not rows:
    print("(empty CSV)")
    sys.exit(0)

widths = [0] * len(rows[0])
for row in rows:
    for i, cell in enumerate(row):
        if i < len(widths):
            widths[i] = max(widths[i], len(cell))

def fmt_row(row):
    cells = []
    for i, cell in enumerate(row):
        w = widths[i] if i < len(widths) else len(cell)
        cells.append(cell.ljust(w))
    return "| {} |".format(" | ".join(cells))

print(fmt_row(rows[0]))
print("| {} |".format(" | ".join("-" * w for w in widths)))
for row in rows[1:]:
    print(fmt_row(row))
PYEOF
  echo ""
  echo "<!-- $BRAND -->"
  ;;

md2csv)
  [ -z "$INPUT" ] && echo "Usage: convert.sh md2csv <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, re

fpath = sys.argv[1]
if fpath == "-":
    content = sys.stdin.read()
else:
    with open(fpath, "r") as f:
        content = f.read()

for line in content.strip().split("\n"):
    line = line.strip()
    if not line.startswith("|"):
        continue
    if re.match(r"^\|[\s\-:|]+\|$", line):
        continue
    cells = [c.strip() for c in line.split("|")[1:-1]]
    escaped = []
    for c in cells:
        if "," in c or '"' in c:
            escaped.append('"{}"'.format(c.replace('"', '""')))
        else:
            escaped.append(c)
    print(",".join(escaped))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

xml2json)
  [ -z "$INPUT" ] && echo "Usage: convert.sh xml2json <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, json
from xml.etree import ElementTree as ET

fpath = sys.argv[1]
if fpath == "-":
    tree = ET.parse(sys.stdin)
else:
    tree = ET.parse(fpath)

def elem_to_dict(elem):
    result = {}
    if elem.attrib:
        for k, v in elem.attrib.items():
            result["@{}".format(k)] = v
    if elem.text and elem.text.strip():
        if not list(elem) and not elem.attrib:
            return elem.text.strip()
        result["#text"] = elem.text.strip()
    for child in elem:
        child_data = elem_to_dict(child)
        tag = child.tag
        if tag in result:
            if not isinstance(result[tag], list):
                result[tag] = [result[tag]]
            result[tag].append(child_data)
        else:
            result[tag] = child_data
    return result

root = tree.getroot()
output = {root.tag: elem_to_dict(root)}
print(json.dumps(output, indent=2, ensure_ascii=False))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

json2xml)
  [ -z "$INPUT" ] && echo "Usage: convert.sh json2xml <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, json

fpath = sys.argv[1]
if fpath == "-":
    data = json.load(sys.stdin)
else:
    with open(fpath, "r") as f:
        data = json.load(f)

def to_xml(obj, tag="root", indent=0):
    prefix = "  " * indent
    if isinstance(obj, dict):
        attrs = ""
        children = []
        for k, v in obj.items():
            if k.startswith("@"):
                attrs += ' {}="{}"'.format(k[1:], v)
            elif k == "#text":
                children.append(("_text_", v))
            else:
                children.append((k, v))
        print("{}<{}{}>".format(prefix, tag, attrs))
        for k, v in children:
            if k == "_text_":
                print("{}  {}".format(prefix, v))
            elif isinstance(v, list):
                for item in v:
                    to_xml(item, k, indent + 1)
            else:
                to_xml(v, k, indent + 1)
        print("{}</{}>".format(prefix, tag))
    elif isinstance(obj, list):
        for item in obj:
            to_xml(item, "item", indent)
    else:
        val = "" if obj is None else str(obj)
        print("{}<{}>{}</{}>".format(prefix, tag, val, tag))

print('<?xml version="1.0" encoding="UTF-8"?>')
if isinstance(data, dict) and len(data) == 1:
    key = list(data.keys())[0]
    to_xml(data[key], key)
else:
    to_xml(data)
PYEOF
  echo ""
  echo "<!-- $BRAND -->"
  ;;

minify)
  [ -z "$INPUT" ] && echo "Usage: convert.sh minify <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, json, re, os

fpath = sys.argv[1]
with open(fpath, "r") as f:
    content = f.read()

ext = os.path.splitext(fpath)[1].lower()
original_size = len(content)

if ext == ".json":
    data = json.loads(content)
    result = json.dumps(data, separators=(",", ":"), ensure_ascii=False)
elif ext in (".css",):
    result = re.sub(r"/\*.*?\*/", "", content, flags=re.DOTALL)
    result = re.sub(r"\s+", " ", result)
    result = re.sub(r"\s*([{}:;,])\s*", r"\1", result)
    result = result.strip()
elif ext in (".js",):
    result = re.sub(r"//.*?$", "", content, flags=re.MULTILINE)
    result = re.sub(r"/\*.*?\*/", "", result, flags=re.DOTALL)
    result = re.sub(r"\n\s*\n", "\n", result)
    result = result.strip()
else:
    try:
        data = json.loads(content)
        result = json.dumps(data, separators=(",", ":"), ensure_ascii=False)
    except:
        result = re.sub(r"\s+", " ", content).strip()

new_size = len(result)
ratio = (1 - new_size / original_size) * 100 if original_size > 0 else 0

print(result)
sys.stderr.write("\n--- Minify Result ---\n")
sys.stderr.write("Original: {} bytes\n".format(original_size))
sys.stderr.write("Minified: {} bytes\n".format(new_size))
sys.stderr.write("Saved:    {:.1f}%\n".format(ratio))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

prettify)
  [ -z "$INPUT" ] && echo "Usage: convert.sh prettify <file>" && exit 1
  python3 - "$INPUT" << 'PYEOF'
import sys, json, os

fpath = sys.argv[1]
with open(fpath, "r") as f:
    content = f.read()

ext = os.path.splitext(fpath)[1].lower()

if ext == ".json" or content.strip().startswith("{") or content.strip().startswith("["):
    try:
        data = json.loads(content)
        print(json.dumps(data, indent=2, ensure_ascii=False))
    except:
        print(content)
else:
    lines = content.split("\n")
    indent_level = 0
    for line in lines:
        stripped = line.strip()
        if not stripped:
            print("")
            continue
        if stripped.startswith("}") or stripped.startswith("]") or stripped.startswith("</"):
            indent_level = max(0, indent_level - 1)
        print("{}{}".format("  " * indent_level, stripped))
        if stripped.endswith("{") or stripped.endswith("[") or (stripped.startswith("<") and not stripped.startswith("</") and not stripped.endswith("/>")):
            indent_level += 1
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

help|*)
  cat << 'HELPEOF'
╔══════════════════════════════════════════════════╗
║         🔄 File Converter                        ║
╠══════════════════════════════════════════════════╣
║  detect   <file>  — Detect file format           ║
║  json2yaml <file> — JSON → YAML                  ║
║  yaml2json <file> — YAML → JSON                  ║
║  csv2md   <file>  — CSV → Markdown table          ║
║  md2csv   <file>  — Markdown table → CSV          ║
║  xml2json <file>  — XML → JSON                    ║
║  json2xml <file>  — JSON → XML                    ║
║  minify   <file>  — Compress JSON/CSS/JS          ║
║  prettify <file>  — Beautify code                 ║
╚══════════════════════════════════════════════════╝
HELPEOF
  echo "$BRAND"
  ;;

esac
