#!/usr/bin/env bash
# align — Alignment Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Alignment Concepts ===

Alignment means arranging elements along a common reference line or
boundary. The concept spans multiple domains:

  Text Alignment:     Formatting text in columns, tables, padding
  CSS/Layout:         Positioning elements in flexbox, grid, or flow
  Memory Alignment:   Placing data at addresses divisible by N bytes
  Sequence Alignment: Matching biological sequences (DNA, protein)
  Data Alignment:     Ensuring fields match across datasets

Each domain has its own rules, tools, and trade-offs, but the
core idea is the same: arranging things relative to a reference.
EOF
}

cmd_text() {
    cat << 'EOF'
=== Text Alignment ===

--- printf/sprintf Formatting ---
  %10s     Right-align in 10-char field   "     hello"
  %-10s    Left-align in 10-char field    "hello     "
  %10d     Right-align integer            "        42"
  %-10d    Left-align integer             "42        "
  %010d    Zero-pad integer               "0000000042"
  %10.2f   Right-align float, 2 decimals  "     42.50"

  printf "%-20s %8s %10s\n" "Product" "Qty" "Price"
  printf "%-20s %8d %10.2f\n" "Widget" 42 9.99
  printf "%-20s %8d %10.2f\n" "Gizmo" 7 149.95

  Output:
  Product              Qty      Price
  Widget                 42       9.99
  Gizmo                   7     149.95

--- Python String Formatting ---
  f"{'hello':>10}"     Right-align    "     hello"
  f"{'hello':<10}"     Left-align     "hello     "
  f"{'hello':^10}"     Center         "  hello   "
  f"{'hello':*^10}"    Center, fill   "**hello***"
  f"{42:08d}"          Zero-pad       "00000042"
  f"{3.14:.4f}"        Decimal places "3.1400"

--- Column Alignment (CLI) ---
  column -t:
    echo -e "Name\tAge\tCity\nAlice\t30\tNYC\nBob\t25\tLA" | column -t
    Name   Age  City
    Alice  30   NYC
    Bob    25   LA

  pr -tT -w80 -3:  Three-column layout

--- Padding Strategies ---
  Left pad:   "   42" — numeric values (right-aligned)
  Right pad:  "hello   " — text labels (left-aligned)
  Zero pad:   "00042" — IDs, codes, timestamps
  Center pad: " hello " — headers, titles

--- Tab Stops ---
  Default: every 8 characters
  Expand tabs: expand -t4 file.txt (convert to 4-space tabs)
  Unexpand: unexpand -t4 (convert spaces back to tabs)
  Be consistent: tabs OR spaces, never mix
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Alignment ===

--- Flexbox Alignment ---

  Container properties:
    justify-content: flex-start | center | flex-end | space-between | space-around
      → Aligns items along MAIN axis (horizontal by default)

    align-items: stretch | flex-start | center | flex-end | baseline
      → Aligns items along CROSS axis (vertical by default)

    align-content: (same values as justify-content)
      → Aligns wrapped LINES (only with flex-wrap)

  Item properties:
    align-self: auto | flex-start | center | flex-end | stretch
      → Override align-items for single item

  Center anything (holy grail):
    .container {
      display: flex;
      justify-content: center;
      align-items: center;
    }

--- Grid Alignment ---
    justify-items: start | center | end | stretch
      → Aligns items within their cell (inline/horizontal)

    align-items: start | center | end | stretch
      → Aligns items within their cell (block/vertical)

    place-items: center center;
      → Shorthand for align-items + justify-items

    justify-content / align-content:
      → Aligns the GRID within its container

--- Text Alignment ---
    text-align: left | right | center | justify
    text-align-last: auto | left | center | right | justify
    vertical-align: baseline | top | middle | bottom | sub | super
      → For inline/table-cell elements only

--- Vertical Centering Methods ---
  1. Flexbox (recommended):
     display: flex; align-items: center;

  2. Grid:
     display: grid; place-items: center;

  3. Transform:
     position: absolute; top: 50%; transform: translateY(-50%);

  4. Line-height (single line text only):
     line-height: 60px; height: 60px;

  5. Table-cell:
     display: table-cell; vertical-align: middle;
EOF
}

