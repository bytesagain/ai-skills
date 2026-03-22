#!/usr/bin/env bash
# truncate — Data Truncation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Truncation ===

Truncation removes data from the end (or middle) of a value,
reducing it to a shorter or smaller representation.

Truncate vs Round vs Floor vs Ceil:
  Value    Truncate  Round    Floor    Ceil
  3.7      3         4        3        4
  3.2      3         3        3        4
  -3.7     -3        -4       -4       -3
  -3.2     -3        -3       -4       -3

  Truncate:  Remove fractional part (toward zero)
  Round:     Nearest integer (away from zero at .5)
  Floor:     Largest integer ≤ value (toward -∞)
  Ceil:      Smallest integer ≥ value (toward +∞)

  Key difference:
    Truncate(-3.7) = -3  (toward zero)
    Floor(-3.7)    = -4  (toward -∞)

Domains of Truncation:
  Strings     "Hello World" → "Hello W..." (with ellipsis)
  Numbers     3.14159 → 3.14 (remove digits)
  Files       Shorten file to N bytes (discard the rest)
  Database    TRUNCATE TABLE — remove all rows (fast)
  Integers    Long → Int (discard high bits)
  Time        Truncate to day/hour (remove sub-units)

Why Truncation Matters:
  1. UI display (limited space for text)
  2. Performance (TRUNCATE vs DELETE in SQL)
  3. Data precision (floating-point limitations)
  4. Security (preventing buffer overflows)
  5. Storage management (log file rotation)
EOF
}

