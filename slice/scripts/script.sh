#!/usr/bin/env bash
# slice — Array & Data Slicing Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
=== Slicing ===

A slice is a contiguous sub-sequence of an array, string, or dataset.
Slicing extracts a portion without copying the entire structure.

Key Concepts:
  Start index:  where the slice begins (inclusive)
  End index:    where the slice ends (exclusive in most languages)
  Step/stride:  skip every Nth element

  View vs Copy:
    View:  slice references same memory (changes affect original)
    Copy:  slice has its own memory (independent)

  Language defaults:
    Python lists:  copy (new list created)
    NumPy arrays:  view (shares memory!)
    Go slices:     view (shares underlying array)
    Rust slices:   borrow (view with ownership rules)
    JavaScript:    copy (Array.slice creates new array)

Indexing Conventions:
  Zero-based:      [0, 1, 2, 3, 4]  (most languages)
  One-based:       [1, 2, 3, 4, 5]  (MATLAB, R, Lua, Julia)
  Negative index:  arr[-1] = last element (Python, Ruby, Rust)

  Half-open intervals: [start, end)
    arr[2:5] → elements at index 2, 3, 4 (NOT 5)
    Length = end - start
    arr[0:n] = entire array
    arr[i:i] = empty slice
EOF
}

cmd_python() { cat << 'EOF'
=== Python Slicing ===

Syntax: sequence[start:stop:step]
  All three parameters are optional.

--- Basic Slicing ---
  lst = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  lst[2:5]     → [2, 3, 4]         # index 2 to 4
  lst[:3]      → [0, 1, 2]         # first 3 elements
  lst[7:]      → [7, 8, 9]         # from index 7 to end
  lst[:]       → [0, 1, ..., 9]    # full copy
  lst[::2]     → [0, 2, 4, 6, 8]  # every 2nd element
  lst[1::2]    → [1, 3, 5, 7, 9]  # odd-indexed elements

--- Negative Indexing ---
  lst[-1]      → 9                  # last element
  lst[-3:]     → [7, 8, 9]         # last 3 elements
  lst[:-2]     → [0, 1, ..., 7]    # all except last 2
  lst[::-1]    → [9, 8, ..., 0]    # reversed
  lst[::-2]    → [9, 7, 5, 3, 1]  # reversed, every 2nd

--- String Slicing ---
  s = "Hello, World!"
  s[7:12]      → "World"
  s[::-1]      → "!dlroW ,olleH"   # reverse string
  s[::2]       → "Hlo ol!"         # every other character

--- Assignment (Mutable) ---
  lst[2:5] = [20, 30, 40]         # replace slice
  lst[2:5] = [20, 30]             # replace with fewer (list shrinks)
  lst[2:2] = [99, 98]             # insert without removing
  del lst[2:5]                     # delete slice

--- Slice Objects ---
  s = slice(2, 5)
  lst[s]  →  same as lst[2:5]
  Useful for: reusable slice definitions, passing slices to functions

--- Out-of-Bounds Safety ---
  lst[100:]    → [] (no error, empty result)
  lst[-100:]   → [0, 1, ..., 9] (clips to start)
  lst[2:100]   → [2, 3, ..., 9] (clips to end)
  Python slicing NEVER raises IndexError (unlike indexing)
EOF
}

