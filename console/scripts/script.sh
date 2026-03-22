#!/usr/bin/env bash
# console — Console Output & Debugging Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Console Output Fundamentals ===

The console is the primary interface between programs and developers.
Understanding output streams, formatting, and debugging through the
console is essential for every developer.

Standard Streams (Unix/POSIX):
  stdin  (fd 0):  Standard input  — keyboard, pipe, file
  stdout (fd 1):  Standard output — normal program output
  stderr (fd 2):  Standard error  — errors, diagnostics, progress

  Separation matters:
    stdout: data output (can be piped, redirected)
    stderr: human-readable messages (always visible)

    cmd > output.txt    # stdout to file, stderr still on screen
    cmd 2> errors.txt   # stderr to file
    cmd &> all.txt      # both to file
    cmd 2>&1 | grep     # merge stderr into stdout for piping

TTY Detection:
  Is output going to a terminal or a pipe/file?
  Terminal: show colors, progress bars, interactive elements
  Pipe/file: plain text only (no ANSI codes)

  Bash:   [ -t 1 ] && echo "stdout is a terminal"
  Python: sys.stdout.isatty()
  Node:   process.stdout.isTTY
  Go:     term.IsTerminal(int(os.Stdout.Fd()))

Output Principles:
  1. Use stdout for DATA, stderr for MESSAGES
  2. Respect NO_COLOR environment variable (no-color.org)
  3. Detect TTY before using colors/formatting
  4. End lines with \n (don't leave partial lines)
  5. Buffer stdout (performance), don't buffer stderr (timeliness)
  6. Use exit codes: 0 = success, non-zero = failure
  7. Be quiet by default, verbose with -v flag
EOF
}

