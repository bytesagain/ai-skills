#!/usr/bin/env bash
# pdf-to-markdown — Convert PDF files to Markdown
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="3.0.1"
DATA_DIR="${PDF_TO_MARKDOWN_DIR:-$HOME/.pdf-to-markdown}"
OUTPUT_DIR="$DATA_DIR/output"
CONFIG_FILE="$DATA_DIR/config.json"
HISTORY_LOG="$DATA_DIR/history.log"
mkdir -p "$OUTPUT_DIR"

# ─── Logging ───────────────────────────────────────────────────────────

_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$HISTORY_LOG"
}

# ─── Config helpers ────────────────────────────────────────────────────

_config_init() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" <<CEOF
{
  "output_dir": "$OUTPUT_DIR",
  "overwrite": "no",
  "fallback": "python"
}
CEOF
    fi
}

_config_get() {
    _config_init
    local key="$1"
    grep "\"$key\"" "$CONFIG_FILE" 2>/dev/null | sed 's/.*: *"\([^"]*\)".*/\1/' || echo ""
}

_config_set() {
    _config_init
    local key="$1" val="$2"
    if grep -q "\"$key\"" "$CONFIG_FILE" 2>/dev/null; then
        sed -i "s|\"$key\": *\"[^\"]*\"|\"$key\": \"$val\"|" "$CONFIG_FILE"
        echo "  Set $key = $val"
    else
        echo "  Unknown key: $key"
        echo "  Valid keys: output_dir, overwrite, fallback"
        return 1
    fi
    _log "config: set $key=$val"
}

_get_output_dir() {
    local dir
    dir="$(_config_get output_dir)"
    if [ -z "$dir" ]; then
        dir="$OUTPUT_DIR"
    fi
    # Expand ~ if present
    dir="${dir/#\~/$HOME}"
    mkdir -p "$dir"
    echo "$dir"
}

# ─── PDF text extraction ──────────────────────────────────────────────

_check_pdf() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "  Error: file not found: $file" >&2
        return 1
    fi
    if [[ ! "$file" =~ \.[Pp][Dd][Ff]$ ]]; then
        echo "  Warning: $file does not have a .pdf extension" >&2
    fi
}

_extract_with_pdftotext() {
    local file="$1"
    local layout="${2:-}" # pass "-layout" for table mode
    if [ -n "$layout" ]; then
        pdftotext -layout "$file" -
    else
        pdftotext "$file" -
    fi
}

_extract_with_python() {
    local file="$1"
    python3 <<PYEOF
import sys
text = ""

# Try PyPDF2 first
try:
    from PyPDF2 import PdfReader
    reader = PdfReader("$file")
    for page in reader.pages:
        t = page.extract_text()
        if t:
            text += t + "\n\n"
    if text.strip():
        print(text)
        sys.exit(0)
except ImportError:
    pass
except Exception as e:
    print(f"  PyPDF2 error: {e}", file=sys.stderr)

# Try pdfminer.six
try:
    from pdfminer.high_level import extract_text as pdfminer_extract
    text = pdfminer_extract("$file")
    if text.strip():
        print(text)
        sys.exit(0)
except ImportError:
    pass
except Exception as e:
    print(f"  pdfminer error: {e}", file=sys.stderr)

# Basic fallback: try to read raw text streams from PDF
try:
    import re
    with open("$file", "rb") as f:
        raw = f.read()
    # Find text between BT and ET markers
    chunks = re.findall(rb'\(([^)]+)\)', raw)
    decoded = []
    for c in chunks:
        try:
            decoded.append(c.decode('utf-8', errors='ignore'))
        except Exception:
            pass
    result = " ".join(decoded)
    if len(result) > 20:
        print(result)
        sys.exit(0)
except Exception:
    pass

print("  Error: could not extract text. Install PyPDF2: pip3 install PyPDF2", file=sys.stderr)
sys.exit(1)
PYEOF
}

