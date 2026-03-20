---
version: "1.0.0"
name: Fastfetch
description: "A maintained, feature-rich and performance oriented, neofetch like system information tool. sysinfo-fetch, c, bsdfetch, command-line, sysinfo-fetch, fetch."
---

# Sysinfo Fetch

Sysinfo Fetch v2.0.0 — a sysops toolkit for collecting, recording, and tracking system information from the command line. Log observations about your systems, track changes over time, and export everything for reporting.

## Why Sysinfo Fetch?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Timestamped logging for every operation
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity tracking
- Searchable records across all categories

## Getting Started

```bash
# See all available commands
sysinfo-fetch help

# Check current health status
sysinfo-fetch status

# View summary statistics
sysinfo-fetch stats
```

## Commands

### Operations Commands

Each command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `sysinfo-fetch scan <input>` | Record scan results (hardware scans, device detection, inventory sweeps) |
| `sysinfo-fetch monitor <input>` | Log monitoring data (resource utilization, temperature readings, service states) |
| `sysinfo-fetch report <input>` | Create report entries (system summaries, audit findings, health reports) |
| `sysinfo-fetch alert <input>` | Record alert events (threshold warnings, hardware failures, capacity alerts) |
| `sysinfo-fetch top <input>` | Log top-level metrics (CPU consumers, memory hogs, I/O leaders) |
| `sysinfo-fetch usage <input>` | Track usage data (disk space, memory allocation, swap usage, network bandwidth) |
| `sysinfo-fetch check <input>` | Record health checks (service validation, config verification, dependency tests) |
| `sysinfo-fetch fix <input>` | Document fixes applied (driver updates, kernel patches, config tweaks) |
| `sysinfo-fetch cleanup <input>` | Log cleanup operations (cache clearing, log rotation, orphan removal) |
| `sysinfo-fetch backup <input>` | Track backup operations (config backups, system snapshots) |
| `sysinfo-fetch restore <input>` | Record restore operations (config restores, rollbacks) |
| `sysinfo-fetch log <input>` | General-purpose log entries (freeform notes, observations) |
| `sysinfo-fetch benchmark <input>` | Record benchmark results (disk I/O, network throughput, CPU scores) |
| `sysinfo-fetch compare <input>` | Log comparison data (before/after upgrades, cross-host diffs) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `sysinfo-fetch stats` | Show summary statistics across all log categories |
| `sysinfo-fetch export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `sysinfo-fetch search <term>` | Search across all entries for a keyword |
| `sysinfo-fetch recent` | Show the 20 most recent history entries |
| `sysinfo-fetch status` | Health check — version, data dir, entry count, disk usage |
| `sysinfo-fetch help` | Show the built-in help message |
| `sysinfo-fetch version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/sysinfo-fetch/`. Structure:

- **`scan.log`**, **`monitor.log`**, **`report.log`**, etc. — one log file per command, pipe-delimited (`timestamp|value`)
- **`history.log`** — unified activity log across all commands
- **`export.json`** / **`export.csv`** / **`export.txt`** — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<input>`. Use `export` to back up your data anytime.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies or internet access needed

## When to Use

1. **System inventory tracking** — Scan and record hardware details across your fleet so you always know what's running where
2. **Performance monitoring journal** — Log CPU, memory, and disk observations over time to spot trends before they become incidents
3. **Upgrade documentation** — Use `compare` and `benchmark` to record before/after data when upgrading kernels, drivers, or hardware
4. **Capacity planning** — Track `usage` entries over weeks to forecast when you'll need more disk, RAM, or bandwidth
5. **Troubleshooting log** — During an outage, record checks, fixes, and observations in one place so you have a complete story later

## Examples

```bash
# Record a system scan result
sysinfo-fetch scan "web-prod-03: 32GB RAM, 8 cores, Ubuntu 22.04, uptime 142 days"

# Log a monitoring observation
sysinfo-fetch monitor "Disk /dev/sda1 at 87% — growing 2%/week"

# Document a fix
sysinfo-fetch fix "Updated kernel from 5.15.0-91 to 5.15.0-97 on db-replica-02"

# Record a benchmark result
sysinfo-fetch benchmark "fio random read: 45k IOPS on nvme0n1 after firmware update"

# Export everything to CSV
sysinfo-fetch export csv

# Search all logs for a host
sysinfo-fetch search "web-prod-03"
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
sysinfo-fetch stats > report.txt
sysinfo-fetch export json
```

## Configuration

Set `SYSINFO_FETCH_DIR` environment variable to override the default data directory (`~/.local/share/sysinfo-fetch/`).

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
