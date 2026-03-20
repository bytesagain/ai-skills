---
version: "1.0.0"
name: The Book Of Secret Knowledge
description: "A collection of inspiring lists, manuals, cheatsheets, blogs, hacks, one-liners, cli/web tools and m the book of secret knowledge, python, awesome."
---

# Sysadmin Handbook

Sysadmin Handbook v2.0.0 — a thorough sysops toolkit for system administrators. Record, track, and manage all aspects of system administration from the command line. Every action is timestamped and logged locally for full auditability.

## Why Sysadmin Handbook?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Timestamped logging for every operation
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity tracking
- Searchable records across all operation types

## Getting Started

```bash
# See all available commands
sysadmin-handbook help

# Check current health status
sysadmin-handbook status

# View summary statistics
sysadmin-handbook stats
```

## Commands

### Operations Commands

Each command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `sysadmin-handbook scan <input>` | Record a scan operation (port scans, vulnerability scans, network sweeps) |
| `sysadmin-handbook monitor <input>` | Log monitoring observations (service health, uptime checks, resource usage) |
| `sysadmin-handbook report <input>` | Create report entries (incident reports, audit summaries, status updates) |
| `sysadmin-handbook alert <input>` | Record alert events (threshold breaches, security warnings, service failures) |
| `sysadmin-handbook top <input>` | Log top-level metrics (CPU hogs, memory consumers, disk leaders) |
| `sysadmin-handbook usage <input>` | Track usage data (disk usage, bandwidth, API calls, license counts) |
| `sysadmin-handbook check <input>` | Record health checks (service checks, config validation, dependency tests) |
| `sysadmin-handbook fix <input>` | Document fixes applied (patches, config changes, workarounds) |
| `sysadmin-handbook cleanup <input>` | Log cleanup operations (temp files, old logs, orphaned processes) |
| `sysadmin-handbook backup <input>` | Track backup operations (full backups, incrementals, snapshots) |
| `sysadmin-handbook restore <input>` | Record restore operations (data recovery, config rollbacks) |
| `sysadmin-handbook log <input>` | General-purpose log entries (freeform notes, observations) |
| `sysadmin-handbook benchmark <input>` | Record benchmark results (performance tests, load tests, I/O benchmarks) |
| `sysadmin-handbook compare <input>` | Log comparison data (before/after, environment diffs, config comparisons) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `sysadmin-handbook stats` | Show summary statistics across all log categories |
| `sysadmin-handbook export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `sysadmin-handbook search <term>` | Search across all entries for a keyword |
| `sysadmin-handbook recent` | Show the 20 most recent history entries |
| `sysadmin-handbook status` | Health check — version, data dir, entry count, disk usage |
| `sysadmin-handbook help` | Show the built-in help message |
| `sysadmin-handbook version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/sysadmin-handbook/`. Structure:

- **`scan.log`**, **`monitor.log`**, **`report.log`**, etc. — one log file per command, pipe-delimited (`timestamp|value`)
- **`history.log`** — unified activity log across all commands
- **`export.json`** / **`export.csv`** / **`export.txt`** — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<input>`. Use `export` to back up your data anytime.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies or internet access needed

## When to Use

1. **Incident response tracking** — Log scan results, alerts, and fixes during an active incident so you have a complete timeline for the post-mortem
2. **Daily ops journaling** — Record monitoring observations, health checks, and cleanup tasks as you go through your sysadmin routine
3. **Backup & restore auditing** — Track every backup and restore operation with timestamps to prove compliance or diagnose failures
4. **Performance benchmarking** — Store benchmark results over time and use `compare` to track regressions or improvements across deploys
5. **Team handoff documentation** — Log everything during your shift so the next admin can run `recent` or `search` to get up to speed instantly

## Examples

```bash
# Record a network scan result
sysadmin-handbook scan "192.168.1.0/24 — 14 hosts up, 3 with open SSH"

# Log a monitoring observation
sysadmin-handbook monitor "web-prod-01 CPU at 92% for 15 minutes"

# Document a fix you applied
sysadmin-handbook fix "Increased nginx worker_connections from 1024 to 4096"

# Track a backup operation
sysadmin-handbook backup "Full backup of /data completed — 48GB, 23 min"

# Export everything to JSON for archival
sysadmin-handbook export json

# Search all logs for a keyword
sysadmin-handbook search "nginx"

# View recent activity across all commands
sysadmin-handbook recent
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
sysadmin-handbook stats > report.txt
sysadmin-handbook export csv
```

## Configuration

Set `SYSADMIN_HANDBOOK_DIR` environment variable to override the default data directory (`~/.local/share/sysadmin-handbook/`).

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
