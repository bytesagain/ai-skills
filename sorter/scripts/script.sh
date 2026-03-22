#!/usr/bin/env bash
# sorter — Sorting Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Sorting ===

Sorting arranges elements in a defined order (ascending, descending,
or by custom key). The most-studied problem in computer science.

Classification:

  By method:
    Comparison-based   Compare pairs of elements (O(n log n) optimal)
    Distribution-based Use element values directly (can beat O(n log n))

  By stability:
    Stable       Equal elements maintain original relative order
    Unstable     Equal elements may be reordered

    Why stability matters:
      Sort by last name, then by first name
      Stable: "Smith, Alice" stays before "Smith, Bob"
      Unstable: might swap them

  By memory:
    In-place     O(1) extra memory (sorts within the array)
    Out-of-place O(n) extra memory (needs auxiliary space)

  By adaptivity:
    Adaptive     Faster on partially sorted data
    Non-adaptive Same performance regardless of input order

Complexity Summary:
  Algorithm       Best        Average       Worst        Space  Stable
  Insertion       O(n)        O(n²)         O(n²)        O(1)   Yes
  Selection       O(n²)       O(n²)         O(n²)        O(1)   No
  Bubble          O(n)        O(n²)         O(n²)        O(1)   Yes
  Merge           O(n log n)  O(n log n)    O(n log n)   O(n)   Yes
  Quick           O(n log n)  O(n log n)    O(n²)        O(log n) No
  Heap            O(n log n)  O(n log n)    O(n log n)   O(1)   No
  Tim             O(n)        O(n log n)    O(n log n)   O(n)   Yes
  Counting        O(n+k)      O(n+k)        O(n+k)       O(k)   Yes
  Radix           O(nk)       O(nk)         O(nk)        O(n+k) Yes
  Bucket          O(n+k)      O(n+k)        O(n²)        O(n)   Yes

  n = number of elements, k = range of values
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Comparison-Based Sorts ===

--- Quicksort ---
  Strategy: pick pivot, partition array, recurse on halves
  Average: O(n log n), Worst: O(n²) — but worst case is rare
  Space: O(log n) for recursion stack
  NOT stable

  Why it's fast in practice:
    Cache-friendly (sequential memory access)
    Low constant factor (simple inner loop)
    In-place (no allocation in hot path)

  Pivot strategies:
    First/last element:  O(n²) on sorted input — DON'T
    Random pivot:        O(n log n) expected
    Median-of-three:     first, middle, last — most common
    Ninther:             median of medians — used in introsort

  Quicksort is the default in: C qsort, Java Arrays.sort (primitives)

--- Merge Sort ---
  Strategy: split array in half, sort each half, merge
  Always O(n log n) — guaranteed, no worst case
  Space: O(n) for merge buffer
  STABLE — preserves order of equal elements

  Why choose merge sort:
    Guaranteed O(n log n) (critical for real-time systems)
    Stable (needed for multi-key sorting)
    Natural for linked lists (O(1) space)
    Natural for external sorting (disk-based merge)

  Used in: Python sorted() (as part of Timsort), Java Arrays.sort (objects)

--- Heapsort ---
  Strategy: build max-heap, repeatedly extract maximum
  Always O(n log n), Space: O(1) — truly in-place
  NOT stable

  Why choose heapsort:
    Guaranteed O(n log n) with O(1) space
    No worst-case degradation
    Good when memory is scarce

  Why it's slower in practice:
    Poor cache behavior (jumps around array)
    Higher constant factor than quicksort
    Rarely used standalone — mostly as introsort fallback

--- Timsort ---
  Hybrid: insertion sort + merge sort
  Finds natural "runs" (pre-sorted subsequences) in data
  Merges runs using a sophisticated strategy
  Best: O(n) on sorted data, Worst: O(n log n)
  STABLE, Space: O(n)

  Used in: Python (default sort), Java (Arrays.sort for objects),
           Android, Swift, Rust (stable sort)

  Why it dominates:
    Real-world data is often partially sorted
    Timsort exploits this — much faster than pure merge sort
    Stable — required for many applications
EOF
}

