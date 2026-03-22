#!/usr/bin/env bash
# fuzz — Fuzz Testing Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Fuzz Testing ===

Fuzzing is an automated testing technique that provides random, unexpected,
or malformed input to a program to discover bugs, crashes, and security
vulnerabilities that humans wouldn't think to test.

Why Fuzzing Works:
  - Humans test expected paths; fuzzers explore the unexpected
  - Finds edge cases in parsers, protocols, and file formats
  - Discovers memory safety bugs (buffer overflows, use-after-free)
  - Runs millions of test cases automatically
  - Found >30,000 bugs in Chrome, >6,000 in Linux kernel

Types of Fuzzing:
  1. Dumb Fuzzing (random):
     Generate completely random input
     Low efficiency — mostly invalid input
     Simple but occasionally finds bugs

  2. Mutation-Based Fuzzing:
     Take valid input (seed corpus) and mutate it
     Bit flips, byte insertions, value replacements
     Maintains some structure → better coverage

  3. Generation-Based Fuzzing:
     Generate input from grammar/specification
     Understands protocol/format structure
     Higher code coverage for complex formats

  4. Coverage-Guided Fuzzing (CGF):
     Instrument program to track code coverage
     Keep mutations that discover new code paths
     Evolutionary approach — most effective
     AFL, libFuzzer, Honggfuzz

History:
  1988    Barton Miller — random input to UNIX utilities (25-33% crashed!)
  1990s   PROTOS project — protocol fuzzing
  2007    AFL (American Fuzzy Lop) by Michal Zalewski
  2013    libFuzzer integrated into LLVM
  2016    Google launches OSS-Fuzz
  2020s   Structure-aware fuzzing, ML-guided fuzzing
EOF
}

cmd_coverage() {
    cat << 'EOF'
=== Coverage-Guided Fuzzing ===

The most effective fuzzing approach. Uses code coverage feedback to
evolve inputs toward unexplored program states.

How It Works:
  1. Instrument target program (compile-time or binary)
  2. Start with seed corpus (valid sample inputs)
  3. Mutate seed → run program → measure coverage
  4. If new code path discovered → save input to corpus
  5. If crash → save as crash input
  6. Repeat millions of times

  ┌─────────┐     mutate    ┌──────────┐
  │  Corpus  │ ──────────→  │  Input   │
  └─────────┘               └──────────┘
       ↑                         │
       │                    execute
       │                         ↓
    new path?              ┌──────────┐
       │                   │  Target  │
       ← ─ coverage ── ─  │ Program  │
                           └──────────┘

Coverage Metrics:
  Edge coverage:   Which branches (edges in CFG) were taken
  Block coverage:  Which basic blocks were executed
  Hit counts:      How many times each edge was taken
                   (distinguishes loop counts)

Instrumentation Methods:
  Compile-time (best):
    clang -fsanitize-coverage=edge  # LLVM SanitizerCoverage
    afl-gcc / afl-clang-fast       # AFL instrumentation
    gcc --coverage                  # gcov-based

  Binary-only (no source):
    AFL QEMU mode: afl-fuzz -Q      # QEMU user-mode emulation
    DynamoRIO: drrun -- ./target     # Dynamic instrumentation
    Frida: dynamic instrumentation   # JavaScript-based hooks
    Intel PT: hardware tracing       # Lowest overhead

Coverage Plateaus:
  Problem: fuzzer stops finding new paths
  Solutions:
    - Provide better seeds (different valid inputs)
    - Add dictionary tokens (format keywords)
    - Use structure-aware mutation
    - Run longer (some bugs take days/weeks)
    - Combine with symbolic execution (hybrid fuzzing)
    - Increase mutation aggressiveness

Sanitizers (Bug Detectors):
  AddressSanitizer (ASan):  buffer overflow, use-after-free, double-free
  MemorySanitizer (MSan):   uninitialized memory reads
  UBSan:                    undefined behavior (signed overflow, etc.)
  ThreadSanitizer (TSan):   data races

  Compile with: clang -fsanitize=address,fuzzer target.c
  Overhead: ASan ~2×, MSan ~3×, TSan ~5-15×
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Fuzzing Tools ===

--- AFL++ (American Fuzzy Lop Plus Plus) ---
  The most popular general-purpose fuzzer
  Fork of original AFL with many improvements

  Install: apt install afl++ (or build from source)

  Usage:
    # Compile with instrumentation
    afl-cc -o target target.c

    # Create seed corpus
    mkdir seeds && echo "valid input" > seeds/seed1

    # Fuzz!
    afl-fuzz -i seeds -o findings ./target @@

    # @@ = replaced with generated file path

  AFL++ modes:
    Default: compile-time instrumentation (fastest)
    QEMU (-Q): binary-only fuzzing
    Unicorn: emulate specific functions
    FRIDA: dynamic instrumentation
    Nyx: full VM snapshot fuzzing

--- libFuzzer (LLVM) ---
  In-process fuzzer, part of LLVM
  Best for library fuzzing (no file I/O overhead)

  Harness:
    extern "C" int LLVMFuzzerTestOneInput(
      const uint8_t *data, size_t size) {
      // Call target with fuzz data
      parseInput(data, size);
      return 0;
    }

  Compile & run:
    clang -fsanitize=fuzzer,address target_fuzz.c -o fuzzer
    ./fuzzer corpus_dir/

--- Honggfuzz ---
  Multi-threaded, uses hardware BTS/PT for coverage
  Supports persistent mode, structure-aware mutation

  honggfuzz -f seeds/ -W findings/ -- ./target ___FILE___

--- Go Native Fuzzing (Go 1.18+) ---
  func FuzzParseJSON(f *testing.F) {
    f.Add([]byte(`{"key": "value"}`))
    f.Fuzz(func(t *testing.T, data []byte) {
      var v interface{}
      json.Unmarshal(data, &v)
    })
  }
  go test -fuzz=FuzzParseJSON -fuzztime=60s

--- Jazzer (Java) ---
  Coverage-guided fuzzing for JVM
  Integrates with JUnit 5
  @FuzzTest
  void fuzzParse(byte[] data) {
    MyParser.parse(data);
  }

--- cargo-fuzz (Rust) ---
  cargo install cargo-fuzz
  cargo fuzz init
  cargo fuzz run my_target
EOF
}

