#!/bin/bash
# Debugger - Code Debugging Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DEBUGGER REFERENCE                             ║
║          Code Debugging Tools & Techniques                  ║
╚══════════════════════════════════════════════════════════════╝

Debuggers let you pause execution, inspect state, step through
code, and find bugs interactively.

DEBUGGERS BY LANGUAGE:
  JavaScript   Chrome DevTools, Node Inspector, VS Code
  Python       pdb, ipdb, debugpy, pudb
  Go           Delve (dlv)
  Rust         rust-gdb, rust-lldb, CodeLLDB
  C/C++        GDB, LLDB, Valgrind
  Java         JDB, IntelliJ IDEA debugger
  Ruby         debug.gem, byebug, pry
  PHP          Xdebug, phpdbg
  .NET         dotnet-dump, VS debugger
  Shell        bash -x, set -x, bashdb

DEBUG APPROACHES:
  Interactive    Breakpoints, step, inspect (debugger)
  Print debug    console.log / print / fmt.Println
  Logging        Structured logs (Winston, loguru)
  Tracing        Distributed traces (Jaeger, Zipkin)
  Core dump      Post-mortem analysis (gdb core)
  Time-travel    Record + replay (rr, Replay.io)
  Remote         Attach to running process
EOF
}

cmd_javascript() {
cat << 'EOF'
JAVASCRIPT / NODE.JS DEBUGGING
==================================

CHROME DEVTOOLS:
  // In code
  debugger;              // Breakpoint in source

  // Console tricks
  console.log({a, b, c})         // Named output
  console.table(arrayOfObjects)  // Table format
  console.trace("stack")         // Stack trace
  console.time("op"); doThing(); console.timeEnd("op")
  console.group("Section"); ...; console.groupEnd()
  console.assert(x > 0, "x must be positive")
  copy(obj)                      // Copy to clipboard

  // Breakpoint types (Sources panel)
  - Line breakpoint              Click line number
  - Conditional breakpoint       Right-click → condition
  - Logpoint                     Right-click → log message
  - DOM breakpoint               Elements → Break on...
  - XHR/fetch breakpoint         Sources → XHR Breakpoints
  - Event listener breakpoint    Sources → Event Listeners

NODE.JS:
  # Built-in inspector
  node --inspect app.js            # Start with debugger
  node --inspect-brk app.js        # Break on first line
  # Open chrome://inspect in Chrome

  # VS Code launch.json
  {
    "type": "node",
    "request": "launch",
    "name": "Debug",
    "program": "${workspaceFolder}/src/index.js",
    "skipFiles": ["<node_internals>/**"],
    "env": { "DEBUG": "*" }
  }

  # Attach to running process
  kill -USR1 <pid>                 # Enable inspector on running Node
  # Then attach via Chrome DevTools or VS Code

REACT DEVTOOLS:
  // Browser extension → Components tab
  // Inspect props, state, hooks, context
  // Profiler → record renders, identify slow components
  // $r in console = selected component

DEBUG TIPS:
  // Conditional console.log
  process.env.DEBUG && console.log("debug info")

  // Debug module
  const debug = require('debug')('app:server');
  debug('listening on port %d', port);
  // Run: DEBUG=app:* node app.js
EOF
}

cmd_python_systems() {
cat << 'EOF'
PYTHON & SYSTEMS DEBUGGING
==============================

PDB (Python Debugger):
  # Drop into debugger
  import pdb; pdb.set_trace()       # Python 3.6+
  breakpoint()                       # Python 3.7+ (preferred)

  # PDB commands
  n(ext)      Execute next line (step over)
  s(tep)      Step into function
  c(ontinue)  Continue to next breakpoint
  r(eturn)    Continue until function returns
  l(ist)      Show source code around current line
  ll          Show entire current function
  p expr      Print expression
  pp expr     Pretty-print expression
  w(here)     Show call stack
  u(p)        Go up one frame
  d(own)      Go down one frame
  b 42        Set breakpoint at line 42
  b func      Set breakpoint at function
  b file:42   Breakpoint in specific file
  cl 1        Clear breakpoint 1
  a(rgs)      Print function arguments
  !statement  Execute Python statement
  q(uit)      Quit debugger

IPDB (IPython debugger):
  pip install ipdb
  import ipdb; ipdb.set_trace()
  # Same commands but with tab completion, syntax highlighting

PUDB (TUI debugger):
  pip install pudb
  python -m pudb script.py
  # Full-screen terminal debugger with variable inspector

REMOTE DEBUGGING (debugpy):
  pip install debugpy
  import debugpy
  debugpy.listen(5678)
  debugpy.wait_for_client()
  breakpoint()
  # VS Code: Attach to port 5678

GDB (C/C++):
  gcc -g -O0 program.c -o program   # Compile with debug info
  gdb ./program

  (gdb) run                          # Start program
  (gdb) break main                   # Breakpoint at main
  (gdb) break file.c:42              # Breakpoint at line
  (gdb) next                         # Step over
  (gdb) step                         # Step into
  (gdb) print variable               # Print value
  (gdb) info locals                  # All local variables
  (gdb) backtrace                    # Call stack
  (gdb) watch variable               # Break when value changes
  (gdb) frame 3                      # Switch to frame 3
  (gdb) thread info                  # List threads
  (gdb) core-file core               # Load core dump

DELVE (Go):
  go install github.com/go-delve/delve/cmd/dlv@latest
  dlv debug ./main.go                # Debug
  dlv test ./...                     # Debug tests
  dlv attach <pid>                   # Attach to process

  (dlv) break main.main
  (dlv) continue
  (dlv) next / step / stepout
  (dlv) print variable
  (dlv) goroutines                   # List goroutines
  (dlv) goroutine 1                  # Switch goroutine
  (dlv) locals                       # Local variables
  (dlv) stack                        # Call stack

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Debugger - Code Debugging Tools Reference

Commands:
  intro             Overview, approaches
  javascript        Chrome DevTools, Node.js, React
  python_systems    pdb/ipdb/pudb, GDB, Delve

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)          cmd_intro ;;
  javascript)     cmd_javascript ;;
  python_systems) cmd_python_systems ;;
  help|*)         show_help ;;
esac
