#!/usr/bin/env bash
# ============================================================================
# JSONLint — JSON Linter & Toolkit
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================================
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="jsonlint"

# --- Colors ----------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Helpers ---------------------------------------------------------------
info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✖${NC} $*" >&2; }
die()     { error "$@"; exit 1; }

need_file() {
    [[ -z "${1:-}" ]] && die "Missing required argument: <file>"
    [[ -f "$1" ]]     || die "File not found: $1"
}

need_python3() {
    command -v python3 &>/dev/null || die "python3 is required but not found"
}

# --- Usage -----------------------------------------------------------------
usage() {
    cat <<EOF
${BOLD}JSONLint v${VERSION}${NC} — JSON Linter & Toolkit
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  ${SCRIPT_NAME} <command> [arguments]

${BOLD}Commands:${NC}
  validate <file>            Validate JSON syntax
  format   <file>            Pretty-print JSON (4-space indent)
  minify   <file>            Compact JSON (remove whitespace)
  diff     <file1> <file2>   Compare two JSON files (normalized)
  keys     <file>            List top-level keys
  extract  <file> <path>     Extract value by dot-path (e.g. "a.b.c")

${BOLD}Options:${NC}
  -h, --help                 Show this help
  -v, --version              Show version

${BOLD}Examples:${NC}
  ${SCRIPT_NAME} validate config.json
  ${SCRIPT_NAME} format   data.json
  ${SCRIPT_NAME} minify   package.json
  ${SCRIPT_NAME} diff     old.json new.json
  ${SCRIPT_NAME} keys     response.json
  ${SCRIPT_NAME} extract  config.json database.host
EOF
}

# --- Commands --------------------------------------------------------------

