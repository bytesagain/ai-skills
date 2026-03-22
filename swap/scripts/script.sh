#!/usr/bin/env bash
# swap — Value & Memory Swap Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Swap Operations ===

Swap is the fundamental operation of exchanging two values. It appears
in every layer of computing — from variables to virtual memory.

Three Domains of Swap:
  1. Variable Swap    Exchange values of two variables
  2. Memory Swap      OS virtual memory paging to disk
  3. Atomic Swap      Lock-free concurrent exchange (CAS)

Variable Swap — The Basics:
  The most fundamental algorithm operation.
  Required for sorting, permutations, shuffling, reordering.

  Classic (with temp):
    temp = a
    a = b
    b = temp

  Without temp (XOR trick — integers only):
    a = a ^ b
    b = a ^ b    (now b = original a)
    a = a ^ b    (now a = original b)
    ⚠ Fails if a and b are the same memory location!

  Modern (destructuring):
    [a, b] = [b, a]              // JavaScript
    a, b = b, a                  // Python, Go, Lua
    std::swap(a, b)              // C++
    mem::swap(&mut a, &mut b)    // Rust

Memory Swap (OS Level):
  When RAM is full, OS moves inactive pages to disk (swap space).
  Allows running programs larger than physical memory.
  Trade-off: Disk is 100,000x slower than RAM.

Atomic Swap (Concurrency):
  Compare-And-Swap (CAS): Atomically exchange value if it matches expected.
  Foundation of lock-free data structures and concurrency.
  Hardware instruction: CMPXCHG (x86), LDREX/STREX (ARM)
EOF
}

cmd_variables() {
    cat << 'EOF'
=== Variable Swapping ===

--- Classic Temp Variable ---
  Language-agnostic, works for ALL types:

  C/C++:    int temp = a; a = b; b = temp;
  Java:     int temp = a; a = b; b = temp;
  C#:       var temp = a; a = b; b = temp;

--- Modern Destructuring ---
  JavaScript:   [a, b] = [b, a];
  Python:       a, b = b, a
  Go:           a, b = b, a
  Lua:          a, b = b, a
  Ruby:         a, b = b, a
  PHP (7.1+):   [$a, $b] = [$b, $a];
  Kotlin:       a = b.also { b = a }

--- Standard Library Swap ---
  C++:     std::swap(a, b);              // <algorithm> or <utility>
  Rust:    std::mem::swap(&mut a, &mut b);
  Java:    Collections.swap(list, i, j);
  Python:  (tuple unpacking — no stdlib needed)
  Swift:   swap(&a, &b)
  Go:      a, b = b, a  (or reflect.Swapper for slices)

--- XOR Swap (Integers Only) ---
  a ^= b;   // a = a XOR b
  b ^= a;   // b = (a XOR b) XOR b = a
  a ^= b;   // a = (a XOR b) XOR a = b

  Why it works:
    XOR is its own inverse: (x ^ y) ^ y = x
    Each step "encodes" one value into the other

  Problems:
    ✗ Fails if &a == &b (both become 0)
    ✗ Only works for integers
    ✗ Modern compilers optimize temp swap better than XOR
    ✗ Harder to read — don't use in production

--- Arithmetic Swap (Integers, Risky) ---
  a = a + b;
  b = a - b;   // b = (a+b) - b = a
  a = a - b;   // a = (a+b) - a = b

  Problem: Integer overflow risk! Don't use.

--- Array Element Swap ---
  JavaScript:  [arr[i], arr[j]] = [arr[j], arr[i]];
  Python:      arr[i], arr[j] = arr[j], arr[i]
  C++:         std::iter_swap(arr+i, arr+j);
  Rust:        arr.swap(i, j);
  Go:          arr[i], arr[j] = arr[j], arr[i]
  Java:        Collections.swap(list, i, j);
EOF
}

