#!/usr/bin/env bash
# splice — Array & Sequence Splicing Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Splice — Insert, Remove, Replace In-Place ===

Splicing is the operation of modifying a sequence (array, list, string)
by removing, inserting, or replacing elements at a specified position.

Splice vs Slice:
  Splice:  MUTATES the original. Removes and/or inserts elements.
  Slice:   COPIES a portion. Original unchanged.

  arr = [1, 2, 3, 4, 5]
  arr.slice(1, 3)   → [2, 3]         arr unchanged: [1, 2, 3, 4, 5]
  arr.splice(1, 2)  → [2, 3] removed  arr mutated:  [1, 4, 5]

Core Splice Operations:
  1. DELETE:    Remove N elements starting at index
  2. INSERT:    Add elements at index without removing
  3. REPLACE:   Remove N elements and insert new ones at same position
  4. EXTRACT:   Remove and return elements (splice doubles as extractor)

Splice Semantics:
  splice(start, deleteCount, ...items)
    start        Index to begin operation
    deleteCount  Number of elements to remove (0 = insert only)
    items        Elements to insert at the position

  Returns: Array of removed elements

Universal Rules:
  - Negative start counts from end (-1 = last element)
  - deleteCount of 0 = pure insertion
  - No items = pure deletion
  - Both deleteCount > 0 and items = replacement
  - Modifies length of the original sequence

Why Splice Exists:
  Without splice, insert/remove requires:
    1. Create new array of correct size
    2. Copy elements before insertion point
    3. Add new elements
    4. Copy remaining elements
  Splice encapsulates this into one atomic operation.
EOF
}

cmd_javascript() {
    cat << 'EOF'
=== JavaScript Array.prototype.splice ===

Signature:
  array.splice(start, deleteCount?, ...items)

--- DELETE ---
  const arr = ['a', 'b', 'c', 'd', 'e'];
  const removed = arr.splice(1, 2);
  // removed: ['b', 'c']
  // arr:     ['a', 'd', 'e']

--- INSERT ---
  const arr = [1, 2, 5, 6];
  arr.splice(2, 0, 3, 4);         // insert 3,4 at index 2
  // arr: [1, 2, 3, 4, 5, 6]

--- REPLACE ---
  const arr = ['Mon', 'Tue', 'XXX', 'Thu'];
  arr.splice(2, 1, 'Wed');        // replace 1 element at index 2
  // arr: ['Mon', 'Tue', 'Wed', 'Thu']

--- NEGATIVE INDEX ---
  const arr = [1, 2, 3, 4, 5];
  arr.splice(-2, 1);              // remove 1 at index -2 (= index 3)
  // arr: [1, 2, 3, 5]

--- EDGE CASES ---
  // start > length: treated as length (appends)
  [1,2].splice(10, 0, 3)          // [1, 2, 3]

  // deleteCount omitted: removes everything from start
  [1,2,3,4].splice(1)             // arr becomes [1], returns [2,3,4]

  // deleteCount > remaining: removes to end
  [1,2,3].splice(1, 99)           // arr becomes [1], returns [2,3]

  // Empty call: does nothing
  [1,2].splice(0, 0)              // arr unchanged, returns []

--- toSpliced (ES2023, non-mutating) ---
  const arr = [1, 2, 3, 4];
  const newArr = arr.toSpliced(1, 2, 'a', 'b');
  // newArr: [1, 'a', 'b', 4]
  // arr:    [1, 2, 3, 4] (unchanged!)

  Non-mutating version — returns new array.
  Supported in modern browsers and Node 20+.
EOF
}