_extract_text() {
    local file="$1"
    local mode="${2:-}"  # "layout" for table mode, empty for normal
    _check_pdf "$file" || return 1

    if command -v pdftotext &>/dev/null; then
        if [ "$mode" = "layout" ]; then
            _extract_with_pdftotext "$file" "-layout"
        else
            _extract_with_pdftotext "$file"
        fi
        return $?
    fi

    local fallback
    fallback="$(_config_get fallback)"
    if [ "$fallback" = "none" ]; then
        echo "  Error: pdftotext not found and fallback is disabled" >&2
        echo "  Install poppler-utils: apt install poppler-utils (or brew install poppler)" >&2
        return 1
    fi

    if command -v python3 &>/dev/null; then
        _extract_with_python "$file"
        return $?
    fi

    echo "  Error: neither pdftotext nor python3 found" >&2
    echo "  Install poppler-utils: apt install poppler-utils" >&2
    echo "  Or install Python 3 with PyPDF2: pip3 install PyPDF2" >&2
    return 1
}

# ─── Markdown formatting ──────────────────────────────────────────────

_text_to_markdown() {
    # Read text from stdin, apply Markdown heuristics
    python3 <<'PYEOF'
import sys
import re

lines = sys.stdin.read().split("\n")
output = []
prev_blank = True

for i, line in enumerate(lines):
    stripped = line.strip()

    # Skip empty lines but preserve paragraph breaks
    if not stripped:
        if not prev_blank:
            output.append("")
            prev_blank = True
        continue

    prev_blank = False

    # Detect headings: ALL-CAPS short lines (likely titles)
    if stripped.isupper() and len(stripped) < 80 and len(stripped.split()) <= 10:
        # Check if it looks like a chapter/section
        if len(stripped.split()) <= 4:
            output.append(f"# {stripped.title()}")
        else:
            output.append(f"## {stripped.title()}")
        continue

    # Detect numbered headings: "1. Something" or "1.2 Something" at start
    num_heading = re.match(r'^(\d+\.[\d.]*)\s+([A-Z].*)', stripped)
    if num_heading and len(stripped) < 80 and len(stripped.split()) <= 12:
        depth = num_heading.group(1).count(".")
        prefix = "#" * min(depth + 1, 4)
        output.append(f"{prefix} {stripped}")
        continue

    # Detect bullet-like lines
    if re.match(r'^[•·▪●◦‣–—-]\s+', stripped):
        cleaned = re.sub(r'^[•·▪●◦‣–—-]\s+', '', stripped)
        output.append(f"- {cleaned}")
        continue

    # Detect numbered list items: "1) text" or "a) text"
    if re.match(r'^[a-zA-Z0-9]+[)]\s+', stripped):
        output.append(f"- {stripped}")
        continue

    # Regular paragraph line
    output.append(stripped)

print("\n".join(output))
PYEOF
}

# ─── PDF metadata ─────────────────────────────────────────────────────

_get_page_count() {
    local file="$1"
    if command -v pdfinfo &>/dev/null; then
        pdfinfo "$file" 2>/dev/null | grep "^Pages:" | awk '{print $2}'
        return
    fi
    if command -v python3 &>/dev/null; then
        python3 <<PYEOF
try:
    from PyPDF2 import PdfReader
    r = PdfReader("$file")
    print(len(r.pages))
except Exception:
    # Fallback: count /Type /Page occurrences
    import re
    with open("$file", "rb") as f:
        data = f.read()
    count = len(re.findall(rb'/Type\s*/Page[^s]', data))
    print(count if count > 0 else "?")
PYEOF
        return
    fi
    echo "?"
}

_get_file_size() {
    local file="$1"
    local bytes
    bytes=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
    if [ "$bytes" -ge 1048576 ]; then
        echo "$(( bytes / 1048576 )).$(( (bytes % 1048576) * 10 / 1048576 )) MB"
    elif [ "$bytes" -ge 1024 ]; then
        echo "$(( bytes / 1024 )) KB"
    else
        echo "$bytes bytes"
    fi
}

# ─── Commands ──────────────────────────────────────────────────────────

