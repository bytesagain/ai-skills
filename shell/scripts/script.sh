#!/usr/bin/env bash
# shell — Shell Scripting Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Shell Scripting ===

The shell is both a command interpreter and a programming language.
Bash (Bourne Again Shell) is the most common shell on Linux systems.

Shebang Line:
  #!/bin/bash           — Use system bash
  #!/usr/bin/env bash   — Use bash from PATH (more portable)
  #!/bin/sh             — POSIX shell (not Bash! fewer features)

  The shebang MUST be the first line, no leading spaces.

Execution Methods:
  chmod +x script.sh && ./script.sh   # Direct execution (uses shebang)
  bash script.sh                      # Explicit interpreter
  source script.sh                    # Run in current shell (no subshell)
  . script.sh                         # Same as source (POSIX)

Shell Comparison:
  sh (Bourne):    POSIX base, minimal, maximum portability
  bash:           Most common, rich features, arrays, [[ ]]
  zsh:            macOS default, globbing, spelling correction
  dash:           Fast POSIX shell (Debian /bin/sh → dash)
  fish:           User-friendly, not POSIX (no sh compatibility)

When to Use Shell vs Other Languages:
  USE SHELL:
    - Gluing programs together (pipe-based workflows)
    - File operations (copy, move, rename, permissions)
    - System administration tasks
    - Quick-and-dirty automation (<100 lines)
    - Anything that's mostly calling other commands

  USE PYTHON/OTHER:
    - Complex data structures (beyond arrays)
    - Error handling needs to be robust
    - Math-heavy operations
    - JSON/XML processing (shell struggles)
    - >200 lines (shell gets unwieldy)
    - Cross-platform requirements

Exit Codes:
  0:     Success
  1:     General error
  2:     Misuse of shell command
  126:   Command found but not executable
  127:   Command not found
  128+N: Killed by signal N (130 = Ctrl+C = SIGINT)
  Custom: use exit N in your script (0-255)
EOF
}

cmd_variables() {
    cat << 'EOF'
=== Variables & Parameter Expansion ===

Declaration:
  name="Alice"          # No spaces around =
  readonly PI=3.14159   # Cannot be reassigned
  local count=0         # Function-local (only in functions)
  export PATH           # Make available to child processes
  declare -i num=42     # Integer attribute
  declare -r const="x"  # Read-only (same as readonly)
  declare -a arr        # Indexed array
  declare -A map        # Associative array (Bash 4+)

Special Variables:
  $0       Script name
  $1-$9    Positional arguments
  ${10}    Arguments beyond 9 (braces required)
  $#       Number of arguments
  $@       All arguments (separate words when quoted)
  $*       All arguments (single string when quoted)
  $$       Current process PID
  $!       Last background process PID
  $?       Last command exit code
  $_       Last argument of previous command
  $LINENO  Current line number

Parameter Expansion:
  ${var:-default}    Use default if var is unset or empty
  ${var:=default}    Set var to default if unset or empty
  ${var:+alternate}  Use alternate if var IS set
  ${var:?error msg}  Exit with error if var is unset

  ${#var}            Length of string
  ${var#pattern}     Remove shortest prefix match
  ${var##pattern}    Remove longest prefix match
  ${var%pattern}     Remove shortest suffix match
  ${var%%pattern}    Remove longest suffix match
  ${var/old/new}     Replace first occurrence
  ${var//old/new}    Replace all occurrences
  ${var^}            Uppercase first letter
  ${var^^}           Uppercase all
  ${var,}            Lowercase first letter
  ${var,,}           Lowercase all

Arrays:
  arr=("one" "two" "three")   # Indexed array
  arr[0]="zero"               # Set element
  echo "${arr[0]}"            # Get element
  echo "${arr[@]}"            # All elements
  echo "${#arr[@]}"           # Array length
  echo "${!arr[@]}"           # All indices
  arr+=("four")               # Append

Associative Arrays (Bash 4+):
  declare -A colors
  colors[red]="#ff0000"
  colors[green]="#00ff00"
  echo "${colors[red]}"       # Get value
  echo "${!colors[@]}"        # All keys
EOF
}

cmd_control() {
    cat << 'EOF'
=== Control Flow ===

if/elif/else:
  if [[ "$name" == "Alice" ]]; then
    echo "Hello Alice"
  elif [[ "$name" == "Bob" ]]; then
    echo "Hello Bob"
  else
    echo "Hello stranger"
  fi

Test Operators ([[ ]] — Bash extended test):
  String:   ==  !=  <  >  -z (empty)  -n (non-empty)  =~ (regex)
  Integer:  -eq  -ne  -lt  -le  -gt  -ge
  File:     -f (file)  -d (dir)  -e (exists)  -r (readable)
            -w (writable)  -x (executable)  -s (non-empty)
            -L (symlink)  -nt (newer than)  -ot (older than)
  Logic:    && (and)  || (or)  ! (not)

  [[ ]] vs [ ]:
    [[ ]] — Bash keyword, supports regex, no word splitting
    [ ]   — POSIX, portable, but needs more quoting

case:
  case "$input" in
    start|begin)  echo "Starting..." ;;
    stop)         echo "Stopping..." ;;
    restart)      echo "Restarting..."
                  do_restart ;;
    *)            echo "Unknown: $input" ;;
  esac

for:
  for item in "one" "two" "three"; do echo "$item"; done
  for file in *.txt; do echo "$file"; done
  for i in {1..10}; do echo "$i"; done
  for ((i=0; i<10; i++)); do echo "$i"; done
  for arg in "$@"; do echo "$arg"; done

while/until:
  while read -r line; do echo "$line"; done < file.txt
  while [[ $count -lt 10 ]]; do ((count++)); done
  until [[ -f /tmp/ready ]]; do sleep 1; done

  # Infinite loop
  while true; do
    echo "running..."
    sleep 5
  done

Functions:
  greet() {
    local name="${1:?Name required}"
    echo "Hello, $name"
    return 0
  }
  greet "Alice"
  
  # Capture output
  result=$(greet "Alice")

  # Functions share global scope unless 'local' used
  # Always use 'local' for function variables
EOF
}

