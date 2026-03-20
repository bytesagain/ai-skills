---
name: CronJob
description: "Manage cron jobs with execution logging and failure alert tracking. Use when adding tasks, monitoring execution, debugging failed crons."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["cron","job","scheduler","automation","admin","linux"]
categories: ["Developer Tools", "Utility"]
---
# CronJob

A thorough sysops toolkit for scanning, monitoring, reporting, and maintaining scheduled job operations. CronJob provides 18+ commands for tracking job events, performing health checks, managing backups, benchmarking performance, and exporting operational data in multiple formats.

## Commands

| Command | Description |
|---------|-------------|
| `cronjob scan <input>` | Record a scan entry — run without args to view recent scan entries |
| `cronjob monitor <input>` | Record a monitoring observation — run without args to view recent entries |
| `cronjob report <input>` | Log a report entry — run without args to view recent reports |
| `cronjob alert <input>` | Record an alert — run without args to view recent alerts |
| `cronjob top <input>` | Log a top-level event — run without args to view recent entries |
| `cronjob usage <input>` | Track usage data — run without args to view recent usage entries |
| `cronjob check <input>` | Record a check result — run without args to view recent checks |
| `cronjob fix <input>` | Log a fix action — run without args to view recent fixes |
| `cronjob cleanup <input>` | Record a cleanup operation — run without args to view recent cleanups |
| `cronjob backup <input>` | Log a backup event — run without args to view recent backups |
| `cronjob restore <input>` | Record a restore operation — run without args to view recent restores |
| `cronjob log <input>` | Add a general log entry — run without args to view recent log entries |
| `cronjob benchmark <input>` | Record a benchmark result — run without args to view recent benchmarks |
| `cronjob compare <input>` | Log a comparison — run without args to view recent comparisons |
| `cronjob stats` | Display summary statistics across all log categories |
| `cronjob export <fmt>` | Export all data to a file (formats: `json`, `csv`, `txt`) |
| `cronjob search <term>` | Search across all log files for a keyword |
| `cronjob recent` | Show the 20 most recent activity entries from the history log |
| `cronjob status` | Health check — shows version, data directory, entry count, disk usage |
| `cronjob help` | Display available commands and usage information |
| `cronjob version` | Print current version (v2.0.0) |

Each data command (scan, monitor, report, etc.) works in two modes:
- **With arguments**: Records the input with a timestamp into its dedicated log file
- **Without arguments**: Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally in plain-text log files:

- **Location**: `~/.local/share/cronjob/`
- **Format**: Each entry is saved as `YYYY-MM-DD HH:MM|<value>` in per-category `.log` files
- **History**: All operations are additionally logged to `history.log` with timestamps
- **Export**: The `export` command can generate JSON, CSV, or TXT files from all log data
- **No cloud sync** — everything stays on your machine

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No external dependencies, no API keys, no network access required
- Works on Linux and macOS

## When to Use

1. **Cron job monitoring** — Track the execution status of scheduled jobs, log failures, and set up alerts for review
2. **Job audit trail** — Record scan, check, and report entries to maintain a complete history of job operations
3. **Backup & restore logging** — Log backup and restore events with timestamps so you always know what happened and when
4. **Performance benchmarking** — Record benchmark results for scheduled tasks and compare them over time to spot regressions
5. **Operational data export** — Export all collected logs in JSON, CSV, or TXT format for dashboards, compliance, or further analysis

## Examples

```bash
# Record a scan of cron job health
cronjob scan "all 12 scheduled jobs ran successfully today"

# Log a monitoring observation
cronjob monitor "backup-job took 45min, 3x longer than usual"

# Record an alert for a failed job
cronjob alert "daily-report cron failed at 03:00 — exit code 1"

# Log a fix action taken
cronjob fix "increased timeout for backup-job from 30m to 90m"

# View summary statistics across all categories
cronjob stats

# Export all data to CSV for spreadsheet analysis
cronjob export csv

# Search for entries related to a specific job
cronjob search "backup-job"

# Quick health check
cronjob status

# View the 20 most recent activity entries
cronjob recent
```

## Configuration

Set `CRONJOB_DIR` to change the data directory. Default: `~/.local/share/cronjob/`

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
