#!/usr/bin/env bash
# transpose — Matrix & Data Transposition Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Transposition ===

Transposition swaps rows and columns — an element at position (i, j)
moves to position (j, i).

Visual:
  Original (3×2):        Transposed (2×3):
  ┌───┬───┐              ┌───┬───┬───┐
  │ 1 │ 2 │              │ 1 │ 3 │ 5 │
  ├───┼───┤     →        ├───┼───┼───┤
  │ 3 │ 4 │              │ 2 │ 4 │ 6 │
  ├───┼───┤              └───┴───┴───┘
  │ 5 │ 6 │
  └───┴───┘

  Element A[i][j] becomes A^T[j][i]

Where Transposition Appears:
  Linear algebra    Matrix operations, solving systems
  Databases         Pivot tables (rows → columns)
  Data science      Reshaping dataframes (wide ↔ long)
  Image processing  90° rotation = transpose + flip
  Music             Shifting key up/down by interval
  Spreadsheets      TRANSPOSE() function
  Signal processing FFT butterfly operations

Notation:
  Mathematics:  A^T  or  A'  (transpose of A)
  NumPy:        A.T  or  np.transpose(A)
  MATLAB:       A.'  (transpose)  A'  (conjugate transpose)
  LaTeX:        A^{\mathsf{T}}

Key Properties (Preview):
  (A^T)^T = A                    Double transpose = original
  (A + B)^T = A^T + B^T          Transpose distributes over addition
  (AB)^T = B^T A^T               Reverses multiplication order!
  (cA)^T = cA^T                  Scalar passes through
  det(A^T) = det(A)              Determinant unchanged
EOF
}

cmd_matrix() {
    cat << 'EOF'
=== Matrix Transpose ===

--- Properties ---
  (A^T)^T = A                    Involution (self-inverse)
  (A + B)^T = A^T + B^T          Linear
  (cA)^T = cA^T                  Scalar multiplication
  (AB)^T = B^T × A^T             Reversal property (IMPORTANT!)
  rank(A^T) = rank(A)            Rank preserved
  det(A^T) = det(A)              Determinant preserved
  eigenvalues(A^T) = eigenvalues(A)  (but eigenvectors differ)

--- Special Transpose Types ---

  Symmetric Matrix:  A^T = A
    ┌───┬───┬───┐
    │ 1 │ 2 │ 3 │     A = A^T
    │ 2 │ 4 │ 5 │     Diagonal mirror symmetry
    │ 3 │ 5 │ 6 │     Real eigenvalues guaranteed
    └───┴───┴───┘     Common in: covariance, distance, adjacency

  Skew-Symmetric:  A^T = -A
    ┌────┬───┬───┐
    │  0 │ 2 │-3 │    Diagonal must be zero
    │ -2 │ 0 │ 5 │    A[i][j] = -A[j][i]
    │  3 │-5 │ 0 │    Common in: cross products, rotations
    └────┴───┴───┘

  Orthogonal Matrix:  A^T = A^(-1)
    A^T × A = I (identity)
    Rotation and reflection matrices
    Columns are orthonormal vectors

  Conjugate Transpose (Hermitian):  A* = conjugate(A^T)
    For complex matrices: (a + bi) → (a - bi) then transpose
    Hermitian: A* = A (complex analog of symmetric)

--- Transpose and Inner Product ---
  Dot product: x · y = x^T × y

  For vectors x = [1, 2, 3]:
    x^T = [[1, 2, 3]]     (row vector)
    x^T × y = scalar      (inner product)
    x × y^T = matrix      (outer product, rank-1 matrix)

--- Transpose and Least Squares ---
  Normal equation: A^T A x = A^T b
  Solves: min ||Ax - b||²
  This is how linear regression works!
  A^T A is always symmetric positive semi-definite.
EOF
}