cmd_redirections() {
    cat << 'EOF'
=== Redirections & Pipes ===

File Descriptors:
  0 = stdin    (standard input)
  1 = stdout   (standard output)
  2 = stderr   (standard error)

Basic Redirections:
  cmd > file          Stdout to file (overwrite)
  cmd >> file         Stdout to file (append)
  cmd < file          File to stdin
  cmd 2> file         Stderr to file
  cmd 2>&1            Stderr to stdout (merge)
  cmd &> file         Both stdout and stderr to file (Bash)
  cmd > file 2>&1     Same, but POSIX compatible
  cmd > /dev/null     Discard output

Pipes:
  cmd1 | cmd2         Stdout of cmd1 → stdin of cmd2
  cmd1 |& cmd2        Stdout AND stderr → stdin (Bash 4+)
  cmd1 | tee file     Stdout to both pipe and file
  cmd1 | tee -a file  Same but append

Here Documents:
  cat << EOF           # Variables expanded
  Hello, $USER
  Today is $(date)
  EOF

  cat << 'EOF'         # Literal — no expansion
  Hello, $USER         # Prints literally: $USER
  EOF

  cat <<- EOF          # Strip leading tabs
  	Indented content
  EOF

Here Strings:
  grep "pattern" <<< "$variable"
  # Feeds variable as stdin (one line)

Process Substitution:
  diff <(sort file1) <(sort file2)
  # Treats command output as a file

  cmd > >(tee log.txt)
  # Redirect output through a process

Named Pipes (FIFO):
  mkfifo /tmp/mypipe
  cmd1 > /tmp/mypipe &
  cmd2 < /tmp/mypipe

Advanced:
  exec 3> logfile.txt     # Open FD 3 for writing
  echo "log entry" >&3    # Write to FD 3
  exec 3>&-               # Close FD 3

  # Read file line-by-line without subshell
  while IFS= read -r line; do
    echo "$line"
  done < file.txt

  # PITFALL: pipe creates subshell!
  count=0
  cat file.txt | while read -r line; do ((count++)); done
  echo "$count"  # Always 0! (subshell variable)

  # FIX: use redirect instead of pipe
  count=0
  while read -r line; do ((count++)); done < file.txt
  echo "$count"  # Correct!
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Shell Script Safety ===

The Holy Trinity — set -euo pipefail:
  set -e            Exit on first error (non-zero exit code)
  set -u            Error on undefined variables
  set -o pipefail   Pipe fails if ANY command in pipe fails
  
  Combined: set -euo pipefail (put at top of every script)

  Exceptions to -e:
    cmd || true          # Intentionally allow failure
    if cmd; then ...     # Tested in condition — no exit
    cmd || handle_error  # Error handling pattern

Quoting — ALWAYS QUOTE YOUR VARIABLES:
  Bad:   if [ $file = "test" ]     # Breaks on spaces/globs
  Good:  if [[ "$file" == "test" ]]

  Bad:   for f in $(ls); do ...    # Word splitting disasters
  Good:  for f in *; do ...        # Glob expansion is safe

  Bad:   echo $var                 # Glob expansion, word splitting
  Good:  echo "$var"               # Preserved as-is

  When to NOT quote:
    Glob patterns: for f in *.txt (intentional expansion)
    Arithmetic: $(( count + 1 )) (already evaluated)

ShellCheck:
  Static analysis tool — catches bugs before running
  Install: apt install shellcheck / brew install shellcheck
  Usage:   shellcheck script.sh
  Online:  https://www.shellcheck.net
  Integrate into CI/CD pipeline
  EVERY shell script should pass ShellCheck

Error Handling Patterns:
  # Trap for cleanup
  cleanup() {
    rm -f "$tmpfile"
    echo "Cleaned up" >&2
  }
  trap cleanup EXIT

  # Die function
  die() {
    echo "ERROR: $*" >&2
    exit 1
  }

  # Safe temp files
  tmpfile=$(mktemp) || die "Failed to create temp file"
  trap 'rm -f "$tmpfile"' EXIT

  # Check commands exist
  command -v jq &>/dev/null || die "jq is required"

Common Gotchas:
  cd /some/dir && do_stuff    # cd might fail!
  cd /some/dir || exit 1       # Safe

  if [ -f "$file" ]; then     # Race condition possible
  
  var=$(cmd)                   # $? is now cmd's exit code, not previous
  
  local var=$(cmd)             # 'local' masks exit code! Always: local var; var=$(cmd)
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Essential CLI Tools ===

grep — Pattern Matching:
  grep "pattern" file            # Basic search
  grep -r "pattern" dir/         # Recursive
  grep -i "pattern" file         # Case-insensitive
  grep -v "pattern" file         # Invert match
  grep -c "pattern" file         # Count matches
  grep -l "pattern" *.txt        # List matching files
  grep -n "pattern" file         # Line numbers
  grep -E "regex|pattern" file   # Extended regex (egrep)
  grep -o "pattern" file         # Only matching part
  grep -P "\d+" file             # Perl regex (GNU grep)

sed — Stream Editor:
  sed 's/old/new/' file          # Replace first per line
  sed 's/old/new/g' file         # Replace all
  sed -i 's/old/new/g' file      # In-place edit
  sed -n '5,10p' file            # Print lines 5-10
  sed '/pattern/d' file          # Delete matching lines
  sed '3a\new line' file         # Insert after line 3

awk — Field Processing:
  awk '{print $1}' file          # First field (space-delimited)
  awk -F: '{print $1}' /etc/passwd  # Custom delimiter
  awk '$3 > 100' file            # Filter by field value
  awk '{sum+=$1} END{print sum}' # Sum a column
  awk 'NR==5,NR==10' file       # Lines 5-10
  awk '!seen[$0]++' file         # Remove duplicates (order preserved)

find — File Discovery:
  find . -name "*.log"           # By name pattern
  find . -type f -mtime -7       # Modified in last 7 days
  find . -size +100M             # Larger than 100MB
  find . -name "*.tmp" -delete   # Find and delete
  find . -type f -exec chmod 644 {} \;  # Execute on each

xargs — Build Commands from Input:
  find . -name "*.log" | xargs rm          # Delete found files
  find . -name "*.log" -print0 | xargs -0 rm  # Handle spaces
  cat urls.txt | xargs -P 4 -I {} curl {}  # Parallel downloads

jq — JSON Processing:
  echo '{"name":"Ada"}' | jq '.name'         # "Ada"
  cat data.json | jq '.items[0]'             # First item
  cat data.json | jq '.items | length'       # Array length
  cat data.json | jq -r '.name'              # Raw output (no quotes)
  cat data.json | jq 'select(.age > 30)'     # Filter

sort/uniq/cut/wc:
  sort file                      # Sort lines
  sort -n file                   # Numeric sort
  sort -k2 file                  # Sort by 2nd field
  sort file | uniq -c            # Count unique lines
  cut -d: -f1 /etc/passwd        # Extract field
  wc -l file                     # Count lines
  wc -w file                     # Count words
EOF
}

