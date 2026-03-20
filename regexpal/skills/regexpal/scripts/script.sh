#!/usr/bin/env bash
# ============================================================================
# RegexPal — Regex Tester & Toolkit
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================================
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="regexpal"

# --- Colors ----------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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
${BOLD}RegexPal v${VERSION}${NC} — Regex Tester & Toolkit
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  ${SCRIPT_NAME} <command> [arguments]

${BOLD}Commands:${NC}
  test    <pattern> <text>                 Test if pattern matches text
  match   <pattern> <file>                 Find all matches in a file
  replace <pattern> <replacement> <file>   Replace matches in file (stdout)
  extract <pattern> <file>                 Extract capturing groups from file
  explain <pattern>                        Explain regex pattern parts

${BOLD}Options:${NC}
  -h, --help          Show this help
  -v, --version       Show version

${BOLD}Examples:${NC}
  ${SCRIPT_NAME} test '^\d{3}-\d{4}$' '123-4567'
  ${SCRIPT_NAME} match '[A-Z]\w+' source.py
  ${SCRIPT_NAME} replace 'foo(\d+)' 'bar\1' input.txt
  ${SCRIPT_NAME} extract '(\w+)@(\w+\.\w+)' emails.txt
  ${SCRIPT_NAME} explain '(?<=@)[\w.-]+'
EOF
}

# --- Commands --------------------------------------------------------------

cmd_test() {
    [[ -z "${1:-}" ]] && die "Missing argument: <pattern>"
    [[ -z "${2:-}" ]] && die "Missing argument: <text>"
    local pattern="$1"
    local text="$2"
    need_python3

    info "Testing pattern: ${CYAN}${pattern}${NC}"
    info "Against text:    ${CYAN}${text}${NC}"
    echo ""

    python3 -c "
import re, sys

pattern = sys.argv[1]
text = sys.argv[2]

try:
    compiled = re.compile(pattern)
except re.error as e:
    print(f'✖ Invalid regex: {e}', file=sys.stderr)
    sys.exit(1)

# Full match
fm = compiled.fullmatch(text)
# Search (partial)
sm = compiled.search(text)
# Find all
fa = compiled.findall(text)

if fm:
    print('✔ FULL MATCH')
    if fm.groups():
        for i, g in enumerate(fm.groups(), 1):
            print(f'  Group {i}: \"{g}\"')
    if fm.groupdict():
        for name, val in fm.groupdict().items():
            print(f'  Named \"{name}\": \"{val}\"')
elif sm:
    print(f'✔ PARTIAL MATCH at position {sm.start()}-{sm.end()}')
    print(f'  Matched: \"{sm.group()}\"')
    if sm.groups():
        for i, g in enumerate(sm.groups(), 1):
            print(f'  Group {i}: \"{g}\"')
    if len(fa) > 1:
        print(f'  Total matches found: {len(fa)}')
else:
    print('✖ NO MATCH')
    sys.exit(1)
" "$pattern" "$text"
}

cmd_match() {
    [[ -z "${1:-}" ]] && die "Missing argument: <pattern>"
    [[ -z "${2:-}" ]] && die "Missing argument: <file>"
    need_file "$2"
    need_python3

    local pattern="$1"
    local file="$2"

    info "Pattern: ${CYAN}${pattern}${NC}"
    info "File:    ${CYAN}${file}${NC}"
    echo ""

    python3 -c "
import re, sys

pattern = sys.argv[1]
filepath = sys.argv[2]

try:
    compiled = re.compile(pattern)
except re.error as e:
    print(f'✖ Invalid regex: {e}', file=sys.stderr)
    sys.exit(1)

total_matches = 0
matching_lines = 0

with open(filepath, 'r', errors='replace') as f:
    for line_num, line in enumerate(f, 1):
        line = line.rstrip('\n')
        matches = list(compiled.finditer(line))
        if matches:
            matching_lines += 1
            total_matches += len(matches)
            # Highlight matches in the line
            highlighted = line
            offset = 0
            parts = []
            last_end = 0
            for m in matches:
                parts.append(line[last_end:m.start()])
                parts.append(f'\033[1;31m{m.group()}\033[0m')
                last_end = m.end()
            parts.append(line[last_end:])
            highlighted = ''.join(parts)
            print(f'  {line_num:5}: {highlighted}')

print(f'')
if total_matches > 0:
    print(f'✔ {total_matches} match(es) on {matching_lines} line(s)')
else:
    print(f'✖ No matches found')
    sys.exit(1)
" "$pattern" "$file"
}