cmd_ansi() {
    cat << 'EOF'
=== ANSI Escape Codes ===

Format: \033[<code>m  (or \e[<code>m in bash)
Reset all: \033[0m

Basic Text Styles:
  \033[0m   Reset/Normal
  \033[1m   Bold/Bright
  \033[2m   Dim/Faint
  \033[3m   Italic (not widely supported)
  \033[4m   Underline
  \033[5m   Blink (slow)
  \033[7m   Reverse/Inverse
  \033[8m   Hidden/Concealed
  \033[9m   Strikethrough

Foreground Colors (Standard):
  \033[30m  Black         \033[90m  Bright Black (Gray)
  \033[31m  Red           \033[91m  Bright Red
  \033[32m  Green         \033[92m  Bright Green
  \033[33m  Yellow        \033[93m  Bright Yellow
  \033[34m  Blue          \033[94m  Bright Blue
  \033[35m  Magenta       \033[95m  Bright Magenta
  \033[36m  Cyan          \033[96m  Bright Cyan
  \033[37m  White         \033[97m  Bright White

Background Colors:
  \033[40m  - \033[47m    Standard backgrounds
  \033[100m - \033[107m   Bright backgrounds
  (Same colors as foreground, just +10 to code)

256-Color Mode:
  Foreground: \033[38;5;<n>m    (n = 0-255)
  Background: \033[48;5;<n>m

  0-7:      Standard colors
  8-15:     Bright colors
  16-231:   216-color cube (6×6×6)
  232-255:  Grayscale (24 shades)

Truecolor (24-bit RGB):
  Foreground: \033[38;2;<r>;<g>;<b>m
  Background: \033[48;2;<r>;<g>;<b>m
  Example: \033[38;2;255;100;0m  → orange text

Cursor Control:
  \033[<n>A   Move cursor up n lines
  \033[<n>B   Move cursor down n lines
  \033[<n>C   Move cursor right n columns
  \033[<n>D   Move cursor left n columns
  \033[2J     Clear entire screen
  \033[K      Clear to end of line
  \033[s      Save cursor position
  \033[u      Restore cursor position
  \033[?25l   Hide cursor
  \033[?25h   Show cursor

Bash Examples:
  echo -e "\033[1;31mError:\033[0m something failed"
  echo -e "\033[32m✓ Success\033[0m"
  printf "\033[33mWarning:\033[0m check config\n"
EOF
}

cmd_logging() {
    cat << 'EOF'
=== Log Levels & Best Practices ===

Standard Log Levels (severity order):

  TRACE (most verbose):
    Extremely detailed flow information
    Example: "Entering function processOrder(), args: {id: 42}"
    Use: development debugging only, NEVER in production
    Performance impact: high

  DEBUG:
    Detailed diagnostic information
    Example: "Cache miss for key: user_42, fetching from DB"
    Use: development, enabled temporarily in production
    Performance impact: moderate

  INFO:
    Notable events in normal operation
    Example: "Server started on port 3000"
    Example: "User alice@example.com logged in"
    Use: production default — show system is working correctly
    Performance impact: low

  WARN:
    Unexpected but recoverable situations
    Example: "Config file not found, using defaults"
    Example: "API rate limit at 80%, throttling soon"
    Use: something needs attention but isn't broken yet
    Performance impact: low

  ERROR:
    Failure in a specific operation (system still running)
    Example: "Failed to send email to user@example.com: timeout"
    Example: "Database query failed: connection refused"
    Use: requires investigation, may need alerting
    Performance impact: none (errors should be rare)

  FATAL / CRITICAL:
    System-wide failure, application cannot continue
    Example: "Cannot connect to database after 10 retries, shutting down"
    Use: triggers alerts, paging, immediate response
    Always followed by process exit

Best Practices:
  1. Log at the RIGHT level (don't ERROR for expected conditions)
  2. Include context: who, what, when, identifiers
  3. Structured logging (JSON) for machine parsing
  4. Don't log sensitive data (passwords, tokens, PII)
  5. Include correlation IDs for request tracing
  6. Use sampling for high-volume logs (1 in 100 requests)
  7. Set log level via environment variable (LOG_LEVEL=info)
  8. Rotate log files (logrotate, max size, max age)
EOF
}

cmd_browser() {
    cat << 'EOF'
=== Browser Console API ===

Basic Output:
  console.log('info');              // General output
  console.info('info');             // Informational (blue icon in Firefox)
  console.warn('warning');          // Yellow warning icon
  console.error('error');           // Red error icon + stack trace
  console.debug('debug');           // Hidden by default in most browsers

String Formatting:
  console.log('Hello %s, you are %d', 'Alice', 30);
  console.log('Object: %o', {a: 1});     // expandable object
  console.log('Styled: %cBold Red', 'color:red;font-weight:bold');

  // Modern: template literals are preferred
  console.log(`User ${name} logged in at ${time}`);

Grouping:
  console.group('API Request');      // collapsible group (open)
  console.groupCollapsed('Details'); // collapsible group (closed)
    console.log('URL:', url);
    console.log('Method:', method);
  console.groupEnd();
  console.groupEnd();

Timing:
  console.time('fetch');
  await fetch(url);
  console.timeEnd('fetch');          // "fetch: 142.5ms"
  console.timeLog('fetch', 'still running...');  // log without ending

Tables:
  console.table([
    { name: 'Alice', age: 30 },
    { name: 'Bob', age: 25 },
  ]);
  // Renders as formatted table in console

Counting:
  console.count('click');   // "click: 1"
  console.count('click');   // "click: 2"
  console.countReset('click');

Assertions:
  console.assert(1 === 2, 'Math is broken');
  // Only outputs if assertion FAILS
  // Does NOT throw — just logs

Stack Traces:
  console.trace('Where am I?');
  // Prints current call stack

Clear:
  console.clear();  // Clear console (with "Console was cleared" msg)

Advanced:
  console.dir(element);         // DOM element as JS object
  console.dirxml(element);      // DOM element as HTML
  copy(object);                 // Copy to clipboard (Chrome)
  monitor(fn);                  // Log every call to fn (Chrome)
  monitorEvents(el, 'click');   // Log events (Chrome)
EOF
}

cmd_node() {
    cat << 'EOF'
=== Node.js Console & Debugging ===

Built-in Console:
  console.log(obj);              // stdout
  console.error(obj);            // stderr
  console.warn(obj);             // stderr
  console.table(data);           // formatted table (stdout)
  console.time/timeEnd(label);   // timing
  console.trace(msg);            // stack trace
  console.dir(obj, {depth: null, colors: true});  // deep inspect

Custom Console:
  const { Console } = require('console');
  const logger = new Console({
    stdout: fs.createWriteStream('out.log'),
    stderr: fs.createWriteStream('err.log'),
  });

util.inspect (Deep Object Display):
  const util = require('util');
  console.log(util.inspect(obj, {
    depth: Infinity,     // how deep to recurse
    colors: true,        // ANSI colors
    showHidden: false,   // show non-enumerable
    maxArrayLength: 100, // truncate arrays
    breakLength: 80,     // wrap width
    compact: false,      // pretty print
  }));

  // Custom inspect:
  class MyClass {
    [util.inspect.custom]() {
      return `MyClass<${this.id}>`;
    }
  }

DEBUG Module (debug npm package):
  const debug = require('debug');
  const log = debug('app:server');
  const dbLog = debug('app:database');

  log('Server started');        // only shows if DEBUG=app:server
  dbLog('Query executed');      // only shows if DEBUG=app:database

  // Enable: DEBUG=app:* node server.js
  // Enable specific: DEBUG=app:server node server.js
  // Disable one: DEBUG=*,-app:database node server.js

Process Signals:
  process.on('uncaughtException', (err) => {
    console.error('Uncaught:', err);
    process.exit(1);
  });
  process.on('unhandledRejection', (reason) => {
    console.error('Unhandled Rejection:', reason);
  });

REPL Debugging:
  node --inspect server.js       // Chrome DevTools debugger
  node --inspect-brk server.js   // Break on first line
  node inspect server.js         // Built-in CLI debugger
  // Open chrome://inspect in Chrome to connect
EOF
}

cmd_cli() {
    cat << 'EOF'
=== CLI Output Patterns ===

Progress Bar:
  Overwrite the same line using carriage return \r

  Bash:
    for i in $(seq 1 100); do
      printf "\r[%-50s] %d%%" $(printf '#%.0s' $(seq 1 $((i/2)))) $i
      sleep 0.05
    done
    echo

  Output: [########################                          ] 48%

Spinner:
  frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  while job_running; do
    for frame in "${frames[@]}"; do
      printf "\r%s Loading..." "$frame"
      sleep 0.1
    done
  done
  printf "\r✓ Done!        \n"

Status Indicators:
  ✓  Success (green)     echo -e "\033[32m✓\033[0m Done"
  ✗  Failure (red)       echo -e "\033[31m✗\033[0m Failed"
  ⚠  Warning (yellow)    echo -e "\033[33m⚠\033[0m Warning"
  ℹ  Info (blue)         echo -e "\033[34mℹ\033[0m Info"
  ●  Bullet              ◆  Diamond
  →  Arrow               ★  Star

Simple Table:
  printf "%-20s %-10s %-10s\n" "NAME" "STATUS" "PORT"
  printf "%-20s %-10s %-10s\n" "web-server" "running" "3000"
  printf "%-20s %-10s %-10s\n" "database" "stopped" "5432"

  Using column:
  echo -e "NAME\tSTATUS\tPORT\nweb\trunning\t3000\ndb\tstopped\t5432" | \
    column -t -s$'\t'

Box Drawing:
  ┌─────────────────────┐
  │  Application v1.0   │
  ├─────────────────────┤
  │  Status: Running    │
  │  Port: 3000         │
  │  Uptime: 42 hours   │
  └─────────────────────┘

  Characters: ┌ ┐ └ ┘ ─ │ ├ ┤ ┬ ┴ ┼

Interactive Prompts:
  read -p "Continue? (y/n) " answer
  select opt in "Option 1" "Option 2" "Quit"; do
    case $opt in
      "Quit") break ;;
      *) echo "Selected: $opt" ;;
    esac
  done

Terminal Width:
  cols=$(tput cols)    # terminal width
  lines=$(tput lines)  # terminal height
  printf '%*s\n' "$cols" '' | tr ' ' '─'   # full-width line
EOF
}

cmd_debug() {
    cat << 'EOF'
=== Debugging Techniques ===

Print Debugging (The Universal Method):
  console.log('HERE 1');
  console.log('value:', variable);
  console.log('type:', typeof variable);
  console.log(JSON.stringify(obj, null, 2));

  Better print debugging:
    - Include file:line → console.log(`[${__filename}:${__LINE__}]`, val);
    - Include timestamp → console.log(new Date().toISOString(), msg);
    - Use labels → console.log('[AUTH]', 'User authenticated:', userId);
    - Pretty print objects → JSON.stringify(obj, null, 2)

Breakpoints:
  Browser: click line number in Sources tab
  Node: debugger; statement in code + --inspect flag
  VS Code: click gutter, F5 to start debugging
  Types:
    Regular: always pause
    Conditional: pause when expression is true
    Logpoint: log without pausing (VS Code)
    Exception: pause on thrown exceptions

Stack Trace Analysis:
  Read bottom-to-top (most recent call at top)
  Look for YOUR code (skip framework/library frames)
  Find the transition: last line of your code before the error

  Error: Cannot read property 'name' of undefined
    at renderUser (app.js:42)           ← error is HERE
    at processUsers (app.js:28)         ← called from here
    at main (app.js:10)                 ← entry point

Conditional Logging:
  const DEBUG = process.env.DEBUG === '1';
  const log = (...args) => DEBUG && console.log(...args);

  // Log only first N occurrences:
  let count = 0;
  if (count++ < 5) console.log('Loop value:', x);

Binary Search Debugging:
  1. Comment out half the code
  2. Does the bug still occur?
  3. Yes → bug is in remaining half
  4. No → bug is in commented half
  5. Repeat until found

Rubber Duck Debugging:
  Explain the code line-by-line to an inanimate object
  The act of explaining often reveals the bug
  Actually works — forces you to think step by step

Common Debug Strategies:
  1. Reproduce reliably first (exact steps)
  2. Simplify (minimal reproduction case)
  3. Check assumptions (print EVERYTHING)
  4. Read the error message carefully (really read it)
  5. Check recent changes (git diff, git log)
  6. Take a break (fresh eyes find bugs faster)
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Console Tools & Libraries ===

Node.js Libraries:

  chalk (Terminal Colors):
    import chalk from 'chalk';
    console.log(chalk.red.bold('Error:'), chalk.gray('file not found'));
    console.log(chalk.hex('#FFA500')('Orange text'));
    console.log(chalk.bgGreen.black(' SUCCESS '));

  winston (Logging Framework):
    const logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json(),
      ),
      transports: [
        new winston.transports.Console(),
        new winston.transports.File({ filename: 'error.log', level: 'error' }),
      ],
    });
    logger.info('Server started', { port: 3000 });

  pino (Fast JSON Logger):
    const pino = require('pino');
    const logger = pino({ level: 'info' });
    logger.info({ port: 3000 }, 'Server started');
    // 5-10x faster than winston (designed for production)
    // Pair with pino-pretty for human-readable dev output

Python Libraries:

  rich (Beautiful Terminal Output):
    from rich.console import Console
    console = Console()
    console.print("[bold red]Error:[/] file not found")
    console.print_json(data)
    from rich.table import Table
    # Creates beautiful formatted tables

  structlog (Structured Logging):
    import structlog
    logger = structlog.get_logger()
    logger.info("user_login", user_id=42, ip="1.2.3.4")
    # Output: {"event": "user_login", "user_id": 42, "ip": "1.2.3.4"}

  loguru (Simple Python Logging):
    from loguru import logger
    logger.info("Processing {item}", item="data")
    # Beautiful default format, rotation, retention, compression

Java:

  SLF4J + Logback:
    Logger logger = LoggerFactory.getLogger(MyClass.class);
    logger.info("User {} logged in from {}", username, ip);
    // Parameterized messages (no string concatenation cost if level off)

  Log4j2:
    Logger logger = LogManager.getLogger();
    logger.error("Database connection failed", exception);
    // Async logging for high-throughput applications
EOF
}

show_help() {
    cat << EOF
console v$VERSION — Console Output & Debugging Reference

Usage: script.sh <command>

Commands:
  intro       Output fundamentals — streams, TTY, principles
  ansi        ANSI escape codes — colors, styles, cursor control
  logging     Log levels and best practices
  browser     Browser console API — log, table, group, time
  node        Node.js console, util.inspect, debug module
  cli         CLI patterns — progress bars, spinners, tables
  debug       Debugging techniques — breakpoints, traces, strategies
  tools       Libraries — chalk, winston, pino, rich, structlog
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)    cmd_intro ;;
    ansi)     cmd_ansi ;;
    logging)  cmd_logging ;;
    browser)  cmd_browser ;;
    node)     cmd_node ;;
    cli)      cmd_cli ;;
    debug)    cmd_debug ;;
    tools)    cmd_tools ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "console v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