cmd_signals() {
    cat << 'EOF'
=== Signals & Traps ===

Common Signals:
  Signal    Number  Default    Source
  SIGHUP      1    Terminate  Terminal closed
  SIGINT      2    Terminate  Ctrl+C
  SIGQUIT     3    Core dump  Ctrl+\
  SIGKILL     9    Terminate  Cannot be caught! (kill -9)
  SIGTERM    15    Terminate  Graceful shutdown (kill default)
  SIGCHLD    17    Ignore     Child process stopped/terminated
  SIGSTOP    19    Stop       Cannot be caught! (like SIGKILL)
  SIGTSTP    20    Stop       Ctrl+Z
  SIGUSR1    10    Terminate  User-defined
  SIGUSR2    12    Terminate  User-defined

trap — Catch Signals:
  # Cleanup on exit (any exit — normal or error)
  trap 'echo "Cleaning up..."; rm -f "$tmpfile"' EXIT

  # Catch Ctrl+C
  trap 'echo "Interrupted!"; exit 130' INT

  # Catch termination
  trap 'echo "Terminated!"; cleanup; exit 143' TERM

  # Multiple signals
  trap 'cleanup' EXIT INT TERM HUP

  # Reset trap to default
  trap - INT

  # Ignore signal
  trap '' INT   # Ctrl+C does nothing

  # List active traps
  trap -p

Cleanup Pattern:
  #!/usr/bin/env bash
  set -euo pipefail

  tmpdir=$(mktemp -d)
  cleanup() {
    local exit_code=$?
    rm -rf "$tmpdir"
    exit "$exit_code"  # Preserve original exit code
  }
  trap cleanup EXIT INT TERM

  # ... script logic ...
  # cleanup runs automatically on any exit

Background Jobs:
  cmd &                  # Run in background
  wait                   # Wait for all background jobs
  wait $pid              # Wait for specific PID
  wait -n                # Wait for any one job (Bash 4.3+)

  jobs                   # List background jobs
  fg %1                  # Bring job 1 to foreground
  bg %1                  # Resume stopped job in background
  kill %1                # Kill job 1
  disown %1              # Detach job from shell

Parallel Execution:
  # Run commands in parallel, wait for all
  cmd1 &
  cmd2 &
  cmd3 &
  wait

  # With exit code checking
  pids=()
  cmd1 & pids+=($!)
  cmd2 & pids+=($!)
  for pid in "${pids[@]}"; do
    wait "$pid" || echo "PID $pid failed"
  done

  # GNU Parallel (more sophisticated)
  parallel -j4 process_file ::: *.csv

Nohup / Disown:
  nohup cmd &            # Survives terminal close (output → nohup.out)
  cmd & disown           # Detach from shell (no nohup.out)
  setsid cmd             # New session (fully detached)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Shell Script Quality Checklist ===

Structure:
  [ ] Shebang line present (#!/usr/bin/env bash)
  [ ] set -euo pipefail at top
  [ ] Script purpose documented in header comment
  [ ] Usage/help function for arguments
  [ ] Consistent indentation (2 or 4 spaces, not tabs)
  [ ] Functions defined before use
  [ ] main() function pattern if script is complex

Safety:
  [ ] All variables quoted ("$var" not $var)
  [ ] No uninitialized variable access (set -u catches these)
  [ ] Temp files created with mktemp
  [ ] Cleanup trap registered (trap cleanup EXIT)
  [ ] Exit codes meaningful and documented
  [ ] No eval with user input (security risk!)
  [ ] No unescaped glob patterns where not intended

Error Handling:
  [ ] Critical commands checked for failure
  [ ] die/error function for clean error reporting
  [ ] Stderr used for error messages (>&2)
  [ ] Dependencies checked at start (command -v)
  [ ] Permissions verified before operations
  [ ] Network operations have timeouts

Code Quality:
  [ ] ShellCheck passes with no warnings
  [ ] Functions are small and focused
  [ ] Local variables used in functions
  [ ] No useless cat (use < file instead of cat file |)
  [ ] No parsing ls output (use globs)
  [ ] No cd without || exit
  [ ] Arrays used for lists (not space-separated strings)

Input Handling:
  [ ] Arguments validated (count and format)
  [ ] Paths handled with spaces and special characters
  [ ] User input sanitized before use
  [ ] Default values provided where appropriate
  [ ] --help / -h supported
  [ ] -- handled for option termination

Portability (if needed):
  [ ] Tested on target systems (Linux, macOS, both?)
  [ ] bash-specific features noted if not POSIX
  [ ] GNU vs BSD tool differences handled (sed -i, grep -P)
  [ ] No hardcoded paths (/usr/local vs /usr)
  [ ] External tool versions documented
EOF
}

show_help() {
    cat << EOF
shell v$VERSION — Shell Scripting Reference

Usage: script.sh <command>

Commands:
  intro        Bash overview, shebang, exit codes, when to use shell
  variables    Variables, arrays, parameter expansion, special vars
  control      if/case/for/while, functions, test operators
  redirections Pipes, heredocs, process substitution, FD management
  safety       set -euo pipefail, quoting, ShellCheck, error handling
  tools        grep, sed, awk, find, xargs, jq essential patterns
  signals      Traps, cleanup, background jobs, parallel execution
  checklist    Shell script quality checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    variables)    cmd_variables ;;
    control)      cmd_control ;;
    redirections) cmd_redirections ;;
    safety)       cmd_safety ;;
    tools)        cmd_tools ;;
    signals)      cmd_signals ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "shell v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