cmd_python() {
    cat << 'EOF'
=== Python Splice (Slice Assignment) ===

Python has no .splice() method. Instead, use slice assignment.

--- DELETE ---
  lst = ['a', 'b', 'c', 'd', 'e']
  del lst[1:3]
  # lst: ['a', 'd', 'e']

  # Or assign empty list:
  lst[1:3] = []                   # same result

--- INSERT ---
  lst = [1, 2, 5, 6]
  lst[2:2] = [3, 4]              # insert at index 2 (delete 0)
  # lst: [1, 2, 3, 4, 5, 6]

--- REPLACE ---
  lst = ['Mon', 'Tue', 'XXX', 'Thu']
  lst[2:3] = ['Wed']
  # lst: ['Mon', 'Tue', 'Wed', 'Thu']

  # Replace with different count:
  lst = [1, 2, 3, 4, 5]
  lst[1:4] = [20, 30]            # remove 3, insert 2
  # lst: [1, 20, 30, 5]

--- EXTRACT + DELETE ---
  lst = [1, 2, 3, 4, 5]
  removed = lst[1:3]             # copy first
  del lst[1:3]                   # then delete
  # removed: [2, 3]
  # lst:     [1, 4, 5]

  # Or use pop for single element:
  lst.pop(2)                     # removes and returns index 2

--- STEP SLICING ---
  lst = [0, 1, 2, 3, 4, 5, 6, 7]
  lst[::2] = ['a', 'b', 'c', 'd']   # replace every other element
  # lst: ['a', 1, 'b', 3, 'c', 5, 'd', 7]
  # Note: replacement must have same length for step slicing

--- LIST COMPREHENSION ALTERNATIVE ---
  # Non-mutating "splice":
  result = lst[:2] + [10, 20] + lst[4:]
  # Equivalent to splice(2, 2, 10, 20) without mutation
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Splice Across Languages ===

--- Rust (Vec::splice) ---
  let mut v = vec![1, 2, 3, 4, 5];
  let removed: Vec<_> = v.splice(1..3, [20, 30]).collect();
  // v:       [1, 20, 30, 4, 5]
  // removed: [2, 3]

  // Uses Range syntax: 1..3 means indices 1, 2
  // Replacement can be any IntoIterator

  // Insert only (empty range):
  v.splice(2..2, [99]);         // [1, 20, 99, 30, 4, 5]

  // Delete only (no replacement):
  v.splice(1..3, []);           // removes indices 1, 2

--- Go (Slice Tricks) ---
  // No built-in splice. Use slice tricks:

  // Delete [i:j]:
  a = append(a[:i], a[j:]...)

  // Insert at index i:
  a = append(a[:i], append([]T{elem}, a[i:]...)...)

  // Replace:
  a = append(a[:i], append(replacement, a[j:]...)...)

  // Go 1.21+ slices package:
  a = slices.Delete(a, i, j)
  a = slices.Insert(a, i, elems...)
  a = slices.Replace(a, i, j, elems...)

--- Java (ArrayList) ---
  List<String> list = new ArrayList<>(Arrays.asList("a","b","c","d"));
  list.subList(1, 3).clear();    // delete indices 1-2
  list.addAll(1, Arrays.asList("x", "y"));  // insert at 1

--- C++ (std::vector) ---
  std::vector<int> v = {1, 2, 3, 4, 5};
  // Delete:
  v.erase(v.begin()+1, v.begin()+3);  // remove indices 1-2

  // Insert:
  v.insert(v.begin()+1, {10, 20});     // insert at index 1

  // Replace (erase + insert):
  auto it = v.erase(v.begin()+1, v.begin()+3);
  v.insert(it, {10, 20});

--- Ruby ---
  arr = [1, 2, 3, 4, 5]
  arr[1, 2] = [20, 30]           # replace 2 elements at index 1
  # arr: [1, 20, 30, 4, 5]

  arr[2, 0] = [99]               # insert at index 2
  arr.slice!(1, 2)               # delete and return 2 elements at index 1
EOF
}