cmd_go() { cat << 'EOF'
=== Go Slices ===

Go slices are one of Go's most important data structures.
A slice is a descriptor for a contiguous segment of an underlying array.

--- Slice Header ---
  type SliceHeader struct {
      Data uintptr   // pointer to underlying array
      Len  int       // number of elements in slice
      Cap  int       // capacity (elements from Data to end of array)
  }

--- Creation ---
  s := []int{1, 2, 3, 4, 5}      // literal
  s := make([]int, 5)             // len=5, cap=5, zero-filled
  s := make([]int, 0, 10)         // len=0, cap=10 (pre-allocate)

--- Slicing (Reslice) ---
  a := []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
  b := a[2:5]    // [2, 3, 4], len=3, cap=8

  ⚠ b shares memory with a!
  b[0] = 99      // a is now [0, 1, 99, 3, 4, ...]

  Three-index slice (limit capacity):
  c := a[2:5:5]  // [2, 3, 4], len=3, cap=3
  // Prevents c from accidentally accessing a's memory beyond index 5

--- Append ---
  s = append(s, 6)           // add one element
  s = append(s, 7, 8, 9)     // add multiple
  s = append(s, other...)    // append another slice

  When len == cap: Go allocates new, larger array and copies.
  Growth factor: ~2× for small slices, ~1.25× for large.
  After reallocation: old and new slices are independent.

--- Copy ---
  dst := make([]int, len(src))
  copy(dst, src)              // independent copy

  Without copy: b := a[2:5] shares memory → bugs!

--- Gotchas ---
  1. Slice of slice shares underlying array
     Modification through one affects the other
     Fix: copy explicitly when independence needed

  2. Append may or may not create new array
     If cap > len: appends in place (modifies shared array!)
     If cap == len: allocates new array (independent)
     This is the single most common Go slice bug

  3. Memory leak: small slice of large array keeps large array alive
     Fix: copy small slice to new allocation
     s := make([]byte, len(small))
     copy(s, bigArray[10:20])
EOF
}

cmd_rust() { cat << 'EOF'
=== Rust Slices ===

Rust slices are borrowed references to contiguous sequences.
They don't own the data — they borrow it.

--- Types ---
  &[T]        Immutable slice (shared reference)
  &mut [T]    Mutable slice (exclusive reference)
  &str        String slice (immutable, UTF-8 bytes)

--- Creation ---
  let arr = [1, 2, 3, 4, 5];
  let slice: &[i32] = &arr[1..4];    // [2, 3, 4]
  let slice: &[i32] = &arr[..3];     // [1, 2, 3]
  let slice: &[i32] = &arr[2..];     // [3, 4, 5]
  let slice: &[i32] = &arr[..];      // [1, 2, 3, 4, 5]

  let s = "Hello, World!";
  let hello: &str = &s[0..5];        // "Hello"
  // ⚠ String slicing is byte-based, not character-based!
  // Slicing in the middle of a multi-byte char → panic

--- Useful Methods ---
  slice.len()                // length
  slice.is_empty()           // len == 0
  slice.first()              // Option<&T>
  slice.last()               // Option<&T>
  slice.contains(&val)       // search
  slice.iter()               // iterator
  slice.windows(3)           // sliding windows of size 3
  slice.chunks(4)            // non-overlapping chunks of size 4
  slice.split(|x| *x == 0)  // split at elements matching predicate
  slice.binary_search(&val)  // O(log n) search in sorted slice

--- Mutable Operations ---
  let mut arr = [5, 3, 1, 4, 2];
  let slice = &mut arr[..];
  slice.sort();                    // [1, 2, 3, 4, 5]
  slice.reverse();                 // [5, 4, 3, 2, 1]
  slice.swap(0, 4);                // swap elements
  slice.rotate_left(2);           // [3, 2, 1, 5, 4]
  slice.fill(0);                   // [0, 0, 0, 0, 0]

--- Ownership Rules ---
  Can't have &mut [T] and &[T] at the same time
  Prevents data races at compile time
  split_at_mut(idx): split mutable slice into two non-overlapping
    let (left, right) = slice.split_at_mut(3);
    // Can mutate left and right independently
EOF
}