cmd_memory() {
    cat << 'EOF'
=== Memory Alignment ===

Data alignment means placing values at memory addresses that are
multiples of their size. Critical for performance and correctness.

--- Why Alignment Matters ---
  CPU fetches data in chunks (4 or 8 bytes on modern CPUs).
  Misaligned data may require two fetches instead of one.

  Aligned:    Address 0x1000 for int32 → one fetch (4 bytes)
  Misaligned: Address 0x1001 for int32 → TWO fetches + combine

  Performance penalty: 2-10× slower for misaligned access (varies by arch)
  Some architectures (ARM, MIPS) CRASH on misaligned access

--- Natural Alignment Rules ---
  Type        Size    Alignment
  char        1       1 (any address)
  short       2       2 (even address)
  int         4       4 (divisible by 4)
  long/ptr    8       8 (divisible by 8)
  float       4       4
  double      8       8
  __m128      16      16 (SSE)
  __m256      32      32 (AVX)
  __m512      64      64 (AVX-512)

--- Struct Padding ---
  struct Bad {       //  Size: 24 bytes (with padding)
    char  a;         //  offset 0, size 1
                     //  3 bytes padding
    int   b;         //  offset 4, size 4
    char  c;         //  offset 8, size 1
                     //  7 bytes padding
    double d;        //  offset 16, size 8
  };

  struct Good {      //  Size: 16 bytes (reordered)
    double d;        //  offset 0, size 8
    int    b;        //  offset 8, size 4
    char   a;        //  offset 12, size 1
    char   c;        //  offset 13, size 1
                     //  2 bytes padding
  };

  Rule: order fields from largest to smallest

--- Compiler Controls ---
  GCC/Clang:
    __attribute__((aligned(16)))    Force alignment
    __attribute__((packed))         Remove padding (misaligned!)
    #pragma pack(push, 1)          Pack following structs

  MSVC:
    __declspec(align(16))          Force alignment
    #pragma pack(1)                Pack structs

  C11: _Alignas(16) int x;
  C++11: alignas(16) int x;

--- Cache Line Alignment ---
  Cache line: 64 bytes on most modern CPUs
  False sharing: two threads writing to same cache line
  Fix: align per-thread data to cache line boundaries
    alignas(64) struct ThreadData { ... };
  Critical in: lock-free data structures, thread pools
EOF
}

cmd_sequence() {
    cat << 'EOF'
=== Sequence Alignment ===

Sequence alignment identifies regions of similarity between biological
sequences (DNA, RNA, protein) that may indicate functional, structural,
or evolutionary relationships.

--- Types ---
  Global Alignment:  Aligns sequences end-to-end
    Algorithm: Needleman-Wunsch (dynamic programming)
    Use: comparing two closely related sequences of similar length
    Time: O(m × n), Space: O(m × n)

  Local Alignment:   Finds best matching subsequences
    Algorithm: Smith-Waterman (dynamic programming)
    Use: finding conserved regions in divergent sequences
    Time: O(m × n), Space: O(m × n)

  Semi-global:       One sequence end-to-end, other partial
    Use: aligning short reads to a reference genome

--- Scoring ---
  Match:    +1 to +5 (reward for identical characters)
  Mismatch: -1 to -3 (penalty for substitution)
  Gap open:  -10 to -12 (penalty for starting a gap)
  Gap extend: -1 to -2 (penalty for continuing a gap)

  Substitution matrices (protein):
    BLOSUM62: most common default for protein alignment
    PAM250: for distantly related sequences
    Higher number = more closely related sequences

--- BLAST (Basic Local Alignment Search Tool) ---
  Heuristic algorithm — much faster than Smith-Waterman
  Not guaranteed to find optimal alignment

  Steps:
    1. Break query into short words (k-mers, typically k=3 for protein)
    2. Find exact matches in database (seeds)
    3. Extend seeds in both directions (HSP — High Scoring Pairs)
    4. Evaluate statistical significance (E-value)

  E-value interpretation:
    E < 1e-50:  Almost certainly homologous
    E < 1e-10:  Very likely homologous
    E < 0.01:   Probably homologous
    E > 1:      Likely random match

  BLAST variants:
    blastn:  nucleotide vs nucleotide
    blastp:  protein vs protein
    blastx:  translated nucleotide vs protein
    tblastn: protein vs translated nucleotide

--- Multiple Sequence Alignment (MSA) ---
  Aligning 3+ sequences simultaneously
  Tools: MUSCLE, MAFFT, ClustalW, T-Coffee
  NP-hard problem — all tools use heuristics
  Used for: phylogenetic trees, conserved region identification
EOF
}

