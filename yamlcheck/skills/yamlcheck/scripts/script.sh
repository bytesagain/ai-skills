#!/usr/bin/env bash
# ============================================================================
# YAMLCheck — YAML Validator & Toolkit
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================================
set -euo pipefail

VERSION="3.0.2"
SCRIPT_NAME="yamlcheck"

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

# Check if PyYAML is available
has_pyyaml() {
    python3 -c "import yaml" 2>/dev/null
}

# --- Usage -----------------------------------------------------------------
usage() {
    cat <<EOF
${BOLD}YAMLCheck v${VERSION}${NC} — YAML Validator & Toolkit
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  ${SCRIPT_NAME} <command> [arguments]

${BOLD}Commands:${NC}
  validate <file>     Validate YAML syntax
  to-json  <file>     Convert YAML to JSON
  lint     <file>     Check for common style issues
  keys     <file>     List top-level keys

${BOLD}Options:${NC}
  -h, --help          Show this help
  -v, --version       Show version

${BOLD}Examples:${NC}
  ${SCRIPT_NAME} validate config.yml
  ${SCRIPT_NAME} to-json  docker-compose.yml
  ${SCRIPT_NAME} lint     values.yaml
  ${SCRIPT_NAME} keys     playbook.yml
EOF
}

# --- Commands: with PyYAML -------------------------------------------------

cmd_validate_pyyaml() {
    need_file "$1"
    info "Validating YAML (PyYAML): ${CYAN}$1${NC}"
    python3 -c "
import yaml, sys, os

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        docs = list(yaml.safe_load_all(f))
    # filter None docs (empty documents)
    docs = [d for d in docs if d is not None]
    count = len(docs)
    if count == 0:
        print('⚠ File is empty or contains only comments')
        sys.exit(0)
    kinds = []
    for d in docs:
        if isinstance(d, dict):
            kinds.append(f'mapping ({len(d)} keys)')
        elif isinstance(d, list):
            kinds.append(f'sequence ({len(d)} items)')
        else:
            kinds.append(f'scalar ({type(d).__name__})')
    size = os.path.getsize(path)
    with open(path, 'r') as f:
        lines = sum(1 for _ in f)
    print(f'✔ Valid YAML — {count} document(s)')
    for i, k in enumerate(kinds):
        print(f'  Document {i+1}: {k}')
    print(f'  Size: {size} bytes, {lines} lines')
except yaml.YAMLError as e:
    print(f'✖ Invalid YAML: {e}', file=sys.stderr)
    sys.exit(1)
" "$1"
}

