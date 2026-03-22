#!/usr/bin/env bash
# flame — Flame Graph Profiling Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Flame Graphs ===

Flame graphs are a visualization of profiled software, invented by
Brendan Gregg (Netflix) in 2011. They show which code paths consume
the most resources (CPU, memory, I/O).

Anatomy of a Flame Graph:
  ┌─────────────────────────────────────────────┐
  │              function_D (leaf)               │  ← widest = most time
  ├──────────────────┬──────────────────────────┤
  │   function_B     │      function_C          │
  ├──────────────────┴──────────────────────────┤
  │              function_A                      │
  ├─────────────────────────────────────────────┤
  │                main()                        │
  └─────────────────────────────────────────────┘
    Bottom = root (entry point)
    Top = leaf (where CPU is actually spent)
    Width = proportion of total time in that function

How to Read:
  - Y-axis: stack depth (bottom=root, top=leaf)
  - X-axis: NOT time! It's sorted alphabetically
  - Width: proportion of samples including this function
  - Color: usually random (or by package/language)

Key Insight:
  - Wide plateaus at TOP = where CPU is actually burning
  - Wide bars at BOTTOM = common ancestor (not necessarily slow)
  - Look for wide TOP-level frames — those are your optimization targets

Types:
  CPU Flame Graph          Where is CPU time spent?
  Off-CPU Flame Graph      Where is the program waiting? (I/O, locks)
  Memory Flame Graph       Where are allocations happening?
  Differential Flame Graph What changed between two profiles?

Sampling vs Tracing:
  Sampling: Periodically record stack trace (low overhead, ~1-5%)
  Tracing: Record every function entry/exit (high overhead, exact)
  Flame graphs typically use sampling for production safety
EOF
}

cmd_cpu() {
    cat << 'EOF'
=== CPU Flame Graph Generation ===

--- Linux perf (most common) ---
  # Record CPU samples for 30 seconds
  perf record -F 99 -p <PID> -g -- sleep 30

  # Or profile a command
  perf record -F 99 -g -- ./my_program

  # Generate flame graph
  perf script | stackcollapse-perf.pl | flamegraph.pl > cpu.svg

  Options:
    -F 99       Sample at 99 Hz (avoids aliasing with 100Hz timers)
    -g          Record call graphs (stack traces)
    -p <PID>    Attach to process
    -a          System-wide profiling
    --call-graph dwarf   Better stack traces (needs debug info)

--- DTrace (macOS, FreeBSD, Solaris) ---
  # Profile user-level stacks
  dtrace -x ustackframes=100 -n '
    profile-99 /pid == $target/ {
      @[ustack()] = count();
    }
    tick-30s { exit(0); }' -p <PID> > out.stacks

  stackcollapse.pl out.stacks | flamegraph.pl > cpu.svg

--- bpftrace (modern Linux) ---
  bpftrace -e '
    profile:hz:99 /pid == cpid/ {
      @[ustack()] = count();
    }' -p <PID> -c './program'

--- Brendan Gregg's FlameGraph tools ---
  git clone https://github.com/brendangregg/FlameGraph

  Key scripts:
    stackcollapse-perf.pl   Convert perf script output
    stackcollapse-dtrace.pl Convert DTrace output
    stackcollapse-jstack.pl Convert jstack output
    flamegraph.pl           Generate SVG from collapsed stacks

  flamegraph.pl options:
    --title "My Profile"    Custom title
    --width 1200            SVG width in pixels
    --minwidth 0.5          Min function width (% of total)
    --countname samples     Label for count axis
    --colors java           Color scheme (java, js, perl, green, ...)
    --reverse               Icicle graph (roots at top)
EOF
}

