---
name: SysCheck
description: "Check system health with CPU, memory, disk, and process stats. Use when scanning resources, monitoring load, reporting disk usage, alerting thresholds."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["system","monitor","health","cpu","memory","disk","admin","devops","linux"]
categories: ["System Tools", "Developer Tools", "Utility"]
---

# SysCheck

A thorough sysops toolkit for recording, tracking, and analyzing system operations from the command line. Log scans, monitor events, generate reports, set alerts, track benchmarks, and export your data — all stored locally with full history.

## Commands

| Command | Description |
|---------|-------------|
| `syscheck scan [input]` | Record a scan entry, or view recent scan entries if no input given |
| `syscheck monitor [input]` | Record a monitoring event, or view recent monitor entries |
| `syscheck report [input]` | Log a report entry, or view recent reports |
| `syscheck alert [input]` | Log an alert, or view recent alerts |
| `syscheck top [input]` | Record a top-level metric, or view recent top entries |
| `syscheck usage [input]` | Log usage data, or view recent usage entries |
| `syscheck check [input]` | Record a check result, or view recent checks |
| `syscheck fix [input]` | Log a fix action, or view recent fixes |
| `syscheck cleanup [input]` | Record a cleanup operation, or view recent cleanups |
| `syscheck backup [input]` | Log a backup event, or view recent backups |
| `syscheck restore [input]` | Log a restore operation, or view recent restores |
| `syscheck log [input]` | Record a general log entry, or view recent logs |
| `syscheck benchmark [input]` | Log benchmark results, or view recent benchmarks |
| `syscheck compare [input]` | Record a comparison, or view recent comparisons |
| `syscheck stats` | Show summary statistics across all log categories |
| `syscheck export <format>` | Export all data in json, csv, or txt format |
| `syscheck search <term>` | Search across all log files for a term (case-insensitive) |
| `syscheck recent` | Show the 20 most recent history entries |
| `syscheck status` | Health check — show version, data dir, entry count, disk usage, last activity |
| `syscheck help` | Show help with all available commands |
| `syscheck version` | Show current version (v2.0.0) |

Each command works in two modes:
- **With arguments:** Records the input as a timestamped entry in the corresponding `.log` file
- **Without arguments:** Displays the 20 most recent entries from that category

## Data Storage

- **Default location:** `~/.local/share/syscheck/`
- **Per-command logs:** Each command type has its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`)
- **History log:** `history.log` — timestamped record of every command executed
- **Export files:** Generated in `export.json`, `export.csv`, or `export.txt` inside the data directory
- All data is local. No cloud, no network, no third-party services.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `cat`, `basename`
- No external dependencies or API keys required

## When to Use

1. **Daily system operations logging** — Record scans, checks, and fixes as you work through sysadmin tasks, building a timestamped audit trail
2. **Incident tracking** — Use `alert` and `fix` to log issues as they arise and how they were resolved, creating a lightweight incident history
3. **Performance benchmarking** — Log benchmark results over time with `benchmark` and use `compare` to track changes between runs
4. **Backup and restore auditing** — Record every backup and restore operation to maintain a verifiable history of data protection activities
5. **Team handoff documentation** — Export thorough reports in JSON or CSV for sharing with team members or integrating into dashboards

## Examples

```bash
# Record a system scan result
syscheck scan "Full disk scan completed, 3 issues found on /dev/sda1"

# Log a monitoring event
syscheck monitor "CPU load average exceeded 4.0 for 15 minutes"

# Set an alert for a threshold breach
syscheck alert "Memory usage at 92% on production server"

# Record a fix that was applied
syscheck fix "Cleared /tmp directory, freed 12GB disk space"

# Log a backup operation
syscheck backup "Daily backup of /var/data completed, 2.3GB tarball"

# Run a benchmark and log results
syscheck benchmark "Disk I/O: 450MB/s read, 320MB/s write on NVMe"

# View recent activity across all commands
syscheck recent

# Search for all entries mentioning disk
syscheck search disk

# Show aggregate statistics
syscheck stats

# Export everything to JSON for external analysis
syscheck export json

# Export as CSV for spreadsheet import
syscheck export csv

# Quick health check
syscheck status
```

## How It Works

SysCheck uses a simple file-per-category logging system. When you run a command with input, it appends a timestamped line to the corresponding `.log` file (e.g., `syscheck scan "message"` writes to `scan.log`). Without input, it tails the last 20 entries from that file.

The `stats` command aggregates counts across all log files. The `export` command merges all logs into a single file in your chosen format (JSON, CSV, or plain text). The `search` command performs case-insensitive grep across every log file.

All operations are also recorded in `history.log` for full audit trail.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
