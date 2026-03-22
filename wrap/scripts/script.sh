#!/usr/bin/env bash
# wrap — Text & Data Wrapping Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Wrapping ===

Wrapping is the operation of enclosing something — breaking text into
lines, encapsulating values in containers, or adding behavior via decoration.

Three Domains:
  1. Text Wrapping    Breaking long text into lines at word boundaries
  2. Value Wrapping   Enclosing values in container types (Option, Box)
  3. Pattern Wrapping Decorator pattern — adding behavior around objects

Text Wrapping — The Core Problem:
  Given a string and a maximum line width, insert line breaks
  so no line exceeds the width, breaking at word boundaries.

  Input:   "The quick brown fox jumps over the lazy dog" (width=20)
  Output:  "The quick brown fox\njumps over the lazy\ndog"

Two Main Algorithms:
  Greedy:        Fill each line as much as possible, then break.
                 Simple, fast, but produces ragged right edge.

  Optimal:       Minimize total "badness" across all lines.
                 Better visual quality, used in TeX/LaTeX.
                 Knuth-Plass algorithm (dynamic programming).

Where Wrapping Happens:
  Terminal:  80-column wrap (fold, fmt commands)
  Browser:   CSS word-wrap, overflow-wrap
  Editor:    Soft wrap (visual) vs hard wrap (newlines inserted)
  Print:     TeX/LaTeX Knuth-Plass algorithm
  Email:     RFC 5322: 78 chars recommended, 998 max
  Code:      Linter wrap rules (80, 100, 120 chars)
  Markdown:  Semantic line breaks vs hard wrap at 80
EOF
}

