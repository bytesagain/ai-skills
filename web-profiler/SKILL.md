---
version: "1.0.0"
name: Web Profiler Bundle
description: "Provides a development tool that gives detailed information about the execution of any request web profiler bundle, twig, component, dev, php, symfony."
---

# Web Profiler

A utility toolkit for profiling, checking, and analyzing web request execution. Log profiling runs, analyze performance data, generate reports, and export results — all from the command line.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from their log.

| Command | Description |
|---------|-------------|
| `web-profiler run <input>` | Run a profiling task and log the result |
| `web-profiler check <input>` | Check a configuration, endpoint, or dependency |
| `web-profiler convert <input>` | Convert profiling data between formats |
| `web-profiler analyze <input>` | Analyze request timing, memory, or query data |
| `web-profiler generate <input>` | Generate profiling configurations or templates |
| `web-profiler preview <input>` | Preview profiling output before committing |
| `web-profiler batch <input>` | Batch process multiple profiling tasks |
| `web-profiler compare <input>` | Compare two profiling results side by side |
| `web-profiler export <input>` | Log an export operation |
| `web-profiler config <input>` | Log or update configuration entries |
| `web-profiler status <input>` | Log a status check result |
| `web-profiler report <input>` | Generate or log a report entry |
| `web-profiler stats` | Show summary statistics across all log files |
| `web-profiler export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `web-profiler search <term>` | Search across all log entries for a keyword |
| `web-profiler recent` | Show the 20 most recent activity entries |
| `web-profiler help` | Show all available commands |
| `web-profiler version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/web-profiler/`. Each command maintains its own `.log` file with timestamped entries in `YYYY-MM-DD HH:MM|value` format. A unified `history.log` tracks all operations across commands.

**Export formats supported:**
- **JSON** — Array of objects with `type`, `time`, and `value` fields
- **CSV** — Standard comma-separated with `type,time,value` header
- **TXT** — Human-readable grouped by command type

## Requirements

- Bash 4.0+ with `set -euo pipefail` (strict mode)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies — runs on any POSIX-compliant system

## When to Use

1. **Profiling web request performance** — Log and review timing, memory, and query data for HTTP requests
2. **Debugging slow routes** — Use `analyze` and `compare` to record performance investigations
3. **Tracking profiling history** — Keep a timestamped log of all profiling runs for trend analysis
4. **Generating performance reports** — Export accumulated profiling data to JSON/CSV for dashboards
5. **Batch profiling operations** — Profile multiple endpoints in one session and review results later

## Examples

```bash
# Run a profiling task
web-profiler run "GET /api/users — 342ms, 12MB memory"

# Analyze query performance
web-profiler analyze "SELECT * FROM orders — 89ms, 1.2k rows"

# Compare two profiling runs
web-profiler compare "v2.1 vs v2.2: 15% latency reduction"

# Search for previous profiling entries
web-profiler search "memory"

# Export all profiling data to CSV
web-profiler export csv

# View summary statistics
web-profiler stats
```

## How It Works

Web Profiler stores all data locally in `~/.local/share/web-profiler/`. Each command creates a dedicated log file (e.g., `run.log`, `analyze.log`, `report.log`). Every entry is timestamped and appended, providing a full audit trail. The `history.log` file aggregates activity across all commands for unified tracking.

When called without arguments, each command displays its most recent 20 entries, making it easy to review past profiling work without manually inspecting log files.

## Output

All output goes to stdout. Redirect to a file with:

```bash
web-profiler stats > report.txt
web-profiler export json  # writes to ~/.local/share/web-profiler/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