cmd_replace() {
    [[ -z "${1:-}" ]] && die "Missing argument: <pattern>"
    [[ -z "${2:-}" ]] && die "Missing argument: <replacement>"
    [[ -z "${3:-}" ]] && die "Missing argument: <file>"
    need_file "$3"
    need_python3

    local pattern="$1"
    local replacement="$2"
    local file="$3"

    info "Pattern:     ${CYAN}${pattern}${NC}"
    info "Replacement: ${CYAN}${replacement}${NC}"
    info "File:        ${CYAN}${file}${NC}"
    info "(Output to stdout — pipe to file to save)"
    echo "---"

    python3 -c "
import re, sys

pattern = sys.argv[1]
replacement = sys.argv[2]
filepath = sys.argv[3]

try:
    compiled = re.compile(pattern)
except re.error as e:
    print(f'✖ Invalid regex: {e}', file=sys.stderr)
    sys.exit(1)

total_replacements = 0
with open(filepath, 'r', errors='replace') as f:
    for line in f:
        new_line, count = compiled.subn(replacement, line)
        total_replacements += count
        sys.stdout.write(new_line)

print(f'---', file=sys.stderr)
print(f'✔ {total_replacements} replacement(s) made', file=sys.stderr)
" "$pattern" "$replacement" "$file"
}

cmd_extract() {
    [[ -z "${1:-}" ]] && die "Missing argument: <pattern>"
    [[ -z "${2:-}" ]] && die "Missing argument: <file>"
    need_file "$2"
    need_python3

    local pattern="$1"
    local file="$2"

    info "Extracting groups for: ${CYAN}${pattern}${NC}"
    info "From: ${CYAN}${file}${NC}"
    echo ""

    python3 -c "
import re, sys

pattern = sys.argv[1]
filepath = sys.argv[2]

try:
    compiled = re.compile(pattern)
except re.error as e:
    print(f'✖ Invalid regex: {e}', file=sys.stderr)
    sys.exit(1)

num_groups = compiled.groups
if num_groups == 0:
    print('⚠ Pattern has no capturing groups — showing full matches instead', file=sys.stderr)

total = 0
with open(filepath, 'r', errors='replace') as f:
    for line_num, line in enumerate(f, 1):
        line = line.rstrip('\n')
        for m in compiled.finditer(line):
            total += 1
            if num_groups == 0:
                print(f'  Line {line_num}: \"{m.group()}\"')
            else:
                groups = ', '.join(f'G{i}=\"{g}\"' for i, g in enumerate(m.groups(), 1) if g is not None)
                print(f'  Line {line_num}: {groups}')

print(f'')
print(f'✔ {total} match(es) extracted')
if total == 0:
    sys.exit(1)
" "$pattern" "$file"
}

