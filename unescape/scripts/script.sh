#!/usr/bin/env bash
# unescape — String Unescaping Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Unescaping ===

Escaping converts special characters into safe representations.
Unescaping reverses this — restoring original characters.

The Escape-Unescape Cycle:
  Original:   Hello "World" & <Friends>
  Escaped:    Hello &quot;World&quot; &amp; &lt;Friends&gt;   (HTML)
  Unescaped:  Hello "World" & <Friends>                      (back to original)

Why Escaping Exists:
  Every language/protocol has special characters:
    HTML:  < > & " '      (structure characters)
    URL:   ? & = # % /    (URL delimiters)
    JSON:  " \ /          (string delimiters)
    SQL:   ' -- ;          (query structure)
    Shell: $ ` " \ ! *    (expansion/globbing)
    Regex: . * + ? [ ] ^  (pattern metacharacters)

  Escaping prevents these characters from being interpreted as structure.

Unescape = Decode = Restore:
  Different names for the same operation:
    HTML:  unescape, decode entities
    URL:   decode, percent-decode
    JSON:  parse, unescape
    Base64: decode
    Shell:  unquote

Common Mistakes:
  1. Double escaping: &amp;amp;  (escaped twice!)
  2. Wrong context:   HTML-escaping data meant for URLs
  3. Missing unescape: Displaying &lt;b&gt; instead of <b>
  4. Premature unescape: Unescaping before validation (XSS risk!)

The Golden Rule:
  Escape as LATE as possible (at output/rendering)
  Unescape as EARLY as possible (at input/parsing)
  Store data in its NATURAL form (unescaped)
EOF
}

cmd_html() {
    cat << 'EOF'
=== HTML Entity Unescaping ===

--- Named Entities ---
  &amp;    → &     (ampersand)
  &lt;     → <     (less than)
  &gt;     → >     (greater than)
  &quot;   → "     (double quote)
  &apos;   → '     (apostrophe, XML/HTML5)
  &nbsp;   → " "   (non-breaking space)
  &copy;   → ©     (copyright)
  &mdash;  → —     (em dash)
  &hellip; → …     (horizontal ellipsis)
  &euro;   → €     (euro sign)

  There are 2,231 named HTML entities!

--- Numeric Entities ---
  &#60;    → <     (decimal code point)
  &#x3C;   → <     (hexadecimal code point)
  &#169;   → ©
  &#x00A9; → ©
  &#128512; → 😀   (emoji via decimal)
  &#x1F600; → 😀   (emoji via hex)

--- Unescaping in Code ---
  JavaScript (Browser):
    function htmlUnescape(str) {
      const el = document.createElement('textarea');
      el.innerHTML = str;
      return el.value;
    }

  JavaScript (Node.js):
    const { decode } = require('html-entities');
    decode('&lt;p&gt;Hello&lt;/p&gt;')  // '<p>Hello</p>'
    // npm install html-entities

  Python:
    import html
    html.unescape('&lt;p&gt;Hello&lt;/p&gt;')  # '<p>Hello</p>'

  PHP:
    html_entity_decode('&lt;p&gt;', ENT_QUOTES, 'UTF-8');

  Go:
    import "html"
    html.UnescapeString("&lt;p&gt;")

--- XSS Warning ---
  ⚠ NEVER unescape HTML and insert into DOM without sanitization!

  // DANGEROUS:
  element.innerHTML = htmlUnescape(userInput);
  // If userInput = "&lt;script&gt;alert('xss')&lt;/script&gt;"
  // After unescape: <script>alert('xss')</script>  → XSS!

  // SAFE:
  element.textContent = htmlUnescape(userInput);
  // Or use DOMPurify: DOMPurify.sanitize(htmlUnescape(input))
EOF
}

cmd_url() {
    cat << 'EOF'
=== URL Decoding ===

--- Percent Encoding ---
  Space    → %20 (or + in query strings)
  !        → %21
  #        → %23
  $        → %24
  &        → %26
  +        → %2B
  /        → %2F
  :        → %3A
  =        → %3D
  ?        → %3F
  @        → %40
  中       → %E4%B8%AD (UTF-8: 3 bytes)

--- Decoding in Code ---
  JavaScript:
    decodeURIComponent('%E4%B8%AD%E6%96%87')  // '中文'
    decodeURI('https://example.com/path%20name')
    // decodeURI preserves URL structure characters (: / ? #)
    // decodeURIComponent decodes everything

  Python:
    from urllib.parse import unquote, unquote_plus
    unquote('%E4%B8%AD%E6%96%87')        # '中文'
    unquote_plus('hello+world')           # 'hello world'

  Go:
    import "net/url"
    url.QueryUnescape("hello%20world")    // "hello world"
    url.PathUnescape("path%2Fto%2Ffile")  // "path/to/file"

  PHP:
    urldecode('hello+world');             // 'hello world'
    rawurldecode('hello%20world');        // 'hello world'

--- + vs %20 ---
  application/x-www-form-urlencoded: + means space
    Form data, query strings: ?q=hello+world

  Path segments: %20 means space
    /path/hello%20world

  decodeURIComponent('%2B') → '+'  (plus stays plus)
  decodeURIComponent('+')  → '+'  (plus stays plus!)
  // For form data, replace + with space first:
  decodeURIComponent(str.replace(/\+/g, '%20'))

--- Double Encoding ---
  Original:  hello world
  Encoded:   hello%20world
  Double:    hello%2520world  (%25 = literal %)

  If you see %25 in URLs, data was encoded twice.
  Fix: decode twice, or fix the encoding pipeline.

--- Full URL Parsing ---
  const url = new URL('https://example.com/path?q=hello%20world&lang=en');
  url.searchParams.get('q')    // 'hello world' (auto-decoded)
  url.pathname                 // '/path' (auto-decoded)

  Python:
  from urllib.parse import urlparse, parse_qs
  parsed = urlparse('https://example.com/path?q=hello%20world')
  parse_qs(parsed.query)       # {'q': ['hello world']}
EOF
}

cmd_json() {
    cat << 'EOF'
=== JSON String Unescaping ===

--- JSON Escape Sequences ---
  \"     → "    (double quote)
  \\     → \    (backslash)
  \/     → /    (forward slash, optional)
  \b     → BS   (backspace, 0x08)
  \f     → FF   (form feed, 0x0C)
  \n     → LF   (newline, 0x0A)
  \r     → CR   (carriage return, 0x0D)
  \t     → TAB  (horizontal tab, 0x09)
  \uXXXX → Unicode code point

--- Unicode Escapes ---
  \u0041           → A
  \u4e2d           → 中
  \u00e9           → é
  \uD83D\uDE00     → 😀 (surrogate pair for U+1F600)

  Surrogate pairs (for code points > U+FFFF):
    High surrogate: 0xD800-0xDBFF
    Low surrogate:  0xDC00-0xDFFF
    \uD83D\uDE00 → U+1F600 (grinning face)

--- Unescaping in Code ---
  JavaScript:
    JSON.parse('"hello\\nworld"')     // "hello\nworld"
    JSON.parse('"\\u4e2d\\u6587"')    // "中文"

  Python:
    import json
    json.loads('"hello\\nworld"')     # "hello\nworld"

  Go:
    var s string
    json.Unmarshal([]byte(`"hello\nworld"`), &s)

--- Edge Cases ---
  // Solidus: both valid JSON
  JSON.parse('"\/"')      // "/"
  JSON.parse('"/"')       // "/"  (solidus escaping is optional)

  // Bare control characters are INVALID in JSON:
  '{"text": "line1\nline2"}'   // INVALID! (literal newline)
  '{"text": "line1\\nline2"}'  // valid (escaped newline)

  // NUL character:
  JSON.parse('"\\u0000"')      // string containing NUL (0x00)
  // Some parsers reject NUL, others accept it

--- Common Pitfall: Double-Escaped JSON ---
  API returns JSON string containing JSON:
    {"data": "{\"name\": \"Alice\"}"}

  Step 1: Parse outer JSON → data = "{\"name\": \"Alice\"}"
  Step 2: Parse inner JSON → {name: "Alice"}

  // JavaScript:
  const outer = JSON.parse(response);
  const inner = JSON.parse(outer.data);

  // If you see \\\" in your data, it's been escaped too many times
EOF
}

cmd_shell() {
    cat << 'EOF'
=== Shell Unescaping ===

--- Single Quotes (No Escaping Inside) ---
  echo 'Hello $USER \n "world"'
  # Output: Hello $USER \n "world"
  # NOTHING is interpreted inside single quotes
  # Even backslash is literal

  # How to include a single quote?
  echo 'can'\''t'          # end quote, escaped quote, new quote
  echo "can't"             # use double quotes instead
  echo $'can\'t'           # ANSI-C quoting

--- Double Quotes (Selective Escaping) ---
  echo "Hello $USER"       # variable expanded
  echo "Hello \$USER"      # \$ → literal $
  echo "Hello \"world\""   # \" → literal "
  echo "Hello \\world"     # \\ → literal \
  echo "Hello \n world"    # \n is NOT special! Literal \n
  echo "Hello `date`"      # backtick command substitution

  Only these are special in double quotes: $ ` \ ! "