cmd_distribution() {
    cat << 'EOF'
=== Distribution Sorts ===

These sorts don't compare elements — they use element VALUES directly.
Can achieve O(n) performance, beating the O(n log n) comparison lower bound.

--- Counting Sort ---
  How: count occurrences of each value, reconstruct sorted array
  Time: O(n + k) where k = range of values
  Space: O(k) for count array
  STABLE (if implemented correctly)

  When to use:
    Small range of integer values (k ≈ n or smaller)
    Example: sort grades 0-100, sort ages 0-150
    NOT suitable: floating point, large range, complex keys

  Algorithm:
    1. Find min and max values → determine range k
    2. Create count array of size k, initialized to 0
    3. For each element: count[element]++
    4. Compute prefix sums (cumulative counts)
    5. Place elements in output array using prefix sums
    6. Decrement prefix sum after each placement

--- Radix Sort ---
  How: sort by each digit/character position, least significant first
  Time: O(d × (n + k)) where d = digits, k = radix
  Space: O(n + k)
  STABLE (required — each digit sort must be stable)

  Variants:
    LSD (Least Significant Digit): right to left
      Most common, uses counting sort per digit
      Natural for fixed-length integers and strings

    MSD (Most Significant Digit): left to right
      Can short-circuit (skip if bucket has 1 element)
      Natural for variable-length strings
      Used in: string sorting, trie-based sorts

  When to use:
    Sorting integers: radix sort beats comparison sorts when n > 1000
    Sorting fixed-length strings: faster than comparison (no string compare)
    Database indexing: building sorted index on integer keys

  Example: sort [329, 457, 657, 839, 436, 720, 355]
    Pass 1 (ones):  720 355 436 457 657 329 839
    Pass 2 (tens):  720 329 436 839 355 457 657
    Pass 3 (hundreds): 329 355 436 457 657 720 839

--- Bucket Sort ---
  How: distribute elements into buckets, sort each bucket, concatenate
  Time: O(n + k) average (if uniform distribution)
  Worst: O(n²) if all elements land in one bucket
  Space: O(n)

  When to use:
    Uniformly distributed floating-point numbers in [0, 1)
    Data with known distribution
    Parallel sorting (each bucket sorted independently)

  Algorithm:
    1. Create k empty buckets
    2. For each element: assign to bucket based on value range
    3. Sort each bucket (insertion sort for small buckets)
    4. Concatenate all buckets in order
EOF
}

cmd_simple() {
    cat << 'EOF'
=== Simple Sorts — When They Actually Win ===

--- Insertion Sort ---
  How: take each element, insert it in correct position in sorted prefix
  Time: O(n²) average, O(n) on nearly-sorted data
  Space: O(1)
  STABLE, adaptive

  When insertion sort wins:
    n < 20-50:   faster than quicksort due to lower overhead
    Nearly sorted: O(n) — best case for any comparison sort
    Online:       can sort as data arrives (one element at a time)
    Used by:      Timsort (for small runs), introsort (small partitions)

  This is why std::sort switches to insertion sort for small subarrays.

--- Selection Sort ---
  How: find minimum, swap to front, repeat
  Time: O(n²) always — not adaptive
  Space: O(1)
  NOT stable (swapping breaks order)

  When to use:
    Almost never in practice
    Minimizes number of SWAPS (O(n) swaps vs O(n²) for insertion)
    Useful when: writes are extremely expensive (flash memory)

--- Bubble Sort ---
  How: repeatedly swap adjacent elements if out of order
  Time: O(n²) average, O(n) on already-sorted
  Space: O(1)
  STABLE, adaptive

  When to use:
    Teaching purposes — simplest to understand
    Detecting sorted arrays — one pass with no swaps = sorted
    Otherwise: never use in production code

--- Shell Sort ---
  How: insertion sort with decreasing gap sequence
  Time: depends on gap sequence — O(n^1.3) to O(n^(4/3)) typical
  Space: O(1)
  NOT stable

  When to use:
    Embedded systems with very limited memory
    When you need in-place and better than O(n²) but can't use recursion
    Gap sequences: Ciura (1, 4, 10, 23, 57, 132, 301, 701...)

--- Practical Insight ---
  Modern language standard libraries use hybrid sorts:
    Introsort (C++):  quicksort + heapsort + insertion sort
    Timsort (Python/Java): merge sort + insertion sort
    Pattern-defeating quicksort (Rust): quicksort + heapsort + insertion sort

  They switch to insertion sort for small subarrays (n < 16-64)
  because the overhead of recursion exceeds the O(n²) cost at small n.
EOF
}

