#!/usr/bin/env bash
# trim — Data Trimming Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Trimming — Overview ===

Trimming is the process of removing unwanted elements from the
edges or extremes of data — whitespace from strings, outliers
from datasets, noise from signals.

Types of Trimming:

  String Trimming
    Remove leading/trailing whitespace or specific characters
    Most common: trim(), strip(), ltrim(), rtrim()

  Numeric Trimming
    Remove extreme values (outliers) from datasets
    Methods: percentile clipping, z-score filtering, winsorizing

  Text Cleaning
    Remove invisible characters, BOM, control characters
    Normalize Unicode, fix encoding issues

  Signal Trimming
    Remove noise, clip amplitude, smooth edges
    Window functions, moving averages, low-pass filters

  Data Truncation
    Shorten data to fit constraints (column width, buffer size)
    May lose information — handle carefully

When to Trim:
  ✓ User input (always trim form inputs)
  ✓ CSV/Excel imports (often have trailing spaces)
  ✓ Database cleanup (legacy data with padding)
  ✓ API responses (inconsistent formatting)
  ✓ Statistical analysis (outlier removal)
  ✓ Log parsing (strip timestamps, levels)

When NOT to Trim:
  ✗ Passwords (spaces may be intentional)
  ✗ Code/source files (indentation matters)
  ✗ Binary data (every byte counts)
  ✗ Pre-formatted text (markdown, ASCII art)
  ✗ Cryptographic data (integrity depends on exact bytes)

Trim vs Strip vs Truncate:
  Trim       Remove from both ends (usually whitespace)
  Strip      Same as trim (Python/Ruby terminology)
  Truncate   Cut to maximum length (lose data)
  Clip       Limit values to range (numeric)
  Chomp      Remove trailing newline only (Perl/Ruby)
EOF
}

cmd_string() {
    cat << 'EOF'
=== String Trimming ===

Basic Whitespace Trimming:
  Leading:   "  hello"   → "hello"      (ltrim/lstrip)
  Trailing:  "hello  "   → "hello"      (rtrim/rstrip)
  Both:      "  hello  " → "hello"      (trim/strip)

What Counts as Whitespace:
  Space      (U+0020)   Standard space
  Tab        (U+0009)   Horizontal tab
  Newline    (U+000A)   Line feed
  CR         (U+000D)   Carriage return
  NBSP       (U+00A0)   Non-breaking space (often missed!)
  Zero-width (U+200B)   Zero-width space (invisible)
  Form feed  (U+000C)   Form feed
  Vertical tab (U+000B) Vertical tab
  
  Warning: Many trim functions only handle ASCII whitespace
  Unicode-aware trimming must handle NBSP, ideographic space, etc.

Character-Specific Trimming:
  Remove specific characters from edges
  Python: "###hello###".strip("#") → "hello"
  Ruby: "hello\n".chomp → "hello" (newline only)
  SQL: TRIM(BOTH '#' FROM '###hello###') → 'hello'

Internal Whitespace Normalization:
  Collapse multiple spaces to single:
    "hello    world" → "hello world"
  Regex: s/\s+/ /g (replace multiple whitespace with single space)
  Python: " ".join(text.split())
  
  Normalize line endings:
    \r\n → \n (Windows to Unix)
    \r → \n (old Mac to Unix)

Null Byte Trimming:
  Remove NUL characters (U+0000)
  Common in: C strings, database imports, binary-text boundaries
  Important: NUL can cause truncation in some languages

Trimming by Pattern:
  Remove prefix: "data:image/png;base64,..." → strip prefix
  Remove suffix: "file.txt.bak" → remove .bak
  Remove enclosing: "'hello'" → strip quotes
  Remove HTML tags: "<p>text</p>" → "text"
  Remove ANSI codes: "\033[31mred\033[0m" → "red"

Language Quick Reference:
  Python:   s.strip() / s.lstrip() / s.rstrip()
  JS:       s.trim() / s.trimStart() / s.trimEnd()
  Java:     s.trim() / s.strip() (Java 11+, Unicode-aware)
  C#:       s.Trim() / s.TrimStart() / s.TrimEnd()
  Go:       strings.TrimSpace(s) / strings.Trim(s, chars)
  Rust:     s.trim() / s.trim_start() / s.trim_end()
  Ruby:     s.strip / s.lstrip / s.rstrip / s.chomp
  PHP:      trim($s) / ltrim($s) / rtrim($s)
  Bash:     "${s#"${s%%[![:space:]]*}"}" (parameter expansion)
EOF
}