cmd_javascript() { cat << 'EOF'
=== JavaScript Slicing ===

--- Array.slice() — Non-Destructive ---
  const arr = [0, 1, 2, 3, 4, 5];
  arr.slice(2, 5)    // [2, 3, 4]  — new array!
  arr.slice(-3)      // [3, 4, 5]  — last 3
  arr.slice()        // [0, 1, 2, 3, 4, 5]  — shallow copy

  slice() NEVER modifies the original array.

--- Array.splice() — Destructive ---
  const arr = [0, 1, 2, 3, 4, 5];
  arr.splice(2, 3)           // removes [2, 3, 4], arr is now [0, 1, 5]
  arr.splice(2, 0, 'a', 'b') // insert at index 2: [0, 1, 'a', 'b', 5]
  arr.splice(1, 1, 'x')      // replace index 1: [0, 'x', 'a', 'b', 5]

  splice(start, deleteCount, ...items)
  MODIFIES original array, returns deleted elements.

--- String.slice() ---
  "Hello, World!".slice(7, 12)    // "World"
  "Hello, World!".slice(-6)       // "orld!"
  Strings are immutable — always creates new string.

--- TypedArray Slicing ---
  const buf = new ArrayBuffer(16);
  const view = new Int32Array(buf);
  const sub = view.subarray(1, 3);   // VIEW (shares buffer!)
  const copy = view.slice(1, 3);      // COPY (new buffer)

  ⚠ subarray() = view (shared memory)
  ⚠ slice() = copy (independent)

--- Destructuring + Spread ---
  const [first, ...rest] = [1, 2, 3, 4, 5];
  // first = 1, rest = [2, 3, 4, 5]

  const [a, , b] = [1, 2, 3];  // skip element: a=1, b=3

--- Array.from() for Slicing ---
  Array.from({length: 5}, (_, i) => i)     // [0, 1, 2, 3, 4]
  Array.from(str)                            // split string to chars
  Array.from(set)                            // Set to Array
EOF
}

cmd_numpy() { cat << 'EOF'
=== NumPy Advanced Slicing ===

NumPy slices are VIEWS (not copies) — changes propagate to original!

--- Basic Slicing (View) ---
  import numpy as np
  a = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  b = a[3:7]      # array([3, 4, 5, 6]) — VIEW
  b[0] = 99       # a is now [0, 1, 2, 99, 4, 5, 6, 7, 8, 9]

  To get a copy: b = a[3:7].copy()

--- Multi-Dimensional ---
  m = np.arange(12).reshape(3, 4)
  #  [[ 0,  1,  2,  3],
  #   [ 4,  5,  6,  7],
  #   [ 8,  9, 10, 11]]

  m[1, 2]        # 6 (single element)
  m[1, :]        # [4, 5, 6, 7] (entire row 1)
  m[:, 2]        # [2, 6, 10] (entire column 2)
  m[0:2, 1:3]    # [[1, 2], [5, 6]] (submatrix)
  m[::2, ::2]    # [[0, 2], [8, 10]] (every other row+col)

--- Fancy Indexing (Copy) ---
  idx = [0, 2, 4]
  a[idx]             # array([0, 2, 4]) — COPY, not view

  m[[0, 2], :]       # rows 0 and 2
  m[:, [1, 3]]       # columns 1 and 3
  m[[0, 1], [2, 3]]  # elements (0,2) and (1,3) → [2, 7]

--- Boolean Masking (Copy) ---
  mask = a > 5
  a[mask]             # array([6, 7, 8, 9]) — COPY
  a[a > 5] = 0        # set all values > 5 to 0

  Combined: a[(a > 2) & (a < 7)]  # array([3, 4, 5, 6])

--- np.where ---
  np.where(a > 5, a, 0)    # keep values >5, replace others with 0
  np.where(a > 5)           # tuple of indices where condition is true

--- View vs Copy Rules ---
  Basic slicing (a[2:5]):           VIEW
  Fancy indexing (a[[1,3,5]]):      COPY
  Boolean indexing (a[a>5]):        COPY
  np.array slice:                   VIEW
  a.copy():                         explicit COPY
  Test: b.base is a → True if b is a view of a
EOF
}

