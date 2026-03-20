---
name: Perf Tools
description: "Trace Linux system performance bottlenecks in real time. Use when scanning disk I/O, monitoring latency, reporting CPU usage, alerting on memory leaks."
version: "1.0.0"
license: GPL-2.0
runtime: python3
---

# Perf Tools

Sysops toolkit v2.0.0 — scan, monitor, report, and manage system performance from the command line.

## Commands

All commands follow the pattern: `perf-tools <command> [input]`

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

All data is stored locally in `~/.local/share/perf-tools/`:

- Each command writes to its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`)
- `history.log` records all write operations with timestamps
- Export files are saved as `export.json`, `export.csv`, or `export.txt`
- No external network calls — everything stays on disk

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies or package installations needed

## When to Use

1. **Scanning for bottlenecks** — log disk I/O issues, CPU hotspots, or latency spikes with `scan`
2. **Real-time monitoring** — track system metrics with `monitor` and record `alert` entries when thresholds are breached
3. **Performance reporting** — use `report` and `benchmark` to capture test results and `compare` runs side by side
4. **Operational maintenance** — log `cleanup`, `backup`, and `restore` activities for compliance and audit trails
5. **Troubleshooting workflows** — record diagnostic checks with `check` and remediation actions with `fix`

## Examples

```bash
# Record a performance scan
perf-tools scan "Disk I/O latency: 15ms avg on /dev/nvme0n1 (normal: 2ms)"

# Monitor system metrics
perf-tools monitor "Load avg: 4.2 3.8 3.1, CPU temp: 72°C"

# Log an alert
perf-tools alert "Memory leak detected: process java-app growing 50MB/hour"

# Record a benchmark result
perf-tools benchmark "fio randread: 45K IOPS, 180MB/s throughput"

# Compare before and after
perf-tools compare "Pre-tune: 12ms p99 latency → Post-tune: 4ms p99 latency"

# Log a cleanup operation
perf-tools cleanup "Removed 3.8GB of old core dumps from /var/crash"

# Export all data to CSV
perf-tools export csv

# Search for memory-related entries
perf-tools search memory

# View recent activity
perf-tools recent

# Check overall status
perf-tools status
```

## Output

All commands return results to stdout. Redirect to a file if needed:

```bash
perf-tools stats > perf-summary.txt
perf-tools export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