--- ANSI-C Quoting ($'...') ---
  echo $'Hello\nWorld'     # actual newline
  echo $'Tab\there'        # actual tab
  echo $'Quote\''          # literal single quote
  echo $'\x41'             # A (hex)
  echo $'\u4e2d'           # 中 (Unicode, bash 4.2+)
  echo $'\033[31mRed\033[0m'  # ANSI color

  Supported escapes:
    \n \r \t \a \b \f \v   Control characters
    \\                      Backslash
    \'                      Single quote
    \"                      Double quote
    \nnn                    Octal
    \xHH                    Hex byte
    \uHHHH                 Unicode (4 hex digits)
    \UHHHHHHHH             Unicode (8 hex digits)

--- Here Document (No Escaping) ---
  cat << 'EOF'
  Everything here is literal: $VAR \n "quotes" `backticks`
  EOF
  # Quoted delimiter ('EOF') prevents ALL expansion

  cat << EOF
  Variables expanded: $USER
  Commands expanded: $(date)
  EOF
  # Unquoted delimiter: normal expansion applies

--- printf for Escape Sequences ---
  printf '%s\n' "Hello"            # %s is literal, \n is printf's
  printf 'Tab:\t Newline:\n'       # printf interprets escapes
  printf '%q' "Hello World"        # shell-quote output for reuse

