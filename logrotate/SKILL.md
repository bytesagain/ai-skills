---
name: LogRotate
description: "Rotate, compress, and clean old log files to keep directories tidy automatically. Use when rotating logs, compressing old files, freeing disk space."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["log","rotate","cleanup","archive","compress","admin","sysadmin","devops"]
categories: ["System Tools", "Developer Tools"]
---
# LogRotate

A sysops toolkit for scanning, monitoring, reporting, alerting, and managing system operations. Each command logs timestamped entries to local files with full export, search, and statistics support.

## Commands

### Core SysOps Operations

| Command | Description |
|---------|-------------|
| `logrotate scan <input>` | Record a scan result (or view recent scans with no args) |
| `logrotate monitor <input>` | Log a monitoring observation or metric |
| `logrotate report <input>` | Record a report entry or summary |
| `logrotate alert <input>` | Log an alert event or threshold breach |
| `logrotate top <input>` | Record top resource consumers or rankings |
| `logrotate usage <input>` | Log resource usage data (disk, CPU, memory, etc.) |
| `logrotate check <input>` | Record a health check or validation result |
| `logrotate fix <input>` | Log a fix or remediation action taken |
| `logrotate cleanup <input>` | Record a cleanup operation (old files, temp dirs, etc.) |
| `logrotate backup <input>` | Log a backup task and its outcome |
| `logrotate restore <input>` | Record a restore operation |
| `logrotate log <input>` | Log a generic operational entry |
| `logrotate benchmark <input>` | Record a performance benchmark result |
| `logrotate compare <input>` | Log a comparison between configurations or time periods |

### Utility Commands

| Command | Description |
|---------|-------------|
| `logrotate stats` | Show summary statistics across all log files |
| `logrotate export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `logrotate search <term>` | Search all entries for a keyword (case-insensitive) |
| `logrotate recent` | Show the 20 most recent activity log entries |
| `logrotate status` | Health check: version, entry count, disk usage, last activity |
| `logrotate help` | Display full command reference |
| `logrotate version` | Print current version (v2.0.0) |

## How It Works

Every core command accepts free-text input. When called with arguments, LogRotate:

1. Timestamps the entry (`YYYY-MM-DD HH:MM`)
2. Appends it to the command-specific log file (e.g. `scan.log`, `alert.log`)
3. Records the action in a central `history.log`
4. Reports the saved entry and running total

When called with **no arguments**, each command displays the 20 most recent entries from its log file.

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/logrotate/
├── scan.log          # Scan results
├── monitor.log       # Monitoring observations
├── report.log        # Report entries
├── alert.log         # Alert events
├── top.log           # Top resource consumers
├── usage.log         # Resource usage data
├── check.log         # Health check results
├── fix.log           # Fix/remediation actions
├── cleanup.log       # Cleanup operations
├── backup.log        # Backup tasks
├── restore.log       # Restore operations
├── log.log           # Generic operational entries
├── benchmark.log     # Performance benchmarks
├── compare.log       # Configuration comparisons
├── history.log       # Central activity log
└── export.{json,csv,txt}  # Exported snapshots
```

Each log uses pipe-delimited format: `timestamp|value`.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `wc`, `du`, `grep`, `tail`, `date`, `sed`
- No external dependencies — pure bash

## When to Use

1. **Daily system health monitoring** — run `scan`, `check`, and `monitor` to record server state, then review with `recent` and `stats`
2. **Tracking backup and restore operations** — log every `backup` and `restore` with timestamps for disaster recovery audits
3. **Disk cleanup and maintenance** — use `cleanup` and `usage` to record what was cleaned, how much space was freed, and current disk consumption
4. **Incident response documentation** — log `alert` events when thresholds are breached, then record `fix` actions taken to resolve them
5. **Performance benchmarking over time** — use `benchmark` and `compare` to track system performance across deployments, upgrades, or configuration changes

## Examples

```bash
# Record a system scan
logrotate scan "full disk scan: /var/log 2.3GB, /tmp 450MB, 12 files older than 90 days"

# Log a monitoring metric
logrotate monitor "CPU avg 78% over last 6h, memory 62%, swap 0%"

# Record an alert
logrotate alert "disk usage on /var exceeded 90% threshold at 14:32"

# Log a cleanup action
logrotate cleanup "removed 847 files from /tmp older than 30 days, freed 1.2GB"

# Record a backup
logrotate backup "daily backup completed: /data → s3://backups/2024-03-18.tar.gz (4.7GB)"

# Log a fix after an incident
logrotate fix "rotated nginx access.log manually, restarted logrotate cron, verified rotation"

# Search for disk-related entries
logrotate search "disk"

# Export all records to CSV
logrotate export csv

# View overall health
logrotate status
```

## Configuration

Set the `DATA_DIR` variable in the script or modify the default path to change storage location. Default: `~/.local/share/logrotate/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