cmd_database() { cat << 'EOF'
=== Database Slicing ===

--- LIMIT / OFFSET ---
  SELECT * FROM products ORDER BY id LIMIT 20 OFFSET 40;
  -- Skip 40, take 20 (page 3 of 20-item pages)

  PostgreSQL: LIMIT 20 OFFSET 40
  MySQL:      LIMIT 40, 20 (offset, count — reversed!)
  SQL Server: OFFSET 40 ROWS FETCH NEXT 20 ROWS ONLY
  Oracle:     OFFSET 40 ROWS FETCH NEXT 20 ROWS ONLY (12c+)

--- Array Slicing in SQL ---
  PostgreSQL array slicing:
    arr[2:5]         -- elements 2 through 5 (1-indexed!)
    arr[1:3]         -- first 3 elements
    arr[2:]          -- from element 2 to end

  PostgreSQL array functions:
    array_length(arr, 1)    -- length of first dimension
    unnest(arr)              -- expand array to rows
    array_agg(col)           -- collect rows into array
    arr[1:5] || arr[8:10]    -- concatenate slices

--- Window Frame Slicing ---
  SELECT value,
    AVG(value) OVER (
      ORDER BY date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_7
  FROM metrics;

  Frame types:
    ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING   -- fixed row count
    RANGE BETWEEN '7 days' PRECEDING AND CURRENT ROW  -- time range
    GROUPS BETWEEN 1 PRECEDING AND 1 FOLLOWING  -- group boundaries

--- JSON Slicing ---
  PostgreSQL:
    data->'items'->0          -- first element of JSON array
    data->'items'->-1         -- last element (PostgreSQL 14+)
    jsonb_array_elements(data->'items')  -- unnest JSON array

  MySQL:
    JSON_EXTRACT(data, '$.items[0]')
    JSON_EXTRACT(data, '$.items[0 to 4]')  -- MySQL 8.0.21+
EOF
}

cmd_patterns() { cat << 'EOF'
=== Slice-Based Patterns ===

--- Sliding Window ---
  Process elements in overlapping windows of size k.

  Python: [lst[i:i+k] for i in range(len(lst)-k+1)]
  NumPy:  np.lib.stride_tricks.sliding_window_view(arr, k)
  Rust:   slice.windows(k)

  Use cases:
    Moving average, convolution, pattern matching,
    substring search, network packet analysis

--- Chunking ---
  Split into non-overlapping chunks of size k.

  Python: [lst[i:i+k] for i in range(0, len(lst), k)]
  NumPy:  np.array_split(arr, n_chunks)
  Rust:   slice.chunks(k)
  Go:     for i := 0; i < len(s); i += k { chunk := s[i:min(i+k, len(s))] }

  Use cases:
    Batch processing, pagination, parallel work distribution

--- Circular Buffer (Ring Buffer) ---
  Fixed-size buffer that wraps around.

  read_pos = (read_pos + 1) % capacity
  write_pos = (write_pos + 1) % capacity
  is_full = (write_pos + 1) % capacity == read_pos

  Slice views: may need two slices (wrap-around)
    [write_pos:capacity] + [0:read_pos]

  Use cases: audio processing, network buffers, log rotation

--- Two-Pointer / Shrinking Window ---
  Two indices that move toward each other or in same direction.

  left, right = 0, len(arr)-1
  while left < right:
      # process arr[left:right+1]
      # move left or right based on condition

  Use cases: sorted array problems, palindrome check,
  container with most water, three-sum

--- Prefix/Suffix Arrays ---
  prefix[i] = sum(arr[0:i+1])     -- prefix sum
  suffix[i] = sum(arr[i:])        -- suffix sum

  Range query: sum(arr[l:r]) = prefix[r] - prefix[l-1]
  O(1) after O(n) preprocessing

  Use cases: range queries, subarray sums, histogram equalization
EOF
}

show_help() { cat << EOF
slice v$VERSION — Array & Data Slicing Reference

Usage: script.sh <command>

Commands:
  intro        Slicing concepts, view vs copy, indexing conventions
  python       Python list and string slicing tricks
  go           Go slices: capacity, append, shared memory gotchas
  rust         Rust slices: borrowing, methods, ownership rules
  javascript   Array.slice, splice, TypedArray, destructuring
  numpy        NumPy views, fancy indexing, boolean masks
  database     SQL LIMIT/OFFSET, array slicing, window frames
  patterns     Sliding window, chunking, ring buffer, two-pointer
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"
case "$CMD" in
    intro) cmd_intro ;; python) cmd_python ;; go) cmd_go ;;
    rust) cmd_rust ;; javascript) cmd_javascript ;; numpy) cmd_numpy ;;
    database) cmd_database ;; patterns) cmd_patterns ;;
    help|--help|-h) show_help ;; version|--version|-v) echo "slice v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
