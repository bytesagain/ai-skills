---
name: debug
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [debug, error, trace, log, crash, stacktrace]
description: "Debug errors and performance. Use when tracing log errors, parsing stack traces, detecting memory leaks, or profiling commands."
---

# Debug

Error tracing, log analysis, memory leak detection, HTTP debugging, and command profiling — all from the command line. Analyze log files for error patterns, parse stack traces from Python/Java/Go/JS crash dumps, monitor process memory for leaks, benchmark command execution, compare log files side-by-side, and debug HTTP endpoints with timing and SSL inspection.

## Commands

### `trace` — Find error patterns in log files

Scans a log file for error-level patterns (`ERROR`, `FATAL`, `Exception`, `Traceback`, `WARN`, `OOM`, `Segfault`, `panic`, `SIGKILL`, `SIGSEGV`). Shows match count, error breakdown by type, last 20 matching lines, and top 10 unique error patterns (with timestamps and addresses normalized for dedup).

```bash
bash scripts/script.sh trace /var/log/app.log
bash scripts/script.sh trace --pattern "OOM\|Segfault\|FATAL" /var/log/syslog
bash scripts/script.sh trace --last 1h /var/log/app.log
bash scripts/script.sh trace --last 2d --pattern "Exception" application.log
```

**Options:**
- `--pattern REGEX` — Custom grep pattern (default: common error keywords)
- `--last 1h|30m|2d` — Filter to entries within the last N hours/minutes/days

**Output:** Error breakdown table, last 20 matches, unique pattern summary. Exit code 1 if errors found, 0 if clean.

### `stacktrace` — Parse and summarize stack traces

Auto-detects language (Python, Java, JavaScript, Go, C/C++), extracts the error message, and shows the call chain with file/line references. Accepts a file path or stdin (`-`).

```bash
bash scripts/script.sh stacktrace crash.log
cat traceback.txt | bash scripts/script.sh stacktrace -
```

**Supported languages:** Python (Traceback), Java (at ...java:N), JavaScript/TypeScript (at ...js:N), Go (goroutine), C/C++ (thread #N).

**Output:** Language detection, error message, call chain (with file + line), stack depth.

### `leaks` — Monitor process memory for leaks

Samples a running process's RSS and VSZ at regular intervals, then calculates total growth. Flags possible leaks (>20% growth) or moderate growth (>5%).

```bash
bash scripts/script.sh leaks --pid 1234
bash scripts/script.sh leaks --pid 1234 --duration 60 --interval 5
bash scripts/script.sh leaks 5678
```

**Options:**
- `--pid PID` — Process ID to monitor (required)
- `--duration N` — Total monitoring time in seconds (default: 30)
- `--interval N` — Sampling interval in seconds (default: 5)

**Output:** Time-series table (RSS, VSZ, delta), summary with start/end RSS and growth percentage.

### `profile` — Measure command execution time

Runs a command one or more times, measures wall-clock time per run (nanosecond precision), and reports min/avg/max with a speed verdict.

```bash
bash scripts/script.sh profile "python3 slow_script.py"
bash scripts/script.sh profile --repeat 5 "curl -s https://api.example.com"
bash scripts/script.sh profile --repeat 10 "make build"
```

**Options:**
- `--repeat N` — Number of runs (default: 1)

**Output:** Per-run timing, summary (avg/min/max/total), speed classification (FAST <1s, MODERATE 1-5s, SLOW >5s).

### `diff-logs` — Compare two log files

Shows line count differences, new lines in the second file, and removed lines from the first. With `--errors-only`, focuses exclusively on error-level entries.

```bash
bash scripts/script.sh diff-logs before.log after.log
bash scripts/script.sh diff-logs --errors-only old.log new.log
```

**Options:**
- `--errors-only` — Compare only error/warning lines (ERROR, FATAL, Exception, Traceback, WARN)

**Output:** Line count comparison, new/removed entries (up to 30/20 lines shown).

### `http` — Debug HTTP requests

Makes a request to a URL and reports status code, redirect chain, and optionally response headers, timing breakdown (DNS, connect, TLS, first byte, total), and SSL certificate expiry.

```bash
bash scripts/script.sh http https://example.com
bash scripts/script.sh http --verbose --timing https://api.example.com/health
bash scripts/script.sh http --timing https://cdn.example.com/asset.js
```

**Options:**
- `--verbose` — Show response headers
- `--timing` — Show detailed timing breakdown (DNS, connect, TLS, first byte, total, size)

**Output:** HTTP status, SSL info (for HTTPS), redirect chain, optional headers and timing. Exit code 1 if status ≥ 400.

### `help` — Show usage summary

```bash
bash scripts/script.sh help
```

## Data Storage

This tool does not persist data. All output goes to stdout/stderr. Exit codes indicate success (0) or errors found (1).

## Requirements

- **bash 4+**
- **curl** (for `http` command)
- **openssl** (for SSL certificate inspection in `http`)
- **ps** (for `leaks` command — monitors `/proc` via `ps -p`)
- **grep, sed, sort, uniq, diff, wc** (standard coreutils)
- **date** with GNU or BSD extensions (for `--last` time filtering in `trace`)
- No external dependencies — uses only standard Unix tools

## When to Use

1. **Production incident triage** — Run `trace` on application logs to quickly identify error patterns and frequency during an outage
2. **Crash dump analysis** — Pipe a stack trace through `stacktrace` to auto-detect the language and extract the root cause call chain
3. **Memory leak investigation** — Use `leaks` to monitor a suspect process over time and quantify RSS growth percentage
4. **Performance benchmarking** — Profile build commands or API endpoints with `profile --repeat` to get statistically meaningful timing data
5. **Deployment verification** — Compare pre- and post-deploy logs with `diff-logs --errors-only` to catch newly introduced errors

## Examples

```bash
# Trace errors in the last hour of an application log
bash scripts/script.sh trace --last 1h /var/log/myapp/error.log

# Parse a Python crash dump from clipboard
pbpaste | bash scripts/script.sh stacktrace -

# Monitor a Node.js process for memory leaks over 2 minutes
bash scripts/script.sh leaks --pid $(pgrep -f "node server.js") --duration 120 --interval 10

# Benchmark an API endpoint 10 times
bash scripts/script.sh profile --repeat 10 "curl -s https://api.myservice.com/health"

# Debug an HTTPS endpoint with full timing and headers
bash scripts/script.sh http --verbose --timing https://api.myservice.com/v2/status
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