cmd_strings() {
    cat << 'EOF'
=== String Splicing ===

Strings are immutable in most languages, so "splicing" creates a new string.

--- JavaScript ---
  // No string.splice() — strings are immutable
  // Use slice + concatenation:
  const s = "Hello World";
  const result = s.slice(0, 5) + " Beautiful" + s.slice(5);
  // "Hello Beautiful World"

  // Delete from string:
  const deleted = s.slice(0, 5) + s.slice(10);
  // "Hellod"

  // Replace substring:
  s.replace("World", "Earth");          // first occurrence
  s.replaceAll("l", "L");               // all occurrences (ES2021)

--- Python ---
  s = "Hello World"
  result = s[:5] + " Beautiful" + s[5:]
  # "Hello Beautiful World"

  # Using str methods:
  s.replace("World", "Earth")
  s[:5] + s[10:]                 # delete characters 5-9

--- Rust ---
  let mut s = String::from("Hello World");
  s.insert_str(5, " Beautiful");
  // "Hello Beautiful World"

  s.replace_range(5..10, " Earth");
  // replaces characters 5-9

  // Drain (extract + delete):
  let removed: String = s.drain(5..11).collect();

--- Go ---
  s := "Hello World"
  result := s[:5] + " Beautiful" + s[5:]

  // Using strings.Builder for efficiency:
  var b strings.Builder
  b.WriteString(s[:5])
  b.WriteString(" Beautiful")
  b.WriteString(s[5:])
  result = b.String()

--- C ---
  // Manual buffer manipulation
  char s[] = "Hello World";
  // Requires careful memory management
  // memmove, memcpy, realloc patterns
  // Generally use snprintf for safe string building

--- StringBuilder Pattern (Java, C#) ---
  StringBuilder sb = new StringBuilder("Hello World");
  sb.insert(5, " Beautiful");    // "Hello Beautiful World"
  sb.delete(5, 15);              // removes characters 5-14
  sb.replace(5, 10, "Earth");    // replaces range
EOF
}

cmd_binary() {
    cat << 'EOF'
=== Binary Data Splicing ===

--- Node.js Buffer ---
  const buf = Buffer.from([0x01, 0x02, 0x03, 0x04, 0x05]);

  // No splice on Buffer — convert to array or use Buffer.concat:
  const before = buf.subarray(0, 2);
  const after = buf.subarray(3);
  const insert = Buffer.from([0xAA, 0xBB]);
  const result = Buffer.concat([before, insert, after]);
  // <Buffer 01 02 aa bb 04 05>

--- Python bytes/bytearray ---
  # bytes are immutable:
  b = b'\x01\x02\x03\x04\x05'
  result = b[:2] + b'\xAA\xBB' + b[3:]

  # bytearray is mutable:
  ba = bytearray(b'\x01\x02\x03\x04\x05')
  ba[2:3] = b'\xAA\xBB'          # splice in place
  # bytearray(b'\x01\x02\xaa\xbb\x04\x05')

--- Rust Vec<u8> ---
  let mut data: Vec<u8> = vec![0x01, 0x02, 0x03, 0x04, 0x05];
  data.splice(2..3, [0xAA, 0xBB]);
  // [0x01, 0x02, 0xAA, 0xBB, 0x04, 0x05]

--- File Splicing ---
  Binary file editing often requires:
  1. Read file into memory (or memory-map)
  2. Splice the byte array
  3. Write back to file

  For large files, use:
  - Memory-mapped files (mmap)
  - Copy-on-write with temp file
  - Chunk-based processing (don't load entire file)

  # Unix dd for binary splice:
  dd if=input.bin of=output.bin bs=1 count=100        # first 100 bytes
  dd if=patch.bin of=output.bin bs=1 seek=100 conv=notrunc  # insert patch
  dd if=input.bin of=output.bin bs=1 skip=150 seek=120 conv=notrunc

--- Audio/Video Splicing ---
  ffmpeg: splice media streams without re-encoding
  ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 -c copy segment.mp4
  # Concat protocol for joining segments
  ffmpeg -f concat -i filelist.txt -c copy output.mp4
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Splice Performance ===

Time Complexity:
  Array splice:    O(n)  — must shift elements after splice point
  Linked list:     O(1)  — for splice operation itself (O(n) to find position)
  Rope (string):   O(log n) — balanced tree of string segments
  Gap buffer:      O(1) amortized — if cursor near splice point

Why Array Splice is O(n):
  [1, 2, 3, 4, 5, 6, 7, 8]
        ↑ splice(2, 1, 'a', 'b')
  1. Remove element at index 2 (value: 3)
  2. Shift elements 4-8 right by 1 (net: insert 2, remove 1)
  3. Write new elements at indices 2-3
  Result: [1, 2, 'a', 'b', 4, 5, 6, 7, 8]
  Shifted: 5 elements → O(n) for array of size n

Optimization Strategies:
  1. Batch operations:
     BAD:  splice one at a time in a loop → O(n²)
     GOOD: collect all changes, apply in one operation

  2. Splice from end to start:
     When doing multiple splices, work backwards
     Avoids index shift issues and reduces total shifts

  3. Use appropriate data structure:
     Frequent insert/delete → Linked List or Deque
     Frequent random access → Array
     Text editing → Gap Buffer or Rope

  4. Pre-allocate for known insertions:
     If you know you'll insert 1000 elements, resize first

Memory Implications:
  - Splice may trigger array reallocation (if growing)
  - Removed elements need garbage collection
  - In-place splice avoids creating new array (saves memory)
  - toSpliced() (JS) creates new array (more memory, less mutation risk)

Benchmarks (rough, 10,000 element array):
  Single splice at start:     ~5μs
  Single splice at middle:    ~3μs
  Single splice at end:       ~0.5μs (basically push/pop)
  1000 splices in loop:       ~50ms (O(n²) total)
  1000 splices batched:       ~0.5ms (O(n) total)
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Common Splice Patterns ===

--- Remove by Value ---
  // JavaScript
  const idx = arr.indexOf(value);
  if (idx !== -1) arr.splice(idx, 1);

  // Remove all occurrences:
  for (let i = arr.length - 1; i >= 0; i--) {
    if (arr[i] === value) arr.splice(i, 1);
  }
  // Note: iterate backwards to avoid index shift issues

--- Insert Sorted ---
  function insertSorted(arr, val) {
    let i = 0;
    while (i < arr.length && arr[i] < val) i++;
    arr.splice(i, 0, val);
  }
  // Better: use binary search for O(log n) find + O(n) insert

--- Interleave Two Arrays ---
  function interleave(a, b) {
    const result = [...a];
    for (let i = b.length - 1; i >= 0; i--) {
      result.splice(i + 1, 0, b[i]);
    }
    return result;
  }
  // [1,2,3] + [a,b,c] → [1,a,2,b,3,c]

--- Circular Buffer Pop ---
  function circularPop(buf, head) {
    const [val] = buf.splice(head, 1);
    return val;  // head now points to next element automatically
  }

--- Move Element ---
  function move(arr, fromIdx, toIdx) {
    const [item] = arr.splice(fromIdx, 1);
    arr.splice(toIdx, 0, item);
  }
  // Useful for drag-and-drop reordering

--- Chunk Insert ---
  // Insert a chunk every N elements
  function insertEvery(arr, n, item) {
    for (let i = n; i < arr.length; i += n + 1) {
      arr.splice(i, 0, item);
    }
  }
  // [1,2,3,4,5,6], every 2, '-' → [1,2,'-',3,4,'-',5,6]

--- Swap via Splice ---
  function swap(arr, i, j) {
    if (i > j) [i, j] = [j, i];
    const [a] = arr.splice(i, 1);
    const [b] = arr.splice(j - 1, 1);  // -1 because i was removed
    arr.splice(i, 0, b);
    arr.splice(j, 0, a);
  }
  // Simpler: [arr[i], arr[j]] = [arr[j], arr[i]];

--- Flatten One Level ---
  function flattenOnce(arr) {
    for (let i = arr.length - 1; i >= 0; i--) {
      if (Array.isArray(arr[i])) {
        arr.splice(i, 1, ...arr[i]);
      }
    }
  }
EOF
}

show_help() {
    cat << EOF
splice v$VERSION — Array & Sequence Splicing Reference

Usage: script.sh <command>

Commands:
  intro        What splicing is, splice vs slice semantics
  javascript   JS Array.splice API, edge cases, toSpliced
  python       Python slice assignment as splice equivalent
  languages    Splice in Rust, Go, Java, C++, Ruby
  strings      String splicing patterns across languages
  binary       Splicing binary data, buffers, byte arrays
  performance  Time complexity and optimization strategies
  patterns     Common patterns: remove, insert sorted, interleave
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    javascript)  cmd_javascript ;;
    python)      cmd_python ;;
    languages)   cmd_languages ;;
    strings)     cmd_strings ;;
    binary)      cmd_binary ;;
    performance) cmd_performance ;;
    patterns)    cmd_patterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "splice v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