cmd_parallel() {
    cat << 'EOF'
=== Parallel and External Sorting ===

--- External Merge Sort (Disk) ---
  When data doesn't fit in memory:
    1. Read chunks that fit in RAM
    2. Sort each chunk in memory (quicksort/timsort)
    3. Write sorted chunks to temporary files
    4. K-way merge sorted files into final output

  Performance:
    I/O bound — minimize disk reads/writes
    Two-pass sort handles data up to M×M (M = memory size)
    Three-pass for larger datasets

  Optimizations:
    Large read/write buffers (reduce I/O calls)
    Replacement selection (create runs longer than memory)
    Polyphase merge (optimize merge pass count)

  Used by: Unix sort command, database ORDER BY (when table > memory)

--- Parallel Sort ---

  Parallel Merge Sort:
    Split array across processors
    Each processor sorts its portion
    Merge sorted portions (can also be parallelized)
    Work: O(n log n), Span: O(log³ n)

  Parallel Quicksort:
    Partition on one processor, recurse on two
    Problem: partitioning is serial — limits speedup
    Fix: sample sort — pick p-1 splitters, create p buckets

  Sample Sort:
    1. Take random sample of n/p elements
    2. Sort sample, pick p-1 evenly spaced splitters
    3. Distribute all elements to p processors by splitter range
    4. Each processor sorts its bucket independently
    Achieves near-perfect load balance

--- MapReduce Sorting ---
  Hadoop/Spark sort for distributed clusters:
    Map phase: partition data by key range
    Shuffle: send each partition to correct reducer
    Reduce phase: sort each partition locally
    TeraSort: sorted 1TB in 62 seconds (2008 record)

--- GPU Sorting ---
  Radix sort maps well to GPU architecture (SIMD)
  Bitonic sort: designed for parallel networks
  Thrust library (CUDA): parallel sort for GPU
  Performance: 1-4 billion 32-bit integers per second on modern GPU

--- Database Sorting ---
  B-tree index: data already sorted by index key
  Index scan: O(n) to read in sorted order (no sort needed!)
  Sort-merge join: both tables sorted, then merged
  Top-N sort: heap of size N, O(n log N) — much faster than full sort
  LIMIT 10 ORDER BY: doesn't need to sort everything — just find top 10
EOF
}

cmd_choosing() {
    cat << 'EOF'
=== Choosing the Right Sort ===

--- Decision Tree ---

  How many elements?
    n < 20         → Insertion sort (lowest overhead)
    n < 1000       → Quicksort or Timsort
    n > 1000       → Depends on data characteristics

  Need stability?
    Yes            → Merge sort / Timsort
    No             → Quicksort / Introsort

  Guaranteed O(n log n)?
    Yes            → Merge sort or Heapsort
    No (OK with rare O(n²)) → Quicksort

  Data type?
    Small integers (range ≈ n) → Counting sort O(n+k)
    Fixed-length integers      → Radix sort O(nk)
    Floating point [0,1)       → Bucket sort O(n)
    General objects             → Comparison sort O(n log n)

  Memory constraint?
    O(1) extra     → Heapsort (or in-place merge sort)
    O(n) OK        → Merge sort / Timsort
    O(log n) OK    → Quicksort

  Data partially sorted?
    Yes            → Timsort (exploits existing runs)
    Reversed       → Timsort handles this too
    Random         → Quicksort edges ahead

--- Benchmark Rules of Thumb ---
  (sorting 32-bit integers on modern x86)

  n = 10:        insertion sort < everything else
  n = 100:       quicksort ≈ insertion sort (crossover point)
  n = 10,000:    quicksort wins by 2-3× over insertion
  n = 1,000,000: radix sort wins for integers
                 quicksort wins for general comparison
  n = 1 billion: need parallel/distributed sort

--- Language Defaults ---
  C (qsort):         Quicksort (varies by implementation)
  C++ (std::sort):   Introsort (quicksort + heapsort + insertion)
  Python (sorted):   Timsort
  Java (Arrays.sort): Dual-pivot quicksort (primitives), Timsort (objects)
  Rust (sort):       Timsort variant (stable), pattern-defeating QS (unstable)
  Go (sort.Slice):   Pattern-defeating quicksort
  JavaScript:        Timsort (V8), merge sort (SpiderMonkey)
EOF
}