cmd_harness() {
    cat << 'EOF'
=== Writing Fuzz Harnesses ===

A fuzz harness is the glue between the fuzzer and your target code.

--- Design Principles ---
  1. One target function per harness
  2. No global state modification (or reset between runs)
  3. No file system or network dependencies
  4. Fast execution (< 1ms per run ideal)
  5. Deterministic — same input = same behavior
  6. No memory leaks (use ASan to verify)

--- C/C++ Harness (libFuzzer) ---
  #include <stdint.h>
  #include <stddef.h>
  #include "my_parser.h"

  extern "C" int LLVMFuzzerTestOneInput(
      const uint8_t *data, size_t size) {
    // Guard: minimum input size
    if (size < 4) return 0;

    // Parse, but don't care about errors
    struct ParseResult *result = parse(data, size);
    if (result) {
      free_result(result);
    }
    return 0;
  }

--- Seed Corpus ---
  Small set of valid inputs that exercise different code paths

  Guidelines:
    - One file per seed (small, diverse files)
    - Cover different valid formats/variants
    - Include edge cases (empty, minimal, maximal)
    - Name descriptively: json_array.seed, json_nested.seed

  For a JSON parser seeds:
    {}
    []
    {"key": "value"}
    {"nested": {"deep": [1, 2, 3]}}
    [null, true, false, 0, -1, 1.5e10, "string"]

--- Dictionaries ---
  Keywords and tokens the fuzzer should try inserting

  # json.dict
  "{"
  "}"
  "["
  "]"
  ":"
  ","
  "true"
  "false"
  "null"
  "\""
  "\\"

  Usage: afl-fuzz -x json.dict ...
         ./fuzzer -dict=json.dict corpus/

--- Structure-Aware Fuzzing ---
  For complex formats, custom mutators outperform random mutation

  libFuzzer custom mutator:
    extern "C" size_t LLVMFuzzerCustomMutator(
      uint8_t *data, size_t size, size_t max_size, unsigned seed) {
      // Understand format structure
      // Mutate meaningful fields
      return new_size;
    }

  libprotobuf-mutator:
    Define format as protobuf → fuzzer generates valid structure
    Mutates within protobuf constraints
    Best for: network protocols, config files, APIs
EOF
}