cmd_numeric() {
    cat << 'EOF'
=== Numeric Trimming ===

Outlier Detection and Removal:

Z-Score Method:
  Remove values more than N standard deviations from mean
  Typical threshold: |z| > 3 (99.7% of normal data)
  Formula: z = (x - μ) / σ
  
  Pros: Simple, well-understood
  Cons: Assumes normal distribution, sensitive to outliers themselves
  
  Python:
    from scipy import stats
    z = np.abs(stats.zscore(data))
    filtered = data[z < 3]

IQR Method (Interquartile Range):
  Q1 = 25th percentile, Q3 = 75th percentile
  IQR = Q3 - Q1
  Lower fence = Q1 - 1.5 × IQR
  Upper fence = Q3 + 1.5 × IQR
  Remove values outside fences
  
  Pros: Robust to non-normal distributions
  Cons: May be too aggressive for skewed data
  
  Python:
    Q1 = data.quantile(0.25)
    Q3 = data.quantile(0.75)
    IQR = Q3 - Q1
    filtered = data[(data >= Q1-1.5*IQR) & (data <= Q3+1.5*IQR)]

Percentile Clipping:
  Remove top and bottom N% of values
  Example: Trim 1% from each tail (keep 1st-99th percentile)
  
  Python:
    lower = data.quantile(0.01)
    upper = data.quantile(0.99)
    trimmed = data[(data >= lower) & (data <= upper)]

Winsorizing:
  Like clipping but REPLACE extreme values instead of removing
  Set extremes to the boundary value
  Preserves dataset size (important for some analyses)
  
  Python (scipy):
    from scipy.stats.mstats import winsorize
    result = winsorize(data, limits=[0.05, 0.05])

Trimmed Mean:
  Calculate mean after removing extreme values
  Example: 10% trimmed mean = drop top and bottom 10%, then average
  More robust than mean, more efficient than median
  
  Python: scipy.stats.trim_mean(data, proportiontocut=0.1)

MAD Method (Median Absolute Deviation):
  MAD = median(|xi - median(x)|)
  Modified z-score = 0.6745 × (xi - median) / MAD
  Remove if |modified z-score| > 3.5
  Most robust method (resistant to outlier influence)

Best Practices:
  1. Visualize before trimming (histogram, box plot)
  2. Document trimming criteria and how many removed
  3. Compare results with and without trimming
  4. Consider: Are "outliers" actually valid data?
  5. Domain knowledge > statistical rules
EOF
}

