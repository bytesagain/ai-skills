#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# RegExr — regex builder & tester (inspired by gskinner/regexr 10K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "RegExr — regex tool & reference
Commands:
  test <pattern> <text>   Test regex match
  match <pattern> <file>  Find matches in file
  replace <p> <r> <file>  Search and replace
  extract <pattern> <f>   Extract matches
  validate <type> <text>  Validate (email/url/ip/phone)
  cheatsheet              Regex cheat sheet
  common                  Common regex patterns
  build <type>            Build regex for type
  info                    Version info
Powered by BytesAgain | bytesagain.com";;
test)
    pattern="${1:-}"; text="${2:-}"
    [ -z "$pattern" ] && { echo "Usage: test <pattern> <text>"; exit 1; }
    python3 -c "
import re
p = '$pattern'
t = '''$text'''
m = re.findall(p, t)
if m:
    print('✅ Matches found: {}'.format(len(m)))
    for i, match in enumerate(m[:10], 1):
        print('  {}: {}'.format(i, match))
else:
    print('❌ No matches')
";;
match)
    pattern="${1:-}"; f="${2:-}"
    [ -z "$f" ] && { echo "Usage: match <pattern> <file>"; exit 1; }
    echo "Matches for /$pattern/:"
    grep -nE "$pattern" "$f" 2>/dev/null | head -20;;
replace)
    pattern="${1:-}"; replacement="${2:-}"; f="${3:-}"
    [ -z "$f" ] && { echo "Usage: replace <pattern> <replacement> <file>"; exit 1; }
    echo "Preview (first 5):"
    sed -n "s/$pattern/$replacement/gp" "$f" 2>/dev/null | head -5;;
extract)
    pattern="${1:-}"; f="${2:-}"
    [ -z "$f" ] && { echo "Usage: extract <pattern> <file>"; exit 1; }
    grep -oE "$pattern" "$f" 2>/dev/null | sort | uniq -c | sort -rn | head -20;;
validate)
    type="${1:-}"; text="${2:-}"
    [ -z "$text" ] && { echo "Usage: validate <type> <text>"; exit 1; }
    python3 -c "
import re
validators = {
    'email': r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    'url': r'^https?://[^\s<>\"]+$',
    'ip': r'^(\d{1,3}\.){3}\d{1,3}$',
    'phone': r'^[\+]?[0-9]{7,15}$',
    'date': r'^\d{4}-\d{2}-\d{2}$',
    'hex': r'^#?[0-9a-fA-F]{3,8}$',
}
t = '$type'
text = '$text'
if t in validators:
    if re.match(validators[t], text):
        print('✅ Valid {} : {}'.format(t, text))
    else:
        print('❌ Invalid {}: {}'.format(t, text))
        print('  Pattern: {}'.format(validators[t]))
else:
    print('Types: {}'.format(', '.join(validators.keys())))
";;
cheatsheet) cat << 'EOF'
📖 Regex Cheat Sheet:
  .       Any character          \d      Digit [0-9]
  *       0 or more              \w      Word char [a-zA-Z0-9_]
  +       1 or more              \s      Whitespace
  ?       0 or 1                 \b      Word boundary
  ^       Start of line          $       End of line
  [abc]   Character class        [^abc]  Negated class
  (...)   Capture group          (?:...) Non-capture group
  {n}     Exactly n              {n,m}   n to m times
  |       Alternation            (?=...) Lookahead
  (?!...) Negative lookahead     (?<=..) Lookbehind
EOF
;;
common) cat << 'EOF'
📋 Common Patterns:
  Email:    [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
  URL:      https?://[^\s<>"]+
  IPv4:     (\d{1,3}\.){3}\d{1,3}
  Phone:    \+?[0-9]{7,15}
  Date:     \d{4}-\d{2}-\d{2}
  Time:     \d{2}:\d{2}(:\d{2})?
  Hex:      #?[0-9a-fA-F]{3,8}
  UUID:     [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
  CSS hex:  #([0-9a-fA-F]{3}){1,2}
  HTML tag: <([a-z]+)[^>]*>(.*?)</\1>
EOF
;;
build)
    type="${1:-email}"
    python3 -c "
patterns = {
    'email': r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    'url': r'https?://[^\s<>\"]+',
    'ip': r'(\d{1,3}\.){3}\d{1,3}',
    'phone': r'\+?[0-9\s()-]{7,20}',
    'date': r'\d{4}[-/]\d{2}[-/]\d{2}',
    'number': r'-?\d+\.?\d*',
    'word': r'\b\w+\b',
    'slug': r'[a-z0-9]+(?:-[a-z0-9]+)*',
    'password': r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,}$',
}
t = '$type'
if t in patterns:
    print('Pattern for {}: {}'.format(t, patterns[t]))
else:
    print('Available: {}'.format(', '.join(patterns.keys())))
";;
info) echo "RegExr v1.0.0"; echo "Inspired by: gskinner/regexr (10,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