cmd_code() {
    cat << 'EOF'
=== Transpose Implementations ===

--- Python ---
  # List of lists
  matrix = [[1, 2, 3], [4, 5, 6]]
  transposed = list(map(list, zip(*matrix)))
  # [[1, 4], [2, 5], [3, 6]]

  # List comprehension
  transposed = [[row[i] for row in matrix] for i in range(len(matrix[0]))]

  # NumPy (fastest)
  import numpy as np
  A = np.array([[1, 2, 3], [4, 5, 6]])
  A.T              # returns view (no copy!)
  np.transpose(A)  # same thing
  A.T.copy()       # force a copy

--- JavaScript ---
  const matrix = [[1,2,3], [4,5,6]];
  const transposed = matrix[0].map((_, i) => matrix.map(row => row[i]));
  // [[1,4], [2,5], [3,6]]

  // Functional style
  const transpose = m => m[0].map((_, i) => m.map(r => r[i]));

--- Rust ---
  fn transpose<T: Clone>(matrix: &[Vec<T>]) -> Vec<Vec<T>> {
      let rows = matrix.len();
      let cols = matrix[0].len();
      (0..cols).map(|j| {
          (0..rows).map(|i| matrix[i][j].clone()).collect()
      }).collect()
  }

  // ndarray crate
  use ndarray::Array2;
  let a = Array2::from_shape_vec((2, 3), vec![1,2,3,4,5,6]).unwrap();
  let t = a.t();    // transposed view

--- SQL (PIVOT) ---
  -- PostgreSQL crosstab
  SELECT * FROM crosstab(
    'SELECT student, subject, score FROM grades ORDER BY 1,2'
  ) AS ct(student text, math int, science int, english int);

  -- SQL Server PIVOT
  SELECT * FROM scores
  PIVOT (AVG(score) FOR subject IN ([Math], [Science], [English])) p;

  -- MySQL (manual pivot)
  SELECT student,
    MAX(CASE WHEN subject='Math' THEN score END) as Math,
    MAX(CASE WHEN subject='Science' THEN score END) as Science
  FROM grades GROUP BY student;

--- Excel/Sheets ---
  =TRANSPOSE(A1:C3)             -- transpose a range
  Ctrl+C → Paste Special → Transpose checkbox
  LAMBDA: =MAP(SEQUENCE(COLUMNS(A1:C3)), LAMBDA(c, INDEX(A1:C3,, c)))
EOF
}

cmd_inplace() {
    cat << 'EOF'
=== In-Place Transpose ===

--- Square Matrix (Easy Case) ---
  Swap A[i][j] with A[j][i] for all i < j.

  void transpose_square(int** A, int n) {
      for (int i = 0; i < n; i++)
          for (int j = i + 1; j < n; j++)
              swap(A[i][j], A[j][i]);
  }

  Time: O(n²)
  Space: O(1) — truly in-place
  Only need to swap upper triangle with lower triangle.

--- Non-Square Matrix (Hard!) ---
  In-place transpose of m×n → n×m is complex.
  Elements follow permutation cycles.

  For flat array (row-major):
    Element at position p maps to position:
      p' = (p × n) mod (m×n - 1)    for p ≠ 0 and p ≠ m×n-1
      First and last elements stay put.

  Example: 2×3 matrix stored as [1, 2, 3, 4, 5, 6]
    Target:                     [1, 4, 2, 5, 3, 6]

    Cycle 1: pos 1 → 2 → 4 → 3 → 1  (values: 2→3→5→4→2)
    Elements 0 and 5 are fixed points.

  Algorithms:
    Follow-the-cycles: O(mn) time, O(mn) extra bits for visited tracking
    Blocked/tiled:     Better cache performance, same complexity

--- Why Non-Square In-Place is Hard ---
  1. Array dimensions change (m×n → n×m)
  2. Cycles have variable length
  3. Finding cycle leaders requires O(mn) visited flags
  4. No known O(1) space, O(mn) time algorithm for general case

  In practice: Just allocate a new array.
  The copy approach is simpler and often faster (cache-friendly).

--- Common Shortcut: Transpose = Reverse + Rotate ---
  For square matrix:
  90° clockwise rotation  = transpose then reverse each row
  90° counter-clockwise   = transpose then reverse each column
  180° rotation           = reverse rows then reverse columns

  # Python: 90° clockwise
  transposed = list(zip(*matrix))
  rotated = [list(reversed(row)) for row in transposed]
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Cache-Efficient Transpose ===

The Problem:
  Naive transpose of large matrix is cache-unfriendly.

  for i in range(N):
      for j in range(N):
          B[j][i] = A[i][j]

  Reading A: sequential (cache-friendly, row-major)
  Writing B: strided (cache-UNFRIENDLY, column access)

  For N=4096 and 64-byte cache lines:
    Every write to B is a cache miss → very slow

--- Blocked (Tiled) Transpose ---
  Process in small blocks that fit in cache.

  BLOCK = 32  # tuned for cache line size

  for i in range(0, N, BLOCK):
      for j in range(0, N, BLOCK):
          for ii in range(i, min(i+BLOCK, N)):
              for jj in range(j, min(j+BLOCK, N)):
                  B[jj][ii] = A[ii][jj]

  Why it works:
    Block fits in L1 cache (~32KB)
    Both reads and writes access nearby memory within block
    Reduces cache misses by factor of BLOCK

  Optimal block size:
    √(cache_size / element_size / 2)
    For L1=32KB, double (8B): BLOCK ≈ 32-64

--- SIMD Transpose ---
  x86 SSE/AVX can transpose 4×4 or 8×8 blocks using shuffle instructions.

  // 4×4 float transpose with SSE
  _MM_TRANSPOSE4_PS(row0, row1, row2, row3);
  // Single instruction transposes 4×4 block

  AVX-512: 16×16 block transpose in ~20 instructions

--- Performance Numbers (1024×1024 doubles) ---
  Naive:              15 ms
  Blocked (32×32):     4 ms   (3.8× faster)
  SIMD blocked:        2 ms   (7.5× faster)
  Parallel + blocked:  0.5 ms (30× faster)

--- NumPy Note ---
  np.array.T returns a VIEW, not a copy.
  No data movement at all! Just changes stride metadata.
  But: subsequent operations on the view may be slower
  (non-contiguous memory access).

  Force contiguous copy: np.ascontiguousarray(A.T)
  Needed before passing to C/Fortran libraries.
EOF
}