cmd_memory() {
    cat << 'EOF'
=== Memory Profiling & Allocation Flame Graphs ===

Memory flame graphs show WHERE allocations happen, not just HOW MUCH.

--- Concept ---
  Traditional: "Process uses 2GB memory" (not actionable)
  Flame graph: "function X allocates 1.2GB via path A→B→X" (actionable)

--- Linux (perf + memory events) ---
  # Record memory allocations
  perf record -e 'kmem:kmalloc' -g -p <PID> -- sleep 30
  perf script | stackcollapse-perf.pl | flamegraph.pl \
    --title "Allocation Flame Graph" --countname "bytes" > mem.svg

--- Valgrind + Massif ---
  valgrind --tool=massif --pages-as-heap=yes ./program
  ms_print massif.out.<PID>     # text snapshot
  massif-visualizer massif.out.<PID>  # GUI tool

--- TCMalloc / jemalloc heap profiling ---
  # TCMalloc
  HEAPPROFILE=/tmp/hp ./program
  pprof --collapsed /tmp/hp.0001.heap | flamegraph.pl > heap.svg

  # jemalloc
  MALLOC_CONF=prof:true,prof_prefix:/tmp/jp ./program
  jeprof --collapsed ./program /tmp/jp.*.heap | flamegraph.pl > heap.svg

--- Chrome DevTools (JS/Node.js) ---
  1. DevTools → Memory → Allocation Sampling
  2. Record during operation
  3. View "Chart" for flame-chart style
  4. Heavy (Bottom Up) view = flame graph equivalent

--- Heap Snapshot Analysis ---
  Node.js:
    v8.writeHeapSnapshot()         // writes .heapsnapshot
    --inspect → Chrome DevTools → Memory → Take Snapshot
    Compare two snapshots to find leaks (Objects allocated between)

  Key metrics:
    Shallow Size    Memory held directly by object
    Retained Size   Memory freed if object is GC'd (includes references)
    Distance        Hops from GC root (high = likely leak candidate)
EOF
}