cmd_mutation() {
    cat << 'EOF'
=== Mutation Strategies ===

Mutations transform existing inputs to explore new code paths.

--- Bit-Level Mutations ---
  Bit flip:       Flip 1, 2, or 4 bits at random positions
  Byte flip:      Flip entire bytes
  Random byte:    Replace with random byte value

  AFL bit flip schedule:
    1/1 walking bit flip (every bit position)
    2/1 walking bit flip
    4/1 walking bit flip
    8/8 walking byte flip
    16/8 walking word flip
    32/8 walking dword flip

--- Arithmetic Mutations ---
  Add/subtract small values (±1 to ±35)
  Apply to: byte, word (16-bit), dword (32-bit)
  Both little-endian and big-endian
  Finds: off-by-one, integer overflow, boundary conditions

  "Interesting" values:
    0, 1, -1, 128, 255, 256, 32767, 32768
    65535, 65536, 2147483647, 2147483648
    These trigger edge cases in integer handling

--- Block-Level Mutations ---
  Insert:     Insert random bytes at random position
  Delete:     Remove bytes from random position
  Overwrite:  Replace bytes with random or dictionary tokens
  Splice:     Combine two corpus entries at random cut point
  Clone:      Duplicate a block within the input

--- Dictionary-Based Mutations ---
  Insert dictionary tokens at random positions
  Replace existing bytes with dictionary tokens
  Combine multiple dictionary tokens
  Critical for text-based formats (JSON, XML, SQL)

--- Havoc Mode (AFL) ---
  Apply multiple random mutations per cycle
  Stacks 2-128 random mutations together
  Most effective at finding deep bugs
  Runs after deterministic stage exhausts easy paths

--- Structure-Aware Mutations ---
  Grammar-based: mutate AST nodes, not raw bytes
  Protocol-aware: modify valid fields, maintain framing
  Format-specific: change image dimensions, chunk types
  Significantly more effective for complex formats

--- Mutation Scheduling ---
  AFL "power schedules" control mutation energy allocation:
    fast:     Favor fast paths
    explore:  Favor under-explored seeds
    exploit:  Favor seeds near crashes
    coe:      Cut-off exponential (balanced)
    rare:     Prioritize rare edge hits
EOF
}

cmd_triage() {
    cat << 'EOF'
=== Crash Triage ===

Fuzzing finds crashes — triage determines which are real bugs worth fixing.

--- Crash Deduplication ---
  Problem: 10,000 crashes but only 5 unique bugs

  Stack hash: Group by crash location + stack trace
    afl-cmin -i crashes/ -o unique_crashes/ -- ./target @@

  Signal type:
    SIGSEGV — memory access violation (buffer overflow, null deref)
    SIGABRT — assertion failure or ASan report
    SIGFPE  — division by zero
    SIGBUS  — bus error (alignment, mmap)
    Timeout — infinite loop or hang

  ASan report uniqueness:
    Group by: error type + allocation site + access site
    READ of size 4 at 0xdeadbeef → different from WRITE

--- Crash Minimization ---
  Reduce crash input to smallest reproducing case

  afl-tmin -i crash_input -o minimized -- ./target @@

  libFuzzer:
    ./fuzzer -minimize_crash=1 crash_input

  Manual: binary search on input size
    Does first half crash? Second half? Middle third?

--- Root Cause Analysis ---
  1. Reproduce with ASan/MSan for detailed report
     clang -fsanitize=address -g target.c
     ./target < minimized_crash

  2. Read ASan report:
     ERROR: AddressSanitizer: heap-buffer-overflow
     READ of size 1 at 0x602000000048
     #0 parse_header (target.c:42)
     #1 main (target.c:15)
     allocated by thread T0:
     #0 malloc
     #1 init_buffer (target.c:28)

  3. Determine severity:
     Write primitive → Critical (potential code execution)
     Read OOB → High (information disclosure)
     Null deref → Medium (denial of service)
     Assert fail → Low (controlled crash)

--- Reporting ---
  Include:
    - Minimized reproducing input
    - ASan/MSan output
    - Affected function and line
    - Impact assessment
    - Fuzzer and version used
    - Seed corpus and dictionary used
    - Time to find (fuzzing duration)
EOF
}