cmd_data() {
    cat << 'EOF'
=== Data Transposition (Pivoting) ===

--- Wide vs Long Format ---
  Wide (each variable is a column):
    Student  | Math | Science | English
    Alice    | 90   | 85      | 92
    Bob      | 78   | 88      | 75

  Long (variable-value pairs):
    Student  | Subject  | Score
    Alice    | Math     | 90
    Alice    | Science  | 85
    Alice    | English  | 92
    Bob      | Math     | 78
    Bob      | Science  | 88
    Bob      | English  | 75

--- pandas: Long → Wide (pivot) ---
  df.pivot(index='Student', columns='Subject', values='Score')

  # With aggregation:
  df.pivot_table(index='Student', columns='Subject',
                 values='Score', aggfunc='mean')

--- pandas: Wide → Long (melt) ---
  pd.melt(df, id_vars=['Student'],
          value_vars=['Math', 'Science', 'English'],
          var_name='Subject', value_name='Score')

--- R: tidyr ---
  # Wide → Long
  pivot_longer(df, cols=c(Math, Science, English),
               names_to="Subject", values_to="Score")

  # Long → Wide
  pivot_wider(df, names_from=Subject, values_from=Score)

--- Excel Pivot Table ---
  Insert → PivotTable
  Rows: Student
  Columns: Subject
  Values: Score (Sum/Average/Count)

--- When to Use Each Format ---
  Wide:
    ✓ Human-readable reports
    ✓ Correlation analysis (variables as columns)
    ✓ Machine learning features

  Long:
    ✓ Tidy data (one observation per row)
    ✓ ggplot2/Seaborn visualization
    ✓ Database storage
    ✓ Time series with multiple variables

--- Unpivot (SQL) ---
  -- SQL Server
  SELECT Student, Subject, Score
  FROM scores
  UNPIVOT (Score FOR Subject IN ([Math], [Science], [English])) u;

  -- PostgreSQL (LATERAL + VALUES)
  SELECT s.student, x.subject, x.score
  FROM scores s,
  LATERAL (VALUES ('Math', math), ('Science', science)) x(subject, score);
EOF
}

cmd_music() {
    cat << 'EOF'
=== Musical Transposition ===

Transposition in music means shifting all notes up or down
by a constant interval, preserving melodic relationships.

--- Chromatic Scale (12 Semitones) ---
  C  C#  D  D#  E  F  F#  G  G#  A  A#  B  C
  0   1  2   3  4  5   6  7   8  9  10  11  12

  To transpose up N semitones: add N, mod 12
  To transpose down N semitones: subtract N, mod 12

--- Transposition Examples ---
  "Happy Birthday" in C:  C C D C F E
  Transpose up 5 (to F):  F F G F Bb A
  Transpose up 7 (to G):  G G A G C B

  Each note shifted by same interval → melody preserved.

--- Interval Names ---
  Semitones  Interval          Example (from C)
  0          Unison            C → C
  1          Minor 2nd         C → C#/Db
  2          Major 2nd         C → D
  3          Minor 3rd         C → D#/Eb
  4          Major 3rd         C → E
  5          Perfect 4th       C → F
  6          Tritone           C → F#/Gb
  7          Perfect 5th       C → G
  8          Minor 6th         C → G#/Ab
  9          Major 6th         C → A
  10         Minor 7th         C → A#/Bb
  11         Major 7th         C → B
  12         Octave            C → C (next)

--- Chord Transposition ---
  Transpose chord progression from C to G (+7 semitones):
    C    → G
    Am   → Em
    F    → C
    G    → D
    Dm7  → Am7

  Rule: Root moves by interval, quality stays same.
  C major → G major (not G minor)

--- Instrument Transposition ---
  Some instruments are "transposing instruments":
    Bb Trumpet:   Written C sounds as Bb (down 2 semitones)
    Eb Alto Sax:  Written C sounds as Eb (down 9 semitones)
    F French Horn: Written C sounds as F (down 7 semitones)

  Concert pitch → Written note:
    Add the transposition interval
    Bb instrument: add 2 semitones to concert pitch

--- Nashville Number System ---
  Uses numbers instead of note names:
  In key of C: I=C, ii=Dm, iii=Em, IV=F, V=G, vi=Am, vii°=Bdim
  Transposable by just changing the key designation.
  Song chart: I  V  vi  IV → works in any key!

--- Guitar Capo ---
  Capo on fret N = transpose up N semitones.
  Capo fret 2: open C shape sounds as D.
  Capo fret 5: open G shape sounds as C.
  Allows same fingering in different keys.
EOF
}

