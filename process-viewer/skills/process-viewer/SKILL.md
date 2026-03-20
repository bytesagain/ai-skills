---
version: "1.0.0"
name: Systeminformer
description: "A free, powerful, multi-purpose tool that helps you monitor system resources, debug software and det process-viewer, c, administrator, benchmarking."
---

# Process Viewer

A sysops toolkit for scanning, monitoring, and managing system processes. Record observations, track alerts, run benchmarks, and generate reports — all from the command line with persistent local storage.

## Quick Start

```bash
bash scripts/script.sh <command> [args...]
```

## Commands

**Core Operations**
- `scan <input>` — Record a process scan entry (without args: show recent scans)
- `monitor <input>` — Log a monitoring observation (without args: show recent entries)
- `report <input>` — Create a report entry (without args: show recent reports)
- `alert <input>` — Log an alert or warning (without args: show recent alerts)
- `top <input>` — Record top-process data (without args: show recent entries)
- `usage <input>` — Track resource usage (without args: show recent entries)
- `check <input>` — Run or log a health check (without args: show recent checks)
- `fix <input>` — Document a fix applied (without args: show recent fixes)

**Maintenance**
- `cleanup <input>` — Record a cleanup action (without args: show recent cleanups)
- `backup <input>` — Log a backup operation (without args: show recent backups)
- `restore <input>` — Log a restore operation (without args: show recent restores)
- `log <input>` — Add a general log entry (without args: show recent logs)

**Analysis**
- `benchmark <input>` — Record benchmark results (without args: show recent benchmarks)
- `compare <input>` — Log comparison data (without args: show recent comparisons)

**Utilities**
- `stats` — Show summary statistics across all entry types
- `export <fmt>` — Export all data (formats: `json`, `csv`, `txt`)
- `search <term>` — Search across all log files for a keyword
- `recent` — Show the 20 most recent activity log entries
- `status` — Display health check: version, data dir, entry count, disk usage
- `help` — Show available commands
- `version` — Print version (v2.0.0)

Each command accepts free-text input. When called without arguments, it displays the most recent 20 entries for that category.

## Data Storage

All data is stored as plain-text log files in:

```
~/.local/share/process-viewer/
├── scan.log          # Process scan entries
├── monitor.log       # Monitoring observations
├── report.log        # Reports
├── alert.log         # Alerts and warnings
├── top.log           # Top-process snapshots
├── usage.log         # Resource usage records
├── check.log         # Health check records
├── fix.log           # Applied fixes
├── cleanup.log       # Cleanup actions
├── backup.log        # Backup operations
├── restore.log       # Restore operations
├── log.log           # General log entries
├── benchmark.log     # Benchmark results
├── compare.log       # Comparison data
└── history.log       # Unified activity history
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` — one line per record. The `history.log` file tracks all commands chronologically.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies, no network access required
- Write access to `~/.local/share/process-viewer/`

## When to Use

1. **Tracking system processes over time** — Use `scan` and `monitor` to build a log of process observations for later review or trend analysis
2. **Incident response documentation** — Use `alert` to log warnings, `fix` to document remediation steps, and `report` to create post-incident summaries
3. **Performance benchmarking** — Use `benchmark` and `compare` to record and contrast performance measurements across different configurations or time periods
4. **Backup and recovery auditing** — Use `backup` and `restore` to maintain an audit trail of data protection operations
5. **Periodic system health reviews** — Use `status` for a quick health check, `stats` for an overview, and `export json` to archive data for external analysis

## Examples

```bash
# Scan and record a process observation
process-viewer scan "nginx worker count: 4, memory 128MB"

# Log a monitoring alert
process-viewer alert "CPU usage exceeded 90% on web-server-03"

# Document a fix
process-viewer fix "Restarted memcached after OOM kill"

# Run a benchmark and record it
process-viewer benchmark "Disk I/O test: 450MB/s sequential read"

# View summary statistics across all categories
process-viewer stats

# Export everything to JSON for external processing
process-viewer export json

# Search all logs for a specific term
process-viewer search "nginx"

# Check system status
process-viewer status
```

## Configuration

Set `PROCESS_VIEWER_DIR` environment variable to override the default data directory. Default: `~/.local/share/process-viewer/`

## Output

All commands output to stdout. Redirect to a file with `process-viewer <command> > output.txt`. Export formats (json, csv, txt) write to the data directory and report the output path and file size.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