cmd_explain() {
    [[ -z "${1:-}" ]] && die "Missing argument: <pattern>"
    need_python3

    local pattern="$1"
    info "Explaining: ${CYAN}${pattern}${NC}"
    echo ""

    python3 -c "
import re, sys

pattern = sys.argv[1]

# Validate first
try:
    compiled = re.compile(pattern)
except re.error as e:
    print(f'✖ Invalid regex: {e}', file=sys.stderr)
    sys.exit(1)

# Token explanations
explanations = {
    '.': 'Any character (except newline)',
    '*': 'Zero or more of the preceding',
    '+': 'One or more of the preceding',
    '?': 'Zero or one of the preceding (optional)',
    '^': 'Start of string/line',
    '\$': 'End of string/line',
    '|': 'Alternation (OR)',
    '\\\\d': 'Any digit [0-9]',
    '\\\\D': 'Any non-digit',
    '\\\\w': 'Any word character [a-zA-Z0-9_]',
    '\\\\W': 'Any non-word character',
    '\\\\s': 'Any whitespace',
    '\\\\S': 'Any non-whitespace',
    '\\\\b': 'Word boundary',
    '\\\\B': 'Non-word boundary',
    '\\\\n': 'Newline',
    '\\\\t': 'Tab',
    '\\\\\\\\': 'Literal backslash',
}

quantifiers = {
    '{n}': 'Exactly n times',
    '{n,}': 'At least n times',
    '{n,m}': 'Between n and m times',
    '*?': 'Zero or more (lazy/non-greedy)',
    '+?': 'One or more (lazy/non-greedy)',
    '??': 'Zero or one (lazy/non-greedy)',
}

groups_info = {
    '(...)': 'Capturing group',
    '(?:...)': 'Non-capturing group',
    '(?P<name>...)': 'Named capturing group',
    '(?=...)': 'Positive lookahead',
    '(?!...)': 'Negative lookahead',
    '(?<=...)': 'Positive lookbehind',
    '(?<!...)': 'Negative lookbehind',
}

print('Pattern breakdown:')
print(f'  {pattern}')
print()

# Walk through the pattern and explain parts
import re as re_mod

# Find character classes
classes = list(re_mod.finditer(r'\[([^\]]*)\]', pattern))
if classes:
    print('Character classes:')
    for m in classes:
        print(f'  [{m.group(1)}] — Match any of: {m.group(1)}')
    print()

# Find groups
grps = list(re_mod.finditer(r'\((?:\?[P<:!=](?:<\w+>)?)?', pattern))
if grps:
    print(f'Groups: {compiled.groups} capturing group(s)')
    named = compiled.groupindex
    if named:
        for name, idx in named.items():
            print(f'  Group {idx} (named \"{name}\")')
    print()

# Find used tokens
print('Tokens found:')
found_any = False
for token, desc in explanations.items():
    if token in pattern or token.replace('\\\\\\\\', '\\\\') in pattern:
        # More careful check
        check = token.replace('\\\\\\\\', '\\\\')
        if check in pattern:
            print(f'  {check:8s} → {desc}')
            found_any = True
if not found_any:
    print('  (only literal characters)')
print()

# Quantifier info
found_q = False
for token, desc in quantifiers.items():
    if token.replace('{n}', '').replace('{n,}', '').replace('{n,m}', '') in pattern:
        pass
import re as r2
quant_matches = list(r2.finditer(r'\{(\d+)(?:,(\d*))?\}', pattern))
if quant_matches:
    print('Quantifiers:')
    for m in quant_matches:
        if m.group(2) is None:
            print(f'  {m.group()} → Exactly {m.group(1)} times')
        elif m.group(2) == '':
            print(f'  {m.group()} → At least {m.group(1)} times')
        else:
            print(f'  {m.group()} → Between {m.group(1)} and {m.group(2)} times')
    print()

print(f'Flags: pattern compiles OK with {compiled.flags} flags')
print(f'Groups: {compiled.groups} capturing, {len(compiled.groupindex)} named')
" "$pattern"
}

# --- Main ------------------------------------------------------------------
main() {
    [[ $# -eq 0 ]] && { usage; exit 0; }

    case "${1}" in
        -h|--help)      usage ;;
        -v|--version)   echo "${SCRIPT_NAME} v${VERSION}" ;;
        test)           shift; cmd_test "${1:-}" "${2:-}" ;;
        match)          shift; cmd_match "${1:-}" "${2:-}" ;;
        replace)        shift; cmd_replace "${1:-}" "${2:-}" "${3:-}" ;;
        extract)        shift; cmd_extract "${1:-}" "${2:-}" ;;
        explain)        shift; cmd_explain "${1:-}" ;;
        *)              die "Unknown command: $1 (try --help)" ;;
    esac
}

main "$@"