cmd_validate() {
    need_file "$1"
    need_python3
    info "Validating JSON: ${CYAN}$1${NC}"
    local result
    if result=$(python3 -c "
import json, sys
try:
    with open(sys.argv[1], 'r') as f:
        data = json.load(f)
    n = len(data) if isinstance(data, (dict, list)) else 1
    kind = type(data).__name__
    print(f'OK|{kind}|{n}')
except json.JSONDecodeError as e:
    print(f'ERR|{e.lineno}|{e.colno}|{e.msg}')
    sys.exit(1)
except Exception as e:
    print(f'ERR|0|0|{e}')
    sys.exit(1)
" "$1" 2>&1); then
        IFS='|' read -r _ kind count <<< "$result"
        success "Valid JSON — type: ${BOLD}${kind}${NC}, top-level elements: ${BOLD}${count}${NC}"
        local size
        size=$(wc -c < "$1" | tr -d ' ')
        local lines
        lines=$(wc -l < "$1" | tr -d ' ')
        info "Size: ${size} bytes, ${lines} lines"
    else
        IFS='|' read -r _ lineno colno msg <<< "$result"
        error "Invalid JSON at line ${BOLD}${lineno}${NC}, column ${BOLD}${colno}${NC}"
        error "Reason: ${msg}"
        # Show context around the error line
        if [[ "${lineno}" -gt 0 ]]; then
            echo ""
            local start=$((lineno > 3 ? lineno - 3 : 1))
            local end=$((lineno + 2))
            sed -n "${start},${end}p" "$1" | while IFS= read -r line; do
                if [[ $start -eq $lineno ]]; then
                    echo -e "  ${RED}→ ${start}: ${line}${NC}"
                else
                    echo -e "    ${start}: ${line}"
                fi
                start=$((start + 1))
            done
        fi
        return 1
    fi
}

cmd_format() {
    need_file "$1"
    need_python3
    info "Formatting JSON: ${CYAN}$1${NC}"
    python3 -c "
import json, sys
try:
    with open(sys.argv[1], 'r') as f:
        data = json.load(f)
    print(json.dumps(data, indent=4, ensure_ascii=False, sort_keys=False))
except json.JSONDecodeError as e:
    print(f'Error: invalid JSON at line {e.lineno}, col {e.colno}: {e.msg}', file=sys.stderr)
    sys.exit(1)
" "$1"
}

cmd_minify() {
    need_file "$1"
    need_python3
    info "Minifying JSON: ${CYAN}$1${NC}"
    local original_size minified minified_size
    original_size=$(wc -c < "$1" | tr -d ' ')
    if minified=$(python3 -c "
import json, sys
try:
    with open(sys.argv[1], 'r') as f:
        data = json.load(f)
    print(json.dumps(data, separators=(',', ':'), ensure_ascii=False), end='')
except json.JSONDecodeError as e:
    print(f'Error: invalid JSON at line {e.lineno}, col {e.colno}: {e.msg}', file=sys.stderr)
    sys.exit(1)
" "$1" 2>&1); then
        echo "$minified"
        minified_size=${#minified}
        if [[ "$original_size" -gt 0 ]]; then
            local saved=$((original_size - minified_size))
            local pct=$((saved * 100 / original_size))
            info "Original: ${original_size} bytes → Minified: ${minified_size} bytes (saved ${saved} bytes / ${pct}%)" >&2
        fi
    else
        echo "$minified" >&2
        return 1
    fi
}

cmd_diff() {
    [[ -z "${1:-}" ]] && die "Missing argument: <file1>"
    [[ -z "${2:-}" ]] && die "Missing argument: <file2>"
    need_file "$1"
    need_file "$2"
    need_python3
    info "Comparing JSON: ${CYAN}$1${NC} vs ${CYAN}$2${NC}"
    python3 -c "
import json, sys

def load_json(path):
    with open(path, 'r') as f:
        return json.load(f)

def diff_values(a, b, path=''):
    diffs = []
    if type(a) != type(b):
        diffs.append(f'  {path}: type changed {type(a).__name__} → {type(b).__name__}')
        diffs.append(f'    - {json.dumps(a, ensure_ascii=False)[:120]}')
        diffs.append(f'    + {json.dumps(b, ensure_ascii=False)[:120]}')
    elif isinstance(a, dict):
        all_keys = set(list(a.keys()) + list(b.keys()))
        for k in sorted(all_keys):
            p = f'{path}.{k}' if path else k
            if k not in a:
                diffs.append(f'  + {p}: {json.dumps(b[k], ensure_ascii=False)[:120]}')
            elif k not in b:
                diffs.append(f'  - {p}: {json.dumps(a[k], ensure_ascii=False)[:120]}')
            else:
                diffs.extend(diff_values(a[k], b[k], p))
    elif isinstance(a, list):
        for i in range(max(len(a), len(b))):
            p = f'{path}[{i}]'
            if i >= len(a):
                diffs.append(f'  + {p}: {json.dumps(b[i], ensure_ascii=False)[:120]}')
            elif i >= len(b):
                diffs.append(f'  - {p}: {json.dumps(a[i], ensure_ascii=False)[:120]}')
            else:
                diffs.extend(diff_values(a[i], b[i], p))
    elif a != b:
        diffs.append(f'  {path}:')
        diffs.append(f'    - {json.dumps(a, ensure_ascii=False)[:120]}')
        diffs.append(f'    + {json.dumps(b, ensure_ascii=False)[:120]}')
    return diffs

try:
    a = load_json(sys.argv[1])
    b = load_json(sys.argv[2])
except json.JSONDecodeError as e:
    print(f'Error: invalid JSON — {e}', file=sys.stderr)
    sys.exit(1)

diffs = diff_values(a, b)
if diffs:
    print(f'Found {len(diffs)} difference(s):')
    for d in diffs:
        print(d)
    sys.exit(1)
else:
    print('✔ Files are identical (structurally)')
" "$1" "$2"
}

cmd_keys() {
    need_file "$1"
    need_python3
    info "Top-level keys in: ${CYAN}$1${NC}"
    python3 -c "
import json, sys
try:
    with open(sys.argv[1], 'r') as f:
        data = json.load(f)
    if isinstance(data, dict):
        for i, k in enumerate(data.keys(), 1):
            v = data[k]
            vtype = type(v).__name__
            if isinstance(v, str):
                preview = v[:60] + ('…' if len(v) > 60 else '')
                print(f'  {i:3}. {k} ({vtype}): \"{preview}\"')
            elif isinstance(v, (list, dict)):
                print(f'  {i:3}. {k} ({vtype}, {len(v)} items)')
            else:
                print(f'  {i:3}. {k} ({vtype}): {v}')
        print(f'\nTotal: {len(data)} keys')
    elif isinstance(data, list):
        print(f'Root is an array with {len(data)} elements (no keys)')
    else:
        print(f'Root is a scalar: {type(data).__name__}')
except json.JSONDecodeError as e:
    print(f'Error: invalid JSON — {e}', file=sys.stderr)
    sys.exit(1)
" "$1"
}

cmd_extract() {
    need_file "$1"
    [[ -z "${2:-}" ]] && die "Missing argument: <dot-path> (e.g. 'a.b.c')"
    need_python3
    info "Extracting ${BOLD}$2${NC} from ${CYAN}$1${NC}"
    python3 -c "
import json, sys, re

path = sys.argv[2]
try:
    with open(sys.argv[1], 'r') as f:
        data = json.load(f)
except json.JSONDecodeError as e:
    print(f'Error: invalid JSON — {e}', file=sys.stderr)
    sys.exit(1)

parts = re.split(r'\.', path)
current = data
for part in parts:
    # support array index like items[0]
    m = re.match(r'^(\w+)\[(\d+)\]$', part)
    if m:
        key, idx = m.group(1), int(m.group(2))
        if isinstance(current, dict) and key in current:
            current = current[key]
            if isinstance(current, list) and idx < len(current):
                current = current[idx]
            else:
                print(f'Error: index [{idx}] out of range at \"{key}\"', file=sys.stderr)
                sys.exit(1)
        else:
            print(f'Error: key \"{key}\" not found', file=sys.stderr)
            sys.exit(1)
    elif isinstance(current, dict) and part in current:
        current = current[part]
    elif isinstance(current, list):
        try:
            current = current[int(part)]
        except (ValueError, IndexError):
            print(f'Error: cannot access \"{part}\" in array', file=sys.stderr)
            sys.exit(1)
    else:
        print(f'Error: key \"{part}\" not found at path \"{path}\"', file=sys.stderr)
        sys.exit(1)

if isinstance(current, (dict, list)):
    print(json.dumps(current, indent=2, ensure_ascii=False))
else:
    print(current)
" "$1" "$2"
}

# --- Main ------------------------------------------------------------------
main() {
    [[ $# -eq 0 ]] && { usage; exit 0; }

    case "${1}" in
        -h|--help)      usage ;;
        -v|--version)   echo "${SCRIPT_NAME} v${VERSION}" ;;
        validate)       shift; cmd_validate "${1:-}" ;;
        format)         shift; cmd_format "${1:-}" ;;
        minify)         shift; cmd_minify "${1:-}" ;;
        diff)           shift; cmd_diff "${1:-}" "${2:-}" ;;
        keys)           shift; cmd_keys "${1:-}" ;;
        extract)        shift; cmd_extract "${1:-}" "${2:-}" ;;
        *)              die "Unknown command: $1 (try --help)" ;;
    esac
}

main "$@"