cmd_strings() {
    cat << 'EOF'
=== String Truncation ===

--- Basic Truncation with Ellipsis ---
  JavaScript:
    function truncate(str, maxLen) {
      if (str.length <= maxLen) return str;
      return str.slice(0, maxLen - 3) + '...';
    }
    truncate("Hello World", 8)  // "Hello..."

  Python:
    def truncate(s, max_len):
        return s[:max_len-3] + '...' if len(s) > max_len else s

--- Word-Boundary Truncation ---
  Don't cut mid-word:

  function truncateWords(str, maxLen) {
    if (str.length <= maxLen) return str;
    const truncated = str.slice(0, maxLen - 3);
    const lastSpace = truncated.lastIndexOf(' ');
    if (lastSpace === -1) return truncated + '...';
    return truncated.slice(0, lastSpace) + '...';
  }

  "The quick brown fox" (max 12) → "The quick..." (not "The quick...")

--- CSS Truncation (No JavaScript Needed) ---
  /* Single line truncation */
  .truncate {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 200px;
  }

  /* Multi-line truncation (clamp) */
  .clamp {
    display: -webkit-box;
    -webkit-line-clamp: 3;        /* show 3 lines */
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  /* Modern: line-clamp (Firefox 68+, Chrome 120+) */
  .clamp-modern {
    line-clamp: 3;
    overflow: hidden;
  }

--- Ellipsis Position ---
  Start:   ...llo World    (show end, useful for file paths)
  Middle:  Hello...World   (show start and end)
  End:     Hello Wo...     (most common)

  Middle truncation:
    function truncateMiddle(str, maxLen) {
      if (str.length <= maxLen) return str;
      const half = Math.floor((maxLen - 3) / 2);
      return str.slice(0, half) + '...' + str.slice(-half);
    }
    // "very/long/file/path/to/document.pdf"
    // → "very/long/...cument.pdf"

--- SQL String Truncation ---
  MySQL:    LEFT(column, 100)
  Postgres: SUBSTRING(column, 1, 100)  or  LEFT(column, 100)
  Oracle:   SUBSTR(column, 1, 100)

  With ellipsis:
    CASE WHEN LENGTH(col) > 100
         THEN LEFT(col, 97) || '...'
         ELSE col END
EOF
}

cmd_numbers() {
    cat << 'EOF'
=== Numeric Truncation ===

--- Integer Truncation (Toward Zero) ---
  JavaScript:  Math.trunc(3.7)   // 3
               Math.trunc(-3.7)  // -3
               3.7 | 0           // 3 (bitwise trick, 32-bit only!)
               ~~3.7             // 3 (double bitwise NOT)

  Python:      int(3.7)          # 3
               math.trunc(3.7)   # 3

  C/C++:       (int)3.7          // 3 (cast truncates)
  Rust:        3.7_f64 as i32    // 3
  Go:          int(3.7)          // 3

--- Decimal Place Truncation ---
  Truncate to N decimal places (NOT rounding):

  JavaScript:
    Math.trunc(3.14159 * 100) / 100  // 3.14 (2 decimals)

  Python:
    import math
    math.trunc(3.14159 * 100) / 100  # 3.14

  Rust:
    let n: f64 = 3.14159;
    let truncated = (n * 100.0).trunc() / 100.0;  // 3.14

--- Truncation vs Rounding in Finance ---
  ⚠ CRITICAL: Financial calculations must specify truncation or rounding.

  For $100 at 7% divided among 3 people:
    $100 × 0.07 = $7.00 / 3 = $2.333333...

    Truncate to cents:  $2.33 × 3 = $6.99  (penny lost!)
    Round to cents:     $2.33 × 3 = $6.99  (same problem)
    Banker's rounding:  $2.33, $2.33, $2.34 (remainder to last)

  Rule: Use integer arithmetic for money (store cents, not dollars).
        $7.00 → 700 cents / 3 = 233 remainder 1
        Distribute: 233, 233, 234

--- Floating-Point Truncation Hazards ---
  0.1 + 0.2 = 0.30000000000000004 (IEEE 754)

  Truncating 0.3... to 1 decimal:
    Math.trunc(0.30000000000000004 * 10) / 10 = 0.3 ✓ (lucky)

  But: Math.trunc(1.005 * 100) / 100 = 1.00  (should be 1.00, OK)
       Math.trunc(2.005 * 100) / 100 = 2.00  (expected 2.00, OK)
       BUT round(2.005 * 100) / 100 = 2.00   (expected 2.01!)

  Use Decimal/BigDecimal for precision-sensitive truncation.

--- Time Truncation ---
  Truncate datetime to day:
    Python:  dt.replace(hour=0, minute=0, second=0, microsecond=0)
    SQL:     DATE_TRUNC('day', timestamp)
    JS:      new Date(date.toDateString())

  DATE_TRUNC in PostgreSQL:
    DATE_TRUNC('month', '2024-03-15 14:30:00')
    → '2024-03-01 00:00:00'
EOF
}

cmd_sql() {
    cat << 'EOF'
=== SQL TRUNCATE TABLE ===

TRUNCATE TABLE removes ALL rows from a table instantly.

--- TRUNCATE vs DELETE ---
  ┌──────────────────┬───────────────────┬──────────────────┐
  │                  │ TRUNCATE          │ DELETE           │
  ├──────────────────┼───────────────────┼──────────────────┤
  │ Speed            │ Very fast         │ Slow (row by row)│
  │ Logged           │ Minimal logging   │ Full logging     │
  │ WHERE clause     │ No (all rows)     │ Yes (selective)  │
  │ Rollback         │ DDL (varies)      │ DML (yes)        │
  │ Identity reset   │ Yes (resets)      │ No (continues)   │
  │ Triggers         │ Not fired         │ Fired per row    │
  │ Foreign keys     │ May block         │ Cascades work    │
  │ Space reclaimed  │ Immediately       │ After VACUUM/etc │
  │ Permissions      │ ALTER TABLE       │ DELETE privilege  │
  │ Locking          │ Table-level       │ Row-level        │
  └──────────────────┴───────────────────┴──────────────────┘

--- Syntax ---
  TRUNCATE TABLE users;                    -- standard
  TRUNCATE TABLE users RESTART IDENTITY;   -- reset auto-increment (PG)
  TRUNCATE TABLE users CASCADE;            -- cascade to FK tables (PG)

--- Database Specifics ---

  PostgreSQL:
    TRUNCATE TABLE users, orders;          -- multiple tables
    TRUNCATE TABLE users CASCADE;          -- cascade to dependents
    TRUNCATE TABLE users RESTART IDENTITY; -- reset sequences
    Transactional DDL → CAN be rolled back in a transaction!

  MySQL:
    TRUNCATE TABLE users;
    Cannot TRUNCATE if table has FK references
    Resets AUTO_INCREMENT to 1
    Cannot be rolled back (implicit commit)

  SQL Server:
    TRUNCATE TABLE users;
    Cannot TRUNCATE if table is referenced by FK
    Can truncate specific partitions (SQL Server 2016+):
    TRUNCATE TABLE orders WITH (PARTITIONS (1, 3, 5));
    Minimal logging in simple/bulk-logged recovery

  Oracle:
    TRUNCATE TABLE users;
    TRUNCATE TABLE users DROP STORAGE;     -- release space
    TRUNCATE TABLE users REUSE STORAGE;    -- keep allocated space
    Cannot be rolled back (implicit commit)

--- When to Use TRUNCATE ---
  ✓ Clearing staging/temp tables
  ✓ Resetting test data
  ✓ ETL pipeline: clear then reload
  ✓ When you don't need WHERE or triggers

--- When to Use DELETE Instead ---
  ✓ Need WHERE clause (selective deletion)
  ✓ Need triggers to fire
  ✓ Need to cascade foreign keys
  ✓ Need rollback capability (MySQL, Oracle, SQL Server)
  ✓ Only removing subset of rows
EOF
}

cmd_files() {
    cat << 'EOF'
=== File Truncation ===

--- Linux truncate Command ---
  truncate -s 0 logfile.log          # truncate to 0 bytes (empty)
  truncate -s 100M largefile.dat     # truncate to exactly 100MB
  truncate -s +10M file.dat          # extend by 10MB (sparse)
  truncate -s -5M file.dat           # shrink by 5MB

  # Truncate multiple files:
  truncate -s 0 *.log

  # Alternative (shell redirect):
  > logfile.log                      # truncate to 0 bytes
  : > logfile.log                    # same (POSIX)
  cat /dev/null > logfile.log        # same

--- System Calls ---
  C:        ftruncate(fd, new_size);
  Python:   os.truncate('file.txt', 100)
            f.truncate(100)  # truncate open file
  Rust:     file.set_len(100)?;
  Go:       os.Truncate("file.txt", 100)
  Node.js:  fs.truncateSync('file.txt', 100)

--- Log Rotation (logrotate) ---
  /etc/logrotate.d/myapp:
    /var/log/myapp/*.log {
        daily
        rotate 7
        compress
        missingok
        notifempty
        copytruncate        # truncate original after copy
        # OR
        create 0640 www-data adm  # create new file, move old
    }

  copytruncate vs create:
    copytruncate: Copy content → truncate original. No reopen needed.
                  Risk: lines written between copy and truncate are lost.
    create:       Rename old → create new. Requires app to reopen/SIGHUP.
                  Safe: no data loss.

--- Sparse Files ---
  truncate -s 10G sparse.img
  ls -l sparse.img     # shows 10GB
  du -h sparse.img     # shows 0 (no actual blocks allocated)

  The file has a 10GB "size" but no disk space used.
  Reads from unwritten areas return zeros.
  Blocks allocated only when data is written.

  Use cases:
    - VM disk images (thin provisioning)
    - Database pre-allocation
    - Testing with large files

--- Safe Truncation Pattern ---
  # Don't do this (data loss if interrupted):
  truncate -s 0 important.log

  # Do this (atomic):
  cp important.log important.log.bak
  truncate -s 0 important.log

  # Or use log rotation tool (handles everything safely)
EOF
}

cmd_overflow() {
    cat << 'EOF'
=== Truncation and Overflow ===

--- Integer Type Truncation ---
  Assigning larger type to smaller type truncates high bits:

  C/C++:
    int32_t big = 300;
    int8_t small = (int8_t)big;    // 44 (300 mod 256 = 44)
    // 300 = 0x12C → truncate to 0x2C = 44

  Java:
    int i = 130;
    byte b = (byte)i;              // -126 (130 - 256 = -126, signed)

  Rust:
    let big: u32 = 300;
    let small: u8 = big as u8;    // 44 (wrapping truncation)
    // Rust warns about this with clippy

--- Silent Truncation Dangers ---
  Database:
    MySQL (strict mode OFF):
      INSERT INTO users (name) VALUES ('This is a very long name...');
      -- Silently truncated to column width!
      -- SET sql_mode='STRICT_TRANS_TABLES' to get error instead

  API responses:
    Server returns 64-bit ID: 9007199254740993
    JavaScript Number can only represent up to 2^53 safely
    JSON.parse truncates: 9007199254740992 (wrong!)
    Fix: Use BigInt or string IDs

--- Type Conversion Truncation ---
  Float → Int:
    C:      (int)3.99 = 3      (truncated, not rounded!)
    Python: int(3.99) = 3
    Rust:   3.99f64 as i32 = 3

  Double → Float:
    double d = 1.23456789012345;
    float f = (float)d;          // 1.234568 (precision lost)

--- Buffer Truncation (Security) ---
  C:
    char buf[10];
    strncpy(buf, input, sizeof(buf) - 1);
    buf[sizeof(buf) - 1] = '\0';  // ensure null termination!

    // snprintf returns needed length:
    int needed = snprintf(buf, sizeof(buf), "%s", input);
    if (needed >= sizeof(buf))
        // truncation occurred!

--- Preventing Silent Truncation ---
  1. Enable strict mode in databases
  2. Use fixed-size types consistently (u32 everywhere, not mix)
  3. Check return values of snprintf
  4. Use Rust's checked conversions:
     let small: u8 = big.try_into()?;  // returns Err if truncated
  5. Use BigInt for large integers in JavaScript
  6. Set compiler warnings: -Wconversion (GCC/Clang)
EOF
}

cmd_unicode() {
    cat << 'EOF'
=== Unicode-Safe Truncation ===

The Problem:
  "Hello 👋🏽 World".slice(0, 8)
  // "Hello 👋"  — might cut emoji in half!
  // "👋🏽" is 2 code points: 👋 (U+1F44B) + 🏽 (U+1F3FD skin tone)

--- Code Points vs Code Units vs Grapheme Clusters ---
  String:  "é" can be:
    1 code point:  U+00E9 (precomposed)
    2 code points: U+0065 + U+0301 (e + combining accent)

  "👨‍👩‍👧‍👦" (family emoji):
    7 code points: 👨 + ZWJ + 👩 + ZWJ + 👧 + ZWJ + 👦
    1 grapheme cluster (what humans see as one character)

  Truncation must respect GRAPHEME CLUSTERS, not code points!

--- JavaScript ---
  // BAD: may split multi-byte characters
  str.slice(0, n)

  // BETTER: Intl.Segmenter (grapheme-aware)
  function truncateGraphemes(str, maxGraphemes) {
    const segmenter = new Intl.Segmenter('en', { granularity: 'grapheme' });
    const segments = [...segmenter.segment(str)];
    if (segments.length <= maxGraphemes) return str;
    return segments.slice(0, maxGraphemes - 1)
                   .map(s => s.segment).join('') + '…';
  }

--- Python ---
  # Code-point safe (Python strings are Unicode):
  s[:10]  # safe for code points but NOT for grapheme clusters

  # Grapheme-safe:
  import grapheme
  grapheme.slice(text, 0, 10)  # pip install grapheme

  # Or with regex:
  import regex
  clusters = regex.findall(r'\X', text)  # \X = grapheme cluster
  truncated = ''.join(clusters[:10])

--- Rust ---
  // Code-point aware:
  s.chars().take(10).collect::<String>()

  // Grapheme-aware (unicode-segmentation crate):
  use unicode_segmentation::UnicodeSegmentation;
  s.graphemes(true).take(10).collect::<String>()

--- Byte-Length Truncation (UTF-8 Safe) ---
  UTF-8 multi-byte sequence detection:
    Byte starts with 0xxxxxxx → single byte (ASCII)
    Byte starts with 110xxxxx → 2-byte sequence start
    Byte starts with 1110xxxx → 3-byte sequence start
    Byte starts with 11110xxx → 4-byte sequence start
    Byte starts with 10xxxxxx → continuation byte

  Safe truncation: never cut at a continuation byte.

  fn truncate_utf8(s: &str, max_bytes: usize) -> &str {
      if s.len() <= max_bytes { return s; }
      let mut end = max_bytes;
      while !s.is_char_boundary(end) { end -= 1; }
      &s[..end]
  }

--- Database Column Truncation ---
  VARCHAR(100) in PostgreSQL = 100 characters (code points)
  VARCHAR(100) in MySQL = 100 characters (grapheme-dependent)
  NVARCHAR(100) in SQL Server = 100 code units (UTF-16)

  Always test with emoji and accented characters!
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Truncation Patterns ===

--- Responsive Truncation ---
  Adjust truncation length based on container width:

  /* CSS: single line with ellipsis */
  .truncate { text-overflow: ellipsis; overflow: hidden; white-space: nowrap; }

  /* JS: resize observer for dynamic truncation */
  const observer = new ResizeObserver(entries => {
    for (const entry of entries) {
      const chars = Math.floor(entry.contentRect.width / 8);
      entry.target.textContent = truncate(fullText, chars);
    }
  });

--- Smart Truncation (Context-Aware) ---
  // Truncate URL, keeping domain visible:
  // "https://example.com/very/long/path/to/page.html" (max 35)
  // → "example.com/very/.../page.html"

  // Truncate file path, keeping filename:
  // "/home/user/documents/project/src/main.ts" (max 25)
  // → ".../project/src/main.ts"

  // Truncate email, keeping domain:
  // "very.long.email.address@example.com" (max 20)
  // → "very.lon...@example.com"

--- Truncation with "Show More" ---
  <div class="content">
    <p class="preview">First 200 characters...</p>
    <p class="full hidden">Full content here...</p>
    <button class="toggle">Show more</button>
  </div>

--- Number Truncation for Display ---
  1,234,567 → "1.2M"
  45,678    → "45.7K"
  999       → "999"

  function abbreviateNumber(n) {
    if (n >= 1e9) return (n / 1e9).toFixed(1) + 'B';
    if (n >= 1e6) return (n / 1e6).toFixed(1) + 'M';
    if (n >= 1e3) return (n / 1e3).toFixed(1) + 'K';
    return n.toString();
  }

--- Hash Truncation ---
  Full SHA-256: a591a6d40bf420404a011733cfb7b190...
  Truncated:    a591a6d4 (first 8 hex chars = 32 bits)

  Git uses 7 chars by default: a591a6d
  Collision probability: ~50% at √(2^28) ≈ 16K commits

  Rule of thumb for truncated hashes:
    7 chars: safe up to ~10K items
    8 chars: safe up to ~65K items
    12 chars: safe up to ~16M items

--- Truncation in APIs ---
  GraphQL: Request only fields you need (no truncation needed)
  REST: ?fields=id,name,summary (sparse fieldsets)
  Pagination: first=10&offset=0 (truncate result set)

  List truncation:
    { items: [...first10], total: 1547, hasMore: true }
EOF
}

show_help() {
    cat << EOF
truncate v$VERSION — Data Truncation Reference

Usage: script.sh <command>

Commands:
  intro        Truncate vs round, domains of truncation
  strings      String truncation: ellipsis, word-boundary, CSS
  numbers      Numeric truncation: float→int, precision, finance
  sql          SQL TRUNCATE TABLE vs DELETE, per-database behavior
  files        File truncation: truncate cmd, logrotate, sparse
  overflow     Integer overflow, silent truncation, prevention
  unicode      Unicode-safe truncation: grapheme clusters, UTF-8
  patterns     Smart truncation: responsive, URLs, numbers, hashes
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    strings)   cmd_strings ;;
    numbers)   cmd_numbers ;;
    sql)       cmd_sql ;;
    files)     cmd_files ;;
    overflow)  cmd_overflow ;;
    unicode)   cmd_unicode ;;
    patterns)  cmd_patterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "truncate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