cmd_text() {
    cat << 'EOF'
=== Text Wrapping Algorithms ===

--- Greedy Algorithm ---
  For each word:
    If it fits on current line → add it
    Otherwise → start a new line

  Pseudocode:
    line = ""
    for word in words:
        if len(line) + 1 + len(word) <= width:
            line += " " + word
        else:
            output(line)
            line = word
    output(line)

  Properties:
    Time:    O(n) — single pass through words
    Space:   O(width) — current line buffer
    Quality: Can produce very ragged right edges
    Use for: Terminals, plain text, real-time display

--- Knuth-Plass Algorithm (Optimal) ---
  Used in TeX/LaTeX. Minimizes total "badness" using dynamic programming.

  Badness of a line:
    badness = (extra_space / shrinkability)³
    Perfectly full line: badness = 0
    Very loose line: badness = 10000
    Overfull line: badness = ∞ (infinitely bad)

  Penalty for breaking at certain points:
    After hyphen: small penalty
    Before last word of paragraph: high penalty (avoid orphans)
    At explicit break: no penalty

  Algorithm:
    1. Build graph: each possible breakpoint is a node
    2. Edge weight = badness of line between two breakpoints
    3. Find minimum-cost path from start to end (DP)

  Properties:
    Time:    O(n²) in theory, O(n) with pruning in practice
    Space:   O(n) — stores best breakpoints
    Quality: Beautiful, even right margins
    Use for: Books, typeset documents, high-quality PDF

--- Minimum Raggedness ---
  Simplified version of Knuth-Plass.
  Minimize sum of (unused space)² for all lines.

  Dynamic programming:
    cost[i] = min over all j < i of:
      cost[j] + (width - line_length(j+1, i))²

  Easier to implement than full Knuth-Plass.
  Good quality, used in many text formatters.

--- Hyphenation ---
  Allows breaking words at syllable boundaries.
  Reduces raggedness by enabling more break opportunities.

  TeX uses Liang's hyphenation algorithm:
    Pattern-based: "hy-phen-ation" → break points
    Language-specific patterns (en, de, fr, etc.)

  CSS: hyphens: auto;
  Libraries: hypher (JS), pyphen (Python), hyphenation (Rust)
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Text Wrapping ===

--- overflow-wrap (word-wrap) ---
  overflow-wrap: normal;     /* break only at allowed points */
  overflow-wrap: break-word; /* break unbreakable words if needed */
  overflow-wrap: anywhere;   /* like break-word + affects min-content */

  word-wrap is the legacy name (same as overflow-wrap).

--- word-break ---
  word-break: normal;        /* default breaking rules */
  word-break: break-all;     /* break between ANY two characters */
  word-break: keep-all;      /* don't break CJK words */
  word-break: break-word;    /* DEPRECATED, use overflow-wrap */

  break-all vs break-word:
    break-all:   breaks mid-word eagerly (fills every line)
    break-word:  breaks mid-word only as last resort

--- white-space ---
  white-space: normal;       /* collapse whitespace, wrap text */
  white-space: nowrap;       /* collapse whitespace, NO wrap */
  white-space: pre;          /* preserve whitespace, NO wrap */
  white-space: pre-wrap;     /* preserve whitespace, wrap */
  white-space: pre-line;     /* collapse spaces, preserve newlines, wrap */
  white-space: break-spaces; /* like pre-wrap, spaces preserved at line end */

  ┌─────────────┬──────────┬────────┬──────────┬────────┐
  │             │ Collapse │ Wrap   │ Preserve │ Preserve│
  │             │ spaces   │ text   │ newlines │ spaces  │
  ├─────────────┼──────────┼────────┼──────────┼─────────┤
  │ normal      │ Yes      │ Yes    │ No       │ No      │
  │ nowrap      │ Yes      │ No     │ No       │ No      │
  │ pre         │ No       │ No     │ Yes      │ Yes     │
  │ pre-wrap    │ No       │ Yes    │ Yes      │ Yes     │
  │ pre-line    │ Yes      │ Yes    │ Yes      │ No      │
  │ break-spaces│ No       │ Yes    │ Yes      │ Yes     │
  └─────────────┴──────────┴────────┴──────────┴─────────┘

--- hyphens ---
  hyphens: none;             /* never hyphenate */
  hyphens: manual;           /* only at &shy; or - */
  hyphens: auto;             /* automatic hyphenation (needs lang attr) */

  <html lang="en">           <!-- required for auto hyphenation -->
  p { hyphens: auto; }

--- text-overflow ---
  .ellipsis {
    overflow: hidden;
    text-overflow: ellipsis;   /* ... when text overflows */
    white-space: nowrap;       /* prevent wrap for single-line */
  }

--- Multi-Line Clamp ---
  .clamp-3-lines {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

--- Common Patterns ---
  /* Wrap long URLs/paths */
  .break-long { overflow-wrap: break-word; word-break: break-all; }

  /* Preserve formatting (code blocks) */
  pre { white-space: pre-wrap; overflow-wrap: break-word; }

  /* No wrap (horizontal scroll instead) */
  .no-wrap { white-space: nowrap; overflow-x: auto; }
EOF
}

cmd_terminal() {
    cat << 'EOF'
=== Terminal Word Wrap ===

--- fold (Simple Character Wrap) ---
  fold -w 80 file.txt            # wrap at 80 characters
  fold -s -w 80 file.txt         # break at spaces (-s = word boundary)

  echo "very long line..." | fold -sw 40

  Options:
    -w N    Width (default 80)
    -s      Break at spaces (word wrap)
    -b      Count bytes, not characters

--- fmt (Paragraph Formatter) ---
  fmt -w 72 file.txt             # reformat paragraphs to width 72
  fmt -w 72 -u file.txt          # uniform spacing (single space after .)

  fmt is smarter than fold:
    - Understands paragraph boundaries (blank lines)
    - Preserves indentation
    - Joins short lines within paragraphs

--- par (Advanced Paragraph Formatter) ---
  echo "text" | par 72           # format to width 72
  par handles:
    - Prefix detection (> for quotes, // for comments)
    - Optimal word wrapping (minimum raggedness)
    - Hanging indentation

--- Column Width Detection ---
  tput cols                      # current terminal width
  stty size | cut -d' ' -f2     # alternative

  # Responsive wrapping:
  fold -sw $(tput cols) file.txt

--- ANSI-Aware Wrapping ---
  ANSI escape codes (colors, bold) have zero visual width
  but fold/fmt count them as characters → breaks wrapping.

  Solutions:
    Strip ANSI before wrapping:
      sed 's/\x1b\[[0-9;]*m//g' | fold -sw 80

    Use ANSI-aware tools:
      Python: textwrap + strip ANSI for length calculation
      Rust: textwrap crate (ANSI-aware)

--- Hard Wrap vs Soft Wrap ---
  Hard wrap:  Inserts actual newline characters
              fold, fmt, editor hard-wrap setting
              Permanent: affects file content

  Soft wrap:  Terminal/editor wraps visually
              No newlines inserted
              Temporary: depends on window width

  Email:      Hard wrap at 72 chars (git commit messages too)
  Code:       Soft wrap in editors, hard wrap by linters
  Prose:      Soft wrap preferred (semantic line breaks)
EOF
}

cmd_cjk() {
    cat << 'EOF'
=== CJK & International Text Wrapping ===

--- CJK Line Breaking Rules ---
  Chinese, Japanese, Korean text can break between ANY two characters
  (no spaces between words). But some rules apply:

  Cannot start a line with:
    Closing brackets:  ）】》」』
    Periods/commas:    。、，．
    Small kana:        ぁぃぅぇぉ
    Prolonged sound:   ー

  Cannot end a line with:
    Opening brackets:  （【《「『
    Currency symbols:  ¥ $

  Keep together (no break between):
    Number + unit:     3月, 100円
    Number sequences:  2024年3月

--- Unicode Line Break Algorithm (UAX #14) ---
  Defines break opportunities for all Unicode characters.
  Classes include:
    AL    Alphabetic         (letters)
    ID    Ideographic        (CJK characters)
    BA    Break After        (commas, periods)
    BB    Break Before       (opening brackets)
    NS    Non-Starter        (small kana, etc.)
    SP    Space              (word separator)
    WJ    Word Joiner        (no break, U+2060)

  Break opportunities:
    ID ÷ ID    → break allowed between ideographs
    AL × AL    → no break between alphabetic chars
    SP ÷ any   → break after space

--- Full-Width vs Half-Width ---
  Full-width characters (CJK, fullwidth ASCII):
    Width = 2 columns in terminal
    Ａ Ｂ Ｃ ＡＢＣ (each = 2 columns)
    中文字 (each = 2 columns)

  Half-width characters (ASCII, Latin):
    Width = 1 column
    ABC abc 123 (each = 1 column)

  Terminal wrapping must account for display width:
    "Hello中文" = 5 + 4 = 9 columns (not 7 characters)

  Libraries:
    Python:  unicodedata.east_asian_width(char)
    Rust:    unicode-width crate
    Node.js: string-width package

--- Thai, Khmer, Myanmar ---
  No spaces between words (like CJK).
  But no character-by-character breaking allowed.
  Require dictionary-based word segmentation.

  ICU (International Components for Unicode):
    Provides line break iterators for all scripts.
    icu::BreakIterator::createLineInstance(locale)

--- Arabic & Hebrew (RTL) ---
  Right-to-left text wrapping:
    Lines start from the right margin
    Word order is right-to-left
    Numbers are still left-to-right (bidirectional)

  CSS: direction: rtl; unicode-bidi: embed;
  HTML: <p dir="rtl">Arabic text</p>

--- Emoji Wrapping ---
  Emoji are typically full-width (2 columns).
  Family emoji (👨‍👩‍👧‍👦) are ONE grapheme cluster but 2 columns wide.
  Don't break in the middle of emoji sequences!
EOF
}

cmd_code() {
    cat << 'EOF'
=== Word Wrap Implementations ===

--- Python (textwrap) ---
  import textwrap

  text = "The quick brown fox jumps over the lazy dog."
  wrapped = textwrap.fill(text, width=20)
  # "The quick brown fox\njumps over the lazy\ndog."

  lines = textwrap.wrap(text, width=20)
  # ["The quick brown fox", "jumps over the lazy", "dog."]

  # With options:
  textwrap.fill(text,
      width=72,
      initial_indent='  ',      # first line indent
      subsequent_indent='  ',   # continuation indent
      break_long_words=False,   # don't break words
      break_on_hyphens=True,    # break at hyphens
  )

  # Dedent (remove common leading whitespace):
  textwrap.dedent("""
      Hello
      World
  """)

--- JavaScript ---
  function wordWrap(text, width) {
    const words = text.split(' ');
    const lines = [];
    let line = '';

    for (const word of words) {
      if (line.length + 1 + word.length > width && line) {
        lines.push(line);
        line = word;
      } else {
        line = line ? line + ' ' + word : word;
      }
    }
    if (line) lines.push(line);
    return lines.join('\n');
  }

  // CSS in JS (React):
  <div style={{ wordBreak: 'break-word', overflowWrap: 'break-word' }}>

--- Rust (textwrap crate) ---
  use textwrap::{wrap, fill, Options};

  let text = "The quick brown fox jumps over the lazy dog.";
  let wrapped = fill(text, 20);

  // With options:
  let options = Options::new(72)
      .initial_indent("  ")
      .subsequent_indent("  ");
  let wrapped = fill(text, &options);

  // Optimal wrapping (Knuth-Plass):
  use textwrap::wrap_algorithms::OptimalFit;
  let options = Options::new(72)
      .wrap_algorithm(OptimalFit::new());

--- Go ---
  import "github.com/mitchellh/go-wordwrap"

  wrapped := wordwrap.WrapString("long text here", 80)

  // Manual implementation:
  func wrap(s string, width int) string {
      words := strings.Fields(s)
      var lines []string
      line := ""
      for _, word := range words {
          if len(line)+1+len(word) > width && line != "" {
              lines = append(lines, line)
              line = word
          } else if line == "" {
              line = word
          } else {
              line += " " + word
          }
      }
      if line != "" { lines = append(lines, line) }
      return strings.Join(lines, "\n")
  }
EOF
}

cmd_decorator() {
    cat << 'EOF'
=== Wrapper / Decorator Pattern ===

Wrapping objects or functions to add behavior without modifying them.

--- Function Wrapping (JavaScript) ---
  // Logging wrapper
  function withLogging(fn) {
    return function(...args) {
      console.log(`Calling ${fn.name} with`, args);
      const result = fn(...args);
      console.log(`${fn.name} returned`, result);
      return result;
    };
  }

  const add = (a, b) => a + b;
  const loggedAdd = withLogging(add);
  loggedAdd(2, 3);  // logs call and result, returns 5

--- Python Decorators ---
  import functools

  def retry(max_attempts=3):
      def decorator(func):
          @functools.wraps(func)
          def wrapper(*args, **kwargs):
              for attempt in range(max_attempts):
                  try:
                      return func(*args, **kwargs)
                  except Exception as e:
                      if attempt == max_attempts - 1:
                          raise
          return wrapper
      return decorator

  @retry(max_attempts=3)
  def fetch_data(url):
      ...

--- Rust Newtype Wrapper ---
  struct Logged<T>(T);

  impl<T: Service> Service for Logged<T> {
      fn call(&self, req: Request) -> Response {
          println!("Request: {:?}", req);
          let resp = self.0.call(req);
          println!("Response: {:?}", resp);
          resp
      }
  }

--- Java Decorator ---
  interface DataSource {
      String readData();
  }

  class FileDataSource implements DataSource {
      String readData() { /* read from file */ }
  }

  class EncryptionDecorator implements DataSource {
      private DataSource wrapped;
      EncryptionDecorator(DataSource source) { this.wrapped = source; }
      String readData() {
          return decrypt(wrapped.readData());
      }
  }

  DataSource source = new EncryptionDecorator(new FileDataSource("data.txt"));

--- When to Use Wrapper Pattern ---
  ✓ Adding cross-cutting concerns (logging, caching, auth)
  ✓ Adapting an interface to another
  ✓ Adding behavior without modifying original code
  ✓ Composing multiple behaviors (stacking decorators)

  ✗ Don't overuse: deep nesting of wrappers is hard to debug
  ✗ Consider middleware pattern for request/response pipelines
  ✗ Consider aspect-oriented programming for pervasive concerns
EOF
}

cmd_containers() {
    cat << 'EOF'
=== Wrapping Values in Containers ===

--- Option / Maybe (Presence) ---
  Rust:     let x: Option<i32> = Some(42);
  Haskell:  let x = Just 42 :: Maybe Int
  Swift:    let x: Int? = 42
  Scala:    val x: Option[Int] = Some(42)
  Java:     Optional<Integer> x = Optional.of(42);

  Wraps a value that might not exist.
  Forces caller to handle the None/Nothing case.

--- Result / Either (Success or Error) ---
  Rust:     let x: Result<i32, String> = Ok(42);
  Haskell:  let x = Right 42 :: Either String Int
  Scala:    val x: Either[String, Int] = Right(42)
  TS:       type Result<T, E> = { ok: true; value: T } | { ok: false; error: E }

  Wraps either a success value or an error.
  Forces caller to handle the error case.

--- Box / Pointer Wrappers ---
  Rust:
    Box<T>      Heap allocation (owned pointer)
    Rc<T>       Reference counted (shared ownership)
    Arc<T>      Atomic RC (thread-safe shared ownership)
    Cell<T>     Interior mutability (copy types)
    RefCell<T>  Interior mutability (borrow checking at runtime)
    Mutex<T>    Thread-safe interior mutability
    Pin<T>      Prevent moving (for self-referential structs)

  C++:
    unique_ptr<T>  Exclusive ownership
    shared_ptr<T>  Reference counted
    weak_ptr<T>    Non-owning reference

--- Wrapper Types in TypeScript ---
  // Branded types (wrapping for type safety):
  type Email = string & { readonly __brand: 'Email' };
  function email(s: string): Email {
      if (!s.includes('@')) throw new Error('Invalid email');
      return s as Email;
  }

  // Promise wrapping:
  const value = Promise.resolve(42);
  // Wraps 42 in a Promise container

--- When to Wrap ---
  Presence uncertainty → Option/Maybe
  Potential failure    → Result/Either
  Heap allocation      → Box/unique_ptr
  Shared ownership     → Rc/Arc/shared_ptr
  Thread safety        → Mutex/RwLock/Arc
  Lazy evaluation      → Lazy/thunk
  Async computation    → Promise/Future
  Type safety          → Branded/Newtype

--- Unwrapping (the inverse) ---
  See: unwrap skill for extracting values from containers
  Rule: Wrap early, unwrap late.
  Keep values wrapped as long as possible.
  Use map/flatMap to work inside the wrapper.
EOF
}

show_help() {
    cat << EOF
wrap v$VERSION — Text & Data Wrapping Reference

Usage: script.sh <command>

Commands:
  intro        Wrapping overview: text, data, patterns
  text         Word wrap algorithms: greedy, Knuth-Plass, hyphenation
  css          CSS wrapping: overflow-wrap, white-space, hyphens
  terminal     Terminal wrap: fold, fmt, ANSI-aware, hard vs soft
  cjk          CJK/international: line break rules, Unicode UAX #14
  code         Implementations: Python, JavaScript, Rust, Go
  decorator    Wrapper/decorator pattern in multiple languages
  containers   Wrapping values: Option, Result, Box, Arc, Promise
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    text)       cmd_text ;;
    css)        cmd_css ;;
    terminal)   cmd_terminal ;;
    cjk)        cmd_cjk ;;
    code)       cmd_code ;;
    decorator)  cmd_decorator ;;
    containers) cmd_containers ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "wrap v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