cmd_validate_fallback() {
    need_file "$1"
    info "Validating YAML (basic checks): ${CYAN}$1${NC}"
    local errors=0
    local line_num=0
    local in_multiline=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))

        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Check for tabs (YAML forbids tabs for indentation)
        if [[ "$line" =~ ^$'\t' ]]; then
            warn "Line ${line_num}: tab used for indentation (use spaces)"
            errors=$((errors + 1))
        fi

        # Check for obviously broken key-value (colon without space)
        if [[ "$line" =~ ^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*:[^[:space:]] ]] && \
           [[ ! "$line" =~ ^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*:\"  ]] && \
           [[ ! "$line" =~ ^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*:\'  ]] && \
           [[ ! "$line" =~ ^[[:space:]]*https?: ]]; then
            warn "Line ${line_num}: missing space after colon"
            errors=$((errors + 1))
        fi

    done < "$1"

    if [[ $errors -eq 0 ]]; then
        local lines
        lines=$(wc -l < "$1" | tr -d ' ')
        success "Basic YAML checks passed (${lines} lines)"
        warn "Install PyYAML for full validation: pip3 install pyyaml"
    else
        error "Found ${errors} issue(s)"
        return 1
    fi
}

cmd_validate() {
    if has_pyyaml; then
        cmd_validate_pyyaml "$1"
    else
        cmd_validate_fallback "$1"
    fi
}

cmd_tojson_pyyaml() {
    need_file "$1"
    info "Converting YAML to JSON: ${CYAN}$1${NC}"
    python3 -c "
import yaml, json, sys

try:
    with open(sys.argv[1], 'r') as f:
        docs = list(yaml.safe_load_all(f))
    docs = [d for d in docs if d is not None]
    if len(docs) == 0:
        print('{}')
    elif len(docs) == 1:
        print(json.dumps(docs[0], indent=2, ensure_ascii=False, default=str))
    else:
        print(json.dumps(docs, indent=2, ensure_ascii=False, default=str))
except yaml.YAMLError as e:
    print(f'Error: invalid YAML — {e}', file=sys.stderr)
    sys.exit(1)
" "$1"
}

cmd_tojson_fallback() {
    need_file "$1"
    info "Converting YAML to JSON: ${CYAN}$1${NC}"
    need_python3
    # Basic YAML-to-JSON for simple flat key:value files
    python3 -c "
import sys, json, re

result = {}
with open(sys.argv[1], 'r') as f:
    for line in f:
        line = line.rstrip()
        if not line or line.lstrip().startswith('#'):
            continue
        # Skip lines that are just list items or complex structures
        m = re.match(r'^([a-zA-Z_][\w.-]*)\s*:\s*(.*)', line)
        if m:
            key = m.group(1)
            val = m.group(2).strip()
            # Remove quotes
            if (val.startswith('\"') and val.endswith('\"')) or (val.startswith(\"'\") and val.endswith(\"'\")):
                val = val[1:-1]
            elif val.lower() in ('true', 'yes', 'on'):
                val = True
            elif val.lower() in ('false', 'no', 'off'):
                val = False
            elif val.lower() in ('null', '~', ''):
                val = None
            else:
                try:
                    val = int(val)
                except ValueError:
                    try:
                        val = float(val)
                    except ValueError:
                        pass
            result[key] = val

print(json.dumps(result, indent=2, ensure_ascii=False))
print('⚠ Basic conversion only (flat keys). Install PyYAML for full support: pip3 install pyyaml', file=sys.stderr)
" "$1"
}

cmd_tojson() {
    if has_pyyaml; then
        cmd_tojson_pyyaml "$1"
    else
        cmd_tojson_fallback "$1"
    fi
}

cmd_lint() {
    need_file "$1"
    info "Linting YAML: ${CYAN}$1${NC}"
    local issues=0
    local line_num=0
    local prev_indent=0

    echo ""
    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))

        # Check for tabs
        if [[ "$line" == *$'\t'* ]]; then
            warn "Line ${line_num}: contains tab character(s) — use spaces in YAML"
            issues=$((issues + 1))
        fi

        # Check for trailing whitespace
        if [[ "$line" =~ [[:space:]]$ ]] && [[ -n "$line" ]]; then
            warn "Line ${line_num}: trailing whitespace"
            issues=$((issues + 1))
        fi

        # Check for very long lines
        if [[ ${#line} -gt 200 ]]; then
            warn "Line ${line_num}: very long line (${#line} chars)"
            issues=$((issues + 1))
        fi

        # Check for Windows line endings
        if [[ "$line" == *$'\r' ]]; then
            warn "Line ${line_num}: Windows line ending (\\r\\n)"
            issues=$((issues + 1))
        fi

        # Check inconsistent indentation (odd number of spaces)
        local stripped="${line%%[! ]*}"
        local indent=${#stripped}
        if [[ $indent -gt 0 ]] && [[ $((indent % 2)) -ne 0 ]]; then
            warn "Line ${line_num}: odd indentation (${indent} spaces) — consider using multiples of 2"
            issues=$((issues + 1))
        fi

        # Check for missing space after colon in key: value
        if [[ "$line" =~ ^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*:[^[:space:]:] ]] && \
           [[ ! "$line" =~ ^[[:space:]]*https?: ]]; then
            warn "Line ${line_num}: missing space after colon in key: value pair"
            issues=$((issues + 1))
        fi

        # Duplicate key detection for top-level keys
        # (basic: just check if same key appears twice at indent 0)

    done < "$1"

    echo ""
    if [[ $issues -eq 0 ]]; then
        success "No style issues found! Clean YAML."
    else
        error "Found ${issues} style issue(s)"
        return 1
    fi
}

cmd_keys() {
    need_file "$1"
    need_python3
    info "Top-level keys in: ${CYAN}$1${NC}"

    if has_pyyaml; then
        python3 -c "
import yaml, sys

try:
    with open(sys.argv[1], 'r') as f:
        data = yaml.safe_load(f)
    if isinstance(data, dict):
        for i, (k, v) in enumerate(data.items(), 1):
            vtype = type(v).__name__
            if isinstance(v, str):
                preview = v[:60] + ('…' if len(v) > 60 else '')
                print(f'  {i:3}. {k} ({vtype}): \"{preview}\"')
            elif isinstance(v, (list, dict)):
                print(f'  {i:3}. {k} ({vtype}, {len(v)} items)')
            elif v is None:
                print(f'  {i:3}. {k} (null)')
            else:
                print(f'  {i:3}. {k} ({vtype}): {v}')
        print(f'\nTotal: {len(data)} keys')
    elif isinstance(data, list):
        print(f'Root is a sequence with {len(data)} items')
    else:
        print(f'Root is a scalar: {data}')
except yaml.YAMLError as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
" "$1"
    else
        # Fallback: grep top-level keys (no leading whitespace)
        info "(Using basic parser — install PyYAML for better results)"
        local count=0
        while IFS= read -r line; do
            # Skip comments and empty lines
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# || "$line" == "---" || "$line" == "..." ]] && continue
            # Top-level key: no leading whitespace, has a colon
            if [[ "$line" =~ ^([a-zA-Z_][a-zA-Z0-9_./-]*):[[:space:]]* ]]; then
                count=$((count + 1))
                local key="${BASH_REMATCH[1]}"
                printf "  %3d. %s\n" "$count" "$key"
            fi
        done < "$1"
        echo ""
        echo "Total: ${count} top-level keys (approximate)"
    fi
}

# --- Main ------------------------------------------------------------------
main() {
    [[ $# -eq 0 ]] && { usage; exit 0; }

    case "${1}" in
        -h|--help)      usage ;;
        -v|--version)   echo "${SCRIPT_NAME} v${VERSION}" ;;
        validate)       shift; cmd_validate "${1:-}" ;;
        to-json|tojson) shift; cmd_tojson "${1:-}" ;;
        lint)           shift; cmd_lint "${1:-}" ;;
        keys)           shift; cmd_keys "${1:-}" ;;
        *)              die "Unknown command: $1 (try --help)" ;;
    esac
}

main "$@"