cmd_convert() {
    local file="$1"
    _check_pdf "$file" || return 1

    local base
    base="$(basename "$file" .pdf)"
    base="$(echo "$base" | sed 's/\.[Pp][Dd][Ff]$//')"
    local out_dir
    out_dir="$(_get_output_dir)"
    local out_file="$out_dir/${base}.md"

    local overwrite
    overwrite="$(_config_get overwrite)"
    if [ -f "$out_file" ] && [ "$overwrite" != "yes" ]; then
        echo "  Skipped: $out_file already exists (set overwrite=yes to replace)"
        return 0
    fi

    local pages
    pages="$(_get_page_count "$file")"

    local raw_text
    raw_text="$(_extract_text "$file")" || return 1

    if [ -z "$raw_text" ]; then
        echo "  Error: no text extracted from $file" >&2
        return 1
    fi

    echo "$raw_text" | _text_to_markdown > "$out_file"

    echo "  Converted: $(basename "$file") → $out_file ($pages pages)"
    _log "convert: $file → $out_file ($pages pages)"
}

cmd_batch() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        echo "  Error: directory not found: $dir" >&2
        return 1
    fi

    local total=0 ok=0 fail=0 skip=0
    local out_dir
    out_dir="$(_get_output_dir)"
    local overwrite
    overwrite="$(_config_get overwrite)"

    while IFS= read -r -d '' pdf; do
        total=$((total + 1))
        local base
        base="$(basename "$pdf" .pdf)"
        local out_file="$out_dir/${base}.md"

        if [ -f "$out_file" ] && [ "$overwrite" != "yes" ]; then
            skip=$((skip + 1))
            continue
        fi

        if cmd_convert "$pdf" >/dev/null 2>&1; then
            ok=$((ok + 1))
        else
            fail=$((fail + 1))
            echo "  Failed: $pdf" >&2
        fi
    done < <(find "$dir" -maxdepth 1 -iname "*.pdf" -print0 | sort -z)

    if [ "$total" -eq 0 ]; then
        echo "  No PDF files found in $dir"
        return 0
    fi

    local msg="  Converted $ok/$total files"
    if [ "$skip" -gt 0 ]; then
        msg="$msg ($skip skipped — already exist)"
    fi
    if [ "$fail" -gt 0 ]; then
        msg="$msg ($fail failed)"
    fi
    echo "$msg"
    _log "batch: $dir — $ok/$total converted, $skip skipped, $fail failed"
}

cmd_extract() {
    local file="$1"
    _extract_text "$file"
    _log "extract: $file"
}

cmd_headers() {
    local file="$1"
    _check_pdf "$file" || return 1

    local raw_text
    raw_text="$(_extract_text "$file")" || return 1

    # Filter for lines that look like headings
    echo "$raw_text" | python3 <<'PYEOF'
import sys
import re

for line in sys.stdin:
    stripped = line.strip()
    if not stripped:
        continue

    # ALL-CAPS short lines
    if stripped.isupper() and len(stripped) < 80 and len(stripped.split()) <= 10:
        if len(stripped.split()) <= 4:
            print(f"# {stripped.title()}")
        else:
            print(f"## {stripped.title()}")
        continue

    # Numbered headings
    m = re.match(r'^(\d+\.[\d.]*)\s+([A-Z].*)', stripped)
    if m and len(stripped) < 80 and len(stripped.split()) <= 12:
        depth = m.group(1).count(".")
        prefix = "#" * min(depth + 1, 4)
        print(f"{prefix} {stripped}")
        continue
PYEOF
    _log "headers: $file"
}