cmd_continuous() {
    cat << 'EOF'
=== Continuous Fuzzing ===

Don't just fuzz once — fuzz continuously as code changes.

--- OSS-Fuzz (Google) ---
  Free continuous fuzzing for open-source projects
  1000+ projects enrolled (Chrome, OpenSSL, FFmpeg, etc.)
  Runs 24/7 on Google infrastructure
  Automatic bug filing and notification
  Bisection to find exact commit that introduced bug

  Requirements:
    - Open-source project
    - Fuzz harnesses in project repo
    - Dockerfile for build
    - project.yaml with contact info

  Setup:
    github.com/google/oss-fuzz
    projects/<your-project>/Dockerfile
    projects/<your-project>/build.sh
    projects/<your-project>/project.yaml

--- ClusterFuzz (Google) ---
  Backend infrastructure for OSS-Fuzz
  Also available for internal use
  Features: crash dedup, bisection, regression detection
  Distributes fuzzing across thousands of cores

--- CI/CD Integration ---

  GitHub Actions:
    - name: Fuzz
      run: |
        cargo install cargo-fuzz
        cargo fuzz run my_target -- -max_total_time=300

  GitLab CI:
    fuzz_test:
      script:
        - make fuzz FUZZ_TIME=300s
      artifacts:
        paths: [fuzz_crashes/]

  Best practices:
    - Short fuzz runs (5-10 min) on every PR
    - Long runs (hours/days) nightly or weekly
    - Save corpus in CI cache for incremental coverage
    - Fail CI on new crashes

--- Corpus Management ---
  Merge and minimize corpus regularly:
    afl-cmin -i full_corpus/ -o minimal/ -- ./target @@
    ./fuzzer -merge=1 minimal/ full_corpus/

  Version control corpus:
    - Store minimal corpus in repo (small, high-coverage)
    - Full corpus in cloud storage (large, evolving)
    - Share corpus across fuzzer instances

--- Metrics to Track ---
  Corpus size over time
  Edge coverage % (total and per component)
  Bugs found per week
  Time to find vs time to fix
  Unique crash count
  Regression bugs (reintroduced)
EOF
}

cmd_targets() {
    cat << 'EOF'
=== High-Value Fuzz Targets ===

Not all code benefits equally from fuzzing. Focus on:

--- Parsers (Highest Value) ---
  Image: PNG, JPEG, WebP, SVG, TIFF, GIF
  Document: PDF, XML, HTML, Markdown, LaTeX
  Data: JSON, YAML, TOML, CSV, Protobuf, MessagePack
  Archive: ZIP, TAR, GZIP, BZIP2, ZSTD, LZ4
  Certificate: X.509, ASN.1, PEM
  Font: TTF, OTF, WOFF2

  Why: Complex state machines, binary formats, untrusted input

--- Network Protocols ---
  HTTP/1.1, HTTP/2, HTTP/3 (QUIC)
  TLS handshake and record processing
  DNS parsing (responses, zone files)
  SMTP, IMAP envelope parsing
  WebSocket frame processing
  gRPC message handling

--- Serialization/Deserialization ---
  JSON.parse(), pickle.loads(), YAML.load()
  Protobuf deserialization
  XML entity expansion (billion laughs attack)
  Java ObjectInputStream
  PHP unserialize()

  These are common RCE vectors!

--- Cryptographic Code ---
  Certificate validation logic
  ASN.1 DER/BER parsing
  Key exchange protocols
  Signature verification
  Constant-time comparison (timing side channels)

--- Compression/Decompression ---
  zlib, brotli, zstd, lz4
  Decompression bombs (zip bombs)
  Corrupted archive handling
  Streaming decompression state machines

--- Regular Expressions ---
  ReDoS (Regular Expression Denial of Service)
  Catastrophic backtracking on crafted input
  Fuzz the regex engine AND regex patterns

--- API Endpoints ---
  Fuzz REST/GraphQL API with random JSON
  Test parameter validation boundaries
  Fuzz authentication and authorization logic
  File upload handling

--- Priority Criteria ---
  ✓ Processes untrusted input
  ✓ Written in memory-unsafe language (C, C++)
  ✓ Complex parsing logic
  ✓ Security-sensitive (auth, crypto, sandboxing)
  ✓ High code complexity (McCabe > 20)
  ✗ Simple CRUD operations (low value)
  ✗ Pure computation (sorting, math)
EOF
}

show_help() {
    cat << EOF
fuzz v$VERSION — Fuzz Testing Reference

Usage: script.sh <command>

Commands:
  intro        Fuzzing overview and types
  coverage     Coverage-guided fuzzing and instrumentation
  tools        Fuzzing tools: AFL++, libFuzzer, Honggfuzz
  harness      Writing fuzz harnesses and seed corpus
  mutation     Mutation strategies and scheduling
  triage       Crash deduplication and root cause analysis
  continuous   Continuous fuzzing and CI/CD integration
  targets      High-value targets for fuzzing
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    coverage)   cmd_coverage ;;
    tools)      cmd_tools ;;
    harness)    cmd_harness ;;
    mutation)   cmd_mutation ;;
    triage)     cmd_triage ;;
    continuous) cmd_continuous ;;
    targets)    cmd_targets ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "fuzz v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
