---
name: Web Profiler Bundle
description: "Profile HTTP requests with timing, memory, and query breakdowns. Use when debugging slow routes, analyzing queries, inspecting middleware, or optimizing."
version: "1.0.0"
license: MIT
runtime: python3
---

# Web Profiler Bundle

A thorough utility toolkit for profiling HTTP request execution. Track runs, analyze performance, generate reports, compare results, and export data — all from the command line with local storage.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from their log.

| Command | Description |
|---------|-------------|
| `web-profiler-bundle run <input>` | Run a profiling task and log the result |
| `web-profiler-bundle check <input>` | Check an endpoint, middleware, or configuration |
| `web-profiler-bundle convert <input>` | Convert profiling data between formats |
| `web-profiler-bundle analyze <input>` | Analyze request timing, memory usage, or query breakdowns |
| `web-profiler-bundle generate <input>` | Generate profiling configs, reports, or templates |
| `web-profiler-bundle preview <input>` | Preview profiling output before committing |
| `web-profiler-bundle batch <input>` | Batch process multiple profiling operations |
| `web-profiler-bundle compare <input>` | Compare two profiling results side by side |
| `web-profiler-bundle export <input>` | Log an export operation |
| `web-profiler-bundle config <input>` | Log or update configuration entries |
| `web-profiler-bundle status <input>` | Log a status check result |
| `web-profiler-bundle report <input>` | Generate or log a report entry |
| `web-profiler-bundle stats` | Show summary statistics across all log files |
| `web-profiler-bundle export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `web-profiler-bundle search <term>` | Search across all log entries for a keyword |
| `web-profiler-bundle recent` | Show the 20 most recent activity entries |
| `web-profiler-bundle help` | Show all available commands |
| `web-profiler-bundle version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/web-profiler-bundle/`. Each command maintains its own `.log` file with timestamped entries in `YYYY-MM-DD HH:MM|value` format. A unified `history.log` tracks all operations across commands.

**Export formats supported:**
- **JSON** — Array of objects with `type`, `time`, and `value` fields
- **CSV** — Standard comma-separated with `type,time,value` header
- **TXT** — Human-readable grouped by command type

## Requirements

- Bash 4.0+ with `set -euo pipefail` (strict mode)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies — runs on any POSIX-compliant system

## When to Use

1. **Debugging slow HTTP routes** — Log profiling runs with timing data and review trends over time
2. **Analyzing query performance** — Record database query breakdowns and compare before/after optimization
3. **Inspecting middleware execution** — Track middleware timing and memory consumption per request
4. **Generating performance reports** — Export accumulated profiling data to JSON/CSV for dashboards or CI pipelines
5. **Batch profiling multiple endpoints** — Profile a set of routes in one session and review aggregated statistics

## Examples

```bash
# Profile a specific route
web-profiler-bundle run "POST /api/orders — 580ms, 24MB, 47 queries"

# Analyze query breakdown
web-profiler-bundle analyze "N+1 detected: users.orders — 34 queries, 210ms total"

# Compare before and after optimization
web-profiler-bundle compare "cache warm: 120ms vs cold: 890ms"

# Check middleware stack
web-profiler-bundle check "auth middleware — 12ms overhead"

# Export all profiling data to JSON
web-profiler-bundle export json

# Search for memory-related entries
web-profiler-bundle search "memory"

# View summary statistics
web-profiler-bundle stats
```

## How It Works

Web Profiler Bundle stores all data locally in `~/.local/share/web-profiler-bundle/`. Each command creates a dedicated log file (e.g., `run.log`, `analyze.log`, `report.log`). Every entry is timestamped and appended, providing a full audit trail of all profiling activity. The `history.log` file aggregates operations across all commands for unified tracking.

When called without arguments, each command displays its most recent 20 entries, making it easy to review past profiling work without manually inspecting log files.

## Output

All output goes to stdout. Redirect to a file with:

```bash
web-profiler-bundle stats > report.txt
web-profiler-bundle export json  # writes to ~/.local/share/web-profiler-bundle/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