cmd_text() {
    cat << 'EOF'
=== Text Data Cleaning ===

BOM (Byte Order Mark) Removal:
  UTF-8 BOM: EF BB BF (3 bytes at file start)
  UTF-16 BOM: FF FE or FE FF
  Problem: Appears as invisible character, breaks parsers
  
  Detection and removal:
    Bash: sed '1s/^\xEF\xBB\xBF//' file.txt
    Python: text.encode().lstrip(b'\xef\xbb\xbf').decode()
    Node: text.replace(/^\uFEFF/, '')

Control Character Removal:
  ASCII 0-31 (except 9=tab, 10=LF, 13=CR):
    Characters 0-8, 11, 12, 14-31 are control characters
    Rarely meaningful in text data
    
  Remove: regex [^\x20-\x7E\x09\x0A\x0D] (keep printable + tab/newline)
  
  Common offenders:
    \x00  NUL   Null character (C string terminator)
    \x01  SOH   Sometimes used as field separator
    \x1B  ESC   ANSI escape sequences
    \x7F  DEL   Delete character

Unicode Normalization:
  NFC:  Composed form (é = single code point U+00E9)
  NFD:  Decomposed form (é = e + combining accent U+0065 U+0301)
  NFKC: Compatibility composed (ﬁ → fi)
  NFKD: Compatibility decomposed
  
  Rule: Normalize to NFC for storage and comparison
  Python: unicodedata.normalize('NFC', text)
  
  Why it matters:
    "café" (NFC) ≠ "café" (NFD) in byte comparison
    But they look identical to humans

Invisible Character Removal:
  Zero-width space:       U+200B
  Zero-width joiner:      U+200D
  Zero-width non-joiner:  U+200C
  Left-to-right mark:     U+200E
  Right-to-left mark:     U+200F
  Soft hyphen:            U+00AD
  Word joiner:            U+2060
  
  These cause: search failures, comparison failures, display issues
  Often injected by: copy-paste from web, Word documents, PDFs

Encoding Cleanup:
  Mojibake: Text displayed with wrong encoding
    "CafÃ©" = UTF-8 bytes displayed as Latin-1
  
  Fix:
    1. Detect actual encoding (chardet, file command)
    2. Decode with correct encoding
    3. Re-encode as UTF-8
    
  Python:
    import chardet
    detected = chardet.detect(raw_bytes)
    text = raw_bytes.decode(detected['encoding'])

HTML Entity Cleanup:
  &amp; → &
  &lt; → <
  &gt; → >
  &quot; → "
  &#39; → '
  &#x27; → '
  
  Python: html.unescape(text)
  JS: Use DOMParser or textarea trick
EOF
}

cmd_database() {
    cat << 'EOF'
=== Database Trimming ===

SQL TRIM Functions:

  Standard SQL:
    TRIM(string)                    -- both sides, spaces
    TRIM(LEADING FROM string)       -- left side
    TRIM(TRAILING FROM string)      -- right side
    TRIM(BOTH 'x' FROM string)     -- specific character

  PostgreSQL:
    TRIM(string)                    -- whitespace
    BTRIM(string, chars)            -- both sides, specific chars
    LTRIM(string, chars)            -- left
    RTRIM(string, chars)            -- right
    REGEXP_REPLACE(s, '^\s+|\s+$', '', 'g')  -- regex trim

  MySQL:
    TRIM(string)
    LTRIM(string)
    RTRIM(string)
    TRIM(BOTH char FROM string)

  SQL Server:
    LTRIM(RTRIM(string))            -- both sides (pre-2017)
    TRIM(string)                    -- SQL Server 2017+
    TRIM(chars FROM string)         -- SQL Server 2017+

Bulk Data Cleanup:
  -- Trim all varchar columns in a table
  UPDATE customers
  SET name = TRIM(name),
      email = LOWER(TRIM(email)),
      phone = REGEXP_REPLACE(TRIM(phone), '[^0-9]', '', 'g');

  -- Find rows with leading/trailing whitespace
  SELECT * FROM customers
  WHERE name != TRIM(name);

  -- Count affected rows before updating
  SELECT COUNT(*) FROM customers
  WHERE name != TRIM(name)
     OR email != TRIM(email);

CHAR vs VARCHAR Padding:
  CHAR(10):    'hello     ' (padded with spaces to 10)
  VARCHAR(10): 'hello'      (no padding)
  
  Gotcha: CHAR columns always right-padded with spaces
  Fix: RTRIM when comparing or migrating CHAR to VARCHAR
  Migration: ALTER TABLE t ALTER COLUMN c TYPE VARCHAR(50);

Data Type Considerations:
  Numbers stored as strings: TRIM then CAST
    SELECT CAST(TRIM(price_str) AS DECIMAL(10,2))
  
  Dates stored as strings: TRIM then PARSE
    SELECT TO_DATE(TRIM(date_str), 'YYYY-MM-DD')
  
  NULLs: TRIM(NULL) returns NULL
    Use COALESCE: COALESCE(TRIM(name), '')

Performance Tips:
  - Add WHERE clause to limit affected rows
  - Batch large updates (1000-10000 rows at a time)
  - Create index on trimmed value for searching
  - Consider computed/generated columns for trimmed values
  - Add CHECK constraint to prevent future whitespace
    ALTER TABLE t ADD CONSTRAINT chk_name CHECK (name = TRIM(name));
EOF
}

