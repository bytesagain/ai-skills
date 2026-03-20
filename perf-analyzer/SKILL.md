---
version: "1.0.0"
name: Perf Tools
description: "Profile Linux performance with perf_events and ftrace. Use when scanning CPU hotspots, monitoring syscalls, reporting flame graphs, alerting on spikes."
---

# Perf Analyzer

Sysops toolkit v2.0.0 — scan, monitor, report, and manage system performance from the command line.

## Commands

All commands follow the pattern: `perf-analyzer <command> [input]`

When called without input, each command displays its recent entries. When called with input, it records a new timestamped entry.

| Command        | Description                                      |
|----------------|--------------------------------------------------|
| `scan`         | Record or view scan entries                      |
| `monitor`      | Record or view monitor entries                   |
| `report`       | Record or view report entries                    |
| `alert`        | Record or view alert entries                     |
| `top`          | Record or view top process entries               |
| `usage`        | Record or view usage entries                     |
| `check`        | Record or view check entries                     |
| `fix`          | Record or view fix entries                       |
| `cleanup`      | Record or view cleanup entries                   |
| `backup`       | Record or view backup entries                    |
| `restore`      | Record or view restore entries                   |
| `log`          | Record or view log entries                       |
| `benchmark`    | Record or view benchmark entries                 |
| `compare`      | Record or view compare entries                   |
| `stats`        | Summary statistics across all log files          |
| `export <fmt>` | Export all data (json, csv, or txt)              |
| `search <term>`| Search across all log entries                    |
| `recent`       | Show the 20 most recent activity log entries     |
| `status`       | Health check — version, entry count, disk usage  |
| `help`         | Show help with all available commands            |
| `version`      | Print version string                             |

## How It Works

Each domain command (`scan`, `monitor`, `report`, etc.) works in two modes:

- **Read mode** (no arguments): displays the last 20 entries from its log file
- **Write mode** (with arguments): appends a timestamped `YYYY-MM-DD HH:MM|<input>` line to its log file and logs the action to `history.log`

The built-in utility commands (`stats`, `export`, `search`, `recent`, `status`) aggregate data across all log files for reporting and analysis.

## Data Storage

All data is stored locally in `~/.local/share/perf-analyzer/`:

- Each command writes to its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`)
- `history.log` records all write operations with timestamps
- Export files are saved as `export.json`, `export.csv`, or `export.txt`
- No external network calls — everything stays on disk

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies or package installations needed

## When to Use

1. **Scanning for performance issues** — log CPU hotspots, memory leaks, or I/O bottlenecks with `scan`
2. **Monitoring system health** — track ongoing performance metrics with `monitor` and set up `alert` entries for threshold breaches
3. **Generating performance reports** — use `report` and `benchmark` to record test results and compare runs over time
4. **System maintenance** — log `cleanup`, `backup`, and `restore` operations for audit trails
5. **Troubleshooting and fixing** — record diagnostic findings with `check` and remediation steps with `fix`

## Examples

```bash
# Record a scan result
perf-analyzer scan "CPU usage spike: nginx at 92% for 5 minutes"

# Log a monitoring observation
perf-analyzer monitor "Memory: 6.2GB/8GB, swap: 0, load avg: 2.1"

# Set an alert
perf-analyzer alert "Disk /dev/sda1 at 89% — threshold 85%"

# Record a benchmark
perf-analyzer benchmark "sysbench cpu: 1847 events/sec (baseline: 1820)"

# Compare two runs
perf-analyzer compare "v1.2 vs v1.3: 12% latency improvement at p99"

# Log a backup operation
perf-analyzer backup "Full backup completed: 4.2GB → /mnt/backups/2026-03-18.tar.gz"

# Export everything to JSON
perf-analyzer export json

# Search for entries about CPU
perf-analyzer search cpu

# Check system health
perf-analyzer status
```

## Output

All commands return results to stdout. Redirect to a file if needed:

```bash
perf-analyzer stats > perf-summary.txt
perf-analyzer export csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
