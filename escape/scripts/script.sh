#!/usr/bin/env bash
# escape — String Escaping Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== String Escaping: Context is Everything ===

Escaping converts special characters into a safe representation
for a specific context. The SAME string needs DIFFERENT escaping
depending on where it's used.

The Core Problem:
  Data and code share the same channel.
  User input:  O'Malley  <script>alert(1)</script>  ; rm -rf /
  
  Without escaping:
    SQL:  SELECT * FROM users WHERE name = 'O'Malley'  ← SQL injection!
    HTML: <span>Hello <script>alert(1)</script></span> ← XSS!
    Shell: echo "file; rm -rf /"                        ← command injection!

The Rule:
  ALWAYS escape data for its OUTPUT context.
  NOT at input. NOT once globally. At every output boundary.

Context → Escaping Required:
  HTML body:       HTML entity encoding (&lt; &gt; &amp; &quot;)
  HTML attribute:  HTML entity encoding + quote properly
  URL parameter:   Percent encoding (%20 %3D %26)
  JavaScript:      JS string escaping (\' \" \\ \n)
  SQL:             Parameterized queries (NOT string escaping!)
  Shell:           Quote arguments (single quotes safest)
  Regex:           Backslash metacharacters (\. \* \+ \?)
  JSON:            JSON string escaping (\n \" \\ \uXXXX)
  XML/CDATA:       XML entity encoding or CDATA sections
  CSS:             CSS escaping (\XX hex codes)
  LDAP:            LDAP filter escaping (\2a \28 \29)

Anti-Pattern: "Sanitize once at input"
  ✗ You don't know all future output contexts at input time
  ✗ Over-escaping corrupts data (double-encoding)
  ✗ Under-escaping misses context-specific characters
  
  ✓ Store raw data, escape at each output point
  ✓ Use templates/frameworks that auto-escape (React, Jinja2)
EOF
}

cmd_html() {
    cat << 'EOF'
=== HTML Escaping ===

Five characters that MUST be escaped in HTML content:
  &  →  &amp;    (ampersand — starts entity references)
  <  →  &lt;     (less-than — starts tags)
  >  →  &gt;     (greater-than — ends tags)
  "  →  &quot;   (double quote — ends attribute values)
  '  →  &#x27;   (single quote — ends attribute values)

Context Matters — HTML has sub-contexts:

  HTML Body:
    <p>Hello, ESCAPED_DATA</p>
    Escape: &amp; &lt; &gt; minimum
    Risk: XSS via <script>, <img onerror=...>

  HTML Attribute (quoted):
    <input value="ESCAPED_DATA">
    Escape: &amp; &lt; &gt; &quot; minimum
    ALWAYS use quotes around attribute values!
    Risk: attribute injection

  HTML Attribute (unquoted):
    <input value=ESCAPED_DATA>
    NEVER do this! Space, >, / all break out.
    
  JavaScript in HTML:
    <script>var x = "ESCAPED_DATA";</script>
    HTML escaping is NOT enough here!
    Need JS string escaping + HTML escaping
    Better: don't inline user data in <script> tags
    Best: use data attributes + JS reading

  URL in href/src:
    <a href="ESCAPED_DATA">click</a>
    Must validate: starts with http:// or https://
    Block: javascript: data: vbscript: URLs!
    Then URL-encode the value

Library Functions:
  Python:   html.escape(s)                  # &amp; &lt; &gt; &quot; &#x27;
  Node.js:  DOMPurify.sanitize(html)        # full HTML sanitizer
  PHP:      htmlspecialchars($s, ENT_QUOTES) # with quote escaping
  Java:     StringEscapeUtils.escapeHtml4(s)
  Ruby:     ERB::Util.html_escape(s)         # aliased as h()
  Go:       html.EscapeString(s)
  React:    automatic! JSX escapes by default 
            (dangerouslySetInnerHTML bypasses — avoid!)

Content Security Policy (defense in depth):
  Content-Security-Policy: script-src 'self'
  Blocks inline scripts even if XSS exists
  Essential second layer of protection
EOF
}

cmd_url() {
    cat << 'EOF'
=== URL Encoding (Percent Encoding) ===

RFC 3986: Encode unsafe characters as %XX (hex byte value).

Reserved Characters (have meaning in URLs):
  :  /  ?  #  [  ]  @  !  $  &  '  (  )  *  +  ,  ;  =
  
  Must be encoded when used as DATA (not delimiters):
    ?search=hello%26world   ← & encoded as %26 (it's data, not separator)

Unreserved Characters (never need encoding):
  A-Z  a-z  0-9  -  _  .  ~

Common Encodings:
  Space  →  %20 (in path) or + (in query, form data)
  &      →  %26
  =      →  %3D
  /      →  %2F
  ?      →  %3F
  #      →  %23
  +      →  %2B
  @      →  %40
  :      →  %3A

Path vs Query Encoding:
  Path segment:   /users/John%20Doe/profile
    Encode everything except unreserved + : @ ! $ & ' ( ) * + , ; =
  
  Query parameter: ?name=John+Doe&city=San+Francisco
    Encode everything except unreserved
    Space can be + (application/x-www-form-urlencoded) or %20
  
  Fragment:        #section%202
    Same as query encoding rules

Library Functions:
  JavaScript:
    encodeURIComponent("a=b&c")  → "a%3Db%26c"  (encode for query VALUE)
    encodeURI(fullUrl)            → encode but keep :/?#[]@ etc.
    new URLSearchParams({q: "a&b"}).toString()  → "q=a%26b"
    
    DON'T use escape() — deprecated, doesn't handle Unicode properly
  
  Python:
    urllib.parse.quote("a=b&c")           → "a%3Db%26c"
    urllib.parse.quote_plus("hello world") → "hello+world"
    urllib.parse.urlencode({"q": "a&b"})  → "q=a%26b"
  
  Go:
    url.QueryEscape("a=b&c")    → "a%3Db%26c"
    url.PathEscape("hello world") → "hello%20world"

Double Encoding Bug:
  Input: "100%"
  First encode:  "100%25"
  Second encode: "100%2525"  ← double-encoded!
  
  Rule: encode ONCE at the boundary, never re-encode
  Debug: if you see %25 in URLs, something double-encoded
EOF
}

cmd_sql() {
    cat << 'EOF'
=== SQL Injection Prevention ===

SQL injection is one of the most dangerous and common vulnerabilities.
Rule #1: NEVER build SQL by string concatenation with user input.

The Problem:
  # VULNERABLE — never do this!
  query = f"SELECT * FROM users WHERE name = '{user_input}'"
  
  Input: O'Malley
  Query: SELECT * FROM users WHERE name = 'O'Malley'
  Result: SQL syntax error
  
  Input: ' OR '1'='1
  Query: SELECT * FROM users WHERE name = '' OR '1'='1'
  Result: returns ALL users!
  
  Input: '; DROP TABLE users;--
  Query: SELECT * FROM users WHERE name = ''; DROP TABLE users;--'
  Result: table deleted!

The Solution: Parameterized Queries (Prepared Statements)
  The database driver handles escaping. You pass data separately.

  Python (psycopg2):
    cursor.execute("SELECT * FROM users WHERE name = %s", (name,))
  
  Python (SQLAlchemy):
    db.execute(text("SELECT * FROM users WHERE name = :name"),
               {"name": name})
  
  Node.js (pg):
    await pool.query("SELECT * FROM users WHERE name = $1", [name]);
  
  Java (JDBC):
    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM users WHERE name = ?");
    ps.setString(1, name);
  
  Go:
    db.Query("SELECT * FROM users WHERE name = $1", name)
  
  PHP (PDO):
    $stmt = $pdo->prepare("SELECT * FROM users WHERE name = :name");
    $stmt->execute(['name' => $name]);

Dynamic Table/Column Names:
  Parameters DON'T work for identifiers (table/column names)!
  
  # Can't do: cursor.execute("SELECT * FROM %s", (table,))
  # Must whitelist:
  allowed_tables = {"users", "orders", "products"}
  if table_name not in allowed_tables:
      raise ValueError("Invalid table")
  query = f"SELECT * FROM {table_name} WHERE id = %s"

ORM Safety:
  ORMs generally protect against SQLi — BUT:
  ✗ Raw queries: Model.objects.raw(f"... {input}")  ← still vulnerable!
  ✗ Extra clauses: .extra(where=[f"name = '{input}'"])  ← vulnerable!
  ✓ ORM methods: Model.objects.filter(name=input)    ← safe
  ✓ Parameterized raw: Model.objects.raw("... %s", [input])  ← safe

LIKE Wildcards:
  Even with parameterized queries, LIKE has special chars:
  % → matches anything, _ → matches one char
  Input "100%" → LIKE '100%' matches "100", "1000", "100abc"
  Solution: escape % and _ in the parameter value
  PostgreSQL: LIKE $1 ESCAPE '\' + replace % with \%
EOF
}

cmd_shell() {
    cat << 'EOF'
=== Shell Escaping ===

Shell commands interpret many characters specially.
User input in shell commands → command injection.

Dangerous Characters:
  ;   command separator (cmd1; cmd2)
  |   pipe (cmd1 | cmd2)
  &   background (cmd &) or AND (cmd1 && cmd2)
  $   variable expansion ($HOME, $(cmd))
  `   command substitution (`cmd`)
  !   history expansion (bash)
  >   redirect output (> file)
  <   redirect input (< file)
  *   glob expansion (*.txt)
  ?   glob single char
  ~   home directory
  \n  newline (command separator)

Quoting Rules:

  Single quotes (strongest, safest):
    echo 'hello $world `cmd` $(rm -rf /)'
    → literally: hello $world `cmd` $(rm -rf /)
    Nothing is interpreted! (except ' itself)
    To include ': echo 'it'\''s'  → it's
  
  Double quotes (partial protection):
    echo "hello $world"
    → $world is expanded!
    Still dangerous: $, `, \, !, " are interpreted
    
  No quotes (no protection):
    echo hello $world *.txt
    → $world expanded, *.txt glob expanded
    NEVER use unquoted variables!

Best Practice — Don't Use Shell at All!
  Python:
    # BAD: os.system(f"convert {filename} output.png")
    # BAD: subprocess.run(f"convert {filename} output.png", shell=True)
    # GOOD: subprocess.run(["convert", filename, "output.png"])
    #        ↑ list form, no shell, no interpretation
  
  Node.js:
    // BAD: exec(`convert ${filename} output.png`)
    // GOOD: execFile("convert", [filename, "output.png"])
    // GOOD: spawn("convert", [filename, "output.png"])
  
  Go:
    // GOOD: exec.Command("convert", filename, "output.png")
  
  Ruby:
    // BAD: system("convert #{filename} output.png")
    // GOOD: system("convert", filename, "output.png")  # array form

If You Must Use Shell:
  Python:  shlex.quote(user_input)  → wraps in single quotes
  Ruby:    Shellwords.shellescape(input)
  PHP:     escapeshellarg($input)  → wraps in single quotes
  Bash:    printf '%q' "$variable"  → escapes for re-evaluation

Heredoc (safe for multi-line):
  cat << 'EOF'
  No $expansion or `substitution` here!
  EOF
  # Note: unquoted EOF allows expansion (dangerous with user data)
EOF
}

cmd_regex() {
    cat << 'EOF'
=== Regex Escaping ===

Regex metacharacters have special meaning and must be escaped
with \ when you want to match them literally.

Metacharacters to Escape:
  .   Any character        →  \.
  *   Zero or more         →  \*
  +   One or more          →  \+
  ?   Zero or one          →  \?
  ^   Start of line        →  \^
  $   End of line          →  \$
  |   Alternation (OR)     →  \|
  \   Escape character     →  \\
  (   Group start          →  \(
  )   Group end            →  \)
  [   Character class      →  \[
  ]   Character class end  →  \]
  {   Quantifier start     →  \{
  }   Quantifier end       →  \}

Inside Character Class []:
  Only these are special inside []:
  ]   close class     →  \] or put first: []]
  \   escape          →  \\
  ^   negate (if first) → \^ or not first: [a^]
  -   range (if middle) → \- or put first/last: [-a] or [a-]