cmd_os() {
    cat << 'EOF'
=== OS Swap Space ===

What is Swap:
  Virtual memory extension — disk space used as overflow RAM.
  When physical RAM is full, inactive pages are moved to swap.
  Process is called "paging" or "swapping out."

Types:
  Swap Partition   Dedicated disk partition (faster, fixed size)
  Swap File        Regular file on filesystem (flexible, slightly slower)
  zram             Compressed RAM block device (no disk I/O)

--- Linux Swap Management ---

  Check current swap:
    free -h                        # overview
    swapon --show                  # detailed swap devices
    cat /proc/swaps                # kernel view

  Create swap file:
    sudo fallocate -l 4G /swapfile       # allocate space
    sudo chmod 600 /swapfile             # secure permissions
    sudo mkswap /swapfile                # format as swap
    sudo swapon /swapfile                # enable

  Make permanent (/etc/fstab):
    /swapfile none swap sw 0 0

  Create swap partition:
    sudo mkswap /dev/sda2
    sudo swapon /dev/sda2

  Remove swap:
    sudo swapoff /swapfile
    sudo rm /swapfile

--- Swappiness ---
  Controls how aggressively the kernel swaps pages to disk.

  cat /proc/sys/vm/swappiness      # view (0-200, default 60)

  Values:
    0     Swap only to avoid OOM (almost never)
    10    Light swapping (recommended for SSDs)
    60    Default — moderate swapping
    100   Aggressive swapping (keep RAM free)
    200   Maximum (cgroup v2)

  Set temporarily:
    sudo sysctl vm.swappiness=10

  Set permanently (/etc/sysctl.conf):
    vm.swappiness=10

  Recommendations:
    Desktop with SSD:     10
    Server with ample RAM: 10
    Database server:       1 (or disable swap entirely)
    Memory-constrained:    60-100

--- How Much Swap? ---
  RAM < 2 GB:    2× RAM
  RAM 2-8 GB:    Same as RAM
  RAM 8-64 GB:   4-8 GB (or √RAM)
  RAM > 64 GB:   4 GB (or none for databases)
  Hibernation:   At least RAM size (swap stores RAM contents)
EOF
}

cmd_atomic() {
    cat << 'EOF'
=== Atomic Swap (Compare-And-Swap) ===

CAS — Compare And Swap:
  Atomic operation that does:
    if (*addr == expected) {
        *addr = new_value;
        return true;    // success
    }
    return false;       // someone else modified it

  This is ONE atomic hardware instruction — cannot be interrupted.

Hardware Instructions:
  x86:   CMPXCHG (Compare and Exchange)
  ARM:   LDREX/STREX (Load/Store Exclusive) or CAS in ARMv8.1
  RISC-V: LR/SC (Load Reserved / Store Conditional)

--- C/C++ (stdatomic / <atomic>) ---
  #include <stdatomic.h>
  atomic_int counter = 0;

  // Atomic swap
  int old = atomic_exchange(&counter, 42);

  // CAS
  int expected = 0;
  bool ok = atomic_compare_exchange_strong(&counter, &expected, 1);
  // If counter was 0, it's now 1. If not, expected = actual value.

  // C++
  std::atomic<int> counter{0};
  counter.exchange(42);
  int exp = 0;
  counter.compare_exchange_strong(exp, 1);

--- Rust ---
  use std::sync::atomic::{AtomicU64, Ordering};

  let val = AtomicU64::new(0);
  let old = val.swap(42, Ordering::SeqCst);
  let result = val.compare_exchange(42, 100,
      Ordering::SeqCst, Ordering::SeqCst);

--- Go ---
  import "sync/atomic"

  var counter int64 = 0
  old := atomic.SwapInt64(&counter, 42)
  ok := atomic.CompareAndSwapInt64(&counter, 42, 100)

--- Java ---
  AtomicInteger counter = new AtomicInteger(0);
  int old = counter.getAndSet(42);
  boolean ok = counter.compareAndSet(42, 100);

--- CAS Spin Loop Pattern ---
  // Lock-free increment:
  loop {
      let current = val.load(Ordering::Relaxed);
      match val.compare_exchange_weak(
          current, current + 1,
          Ordering::SeqCst, Ordering::Relaxed
      ) {
          Ok(_) => break,
          Err(_) => continue,  // retry — someone else modified it
      }
  }

Memory Ordering:
  Relaxed     No ordering guarantees (fastest)
  Acquire     See all writes before this load
  Release     All writes before this store are visible
  AcqRel      Both acquire and release
  SeqCst      Strongest — total order (safest, slowest)
EOF
}