cmd_table() {
    local file="$1"
    _check_pdf "$file" || return 1

    local raw_text
    raw_text="$(_extract_text "$file" "layout")" || return 1

    echo "$raw_text" | python3 <<'PYEOF'
import sys
import re

lines = sys.stdin.read().split("\n")
tables_found = 0

# Detect table regions: lines with multiple whitespace-separated columns
# aligned vertically
i = 0
while i < len(lines):
    line = lines[i]
    # Look for lines with 2+ groups of text separated by 2+ spaces
    parts = re.split(r'\s{2,}', line.strip())
    if len(parts) >= 2 and len(line.strip()) > 5:
        # Potential table row — collect consecutive similar lines
        table_lines = []
        j = i
        while j < len(lines):
            row = lines[j].strip()
            if not row:
                # Allow one blank line inside table
                if j + 1 < len(lines) and re.split(r'\s{2,}', lines[j+1].strip()):
                    j += 1
                    continue
                break
            row_parts = re.split(r'\s{2,}', row)
            if len(row_parts) < 2:
                break
            table_lines.append(row_parts)
            j += 1

        if len(table_lines) >= 2:
            tables_found += 1
            # Determine max columns
            max_cols = max(len(r) for r in table_lines)
            # Normalize rows to same column count
            for row in table_lines:
                while len(row) < max_cols:
                    row.append("")

            # Calculate column widths
            widths = [0] * max_cols
            for row in table_lines:
                for ci, cell in enumerate(row):
                    widths[ci] = max(widths[ci], len(cell))

            # Print header
            header = table_lines[0]
            print("| " + " | ".join(cell.ljust(widths[ci]) for ci, cell in enumerate(header)) + " |")
            print("|" + "|".join("-" * (w + 2) for w in widths) + "|")
            # Print data rows
            for row in table_lines[1:]:
                print("| " + " | ".join(cell.ljust(widths[ci]) for ci, cell in enumerate(row)) + " |")
            print()

        i = j
    else:
        i += 1

if tables_found == 0:
    print("  No tables detected in this PDF")
PYEOF
    _log "table: $file"
}

cmd_info() {
    local file="$1"
    _check_pdf "$file" || return 1

    local pages size
    pages="$(_get_page_count "$file")"
    size="$(_get_file_size "$file")"

    echo "  File: $(basename "$file")"
    echo "  Pages: $pages"
    echo "  Size: $size"

    # Try to get metadata
    if command -v pdfinfo &>/dev/null; then
        local title author creator created
        title="$(pdfinfo "$file" 2>/dev/null | grep "^Title:" | sed 's/^Title: *//')"
        author="$(pdfinfo "$file" 2>/dev/null | grep "^Author:" | sed 's/^Author: *//')"
        creator="$(pdfinfo "$file" 2>/dev/null | grep "^Creator:" | sed 's/^Creator: *//')"
        created="$(pdfinfo "$file" 2>/dev/null | grep "^CreationDate:" | sed 's/^CreationDate: *//')"
        [ -n "$title" ] && echo "  Title: $title"
        [ -n "$author" ] && echo "  Author: $author"
        [ -n "$creator" ] && echo "  Creator: $creator"
        [ -n "$created" ] && echo "  Created: $created"
    elif command -v python3 &>/dev/null; then
        python3 <<PYEOF
try:
    from PyPDF2 import PdfReader
    r = PdfReader("$file")
    meta = r.metadata
    if meta:
        if meta.title: print(f"  Title: {meta.title}")
        if meta.author: print(f"  Author: {meta.author}")
        if meta.creator: print(f"  Creator: {meta.creator}")
        if meta.creation_date: print(f"  Created: {meta.creation_date}")
except Exception:
    pass
PYEOF
    fi
    _log "info: $file"
}

cmd_list() {
    local out_dir
    out_dir="$(_get_output_dir)"

    if [ ! -d "$out_dir" ] || [ -z "$(ls -A "$out_dir" 2>/dev/null)" ]; then
        echo "  No converted files yet"
        return 0
    fi

    while IFS= read -r -d '' f; do
        local name modified
        name="$(basename "$f")"
        modified="$(date -r "$f" '+%Y-%m-%d' 2>/dev/null || stat -c '%y' "$f" 2>/dev/null | cut -d' ' -f1 || echo "?")"
        printf "  %-30s %s\n" "$name" "$modified"
    done < <(find "$out_dir" -maxdepth 1 -name "*.md" -print0 | sort -z)
    _log "list"
}

cmd_export() {
    local format="${1:-md}"
    local out_dir
    out_dir="$(_get_output_dir)"

    # Find the most recently modified file
    local latest
    latest="$(find "$out_dir" -maxdepth 1 -name "*.md" -printf '%T+ %p\n' 2>/dev/null | sort -r | head -1 | cut -d' ' -f2-)"

    if [ -z "$latest" ]; then
        echo "  No converted files to export"
        return 1
    fi

    local base
    base="$(basename "$latest" .md)"

    case "$format" in
        md)
            cat "$latest"
            ;;
        txt)
            # Strip Markdown formatting
            sed 's/^#\+ //; s/\*\*//g; s/\*//g; s/`//g; s/^- /  /; s/|//g' "$latest"
            ;;
        json)
            local json_out="$out_dir/${base}.json"
            local content
            content="$(cat "$latest")"
            python3 <<PYEOF