--- Unescaping in Scripts ---
  # Read escaped input:
  read -r line                     # -r prevents backslash interpretation
  # Without -r: \n in input becomes literal n

  # echo -e interprets escapes:
  echo -e "Hello\nWorld"           # actual newline
  echo "Hello\nWorld"              # literal \n (no -e)
  # Prefer printf over echo -e (more portable)
EOF
}

cmd_regex() {
    cat << 'EOF'
=== Regex Unescaping ===

--- Metacharacters That Need Escaping ---
  .   Any character         →  \.  literal dot
  *   Zero or more          →  \*  literal asterisk
  +   One or more           →  \+  literal plus
  ?   Zero or one           →  \?  literal question mark
  ^   Start of line         →  \^  literal caret
  $   End of line           →  \$  literal dollar
  |   Alternation           →  \|  literal pipe
  \   Escape character      →  \\  literal backslash
  (   Group open            →  \(  literal paren
  )   Group close           →  \)  literal paren
  [   Class open            →  \[  literal bracket
  {   Quantifier open       →  \{  literal brace

--- Raw Strings (Avoid Double Escaping) ---
  Python:
    re.search(r'\d+\.\d+', text)     # raw string: \d and \. are regex
    re.search('\\d+\\.\\d+', text)   # regular string: must double-escape

  Rust:
    Regex::new(r"\d+\.\d+")          # raw string
    Regex::new("\\d+\\.\\d+")        // regular string

  JavaScript:
    /\d+\.\d+/                       # regex literal (no escaping needed)
    new RegExp('\\d+\\.\\d+')        // string: must double-escape

  Go:
    regexp.Compile(`\d+\.\d+`)       // backtick: raw string
    regexp.Compile("\\d+\\.\\d+")    // double-escape

--- Escaping User Input for Regex ---
  JavaScript:
    function escapeRegex(str) {
      return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

  Python:
    import re
    re.escape('hello.world')  # 'hello\\.world'

  Go:
    regexp.QuoteMeta("hello.world")  // "hello\\.world"

--- Inside Character Classes [...] ---
  Most metacharacters are literal inside []:
    [.+*?]   → matches literal . + * ?
  Still special inside []:
    ]        → \]  or place first: []abc]
    \        → \\
    ^        → place not first: [a^b]
    -        → \-  or place first/last: [-abc] or [abc-]

--- Common Unescape Mistakes ---
  1. "I want to match C:\Users" in regex
     WRONG: C:\Users        (\U is not a valid escape!)
     RIGHT: C:\\Users       (escaped backslash)
     BEST:  r'C:\\Users'    (raw string + regex escape)

  2. "\b" in different contexts:
     Shell:     backspace character
     Regex:     word boundary
     JSON:      backspace
     Same sequence, different meaning per context!
EOF
}

cmd_sql() {
    cat << 'EOF'
=== SQL Unescaping ===

--- Single Quote Escaping ---
  Standard SQL: double the quote
    'O''Brien'     → O'Brien
    'It''s a test' → It's a test
    ''''           → '  (just a single quote)

--- Backslash Escaping (MySQL) ---
  MySQL (and some PostgreSQL modes):
    'Hello\nWorld'  → Hello<newline>World
    'Path\\to\\file' → Path\to\file
    'Say \"hi\"'    → Say "hi"

  MySQL escape sequences:
    \\   → \
    \'   → '
    \"   → "
    \n   → newline
    \r   → carriage return
    \t   → tab
    \0   → NUL
    \Z   → Ctrl-Z (Windows EOF)
    %%   → % (in LIKE patterns)
    __   → _ (in LIKE patterns, actually \_)

--- PostgreSQL Dollar Quoting ---
  $$O'Brien's "data"$$           # no escaping needed!
  $tag$Complex 'string' here$tag$  # tagged dollar quotes

  Perfect for: stored procedures, strings with many quotes.

--- Preventing SQL Injection (Don't Manual-Unescape!) ---
  NEVER build SQL by concatenating unescaped user input.

  BAD:
    query = "SELECT * FROM users WHERE name = '" + input + "'"
    # Input: "'; DROP TABLE users; --"
    # → SELECT * FROM users WHERE name = ''; DROP TABLE users; --'

  GOOD (parameterized queries):
    Python:  cursor.execute("SELECT * FROM users WHERE name = %s", (name,))
    Node.js: db.query("SELECT * FROM users WHERE name = $1", [name])
    Go:      db.Query("SELECT * FROM users WHERE name = ?", name)
    Java:    stmt.setString(1, name)  // PreparedStatement

  The database driver handles escaping internally.
  You should NEVER need to manually escape/unescape SQL strings.

--- Identifier Quoting ---
  MySQL:     `table name`      (backticks)
  PostgreSQL: "table name"     (double quotes)
  SQL Server: [table name]     (square brackets)

  Needed when identifier contains:
    Spaces, reserved words, special characters
    Case-sensitive names (PostgreSQL lowercases unquoted)

--- LIKE Pattern Escaping ---
  -- % and _ are wildcards in LIKE
  -- To search for literal % or _:
  SELECT * FROM t WHERE col LIKE '%10\%%' ESCAPE '\'
  -- Finds strings containing "10%"
EOF
}

cmd_double() {
    cat << 'EOF'
=== Double Escaping Problems ===

--- What is Double Escaping? ---
  Data passes through multiple escape layers:

  Layer 1 (JavaScript string):  "Hello \"World\""
  Layer 2 (JSON):               "Hello \\\"World\\\""
  Layer 3 (HTML):               Hello &amp;quot;World&amp;quot;

  Each layer adds its own escaping.
  If you escape at one layer and the next layer also escapes,
  you get double (or triple!) escaping.

--- Symptoms ---
  Displaying:  &amp;amp;  instead of  &
  Showing:     \\n  instead of newline
  URL has:     %2520  instead of %20
  JSON shows:  \\" instead of "
  Database:    O\'Brien  instead of O'Brien

--- Diagnosis ---
  Count the escape levels:
    &     → 0 escapes (raw)
    &amp; → 1 escape (correct for HTML)
    &amp;amp; → 2 escapes (double-escaped!)

    %20        → 1 encode (correct)
    %2520      → 2 encodes (%25 = %, then 20)
    %252520    → 3 encodes

    "hello"    → 0 escapes
    \"hello\"  → 1 escape (in JSON string)
    \\\"hello\\\" → 2 escapes

--- Common Causes ---
  1. Escaping on input AND output
     Fix: Escape only at OUTPUT, store raw data

  2. Framework auto-escapes, then you escape manually
     Fix: Check if your framework already escapes
     React: JSX auto-escapes, no need for manual HTML escaping
     Django: Templates auto-escape, use |safe for raw HTML

  3. Encoding URL parameters that are already encoded
     Fix: Check if URL is already encoded before encoding

  4. Serializing JSON string that's already JSON
     Fix: Parse the string first, then re-serialize once

--- Prevention Rules ---
  1. Store data in its natural (unescaped) form
  2. Escape at the LAST moment before output
  3. Know which layers auto-escape
  4. Never escape "just in case"
  5. Test with special characters: ' " < > & % \ / 中 😀

--- Debugging Steps ---
  1. Print raw bytes: hexdump, xxd, JSON.stringify
  2. Trace data through each layer
  3. Check each transformation point
  4. Add the character "O'Brien & <test>" as test data
  5. If it displays correctly, you're fine
  6. If it shows O&apos;Brien &amp;amp; &amp;lt;test&amp;gt;
     → too many escape passes
EOF
}

show_help() {
    cat << EOF
unescape v$VERSION — String Unescaping Reference

Usage: script.sh <command>

Commands:
  intro        What escaping/unescaping is, the escape lifecycle
  html         HTML entity unescaping and XSS considerations
  url          URL percent-decoding, + vs %20, double encoding
  json         JSON string unescaping, surrogate pairs, edge cases
  shell        Shell quoting: single, double, ANSI-C, here-docs
  regex        Regex metacharacter escaping, raw strings
  sql          SQL quoting, injection prevention, LIKE patterns
  double       Double-escaping: diagnosis, causes, prevention
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)    cmd_intro ;;
    html)     cmd_html ;;
    url)      cmd_url ;;
    json)     cmd_json ;;
    shell)    cmd_shell ;;
    regex)    cmd_regex ;;
    sql)      cmd_sql ;;
    double)   cmd_double ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "unescape v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