cmd_applications() {
    cat << 'EOF'
=== Transpose Applications ===

--- Image Rotation ---
  90° clockwise  = transpose + horizontal flip
  90° counter-CW = transpose + vertical flip
  180°           = horizontal + vertical flip

  # Python PIL
  from PIL import Image
  img.transpose(Image.TRANSPOSE)    # mirror along diagonal
  img.transpose(Image.ROTATE_90)    # 90° counter-clockwise

--- Graph Adjacency Matrix ---
  For directed graph:
    A[i][j] = 1 means edge from i to j
    A^T[i][j] = 1 means edge from j to i

    A^T = "reverse all edges" (transpose graph)

  For undirected graph:
    A = A^T (symmetric — transpose is itself)

  Application: finding strongly connected components
    Run DFS on G, then DFS on G^T (transposed graph)

--- Signal Processing ---
  In FFT (Fast Fourier Transform):
    Large 2D FFT decomposed as:
    1. FFT each row
    2. Transpose
    3. FFT each row (was column)
    4. Transpose back

  This pattern exploits cache-friendly row access.

--- Machine Learning ---
  Weight matrix transpose in neural networks:
    Forward:  y = W × x + b
    Backward: dx = W^T × dy    (backpropagation)

  Feature matrix: rows=samples, cols=features
  Some algorithms need samples in columns (transpose).

--- Database Columnar Storage ---
  Row-oriented: [[name, age, salary], [name, age, salary], ...]
  Column-oriented: [[name, name, ...], [age, age, ...], [salary, ...]]

  Column store = transposed row store!
  Benefits: better compression, faster aggregation (SUM, AVG)
  Examples: Parquet, ClickHouse, DuckDB, Redshift

--- Sparse Matrix Transpose ---
  CSR (Compressed Sparse Row) format:
    Transpose CSR → CSC (Compressed Sparse Column)

  Algorithm:
    1. Count non-zeros per column
    2. Compute column pointers (cumulative sum)
    3. Place each element in correct position

  Time: O(nnz + n) where nnz = number of non-zeros
  Converting CSR ↔ CSC is essentially transposing.

--- Cryptography ---
  Columnar transposition cipher:
    1. Write message in rows of fixed width
    2. Read columns in key-specified order

    Key:    3 1 4 2
    Message: H E L P
             M E N O
             W _ _ _

    Read by key order (1,2,3,4): EE LP HM LN OW__
    Simple but forms basis of more complex ciphers.
EOF
}

show_help() {
    cat << EOF
transpose v$VERSION — Matrix & Data Transposition Reference

Usage: script.sh <command>

Commands:
  intro        What transposition means across domains
  matrix       Matrix transpose properties and special types
  code         Implementations: Python, JS, Rust, NumPy, SQL
  inplace      In-place transpose algorithms (square + non-square)
  performance  Cache-efficient transpose: blocking, SIMD, parallel
  data         Data pivoting: wide/long, pandas, SQL PIVOT
  music        Musical transposition: keys, chords, instruments
  applications Image rotation, graphs, FFT, ML, crypto
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    matrix)       cmd_matrix ;;
    code)         cmd_code ;;
    inplace)      cmd_inplace ;;
    performance)  cmd_performance ;;
    data)         cmd_data ;;
    music)        cmd_music ;;
    applications) cmd_applications ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "transpose v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