Language Functions to Escape for Literal Match:

  Python:   re.escape("1+2=3")     → "1\+2\=3"
  JavaScript: str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
              // No built-in function! Use the regex above.
  Java:     Pattern.quote("1+2=3") → "\Q1+2=3\E"
  Go:       regexp.QuoteMeta("1+2=3") → "1\+2=3"
  Ruby:     Regexp.escape("1+2=3") → "1\\+2=3"
  PHP:      preg_quote("1+2=3", "/") → "1\+2\=3"
  C#:       Regex.Escape("1+2=3")  → "1\+2=3"

Common Mistakes:
  Searching for "." (period) without escaping:
    /hello.world/ matches "helloXworld" too!
    /hello\.world/ matches only "hello.world"
  
  Searching for "$" (dollar):
    /$100/ matches end-of-line followed by "100"
    /\$100/ matches literal "$100"
  
  Building regex from user input:
    user_input = "price is $5.00 (USD)"
    // WRONG: new RegExp(user_input)  → invalid/unintended regex
    // RIGHT: new RegExp(escapeRegex(user_input))

ReDoS (Regex Denial of Service):
  Catastrophic backtracking with evil input:
    Pattern: (a+)+ matched against "aaaaaaaaaaaaaaaa!"
    → exponential time!
  
  Vulnerable patterns: nested quantifiers (a+)+, (a|a)+, (a*)*
  Prevention: avoid nested quantifiers, use atomic groups, set timeouts
  Tools: safe-regex (npm), regexploit (Python)
