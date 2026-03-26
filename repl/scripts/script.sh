#!/bin/bash
# REPL - Interactive Programming Environments Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              REPL REFERENCE                                 ║
║          Interactive Programming Environments               ║
╚══════════════════════════════════════════════════════════════╝

REPL (Read-Eval-Print Loop) is an interactive environment that
reads input, evaluates it, prints the result, and loops. Perfect
for exploration, prototyping, and learning.

REPLS BY LANGUAGE:
  Python       python3, IPython, ptpython, bpython
  JavaScript   node, Deno REPL, Bun REPL
  Ruby         irb, pry
  Go           gore, gomacro
  Rust         evcxr_repl
  Haskell      ghci
  Elixir       iex
  Clojure      lein repl, Clojure CLI
  PHP          php -a, PsySH
  Scala        scala, Ammonite
  R            R, radian
  Julia        julia
  Lua          lua
  Shell        bash, zsh, fish

ONLINE REPLS:
  Replit         replit.com (full IDE)
  CodeSandbox    codesandbox.io (web apps)
  StackBlitz     stackblitz.com (WebContainers)
  Jupyter        jupyter.org (notebooks)
  Observable     observablehq.com (JS notebooks)
  Go Playground  go.dev/play
  Rust Play      play.rust-lang.org
  TS Playground  typescriptlang.org/play

REPL FEATURES CHECKLIST:
  ✅ Tab completion
  ✅ Syntax highlighting
  ✅ Multi-line editing
  ✅ History search (Ctrl+R)
  ✅ Auto-import
  ✅ Magic commands (%timeit, %run)
  ✅ Rich output (tables, plots)
EOF
}

cmd_python() {
cat << 'EOF'
PYTHON REPLS
==============

IPYTHON (the best Python REPL):
  pip install ipython
  ipython

  # Magic commands
  %timeit [x**2 for x in range(1000)]   # Benchmark
  %time slow_function()                   # Time once
  %run script.py                          # Run file
  %load script.py                         # Load file into REPL
  %who / %whos                            # List variables
  %history -n 1-10                        # Show history
  %reset                                  # Clear namespace
  %debug                                  # Post-mortem debug
  %pdb on                                 # Auto-debug on exception
  %edit                                   # Open editor
  %paste                                  # Paste clipboard
  %pip install package                    # Install package
  %env VAR=value                          # Set env variable

  # Shell commands
  !ls -la                                 # Run shell command
  files = !ls *.py                        # Capture output
  
  # Auto-reload modules
  %load_ext autoreload
  %autoreload 2                           # Reload all modules on change

  # Output display
  from IPython.display import display, HTML, Image, Markdown
  display(HTML("<h1>Hello</h1>"))
  display(Image("photo.png"))

  # Config (~/.ipython/profile_default/ipython_config.py)
  c.InteractiveShell.ast_node_interactivity = "all"  # Show all outputs
  c.TerminalInteractiveShell.confirm_exit = False

PTPYTHON (enhanced REPL):
  pip install ptpython
  ptpython
  # Features: multi-line editing, vi/emacs mode,
  # autocompletion popup, signature help, mouse support

JUPYTER CONSOLE:
  pip install jupyter-console
  jupyter console                         # Terminal notebook
  jupyter qtconsole                       # GUI notebook
EOF
}

cmd_node_others() {
cat << 'EOF'
NODE.JS & OTHER REPLS
========================

NODE.JS REPL:
  node                                    # Start REPL

  > .help                                 # Show commands
  > .break                                # Exit multi-line
  > .clear                                # Clear context
  > .load script.js                       # Load file
  > .save session.js                      # Save session
  > .editor                               # Multi-line editor mode

  # REPL tricks
  > _                                     # Last result
  > require('fs').readFileSync('f.txt','utf8')
  > const {inspect} = require('util')
  > inspect(obj, {depth: null, colors: true})

  # Custom REPL
  const repl = require('repl');
  const r = repl.start('myapp> ');
  r.context.db = require('./db');
  // Now `db` available in REPL

  # Experimental
  node --experimental-repl-await
  > const resp = await fetch('https://api.example.com/data')
  > const data = await resp.json()

DENO REPL:
  deno repl
  > const resp = await fetch("https://api.example.com")
  > import { serve } from "https://deno.land/std/http/mod.ts"
  # Top-level await by default!

BUN REPL:
  bun repl

RUBY (pry):
  gem install pry
  pry

  pry> ls                                 # List methods
  pry> cd MyClass                         # Enter context
  pry> show-source method_name            # View source
  pry> show-doc method_name               # View docs
  pry> edit method_name                   # Edit in $EDITOR
  pry> whereami                           # Show location
  pry> binding.pry                        # Insert breakpoint (in code)
  pry> hist --grep pattern                # Search history

GO (gore):
  go install github.com/x-motemen/gore/cmd/gore@latest
  gore
  gore> fmt.Println("hello")
  gore> :import "net/http"
  gore> :doc fmt.Println
  gore> :type 42

RUST (evcxr):
  cargo install evcxr_repl
  evcxr
  >> let v = vec![1, 2, 3];
  >> v.iter().map(|x| x * 2).collect::<Vec<_>>()
  >> :dep serde = "1.0"                   # Add dependency

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
REPL - Interactive Programming Environments Reference

Commands:
  intro        Overview, REPL features
  python       IPython, ptpython, Jupyter
  node_others  Node.js, Deno, Ruby pry, Go, Rust

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  python)      cmd_python ;;
  node_others) cmd_node_others ;;
  help|*)      show_help ;;
esac