import json
content = open("$latest").read()
data = {
    "source": "$base.pdf",
    "format": "markdown",
    "content": content,
    "exported": __import__("datetime").datetime.now().isoformat()
}
with open("$json_out", "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print(f"  Exported: $json_out")
PYEOF
            ;;
        *)
            echo "  Unknown format: $format"
            echo "  Supported: md, txt, json"
            return 1
            ;;
    esac
    _log "export: $base → $format"
}

cmd_config() {
    _config_init
    if [ $# -eq 0 ]; then
        # Show current config
        echo "  Configuration ($CONFIG_FILE):"
        while IFS= read -r line; do
            # Print key-value pairs
            if echo "$line" | grep -q '": "'; then
                local key val
                key="$(echo "$line" | sed 's/.*"\([^"]*\)": ".*/\1/')"
                val="$(echo "$line" | sed 's/.*": "\([^"]*\)".*/\1/')"
                printf "    %-12s %s\n" "$key:" "$val"
            fi
        done < "$CONFIG_FILE"
        return
    fi
    if [ $# -eq 1 ]; then
        # Show single key
        local val
        val="$(_config_get "$1")"
        if [ -n "$val" ]; then
            echo "  $1: $val"
        else
            echo "  Unknown key: $1"
        fi
        return
    fi
    _config_set "$1" "$2"
}

show_help() {
    cat <<EOF
pdf-to-markdown v$VERSION
Convert PDF files to Markdown

Usage: pdf-to-markdown <command> [args]

Commands:
  convert <file.pdf>    Convert a PDF to Markdown
  batch <dir>           Batch convert all PDFs in a directory
  extract <file.pdf>    Extract plain text (no Markdown formatting)
  headers <file.pdf>    Extract headings/section structure only
  table <file.pdf>      Extract tables as Markdown tables
  info <file.pdf>       Show PDF metadata (pages, size, author)
  list                  List previously converted files
  export <format>       Export latest result (md/txt/json)
  config [key] [value]  View or update configuration
  help                  Show this help
  version               Show version

Data directory: $DATA_DIR
Output directory: $OUTPUT_DIR

Requires: pdftotext (poppler-utils) or Python 3 as fallback
EOF
}

# ─── Main dispatch ─────────────────────────────────────────────────────

cmd="${1:-help}"
shift || true

case "$cmd" in
    convert)  [[ $# -lt 1 ]] && { echo "  Usage: pdf-to-markdown convert <file.pdf>"; exit 1; }; cmd_convert "$1" ;;
    batch)    [[ $# -lt 1 ]] && { echo "  Usage: pdf-to-markdown batch <dir>"; exit 1; }; cmd_batch "$1" ;;
    extract)  [[ $# -lt 1 ]] && { echo "  Usage: pdf-to-markdown extract <file.pdf>"; exit 1; }; cmd_extract "$1" ;;
    headers)  [[ $# -lt 1 ]] && { echo "  Usage: pdf-to-markdown headers <file.pdf>"; exit 1; }; cmd_headers "$1" ;;
    table)    [[ $# -lt 1 ]] && { echo "  Usage: pdf-to-markdown table <file.pdf>"; exit 1; }; cmd_table "$1" ;;
    info)     [[ $# -lt 1 ]] && { echo "  Usage: pdf-to-markdown info <file.pdf>"; exit 1; }; cmd_info "$1" ;;
    list)     cmd_list ;;
    export)   cmd_export "${1:-md}" ;;
    config)   cmd_config "$@" ;;
    help|-h)  show_help ;;
    version|-v) echo "pdf-to-markdown v$VERSION" ;;
    *)        echo "  Unknown command: $cmd"; show_help; exit 1 ;;
esac
