---
name: DiskMon
description: "Watch disk space in real time and alert before storage runs low. Use when monitoring usage, finding large dirs, preventing disk-full events."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["disk","storage","monitor","space","cleanup","filesystem","admin","devops"]
categories: ["System Tools", "Utility"]
---

# DiskMon

A sysops toolkit for scanning, monitoring, reporting, alerting, tracking top usage, checking health, fixing issues, cleaning up, backing up, restoring, logging, benchmarking, and comparing disk-related operations — all from the command line with full history tracking.

## Commands

| Command | Description |
|---------|-------------|
| `diskmon scan <input>` | Record and review disk scan entries (run without args to see recent) |
| `diskmon monitor <input>` | Record and review monitoring entries |
| `diskmon report <input>` | Record and review report entries |
| `diskmon alert <input>` | Record and review alert entries |
| `diskmon top <input>` | Record and review top-usage entries |
| `diskmon usage <input>` | Record and review usage entries |
| `diskmon check <input>` | Record and review health check entries |
| `diskmon fix <input>` | Record and review fix entries |
| `diskmon cleanup <input>` | Record and review cleanup entries |
| `diskmon backup <input>` | Record and review backup entries |
| `diskmon restore <input>` | Record and review restore entries |
| `diskmon log <input>` | Record and review log entries |
| `diskmon benchmark <input>` | Record and review benchmark entries |
| `diskmon compare <input>` | Record and review comparison entries |
| `diskmon stats` | Show summary statistics across all log files |
| `diskmon export <fmt>` | Export all data in JSON, CSV, or TXT format |
| `diskmon search <term>` | Search across all logged entries |
| `diskmon recent` | Show the 20 most recent activity entries |
| `diskmon status` | Health check — version, data dir, entry count, disk usage |
| `diskmon help` | Show usage info and all available commands |
| `diskmon version` | Print version string |

Each data command (scan, monitor, report, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves to the corresponding `.log` file
- **Without arguments:** Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/diskmon/`. Each command writes to its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`). A unified `history.log` tracks all activity across commands with timestamps.

- Log format: `YYYY-MM-DD HH:MM|<input>`
- History format: `MM-DD HH:MM <command>: <input>`
- No external database or network access required

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard POSIX utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No root privileges needed
- No API keys or external dependencies

## When to Use

1. **Tracking disk space trends over time** — Use `diskmon monitor` and `diskmon usage` to log periodic disk space readings across servers, building a historical record you can search and export
2. **Setting up alert documentation** — Use `diskmon alert` to record threshold breaches and disk-full warnings, creating a searchable incident history
3. **Documenting cleanup and maintenance** — Use `diskmon cleanup` and `diskmon fix` to keep timestamped logs of what was cleaned, freed, or repaired on which systems
4. **Benchmarking storage performance** — Use `diskmon benchmark` and `diskmon compare` to log I/O test results and compare performance across different disks or configurations
5. **Generating audit-ready exports** — Use `diskmon export json` to produce a structured file of all logged monitoring activity for capacity planning, compliance reviews, or team handoff

## Examples

### Log a scan and review history

```bash
# Record a scan result
diskmon scan "/dev/sda1: 78% used, 45GB free"

# View recent scan entries
diskmon scan
```

### Monitor, alert, and report workflow

```bash
# Log a monitoring observation
diskmon monitor "web-server-01 /var at 91% — nearing threshold"

# Log an alert
diskmon alert "CRITICAL: /data at 98% on prod-db-02"

# Generate a report entry
diskmon report "Weekly disk report: 3 servers above 85% threshold"

# Search across all entries
diskmon search "prod-db"
```

### Cleanup and fix tracking

```bash
# Log a cleanup action
diskmon cleanup "Purged 15GB of old logs from /var/log on app-server-03"

# Log a fix
diskmon fix "Extended /home LVM volume by 20GB on dev-server"

# View recent activity
diskmon recent
```

### Export and statistics

```bash
# Summary stats across all log files
diskmon stats

# Export everything as JSON
diskmon export json

# Export as CSV for spreadsheet analysis
diskmon export csv

# Health check
diskmon status
```

### Backup, restore, and benchmark

```bash
# Log a backup
diskmon backup "Snapshot of /data volume taken at 03:00 UTC"

# Log a restore test
diskmon restore "Verified restore of /etc from snapshot-2025-03-15"

# Log a benchmark result
diskmon benchmark "Sequential write: 480 MB/s on /dev/nvme0n1"

# Compare two benchmark runs
diskmon compare "nvme0n1 vs sda: 480 MB/s vs 210 MB/s sequential write"
```

## How It Works

DiskMon uses a simple case-dispatch architecture in a single Bash script. Each command maps to a log file under `~/.local/share/diskmon/`. When called with arguments, the input is appended with a timestamp. When called without arguments, the last 20 lines of that log are displayed. The `stats` command aggregates entry counts across all logs, `export` serializes everything into JSON, CSV, or plain text, and `search` greps across all log files for a given term.

## Support

- Website: [bytesagain.com](https://bytesagain.com)
- Feedback: [bytesagain.com/feedback](https://bytesagain.com/feedback)
- Email: hello@bytesagain.com

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