EOF
}

cmd_json() {
    cat << 'EOF'
=== JSON String Escaping ===

JSON strings must be enclosed in double quotes.
These characters MUST be escaped inside JSON strings:

  "   →  \"     double quote
  \   →  \\     backslash
  /   →  \/     forward slash (optional but recommended)
  \b  →  \b     backspace (U+0008)
  \f  →  \f     form feed (U+000C)
  \n  →  \n     newline (U+000A)
  \r  →  \r     carriage return (U+000D)
  \t  →  \t     tab (U+0009)

Control characters (U+0000 to U+001F) MUST be escaped:
  \u0000 through \u001F

Unicode Escapes:
  \uXXXX   4-hex-digit Unicode code point
  \u00E9   → é (e with acute accent)
  \u4F60   → 你
  \u597D   → 好
  
  Surrogate pairs (for code points > U+FFFF):
    🎉 = U+1F389 → \uD83C\uDF89 (two \uXXXX escapes!)
    High surrogate: D800–DBFF, Low surrogate: DC00–DFFF

Edge Cases:

  Bare newline in JSON string → INVALID:
    {"text": "line1
    line2"}                      ← parse error!
    {"text": "line1\nline2"}     ← correct!
  
  Bare tab in JSON string → INVALID:
    {"text": "col1	col2"}    ← parse error (literal tab)!
    {"text": "col1\tcol2"}       ← correct!
  
  Emoji in JSON: valid as literal UTF-8 OR as escaped surrogate pair
    {"emoji": "🎉"}              ← valid (UTF-8 bytes)
    {"emoji": "\uD83C\uDF89"}   ← valid (escaped)

JSON vs JavaScript String:
  JSON allows: \uXXXX, standard escapes
  JSON forbids: single quotes, \x hex escapes, unescaped control chars
  JavaScript allows: all of JSON + 'strings', \xFF, template literals
  
  JSON is NOT a subset of JavaScript! (U+2028, U+2029 issue)
  Fixed in ES2019: JS now accepts U+2028/U+2029 in strings

Library Functions:
  Python:  json.dumps(string)          # handles all escaping
  Node.js: JSON.stringify(string)      # handles all escaping
  Go:      json.Marshal(string)        # handles all escaping
  
  NEVER manually build JSON strings by concatenation!
  ALWAYS use a JSON library — they handle escaping correctly.
EOF
}

cmd_unicode() {
    cat << 'EOF'
=== Unicode Escaping ===

Unicode: universal character encoding — 149,000+ characters.
UTF-8: variable-width encoding (1-4 bytes per character).

UTF-8 Byte Patterns:
  U+0000–U+007F:    0xxxxxxx              (1 byte, ASCII compatible)
  U+0080–U+07FF:    110xxxxx 10xxxxxx      (2 bytes)
  U+0800–U+FFFF:    1110xxxx 10xxxxxx 10xxxxxx  (3 bytes)
  U+10000–U+10FFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx (4 bytes)

  Examples:
    'A'  U+0041 → 0x41 (1 byte)
    'é'  U+00E9 → 0xC3 0xA9 (2 bytes)
    '你' U+4F60 → 0xE4 0xBD 0xA0 (3 bytes)
    '🎉' U+1F389 → 0xF0 0x9F 0x8E 0x89 (4 bytes)

Escape Syntax by Context:
  HTML:     &#x1F389; or &#127881; (decimal)
  CSS:      \1F389
  JSON:     \uD83C\uDF89 (surrogate pair) or raw UTF-8
  Python:   "\U0001F389" or "\N{PARTY POPPER}"
  Java:     "\uD83C\uDF89" (surrogate pair in UTF-16)
  JavaScript: "\u{1F389}" (ES6) or "\uD83C\uDF89"
  Rust:     '\u{1F389}' or "\u{1F389}"
  Go:       '\U0001F389' or "\U0001F389"
  C/C++:    u8"\U0001F389" (C++11 / C11)
  URL:      %F0%9F%8E%89 (percent-encoded UTF-8 bytes)

Surrogate Pairs (UTF-16 encoding for >U+FFFF):
  Code point: U+1F389
  Subtract: 0x1F389 - 0x10000 = 0xF389
  High: 0xD800 + (0xF389 >> 10) = 0xD83C
  Low:  0xDC00 + (0xF389 & 0x3FF) = 0xDF89
  Pair: \uD83C\uDF89

Unicode Normalization:
  Same visual character, different byte sequences!
  é = U+00E9 (precomposed) = U+0065 U+0301 (decomposed)
  
  Forms:
    NFC:  composed (é as single code point) — most common
    NFD:  decomposed (e + combining accent)
    NFKC: compatibility composed (ﬁ → fi)
    NFKD: compatibility decomposed
  
  Impact: string comparison, file names, database keys
  Rule: normalize to NFC before comparison/storage

Homoglyph Attacks:
  Characters that LOOK identical but are different code points:
    Latin 'a' (U+0061) vs Cyrillic 'а' (U+0430)
    Latin 'o' (U+006F) vs Greek 'ο' (U+03BF)
    apple.com vs аpple.com (Cyrillic а!)
  
  Defense: IDN (Internationalized Domain Names) Punycode
  Defense: confusable detection (Unicode Security Mechanisms)
  Defense: restrict to ASCII for usernames/identifiers
EOF
}

show_help() {
    cat << EOF
escape v$VERSION — String Escaping Reference

Usage: script.sh <command>

Commands:
  intro     Why escaping matters and context-specific rules
  html      HTML entity encoding and XSS prevention
  url       Percent encoding for URLs and query parameters
  sql       SQL injection prevention with parameterized queries
  shell     Shell quoting and command injection prevention
  regex     Regex metacharacter escaping
  json      JSON string escaping and Unicode in JSON
  unicode   UTF-8, surrogate pairs, normalization, homoglyphs
  help      Show this help
  version   Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)    cmd_intro ;;
    html)     cmd_html ;;
    url)      cmd_url ;;
    sql)      cmd_sql ;;
    shell)    cmd_shell ;;
    regex)    cmd_regex ;;
    json)     cmd_json ;;
    unicode)  cmd_unicode ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "escape v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
