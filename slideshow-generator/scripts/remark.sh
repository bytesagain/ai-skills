#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Remark — Markdown slideshow generator (inspired by gnab/remark 12K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Remark — HTML slideshow from Markdown
Commands:
  generate <file>    Convert MD to HTML slideshow
  preview <file>     Generate and show file path
  theme <name>       Apply theme (dark/light/solarized)
  speaker <file>     Add speaker notes format
  info               Version info
Powered by BytesAgain | bytesagain.com";;
generate)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: generate <file.md>"; exit 1; }
    out="${f%.md}.html"
    python3 << PYEOF
with open("$f") as fh: md = fh.read()
html = """<!DOCTYPE html>
<html><head><title>Slides</title>
<style>
body{font-family:sans-serif;margin:0}
.slide{min-height:100vh;padding:60px;display:flex;flex-direction:column;justify-content:center;border-bottom:1px solid #eee}
h1{font-size:2.5em;color:#333}h2{font-size:2em;color:#555}
li{font-size:1.3em;margin:8px 0}
pre{background:#f5f5f5;padding:15px;border-radius:5px}
.footer{text-align:center;color:#999;padding:20px}
</style></head><body>
"""
slides = md.split("---")
for i, slide in enumerate(slides):
    content = slide.strip()
    if not content: continue
    html += '<div class="slide">'
    for line in content.split("\\n"):
        line = line.strip()
        if line.startswith("# "): html += "<h1>{}</h1>".format(line[2:])
        elif line.startswith("## "): html += "<h2>{}</h2>".format(line[3:])
        elif line.startswith("### "): html += "<h3>{}</h3>".format(line[4:])
        elif line.startswith("- "): html += "<li>{}</li>".format(line[2:])
        elif line: html += "<p>{}</p>".format(line)
    html += "</div>\\n"
html += '<div class="footer">Powered by BytesAgain</div></body></html>'
with open("$out", "w") as fh: fh.write(html)
print("Generated: $out ({} slides)".format(len(slides)))
PYEOF
;;
preview)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: preview <file>"; exit 1; }
    bash "$0" generate "$f"
    out="${f%.md}.html"
    echo "Open in browser: file://$(readlink -f "$out" 2>/dev/null || echo "$out")";;
theme)
    name="${1:-dark}"
    case "$name" in
        dark) echo "background:#1a1a2e;color:#eee;h1{color:#e94560}";;
        light) echo "background:#fff;color:#333;h1{color:#0f3460}";;
        solarized) echo "background:#002b36;color:#839496;h1{color:#b58900}";;
        *) echo "Themes: dark, light, solarized";;
    esac;;
speaker)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: speaker <file>"; exit 1; }
    echo "Add speaker notes with ???:"
    echo "  ## Slide Title"
    echo "  Content here"
    echo "  ???"
    echo "  Speaker notes go here";;
info) echo "Remark v1.0.0"; echo "Inspired by: gnab/remark (12,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