cmd_nodejs() {
    cat << 'EOF'
=== Node.js Flame Graphs ===

--- 0x (recommended, simple) ---
  npx 0x -- node app.js
  # Generates interactive flame graph in browser

  npx 0x -o -- node app.js   # Open in browser automatically
  npx 0x -P 'autocannon -d 10 http://localhost:3000' -- node app.js

--- clinic.js (comprehensive) ---
  npx clinic doctor -- node app.js
  npx clinic flame -- node app.js     # Flame graph
  npx clinic bubbleprof -- node app.js # Async delays

  clinic flame features:
    - Automatic flame graph generation
    - Identifies hot frames
    - Separates Node.js internals from user code
    - Handles async stack traces

--- V8 Profiler (built-in) ---
  # Generate V8 log
  node --prof app.js
  # Process the log
  node --prof-process isolate-0x*.log > processed.txt

  # Or use --cpu-prof for Chrome DevTools format
  node --cpu-prof --cpu-prof-interval=1000 app.js
  # Opens in Chrome DevTools → Performance tab

--- Chrome DevTools Remote ---
  node --inspect app.js
  # Chrome → chrome://inspect → select target
  # Performance tab → Record → interact → Stop
  # View flame chart (time-based, left=start, right=end)

  Flame CHART vs Flame GRAPH:
    Chart: X-axis = time (shows sequence)
    Graph: X-axis = alphabetical (shows aggregate)

--- Common Hot Spots in Node.js ---
  JSON.parse/stringify   Large object serialization
  RegExp backtracking    Catastrophic regex patterns
  Buffer.toString()      Encoding conversion
  crypto.*               Hash/encrypt operations
  console.log()          I/O blocking in hot path
  deep clone/merge       Recursive object traversal

--- Production Profiling Tips ---
  1. Use --perf-basic-prof for perf integration
     node --perf-basic-prof app.js
     perf record -F 99 -p <PID> -g -- sleep 30
     perf script | stackcollapse-perf.pl | flamegraph.pl > out.svg

  2. Keep debug info: don't strip source maps
  3. Profile under realistic load (not synthetic)
  4. Sample for 30-60 seconds minimum
  5. Compare before/after for optimization verification
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Language-Specific Flame Graphs ===

--- Python ---
  py-spy (sampling profiler, no code changes):
    py-spy record -o profile.svg --pid <PID>
    py-spy record -o profile.svg -- python app.py
    py-spy top --pid <PID>    # live top-like view

  cProfile + flameprof:
    python -m cProfile -o profile.pstats app.py
    flameprof profile.pstats > flame.svg

  Austin (zero-instrumentation):
    austin -o profile.austin python app.py
    austin2speedscope profile.austin  # view in speedscope

--- Java ---
  async-profiler (best for Java):
    ./asprof -d 30 -f profile.html <PID>
    ./asprof -e alloc -d 30 -f alloc.html <PID>  # allocation
    ./asprof -e wall -d 30 -f wall.html <PID>     # wall clock

  JFR (Java Flight Recorder, built-in since JDK 11):
    java -XX:StartFlightRecording=duration=30s,filename=rec.jfr App
    jfr print --events CPULoad rec.jfr
    # Convert: jfr2flame rec.jfr flame.svg

  jstack + flame graph:
    for i in $(seq 1 100); do jstack <PID>; sleep 0.1; done > stacks.txt
    stackcollapse-jstack.pl stacks.txt | flamegraph.pl > cpu.svg

--- Go ---
  pprof (built-in):
    import _ "net/http/pprof"   // add to main
    go tool pprof -http=:8080 http://localhost:6060/debug/pprof/profile?seconds=30
    # Interactive flame graph in browser

  Command line:
    go tool pprof http://localhost:6060/debug/pprof/profile
    (pprof) web        # opens flame graph in browser
    (pprof) top 20     # top functions
    (pprof) list funcName  # source-level annotation

--- Rust ---
  cargo-flamegraph:
    cargo install flamegraph
    cargo flamegraph -- args     # profile binary
    cargo flamegraph --bench     # profile benchmarks

  perf-based (Linux):
    perf record -F 99 -g -- ./target/release/myapp
    perf script | stackcollapse-perf.pl | flamegraph.pl > out.svg
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Flame Graph Tools ===

--- Generation Tools ---

  FlameGraph (Brendan Gregg):
    https://github.com/brendangregg/FlameGraph
    The original. Perl scripts, generates SVG.
    stackcollapse-*.pl → flamegraph.pl
    Supports: perf, DTrace, SystemTap, jstack, Instruments

  speedscope:
    https://www.speedscope.app
    Web-based viewer (also npm package)
    Supports: Chrome profiles, perf, pprof, Instruments
    Three views: Time Order, Left Heavy, Sandwich
    npm install -g speedscope

  Firefox Profiler:
    https://profiler.firefox.com
    Drag & drop perf/Chrome profiles
    Excellent call tree + flame chart
    Supports filtering, markers, memory

  pprof (Google):
    Built into Go, available for others
    Interactive web UI with flame graph
    go tool pprof -http=:8080 profile.pb.gz

--- Visualization Options ---

  SVG (flamegraph.pl):
    Interactive: hover for details, click to zoom
    Search: Ctrl+F to highlight matching functions
    Static file, shareable, version-controllable

  speedscope:
    Time Order:  Flame chart (X = time)
    Left Heavy:  Flame graph (X = aggregate, sorted)
    Sandwich:    Callers/callees of selected function

  d3-flame-graph:
    JavaScript library for embedding in web apps
    npm install d3-flame-graph

--- Viewing Tips ---
  1. Start from the TOP — wide plateaus are the bottleneck
  2. Use search to highlight specific functions/modules
  3. Click to zoom into a subtree
  4. Compare widths, not heights
  5. Ignore narrow towers (insignificant time)
  6. Look for unexpected frames (why is JSON.parse here?)
EOF
}

