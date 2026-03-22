#!/usr/bin/env bash
# buffer — Memory Buffer & Data Buffering Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Memory Buffers ===

A buffer is a region of memory used to temporarily hold data while it
is being moved from one place to another. Buffers bridge speed differences
between producer and consumer, enabling efficient data transfer.

Why Buffers Exist:
  - CPU is ~1000x faster than disk, ~1,000,000x faster than network
  - Without buffers: CPU waits for slow I/O (massive waste)
  - With buffers: CPU fills buffer, I/O drains it asynchronously
  - Decouple producer speed from consumer speed

Core Concepts:
  Capacity:     Total size of the buffer (bytes)
  Position:     Current read/write cursor location
  Limit:        Maximum readable/writable position
  Remaining:    Limit - Position (how much space/data left)
  Flip:         Switch from write mode to read mode
  Compact:      Shift unread data to start, resume writing

Buffer States:
  Empty:     Position = 0, nothing to read
  Filling:   Data being written, position advancing
  Full:      Position = Capacity, no more room
  Draining:  Data being read, position advancing
  Overflow:  More data than capacity (ERROR condition)
  Underrun:  Consumer reads faster than producer fills

Data Flow:
  Producer → [Buffer] → Consumer

  Without buffer:
    Producer: WRITE → wait → WRITE → wait → WRITE (synchronous)

  With buffer:
    Producer: WRITE WRITE WRITE WRITE (burst into buffer)
    Consumer: read read read read (drain at own pace)

Common Uses:
  - File I/O (read/write buffers)
  - Network sockets (send/receive buffers)
  - Audio/video streaming (playback buffers)
  - Inter-process communication (shared buffers)
  - Database query results (result set buffers)
  - GPU rendering (frame buffers)
EOF
}

cmd_types() {
    cat << 'EOF'
=== Buffer Types ===

Linear Buffer:
  Simple contiguous memory block
  Write from start, read from start
  Must copy/compact when partially consumed
  [ data data data | empty empty ]
  Simplest but least efficient for streaming

Ring Buffer (Circular Buffer):
  Fixed-size buffer that wraps around
  Head pointer (write) and tail pointer (read)
  When head reaches end, wraps to beginning
  [ old | readable data | write-head → ... → wraps ]

  Properties:
    - O(1) read and write
    - No memory allocation after creation
    - Lock-free single-producer/single-consumer possible
    - Perfect for streaming, logging, audio

  Implementation:
    write_pos = (write_pos + 1) % capacity
    read_pos = (read_pos + 1) % capacity
    is_full = (write_pos + 1) % capacity == read_pos
    is_empty = write_pos == read_pos

Double Buffer:
  Two buffers, alternating roles
  Buffer A: being filled by producer
  Buffer B: being consumed by consumer
  Swap when both are done → seamless data flow
  Used in: GPU rendering, audio processing, DMA

  Triple buffering: adds a third buffer to prevent stalls
  when producer and consumer run at different rates

Frame Buffer:
  Stores pixel data for display output
  Size = width × height × bytes_per_pixel
  Example: 1920×1080×4 (RGBA) = 8.3 MB per frame
  Double-buffered to prevent screen tearing (vsync)
  GPU writes to back buffer, display reads front buffer

Protocol Buffer (protobuf):
  NOT a memory buffer — Google's serialization format
  Binary encoding, schema-defined (*.proto files)
  Smaller and faster than JSON/XML
  Used in: gRPC, internal Google services, microservices

  message Person {
    string name = 1;
    int32 age = 2;
    repeated string emails = 3;
  }

Gap Buffer:
  Array with a gap in the middle (at cursor position)
  Insert/delete at cursor = O(1)
  Move cursor = O(gap_size)
  Used in: text editors (Emacs, VS Code internal)
  [ text before cursor |___GAP___| text after cursor ]
EOF
}

