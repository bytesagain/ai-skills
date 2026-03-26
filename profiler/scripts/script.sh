#!/bin/bash
# Profiler - Performance Profiling Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PROFILER REFERENCE                             ║
║          Performance Profiling & Optimization               ║
╚══════════════════════════════════════════════════════════════╝

Profilers measure where your program spends time and memory,
helping you find and fix performance bottlenecks.

PROFILING TYPES:
  CPU          Which functions take the most time?
  Memory       Where is memory allocated/leaked?
  I/O          Disk/network blocking?
  Concurrency  Lock contention, goroutine leaks?

PROFILERS BY LANGUAGE:
  JavaScript   Chrome DevTools, clinic.js, 0x
  Python       cProfile, py-spy, Scalene, memray
  Go           pprof (built-in)
  Rust         flamegraph, perf, cargo-flamegraph
  Java         JProfiler, async-profiler, VisualVM
  C/C++        perf, Valgrind, gprof, Instruments
  Ruby         stackprof, rack-mini-profiler
  .NET         dotTrace, PerfView

VISUALIZATION:
  Flame graph    Shows call stack depth + time
  Call tree      Hierarchical function calls
  Timeline       Time-series view of events
  Heatmap        Memory allocation patterns
  Waterfall      Network request timing

PROFILING METHODOLOGY:
  1. Establish baseline (measure before optimizing)
  2. Identify hotspot (top-down: which function?)
  3. Understand why (algorithm? I/O? allocation?)
  4. Fix the bottleneck
  5. Measure again (verify improvement)
  6. Repeat (next bottleneck)

  Rule: Don't optimize what you haven't measured.
EOF
}

cmd_javascript() {
cat << 'EOF'
JAVASCRIPT / NODE.JS PROFILING
==================================

CHROME DEVTOOLS:
  Performance tab → Record → interact → Stop
  - Flame chart: bottom-up call stacks
  - Summary: scripting/rendering/painting time
  - Bottom-Up: most expensive functions
  - Call Tree: hierarchical view

  Memory tab:
  - Heap snapshot: all objects in memory
  - Allocation timeline: when objects are allocated
  - Allocation sampling: statistical sampling
  
  Lighthouse: automated performance audit
  - FCP, LCP, CLS, TBT, TTI scores

NODE.JS BUILT-IN:
  # CPU profile
  node --prof app.js
  node --prof-process isolate-*.log > profile.txt

  # V8 inspector + Chrome DevTools
  node --inspect app.js
  # Open chrome://inspect → Profiler tab

  # Heap snapshot
  process.memoryUsage()
  // { rss, heapTotal, heapUsed, external, arrayBuffers }
  
  v8.writeHeapSnapshot()   // Dump heap to file
  // Load in Chrome DevTools Memory tab

CLINIC.JS:
  npm install -g clinic
  clinic doctor -- node app.js        # Detect issue type
  clinic flame -- node app.js         # CPU flame graph
  clinic bubbleprof -- node app.js    # Async bottlenecks
  clinic heapprofiler -- node app.js  # Memory profiling

0X (flame graphs):
  npm install -g 0x
  0x app.js
  # Opens interactive flame graph in browser

WEB VITALS:
  import { onLCP, onFID, onCLS } from 'web-vitals';
  onLCP(console.log);   // Largest Contentful Paint
  onFID(console.log);   // First Input Delay
  onCLS(console.log);   // Cumulative Layout Shift
EOF
}

cmd_python_systems() {
cat << 'EOF'
PYTHON & SYSTEMS PROFILING
==============================

CPROFILE (built-in):
  python -m cProfile -s cumulative script.py
  python -m cProfile -o profile.prof script.py

  # In code
  import cProfile
  cProfile.run('my_function()')

  # Analyze saved profile
  import pstats
  stats = pstats.Stats('profile.prof')
  stats.sort_stats('cumulative')
  stats.print_stats(20)           # Top 20 functions

PY-SPY (sampling profiler, no code changes):
  pip install py-spy
  py-spy record -o profile.svg -- python script.py
  py-spy top -- python script.py          # Live top-like view
  py-spy record --pid 12345 -o out.svg    # Attach to running process
  # Generates SVG flame graph

SCALENE (CPU + memory + GPU):
  pip install scalene
  scalene script.py
  scalene --cpu --memory --gpu script.py
  # Shows per-line CPU time, memory allocation, copy volume

MEMRAY (memory profiler):
  pip install memray
  memray run script.py
  memray flamegraph memray-*.bin    # Flame graph
  memray table memray-*.bin        # Table view
  memray tree memray-*.bin         # Call tree
  memray stats memray-*.bin        # Summary

GO PPROF (built-in):
  import _ "net/http/pprof"
  go func() { http.ListenAndServe(":6060", nil) }()

  go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30
  go tool pprof http://localhost:6060/debug/pprof/heap
  go tool pprof http://localhost:6060/debug/pprof/goroutine

  # In pprof interactive
  (pprof) top 20                   # Top functions
  (pprof) web                      # Open in browser
  (pprof) list functionName        # Source-level view

LINUX PERF:
  perf record -g ./program         # Record
  perf report                      # Analyze
  perf stat ./program              # Quick stats
  perf top                         # Live system-wide

  # Generate flame graph
  perf script | stackcollapse-perf.pl | flamegraph.pl > flame.svg

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Profiler - Performance Profiling Tools Reference

Commands:
  intro             Profiling types, methodology
  javascript        Chrome DevTools, clinic.js, 0x
  python_systems    cProfile, py-spy, Scalene, memray, pprof

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)          cmd_intro ;;
  javascript)     cmd_javascript ;;
  python_systems) cmd_python_systems ;;
  help|*)         show_help ;;
esac