cmd_differential() {
    cat << 'EOF'
=== Differential Flame Graphs ===

Compare two profiles to see what CHANGED between them.
Essential for: regression analysis, optimization verification.

--- How It Works ---
  1. Capture baseline profile (before change)
  2. Capture comparison profile (after change)
  3. Generate diff: red = regression, blue = improvement

--- Generation ---
  # Baseline
  perf record -F 99 -g -p <PID> -- sleep 30
  perf script > baseline.perf
  stackcollapse-perf.pl baseline.perf > baseline.folded

  # After change
  perf record -F 99 -g -p <PID> -- sleep 30
  perf script > comparison.perf
  stackcollapse-perf.pl comparison.perf > comparison.folded

  # Differential flame graph
  difffolded.pl baseline.folded comparison.folded \
    | flamegraph.pl > diff.svg

--- Reading Differential Flame Graphs ---
  Red frames:    More samples than baseline (regression)
  Blue frames:   Fewer samples than baseline (improvement)
  White frames:  Unchanged
  Width:         Based on comparison profile

  Warning: Changes in one function can shift others
  A function getting faster makes everything else look
  relatively wider (even if unchanged in absolute terms)

--- Normalized Comparison ---
  # Normalize to same number of total samples
  difffolded.pl -n baseline.folded comparison.folded \
    | flamegraph.pl > diff-normalized.svg

--- flamegraph.pl diff options ---
  --negate          Reverse colors (blue=regression)

--- Alternative: flamegraph --differential in speedscope ---
  Import both profiles, visual side-by-side comparison

--- Best Practices ---
  1. Profile under SAME workload (same requests, same data)
  2. Profile for same duration
  3. Use same sampling rate
  4. Run multiple samples, compare averages
  5. Isolate the change (one variable at a time)
  6. Normalize sample counts for fair comparison
  7. Focus on significant changes (>5% diff)
EOF
}

cmd_interpret() {
    cat << 'EOF'
=== Interpreting Flame Graphs ===

--- Common Patterns ---

  "Flat Top" (Wide plateau at top):
    ┌──────────────────────────────┐
    │        hot_function()         │
    Meaning: This function is CPU-bound
    Action: Optimize this function's algorithm

  "Narrow Spikes" (Tall thin towers):
    │ │
    │f│
    │e│
    │d│
    Meaning: Deep call chain but infrequent
    Action: Usually ignorable (small % of total)

  "Missing Frames" ([unknown]):
    ┌────────────────────────┐
    │      [unknown]          │
    Meaning: Missing debug symbols
    Action: Install -dbg packages, compile with -g
    Common: libc, kernel frames without debuginfo

  "Two Humps" (bimodal distribution):
    ┌─────┐      ┌─────┐
    │pathA │      │pathB │
    Meaning: Two distinct hot paths
    Action: Address whichever is wider first

--- Anti-Patterns & Gotchas ---

  1. Don't read X-axis as time!
     Frames are sorted alphabetically, not chronologically
     Use flame CHARTS (speedscope Time Order) for time view

  2. GC / Runtime frames:
     Large GC frames = memory pressure (fix allocations, not GC)
     JIT compilation frames = cold start (ignore for steady state)

  3. Kernel frames dominating:
     syscall frames (read, write, futex) = I/O bound, not CPU bound
     Use off-CPU flame graph instead

  4. Sampling bias:
     Very short functions may not appear (under sampling interval)
     Higher frequency = more accuracy but more overhead

  5. Inlined functions:
     May not appear in profile (compiler optimized away)
     Use --call-graph dwarf or -fno-omit-frame-pointer

--- Optimization Workflow ---
  1. Profile → Generate flame graph
  2. Identify widest top-level frame
  3. Understand WHY it's hot (algorithm? I/O? contention?)
  4. Optimize the specific cause
  5. Re-profile → Generate differential flame graph
  6. Verify improvement (blue in diff = success)
  7. Repeat for next widest frame
EOF
}

show_help() {
    cat << EOF
flame v$VERSION — Flame Graph Profiling Reference

Usage: script.sh <command>

Commands:
  intro        Flame graph anatomy and how to read them
  cpu          CPU flame graph generation (perf, DTrace)
  memory       Memory profiling and allocation flame graphs
  nodejs       Node.js specific profiling tools
  languages    Python, Java, Go, Rust flame graphs
  tools        Flame graph visualization tools
  differential Differential flame graphs for regression analysis
  interpret    How to interpret patterns and anti-patterns
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    cpu)          cmd_cpu ;;
    memory|mem)   cmd_memory ;;
    nodejs|node)  cmd_nodejs ;;
    languages)    cmd_languages ;;
    tools)        cmd_tools ;;
    differential|diff) cmd_differential ;;
    interpret)    cmd_interpret ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "flame v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