cmd_allocation() {
    cat << 'EOF'
=== Memory Allocation Strategies ===

Stack Allocation:
  char buffer[4096];   // allocated on stack
  Pros: extremely fast (just move stack pointer), no fragmentation
  Cons: fixed size, limited total size (~1-8MB stack), scope-bound
  Use when: small, fixed-size, short-lived buffers

Heap Allocation:
  char* buffer = malloc(size);  // or new, allocate, etc.
  Pros: dynamic size, long-lived, large buffers possible
  Cons: slower than stack, fragmentation risk, must free manually
  Use when: runtime-determined size, buffers outliving function scope

Memory Pool (Object Pool):
  Pre-allocate many same-sized blocks
  Hand out blocks on request, return to pool on release
  No malloc/free per operation → deterministic performance
  Used in: network servers, game engines, real-time systems

  Pool: [ free | used | free | free | used | free ]
  Allocate: take a free block → O(1)
  Release: return block to free list → O(1)

Slab Allocator:
  Linux kernel's allocation strategy
  Groups same-sized objects into "slabs"
  Each slab = contiguous page(s) of memory
  Objects are pre-constructed and cached
  Used for: frequently allocated/freed kernel objects

mmap (Memory-Mapped Files):
  Map a file directly into virtual memory
  OS handles paging — file becomes a buffer automatically
  buffer = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
  Pros: zero-copy file access, OS manages caching
  Cons: can cause page faults, not suitable for all patterns
  Use when: large files, random access, read-mostly patterns

DMA Buffers:
  Direct Memory Access — hardware reads/writes memory directly
  CPU sets up transfer, DMA controller handles the rest
  Requires physically contiguous memory (or IOMMU)
  Used in: disk I/O, network cards, GPU transfers
  Key: CPU is free to do other work during transfer

Huge Pages:
  Normal page: 4KB, Huge page: 2MB or 1GB
  Fewer TLB misses for large buffers
  Linux: hugetlbfs or transparent huge pages (THP)
  Use when: buffers > 2MB, performance-critical applications
EOF
}

cmd_overflow() {
    cat << 'EOF'
=== Buffer Overflow ===

What Is Buffer Overflow?
  Writing data beyond the allocated buffer boundary
  Overwrites adjacent memory → corruption, crashes, exploits

  char buffer[8];
  strcpy(buffer, "This string is way too long");  // OVERFLOW!
  // Overwrites memory after buffer[7]

Stack Buffer Overflow:
  Overflows on stack-allocated buffers
  Can overwrite:
    - Other local variables
    - Saved frame pointer
    - Return address ← most dangerous (code execution)
  Attack: overwrite return address → redirect to attacker's code
  Historic exploits: Morris Worm (1988), Code Red, Slammer

Heap Buffer Overflow:
  Overflows on heap-allocated buffers
  Can overwrite:
    - Adjacent heap objects
    - Heap metadata (chunk headers)
  Attack: corrupt heap metadata → arbitrary write on free()
  Harder to exploit than stack overflow but still critical

Prevention Strategies:

  Language-Level:
    Use memory-safe languages: Rust, Go, Python, Java
    Rust: borrow checker prevents buffer overflows at compile time
    Go: slice bounds checking at runtime
    Python/Java: managed memory, no raw pointer access

  C/C++ Safe Practices:
    ✗ strcpy()  → ✓ strncpy() or strlcpy()
    ✗ sprintf() → ✓ snprintf()
    ✗ gets()    → ✓ fgets()
    ✗ scanf()   → ✓ scanf with width: scanf("%255s", buf)
    Always check: if (len > sizeof(buffer)) { error; }

  Compiler Protections:
    Stack canaries: GCC -fstack-protector-strong
      Places a random value before return address
      Detects overflow before function returns
    ASLR: Address Space Layout Randomization
      Randomizes memory layout → harder to predict addresses
    DEP/NX: Data Execution Prevention / No-Execute
      Mark stack/heap as non-executable → can't run injected code
    FORTIFY_SOURCE: replaces unsafe functions with bounds-checked versions

  Runtime Protections:
    AddressSanitizer (ASan): detects out-of-bounds access
    Valgrind: memory error detector
    Electric Fence: catches overflows immediately
    Fuzzing: automated testing with random inputs (AFL, libFuzzer)
EOF
}