cmd_physical() {
    cat << 'EOF'
=== Physical Sortation Systems ===

Industrial sorting systems for warehouses, distribution centers,
and postal facilities.

--- Sorting Technologies ---

  Crossbelt Sorter:
    Individual carriers with mini belt conveyors
    Load/unload independently at full speed
    Throughput: 200-450 items/min
    Destinations: 100-500+
    Best for: mixed sizes, shapes, fragile items
    Cost: $2M-15M installed

  Sliding Shoe Sorter:
    Angled shoes push items off conveyor surface
    Throughput: 100-300 items/min
    Destinations: 30-100+
    Best for: flat-bottom cartons and packages
    Cost: $500K-5M installed

  Tilt-Tray Sorter:
    Trays tilt to dump items into chutes
    Throughput: 150-250 items/min
    Best for: small, uniform items
    Cost: $1M-8M installed

  Bomb Bay Sorter:
    Floor panels open to drop items
    Throughput: 200+ items/min
    Best for: flat items (envelopes, polybags)

  Pop-Up Wheel Divert:
    Wheels rise through roller gaps
    Throughput: 30-60 items/min per divert
    Lowest cost option
    Best for: low-speed, carton sorting

--- Postal Sorting ---
  Modern postal facilities sort 36,000+ letters per hour per machine

  Sequence:
    1. Culling: remove non-machinable items
    2. Facing: orient all letters same direction
    3. Cancelling: postmark stamps
    4. OCR/BCR: read address, apply barcode (11-digit POSTNET/Intelligent Mail)
    5. Primary sort: by region/zip code
    6. Secondary sort: by delivery route
    7. Carrier sequence sort: sorted in delivery walk order

--- Warehouse Order Sorting ---
  Put-to-Light:
    Pick items in batch → sort to orders at put wall
    Light shows which order gets each item
    100-200 orders per hour per operator

  Goods-to-Person:
    Robots bring items to operator
    Operator sorts/picks at stationary workstation
    Examples: Amazon Kiva (now Amazon Robotics), AutoStore

  Wave vs Waveless:
    Wave: orders released in batches, sorted at end
    Waveless: orders released continuously, sorted in-line
    Trend: moving toward waveless for flexibility

--- Throughput Planning ---
  Sort rate = (items/hr) ÷ (destinations)
  If each destination needs 10 items/hr, 100 destinations:
    1,000 items/hr minimum sort rate
    Choose sorter with 1,500+ capacity (50% buffer)

  Induction rate often the bottleneck:
    Manual induction: 20-30 items/min per operator
    Automated induction: 60-120 items/min per inductor
    Multiple induction points needed for high throughput
EOF
}

cmd_tricks() {
    cat << 'EOF'
=== Sorting Tricks & Optimizations ===

--- Partial Sort (Top-K) ---
  Need only the K smallest/largest elements?
  Don't sort everything — use a heap!

  Min-heap approach: O(n log k)
    Maintain heap of size k
    For each element: if better than heap top, replace
    Result: k elements in heap are the answer

  Quickselect: O(n) average
    Partition like quicksort, but only recurse on the side containing k
    C++: std::partial_sort, std::nth_element
    Python: heapq.nsmallest(k, iterable)

  Example: "Top 10 scores from 1M records"
    Full sort: O(n log n) = ~20M comparisons
    Partial sort: O(n log k) = ~3.3M comparisons (6× faster)

--- Nth Element ---
  Find the element that would be at position N if sorted
  Without actually sorting everything

  Quickselect (Hoare's algorithm): O(n) average, O(n²) worst
  Median of Medians: O(n) guaranteed (but larger constant)
  C++: std::nth_element
  Use: finding median, percentiles, partitioning

--- Exploiting Presorted Data ---
  If data is "almost sorted" (few inversions):
    Insertion sort: O(n + inversions) — nearly O(n)
    Timsort: detects runs, merges them — very fast
    DO NOT use heapsort (ignores pre-sorting, always O(n log n))

  If data is "reverse sorted":
    Reverse it in O(n), then it's sorted!
    Timsort detects this automatically

--- Multi-Key Sort ---
  Sort by primary key, then secondary key?
  Method 1: single sort with composite comparator
    sort(data, key=lambda x: (x.last_name, x.first_name))

  Method 2: two stable sorts in REVERSE order of priority
    stable_sort(data, key=first_name)   # secondary first
    stable_sort(data, key=last_name)    # primary second
    Works because stable sort preserves relative order

--- Sorting Strings ---
  Comparison sort on strings: O(n × L × log n) where L = avg length
  String comparison is O(L), not O(1)!

  Faster: MSD radix sort / burstsort / trie-based sorts
  Can achieve O(n × L) by avoiding redundant character comparisons

--- Custom Comparators ---
  Schwartzian transform (decorate-sort-undecorate):
    Compute sort key once per element, not per comparison
    Python: sorted(data, key=expensive_function)
    Avoids calling key function O(n log n) times

--- Stability Without Stable Sort ---
  Need stable sort but only have unstable sort?
  Add original index as tiebreaker:
    Sort by (key, original_index) using any sort
    Equal keys sort by original position = stable
EOF
}

show_help() {
    cat << EOF
sorter v$VERSION — Sorting Reference

Usage: script.sh <command>

Commands:
  intro        Sorting classification, stability, complexity overview
  comparison   Quicksort, mergesort, heapsort, timsort
  distribution Counting sort, radix sort, bucket sort
  simple       Insertion, selection, bubble — when they win
  parallel     External, MapReduce, GPU, and database sorting
  choosing     Decision guide: which sort for which situation
  physical     Warehouse and postal sortation systems
  tricks       Partial sort, nth element, presorted data hacks
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    comparison)   cmd_comparison ;;
    distribution) cmd_distribution ;;
    simple)       cmd_simple ;;
    parallel)     cmd_parallel ;;
    choosing)     cmd_choosing ;;
    physical)     cmd_physical ;;
    tricks)       cmd_tricks ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "sorter v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