cmd_sorting() {
    cat << 'EOF'
=== Swap in Sorting ===

--- Bubble Sort (Adjacent Swaps) ---
  Repeatedly swap adjacent elements if out of order.

  for i in range(n):
      for j in range(n-1-i):
          if arr[j] > arr[j+1]:
              arr[j], arr[j+1] = arr[j+1], arr[j]  # swap

  Swaps: O(n²) worst case
  Best case: 0 swaps (already sorted) — detected in one pass

--- Selection Sort (One Swap per Pass) ---
  Find minimum, swap to front position.

  for i in range(n):
      min_idx = i
      for j in range(i+1, n):
          if arr[j] < arr[min_idx]:
              min_idx = j
      arr[i], arr[min_idx] = arr[min_idx], arr[i]  # one swap

  Swaps: O(n) — always exactly n-1 swaps
  Good when: write cost is high (flash memory)

--- Quicksort Partition (Swap to Pivot) ---
  Hoare partition:
    Choose pivot, swap elements to correct side.

    def partition(arr, lo, hi):
        pivot = arr[(lo + hi) // 2]
        i, j = lo - 1, hi + 1
        while True:
            i += 1
            while arr[i] < pivot: i += 1
            j -= 1
            while arr[j] > pivot: j -= 1
            if i >= j: return j
            arr[i], arr[j] = arr[j], arr[i]    # swap

  Average swaps: O(n log n)

--- Fisher-Yates Shuffle ---
  Random permutation using swaps:

  for i in range(n-1, 0, -1):
      j = random(0, i)           # random index [0, i]
      arr[i], arr[j] = arr[j], arr[i]

  Exactly n-1 swaps → O(n) time, O(1) space
  Uniform distribution — each permutation equally likely

--- Cycle Sort (Minimum Writes) ---
  Theoretically optimal number of writes (swaps).
  Each element placed in correct position in one swap.
  O(n²) time but minimizes memory writes.
  Use case: EEPROM or flash with limited write cycles.

--- Counting Swaps ---
  Minimum swaps to sort = n - (number of cycles in permutation)
  Example: [3, 1, 2] has one cycle (3→2→1→3)
  Minimum swaps = 3 - 1 = 2
  Useful for: interview problems, measuring array disorder
EOF
}

cmd_containers() {
    cat << 'EOF'
=== Container Swap ===

--- C++ std::swap ---
  vector<int> a = {1, 2, 3};
  vector<int> b = {4, 5, 6};
  std::swap(a, b);        // O(1) — swaps internal pointers
  // a is now {4,5,6}, b is now {1,2,3}

  // Element swap within container:
  std::swap(vec[0], vec[2]);

  // Why O(1) for containers:
  // Containers store: pointer to data, size, capacity
  // Swap only exchanges these 3 fields (24 bytes), not all elements

--- Rust Vec::swap and mem::swap ---
  let mut v = vec![1, 2, 3, 4, 5];
  v.swap(0, 4);           // swap elements at index 0 and 4
  // v = [5, 2, 3, 4, 1]

  // Swap two variables:
  let mut a = vec![1, 2];
  let mut b = vec![3, 4];
  std::mem::swap(&mut a, &mut b);

  // swap_remove — O(1) removal by swapping with last
  v.swap_remove(1);       // swap index 1 with last, then pop
  // Fast but doesn't preserve order

--- Double Buffering ---
  Two buffers: front (displayed) and back (being written).
  Swap pointers when back buffer is ready.

  let mut front = create_buffer();
  let mut back = create_buffer();

  loop {
      render_to(&mut back);          // draw to back buffer
      std::mem::swap(&mut front, &mut back);  // instant swap
      display(&front);               // show front buffer
  }

  Used in:
    Graphics rendering (prevent tearing)
    Audio processing (prevent glitches)
    Network I/O (read while processing previous batch)

--- Buffer Pool Swap ---
  Pre-allocate buffers, swap in/out instead of alloc/free.

  let mut pool: Vec<Vec<u8>> = (0..10)
      .map(|_| Vec::with_capacity(4096))
      .collect();

  let mut active = pool.pop().unwrap();
  // Use active buffer...
  active.clear();
  pool.push(active);  // return to pool

  Benefits:
    No allocation during hot path
    Predictable memory usage
    Cache-friendly (reuse same memory)

--- Map/Dictionary Swap ---
  Python:  d['a'], d['b'] = d['b'], d['a']
  Go:      m["a"], m["b"] = m["b"], m["a"]
  Rust:    Use temporary: let v = map.remove("a"); map.insert("a", map["b"]); ...
EOF
}

cmd_diagnosis() {
    cat << 'EOF'
=== Diagnosing Swap Issues ===

--- Is the System Swapping? ---
  free -h
  # Look at Swap row:
  #              total    used    free
  # Swap:        4.0G     1.2G    2.8G
  # If used > 0, system is swapping

  vmstat 1 5
  # Columns si (swap in) and so (swap out):
  # si = pages swapped in from disk (reads)
  # so = pages swapped out to disk (writes)
  # If si/so > 0 consistently → active swapping

  sar -W 1 10
  # pswpin/s and pswpout/s — swap rate over time

--- Thrashing ---
  When the system spends more time swapping than doing useful work.

  Symptoms:
    - System extremely slow / unresponsive
    - High disk I/O (iostat shows near 100% utilization)
    - si/so values very high in vmstat
    - Load average much higher than CPU count
    - OOM killer may start killing processes

  Causes:
    - Not enough RAM for workload
    - Memory leak in application
    - Too many processes competing for RAM
    - swappiness too high for workload

  Solutions:
    1. Add more RAM (the real fix)
    2. Reduce swappiness: sysctl vm.swappiness=10
    3. Kill memory-hogging processes
    4. Add swap space (buys time, doesn't fix root cause)
    5. Use zram for compressed swap (2-3x effective swap)
    6. Set memory limits: cgroups, ulimit

--- Per-Process Swap Usage ---
  # Which process is using the most swap?
  for f in /proc/*/status; do
    awk '/VmSwap|Name/{printf "%s ", $2}' "$f" 2>/dev/null
    echo
  done | sort -nk2 | tail -20

  # Or simpler:
  smem -s swap -r | head -20

--- OOM Killer ---
  When swap + RAM exhausted, Linux OOM killer activates.
  Kills process with highest oom_score.

  # Check OOM score:
  cat /proc/<pid>/oom_score

  # Protect critical process:
  echo -1000 > /proc/<pid>/oom_score_adj

  # Check OOM kills in logs:
  dmesg | grep -i "out of memory"
  journalctl | grep -i "oom"

--- zram (Compressed Swap in RAM) ---
  Compresses swap pages in RAM instead of writing to disk.
  Typically 2-3x compression ratio.
  Much faster than disk swap (RAM speed, not I/O speed).

  sudo modprobe zram
  echo lz4 > /sys/block/zram0/comp_algorithm
  echo 4G > /sys/block/zram0/disksize
  sudo mkswap /dev/zram0
  sudo swapon -p 100 /dev/zram0    # higher priority than disk swap
EOF
}

cmd_financial() {
    cat << 'EOF'
=== Financial Swaps ===

A swap is a derivative contract where two parties exchange cash flows
or financial instruments over a specified period.

--- Interest Rate Swap (IRS) ---
  Most common swap type. ~$500 trillion notional outstanding.

  Party A pays: Fixed rate (e.g., 3.5%)
  Party B pays: Floating rate (e.g., SOFR + 0.5%)
  Notional: $10 million (never exchanged, just for calculation)
  Tenor: 5 years, payments every 6 months

  Why:
    Company with floating-rate debt wants certainty → pays fixed
    Company with fixed-rate debt wants lower cost → pays floating
    Banks hedge interest rate exposure

  Net settlement:
    Only the difference is paid each period.
    If fixed=3.5% and floating=4.0%:
    Party A receives: (4.0% - 3.5%) × $10M × (180/360) = $25,000

--- Currency Swap (Cross-Currency Swap) ---
  Exchange principal and interest in different currencies.

  Example:
    Company A (US) needs EUR → provides USD collateral
    Company B (EU) needs USD → provides EUR collateral
    Exchange principals at start and end
    Each pays interest in the currency they borrowed

  Used for: International financing, hedging FX exposure

--- Credit Default Swap (CDS) ---
  Insurance against default on a bond or loan.

  Protection buyer: Pays periodic premium (spread, e.g., 150 bps)
  Protection seller: Pays face value if credit event occurs

  Credit events: bankruptcy, failure to pay, restructuring

  Notional: $100M bond
  Spread: 150 bps = 1.5%/year = $1.5M annual premium
  If default: seller pays $100M, buyer delivers defaulted bonds

  Famous in: 2008 financial crisis (AIG sold massive CDS)

--- Commodity Swap ---
  Fixed price vs floating market price for a commodity.
  Airline locks in jet fuel price.
  Producer locks in selling price.

--- Equity Swap ---
  Exchange equity returns for fixed/floating rate.
  Gain exposure to stock/index without owning shares.
  Used for: tax efficiency, leverage, avoiding ownership restrictions

--- Total Return Swap (TRS) ---
  One party receives total return (price change + income) of an asset.
  Other party receives fixed/floating rate.
  Used for: synthetic ownership, balance sheet optimization.

Key Swap Terminology:
  Notional        Reference amount for calculating payments
  Tenor           Duration of the swap contract
  Counterparty    The other party in the swap
  ISDA            International Swaps and Derivatives Association
  Mark-to-market  Current value of the swap position
  Netting         Offsetting payments between counterparties
EOF
}

show_help() {
    cat << EOF
swap v$VERSION — Value & Memory Swap Reference

Usage: script.sh <command>

Commands:
  intro        Swap overview — variables, memory, atomic
  variables    Variable swapping: temp, XOR, destructuring
  os           OS swap space: partition, swapfile, swappiness
  atomic       Atomic CAS operations and lock-free patterns
  sorting      Swap in sorting: bubble, selection, quicksort
  containers   Container swap: double buffer, pool, O(1) swap
  diagnosis    Diagnosing swap issues: thrashing, OOM, zram
  financial    Financial swaps: IRS, CDS, currency, equity
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    variables)  cmd_variables ;;
    os)         cmd_os ;;
    atomic)     cmd_atomic ;;
    sorting)    cmd_sorting ;;
    containers) cmd_containers ;;
    diagnosis)  cmd_diagnosis ;;
    financial)  cmd_financial ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "swap v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