cmd_io() {
    cat << 'EOF'
=== I/O Buffering ===

Buffering Modes:

  Unbuffered:
    Each write goes directly to the destination
    Maximum latency per write, minimum overall latency
    Use: stderr, real-time logging, interactive output
    C: setvbuf(stream, NULL, _IONBF, 0);

  Line Buffered:
    Buffer flushed on newline character
    Use: stdout when connected to terminal
    C: setvbuf(stream, NULL, _IOLBF, 0);

  Fully Buffered (Block Buffered):
    Buffer flushed when full (typically 4KB-64KB)
    Most efficient for throughput
    Use: file I/O, stdout when piped to another process
    C: setvbuf(stream, buf, _IOFBF, 65536);

Kernel I/O Buffers:
  User space buffer → kernel page cache → disk
  Page cache: OS caches disk blocks in RAM
  Read: check page cache first → cache hit = no disk I/O
  Write: write to page cache → flush to disk later (writeback)
  fsync(): forces flush from page cache to disk

  Read-ahead: OS pre-fetches sequential blocks (great for streaming)
  Write-behind: batches writes for efficiency (risk: data loss on crash)

Zero-Copy:
  Normal: disk → kernel buffer → user buffer → kernel buffer → network
  Zero-copy: disk → kernel buffer → network (skip user space copies)

  Linux: sendfile(), splice(), mmap()
  Benefit: eliminates 2 memory copies, reduces CPU usage 50-80%
  Used in: web servers (nginx), databases, file transfer

  sendfile(out_fd, in_fd, &offset, count);
  // Sends file directly from disk to socket — no user-space copy

Scatter-Gather I/O (vectored I/O):
  Read/write from multiple non-contiguous buffers in one syscall
  readv() / writev()
  Avoids: copying fragments into one big buffer before writing
  Used in: network protocol stacks, database pages

Direct I/O:
  Bypasses kernel page cache entirely
  O_DIRECT flag on open()
  User manages their own buffer (must be aligned)
  Used in: databases (manage their own cache), benchmarking
  Trade-off: no OS caching benefits, but predictable performance
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Common Buffer Patterns ===

Producer-Consumer:
  Producer → [Buffer Queue] → Consumer
  Thread-safe queue with bounded capacity
  Producer blocks when full, consumer blocks when empty
  Variations:
    SPSC: single producer, single consumer (lock-free possible)
    MPSC: multiple producers, single consumer
    MPMC: multiple producers, multiple consumers (most complex)

  SPSC Lock-Free Ring Buffer:
    Producer owns write_pos, consumer owns read_pos
    No locks needed — atomic load/store sufficient
    Highest throughput pattern (~100M+ ops/sec)

Back-Pressure:
  When consumer can't keep up, signal producer to slow down
  Strategies:
    Block:     Producer waits until space available
    Drop:      Drop oldest or newest data (lossy)
    Signal:    TCP window size, reactive streams, flow control
    Throttle:  Rate-limit the producer

  Reactive Streams spec: Publisher/Subscriber with demand signals
  Subscriber.request(n) → "I can handle n more items"

Watermark Pattern:
  High watermark: buffer X% full → signal producer to slow/stop
  Low watermark: buffer Y% full → signal producer to resume
  Prevents oscillation between full and empty states

  Example: Buffer capacity 1000
    High watermark: 800 (80%) → pause producer
    Low watermark:  200 (20%) → resume producer
    Hysteresis prevents rapid start/stop cycling

Sliding Window:
  Fixed-size view over a data stream
  Window advances as new data arrives, old data drops off
  Used in: TCP flow control, moving averages, log analysis

  TCP sliding window:
    Sender window: how much data can be in-flight
    Receiver window: how much buffer space receiver has
    Window size adapts to network congestion

Copy-on-Write (COW):
  Multiple readers share the same buffer
  Copy only when someone needs to modify
  Used in: fork(), string implementations, persistent data structures
  Benefit: saves memory and copy time for read-heavy workloads

Ping-Pong Buffer:
  Two buffers alternating between fill and drain
  While buffer A is processed, buffer B is being filled
  Swap roles when both complete
  Minimizes latency — always a buffer ready to process
  Used in: real-time audio, video encoding, DMA transfers
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Buffer APIs Across Languages ===

C:
  char buf[1024];                    // stack buffer
  char* buf = malloc(1024);          // heap buffer
  memcpy(dst, src, n);               // copy n bytes
  memset(buf, 0, sizeof(buf));       // zero-fill
  fread(buf, 1, n, file);            // buffered file read
  read(fd, buf, n);                  // unbuffered (syscall)
  setvbuf(stream, buf, _IOFBF, sz); // set buffer mode

Python:
  buf = bytearray(1024)              # mutable byte buffer
  buf = bytes(data)                  # immutable byte buffer
  buf = memoryview(data)             # zero-copy view
  buf = io.BytesIO()                 # in-memory binary stream
  buf = io.BufferedReader(raw)       # buffered read wrapper
  buf = io.BufferedWriter(raw)       # buffered write wrapper
  # Default: 8KB internal buffer for file I/O

Node.js:
  const buf = Buffer.alloc(1024);       // zero-filled
  const buf = Buffer.allocUnsafe(1024); // uninitialized (faster)
  const buf = Buffer.from('hello');     // from string
  buf.writeUInt32BE(value, offset);     // write typed data
  buf.readUInt32BE(offset);             // read typed data
  buf.copy(target, tOff, sStart, sEnd); // copy between buffers
  // Node Buffer is a subclass of Uint8Array

Go:
  buf := make([]byte, 1024)         // byte slice
  buf := bytes.NewBuffer(nil)       // growable buffer
  buf := bufio.NewReader(r)         // buffered reader (4KB default)
  buf := bufio.NewReaderSize(r, n)  // custom buffer size
  buf := bufio.NewWriter(w)         // buffered writer
  // bufio.Scanner for line-by-line reading

Rust:
  let mut buf = vec![0u8; 1024];         // Vec<u8> buffer
  let mut buf = [0u8; 1024];             // stack array
  let reader = BufReader::new(file);     // buffered reader (8KB)
  let writer = BufWriter::new(file);     // buffered writer (8KB)
  let mut buf = BytesMut::with_capacity(1024); // bytes crate
  // Ownership system prevents buffer overflows at compile time

Java:
  ByteBuffer buf = ByteBuffer.allocate(1024);      // heap
  ByteBuffer buf = ByteBuffer.allocateDirect(1024); // off-heap (DMA)
  buf.put(data); buf.flip(); buf.get(dst);          // write/read cycle
  // NIO: BufferedInputStream, BufferedOutputStream
  // Direct buffers: avoid one copy for I/O (native memory)
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== Buffer Sizing Guide ===

General Principles:
  Too small: frequent flushes, high overhead, potential overflow
  Too large: wasted memory, increased latency, cache pressure
  Goal: balance throughput, latency, and memory usage

File I/O Buffers:
  Typical: 4KB - 64KB
  Aligned to filesystem block size (usually 4KB)
  Sequential read: larger = better (32KB-128KB)
  Random access: smaller is fine (4KB-8KB)
  Rule of thumb: 8KB is a solid default (most std libs use this)

  Benchmark approach:
    Test throughput at: 1KB, 4KB, 8KB, 16KB, 32KB, 64KB, 128KB
    Usually plateaus around 8KB-32KB

Network Buffers:
  TCP socket buffer:
    Linux default: 87380 bytes (recv), varies (send)
    BDP (Bandwidth-Delay Product) = Bandwidth × RTT
    Example: 1 Gbps × 10ms RTT = 1.25 MB optimal window
    sysctl: net.core.rmem_max, net.core.wmem_max
    Application: usually 8KB-64KB per read/write call

  UDP:
    Smaller buffers OK (individual datagrams)
    Typical: MTU size (1500 bytes) or jumbo frames (9000 bytes)

Audio Buffers:
  Sample rate × channels × bytes_per_sample × duration
  Example: 44100 Hz × 2ch × 2B × 10ms = 1764 bytes
  Smaller = lower latency (good for real-time)
  Larger = fewer underruns (good for playback)
  Typical: 256-2048 samples (5.8ms-46.4ms at 44.1kHz)

Video Buffers:
  Frame size = width × height × bytes_per_pixel
  1080p RGBA = 1920 × 1080 × 4 = 8.3 MB per frame
  Double buffered: 16.6 MB
  Triple buffered: 24.9 MB
  Compressed buffers much smaller (H.264 frame ~100KB)

Ring Buffer Sizing:
  Capacity ≥ max burst size from producer
  Capacity ≥ processing time × production rate
  Example: producer bursts 100 items, consumer processes 10/sec
    Need at least 100 items capacity for burst absorption
  Power of 2 sizes enable fast modulo: index & (size-1)
  Typical: 256, 512, 1024, 4096, 65536 entries

Database Buffers:
  Buffer pool: caches frequently accessed pages
  Size: 60-80% of available RAM for dedicated DB servers
  Page size: 4KB (SQLite), 8KB (PostgreSQL), 16KB (MySQL InnoDB)
  Dirty page ratio: aim for < 75% (flush pressure increases above)
EOF
}

show_help() {
    cat << EOF
buffer v$VERSION — Memory Buffer & Data Buffering Reference

Usage: script.sh <command>

Commands:
  intro        What buffers are and why they matter
  types        Ring, double, frame, protocol, gap buffers
  allocation   Stack, heap, pool, slab, mmap strategies
  overflow     Buffer overflow causes, prevention, security
  io           I/O buffering — line, block, zero-copy, direct
  patterns     Producer-consumer, back-pressure, watermarks
  languages    Buffer APIs in C, Python, Node.js, Go, Rust, Java
  sizing       How to calculate optimal buffer sizes
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    types)       cmd_types ;;
    allocation)  cmd_allocation ;;
    overflow)    cmd_overflow ;;
    io)          cmd_io ;;
    patterns)    cmd_patterns ;;
    languages)   cmd_languages ;;
    sizing)      cmd_sizing ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "buffer v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