cmd_signal() {
    cat << 'EOF'
=== Signal & Time-Series Trimming ===

Amplitude Clipping:
  Limit signal values to a range [min, max]
  Values beyond range set to the boundary value
  
  Hard clipping:
    if x > max: x = max
    if x < min: x = min
  
  Soft clipping (sigmoid):
    Smooth transition near boundaries
    tanh(x) for symmetric clipping
    Used in audio to avoid harsh distortion
  
  numpy: np.clip(signal, -1.0, 1.0)

Moving Average (Smoothing):
  Simple Moving Average (SMA):
    Average of last N values
    Removes high-frequency noise
    Lag: N/2 time steps
    
  Exponential Moving Average (EMA):
    Recent values weighted more heavily
    EMA = α × current + (1-α) × previous_EMA
    Less lag than SMA

  Weighted Moving Average (WMA):
    Custom weights for each position in window

Noise Floor Trimming:
  Remove signal below a threshold (considered noise)
  Common in audio:
    - Noise gate: Mute signal below threshold
    - Expander: Reduce (not mute) signal below threshold
  
  Spectral: Remove frequency components below noise floor
  
  Threshold selection:
    - Measure noise during silence
    - Set threshold 6-10dB above noise floor

Edge Trimming (Time-Series):
  Remove startup transients:
    First N samples may be unreliable (sensor warmup)
    Remove initial stabilization period
  
  Remove trailing data:
    After shutdown or end of experiment
    After quality degrades (sensor failure)
  
  Trim to analysis window:
    Start/end at specific timestamps
    Align to external events

Spike Removal:
  Detect and remove impulse noise / glitches
  Methods:
    - Median filter: Replace each value with median of neighbors
    - Threshold: Remove values > N × standard deviation from local mean
    - Hampel filter: Uses median absolute deviation for robust detection
  
  Important: Don't remove real peaks!
    Use domain knowledge to distinguish spikes from valid data

Decimation (Downsampling):
  Reduce sample rate by keeping every Nth sample
  Must apply anti-aliasing filter first (low-pass)
  Without filter → aliasing artifacts
  
  Process:
    1. Low-pass filter at new_rate/2 (Nyquist)
    2. Take every Nth sample
    3. Verify no aliasing in frequency domain
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Practical Trimming Examples ===

--- Bash ---
# Trim whitespace from variable
trimmed=$(echo "  hello  " | xargs)

# Trim using parameter expansion
var="  hello  "
var="${var#"${var%%[![:space:]]*}"}"   # ltrim
var="${var%"${var##*[![:space:]]}"}"   # rtrim

# Trim BOM from file
sed -i '1s/^\xEF\xBB\xBF//' file.txt

# Trim blank lines from beginning/end of file
sed -i '/./,$!d' file.txt        # leading blank lines
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' file.txt  # trailing

--- Python ---
# Basic trim
"  hello  ".strip()           # 'hello'
"  hello  ".lstrip()          # 'hello  '
"  hello  ".rstrip()          # '  hello'

# Trim specific characters
"###hello###".strip("#")      # 'hello'
"hello\n\r".strip()           # 'hello'

# Normalize whitespace
" ".join("  hello   world  ".split())  # 'hello world'

# Trim outliers (pandas)
import pandas as pd
q_low = df['col'].quantile(0.01)
q_high = df['col'].quantile(0.99)
df_trimmed = df[(df['col'] >= q_low) & (df['col'] <= q_high)]

--- JavaScript ---
"  hello  ".trim()           // 'hello'
"  hello  ".trimStart()      // 'hello  '
"  hello  ".trimEnd()        // '  hello'

// Trim and normalize
str.replace(/^\s+|\s+$/g, '')     // trim
str.replace(/\s+/g, ' ').trim()   // normalize whitespace

--- SQL ---
-- Cleanup user input
UPDATE users
SET email = LOWER(TRIM(email)),
    name = TRIM(REGEXP_REPLACE(name, '\s+', ' ', 'g'));

-- Find padded data
SELECT id, name, LENGTH(name), LENGTH(TRIM(name))
FROM users
WHERE name != TRIM(name);

--- Data Pipeline ---
# Full text cleaning pipeline
import unicodedata, re, html

def clean_text(text):
    text = text.strip()                          # 1. Trim whitespace
    text = unicodedata.normalize('NFC', text)    # 2. Normalize Unicode
    text = html.unescape(text)                   # 3. Decode HTML entities
    text = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]', '', text)  # 4. Control chars
    text = re.sub(r'\s+', ' ', text)             # 5. Normalize spaces
    return text
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Trimming Pitfalls & Best Practices ===

Pitfall 1: Trimming Passwords
  NEVER trim user passwords!
  "  my password  " is a valid password
  Leading/trailing spaces are intentional
  Only trim: usernames, emails, search queries

Pitfall 2: Non-Breaking Spaces (NBSP)
  Many trim() functions DON'T remove NBSP (U+00A0)
  Common source: copy-paste from Word, websites
  JavaScript trim() handles NBSP
  Java trim() does NOT (use strip() in Java 11+)
  Always test with NBSP in your data

Pitfall 3: Over-Trimming Numeric Data
  Removing "outliers" that are actually valid
  Example: Removing all incomes > $1M (they're real!)
  Rule: Understand your data before trimming
  Always justify why a value is invalid, not just unusual

Pitfall 4: Trimming Before Validation
  User enters "  " (just spaces)
  After trim: "" (empty string)
  Validation passes if you don't check for empty
  Rule: Trim THEN validate (including empty check)

Pitfall 5: Lossy Truncation
  Truncating UTF-8 at byte boundary → corrupted characters
  "Hello 世界" truncated at 8 bytes → "Hello \xe4\xb8" (broken)
  Always truncate at character or grapheme boundary
  Python: text[:max_chars] (character-safe)
  But emoji: "👨‍👩‍👧‍👦" is 1 grapheme, 7 code points, 25 bytes!

Pitfall 6: Database CHAR Type Surprises
  CHAR(50) stores "hello" as "hello" + 45 spaces
  Comparing CHAR to VARCHAR may fail unexpectedly
  PostgreSQL: CHAR = is space-padded aware
  MySQL: Depends on collation settings
  Best practice: Use VARCHAR, not CHAR

Pitfall 7: Trimming in Wrong Order
  Pipeline: trim → lowercase → remove punctuation
  Not: remove punctuation → trim (punctuation at edges gone first)
  Order matters for consistent results

Best Practices:
  1. Trim at input boundaries (forms, APIs, file imports)
  2. Store clean data (don't trim at query time)
  3. Validate AFTER trimming
  4. Log how many values were modified by trimming
  5. Use Unicode-aware trim functions
  6. Test with edge cases: empty string, all whitespace, NBSP
  7. Document your trimming policy (what gets trimmed where)
  8. Never trim binary data or passwords
EOF
}

show_help() {
    cat << EOF
trim v$VERSION — Data Trimming Reference

Usage: script.sh <command>

Commands:
  intro      Trimming concepts, types, and when to use
  string     String trimming — whitespace, characters, patterns
  numeric    Numeric trimming — outliers, clipping, winsorizing
  text       Text cleaning — encoding, BOM, invisible characters
  database   Database trimming — SQL functions, CHAR vs VARCHAR
  signal     Signal trimming — noise removal, smoothing, clipping
  examples   Practical examples across languages
  pitfalls   Common pitfalls and best practices
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)    cmd_intro ;;
    string)   cmd_string ;;
    numeric)  cmd_numeric ;;
    text)     cmd_text ;;
    database) cmd_database ;;
    signal)   cmd_signal ;;
    examples) cmd_examples ;;
    pitfalls) cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "trim v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