cmd_columns() {
    cat << 'EOF'
=== Column Formatting ===

--- CLI Table Output ---

  Simple column alignment:
    printf "%-15s %-10s %10s\n" "Name" "Status" "Count"
    printf "%-15s %-10s %10d\n" "production" "active" 1542
    printf "%-15s %-10s %10d\n" "staging" "paused" 38
    printf "%s\n" "$(printf '=%.0s' {1..37})"
    printf "%-15s %-10s %10d\n" "TOTAL" "" 1580

  Output:
    Name            Status          Count
    production      active           1542
    staging         paused             38
    =====================================
    TOTAL                            1580

--- Dynamic Column Width ---
  Calculate widths from data:
    # Find max width of each column
    max_name=0
    for name in "${names[@]}"; do
      (( ${#name} > max_name )) && max_name=${#name}
    done
    # Use in printf
    printf "%-${max_name}s ...\n" "$name"

--- Box Drawing Characters ---
  Unicode box drawing for nicer tables:
    ┌──────────┬────────┬──────┐
    │ Name     │ Status │ Size │
    ├──────────┼────────┼──────┤
    │ server-1 │ up     │ 4GB  │
    │ server-2 │ down   │ 8GB  │
    └──────────┴────────┴──────┘

  Characters: ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼ ─ │

--- Tools ---
  column -t -s','    Auto-align CSV with tabs
  pr -t -w80         Format for printing
  expand -t4         Convert tabs to spaces
  fold -w80          Wrap long lines at width
  fmt -w72           Reflow text to width
  rs -t              Reshape data (transpose, etc.)
  csvlook            Pretty-print CSV as table (csvkit)
  tabulate (Python)  Generate ASCII/Unicode tables from data
EOF
}

cmd_typographic() {
    cat << 'EOF'
=== Typographic Alignment ===

--- Text Alignment Types ---

  Left-Aligned (Ragged Right):
    Most readable for body text in left-to-right languages
    Natural word spacing, no awkward gaps
    Default for web, documents, and code
    Use for: body text, lists, code

  Right-Aligned (Ragged Left):
    Harder to read for long text
    Use for: numbers in tables, dates, prices
    Aligns decimal points in numeric columns
    Use for: captions on left side of images

  Center-Aligned:
    Symmetrical appearance
    Hard to read for more than 2-3 lines
    Use for: headings, invitations, poetry, short labels
    Never for: body text, paragraphs

  Justified:
    Both edges aligned (flush left and right)
    Creates uneven word spacing (rivers of white space)
    Requires: good hyphenation to avoid huge gaps
    Use for: newspapers, books, formal documents
    Avoid for: narrow columns (too many gaps)

--- Baseline Alignment ---
  Aligning text of different sizes along the baseline
  (the invisible line text sits on)

  Important for:
    Mixed font sizes on same line
    Inline images with text
    Form labels next to inputs

  CSS: vertical-align: baseline (default for inline elements)

--- Optical Alignment ---
  Mathematically centered ≠ visually centered
  Round shapes (O, C) need to extend slightly beyond the line
  Triangles (A, V) need to extend slightly to look aligned
  This is why fonts have overshoot — characters extend past metrics

  For icons:
    A play button (▶) centered in a circle needs to shift RIGHT
    because the visual center of a triangle is right of geometric center

  For text in buttons:
    Often needs 1-2px more padding on top than bottom
    Because descenders (g, y, p) make text look low

--- Vertical Rhythm ---
  Maintaining consistent spacing throughout a page
  All text and spacing based on a base unit (e.g., 8px)
  Line heights: multiples of the base (16px, 24px, 32px)
  Margins and padding: multiples of the base
  Creates visual harmony and readability
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Alignment Tools ===

--- CLI Tools ---
  column       Align columns in text
    echo "a 1\nbb 22\nccc 333" | column -t
    a    1
    bb   22
    ccc  333

  printf       Formatted output with field widths
    printf "%-10s %5d\n" "Alice" 42

  fmt          Reflow text to specified width
    fmt -w72 essay.txt

  fold         Wrap lines at specified width
    fold -w80 -s file.txt    (-s = break at spaces)

  expand/unexpand  Convert between tabs and spaces
  rev          Reverse each line (for right-alignment tricks)

--- Python Tools ---
  tabulate:  pip install tabulate
    from tabulate import tabulate
    print(tabulate(data, headers=["Name","Age"], tablefmt="grid"))

  textwrap:  Standard library text wrapping
    textwrap.fill(text, width=72)
    textwrap.indent(text, prefix="  ")

  str methods:
    "hello".ljust(10)    "hello     "
    "hello".rjust(10)    "     hello"
    "hello".center(10)   "  hello   "
    "42".zfill(8)        "00000042"

--- CSS Debugging ---
  * { outline: 1px solid red; }  — show all element boxes
  Flexbox Inspector: Firefox DevTools > Layout > Flex
  Grid Inspector: Firefox DevTools > Layout > Grid
  Chrome DevTools: overlay flex/grid alignment guides

--- Memory Alignment Tools ---
  pahole (Linux):  Analyze struct padding
    pahole -C MyStruct my_binary
  offsetof() macro: Check field offsets at compile time
  alignof() operator: Query alignment requirement (C++11)
  -Wpadded (GCC):  Warn about struct padding
EOF
}

show_help() {
    cat << EOF
align v$VERSION — Alignment Reference

Usage: script.sh <command>

Commands:
  intro        Alignment concepts overview
  text         printf formatting, padding, column alignment
  css          CSS flexbox, grid, text, and vertical centering
  memory       Struct padding, cache lines, SIMD alignment
  sequence     Biological sequence alignment algorithms
  columns      CLI table output and dynamic column sizing
  typographic  Left, right, center, justified, baseline alignment
  tools        CLI, Python, CSS, and memory alignment tools
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    text)        cmd_text ;;
    css)         cmd_css ;;
    memory)      cmd_memory ;;
    sequence)    cmd_sequence ;;
    columns)     cmd_columns ;;
    typographic) cmd_typographic ;;
    tools)       cmd_tools ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "align v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
