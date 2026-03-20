---
version: "1.0.0"
name: Imagemagick
description: "ImageMagick is a free, open-source software suite for creating, editing, converting, and displaying image-processor, c, command-line-image-tool."
---

# Image Processor

Image Processor v2.0.0 — a sysops toolkit for scanning, monitoring, reporting, alerting, usage tracking, checking, fixing, cleanup, backup, restore, logging, benchmarking, and comparing system and image processing operations. All entries are timestamped and logged locally for history tracking.

## Commands

### Core Commands

- `scan <input>` — Record and log a scan entry. Without arguments, shows the 20 most recent scan entries.
- `monitor <input>` — Record and log a monitor entry. Without arguments, shows recent monitor entries.
- `report <input>` — Record and log a report entry. Without arguments, shows recent report entries.
- `alert <input>` — Record and log an alert entry. Without arguments, shows recent alert entries.
- `top <input>` — Record and log a top entry. Without arguments, shows recent top entries.
- `usage <input>` — Record and log a usage entry. Without arguments, shows recent usage entries.
- `check <input>` — Record and log a check entry. Without arguments, shows recent check entries.
- `fix <input>` — Record and log a fix entry. Without arguments, shows recent fix entries.
- `cleanup <input>` — Record and log a cleanup entry. Without arguments, shows recent cleanup entries.
- `backup <input>` — Record and log a backup entry. Without arguments, shows recent backup entries.
- `restore <input>` — Record and log a restore entry. Without arguments, shows recent restore entries.
- `log <input>` — Record and log a log entry. Without arguments, shows recent log entries.
- `benchmark <input>` — Record and log a benchmark entry. Without arguments, shows recent benchmark entries.
- `compare <input>` — Record and log a compare entry. Without arguments, shows recent compare entries.

### Utility Commands

- `stats` — Show summary statistics across all log files (entry counts per type, total entries, disk usage).
- `export <fmt>` — Export all logged data to a file. Supported formats: `json`, `csv`, `txt`.
- `search <term>` — Search all log files for a case-insensitive term match.
- `recent` — Show the 20 most recent entries from the activity history log.
- `status` — Health check showing version, data directory, total entries, disk usage, and last activity.
- `help` — Display the full help message with all available commands.
- `version` — Print the current version (v2.0.0).

## Data Storage

All data is stored in `~/.local/share/image-processor/`:

- Each core command writes timestamped entries to its own log file (e.g., `scan.log`, `monitor.log`, `backup.log`).
- A unified `history.log` tracks all operations across commands.
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`

## When to Use

- When you need to log and track sysops operations (scans, monitoring, alerts, backups, restores, etc.)
- For maintaining an audit trail of image processing and system administration activities
- To benchmark and compare operations over time with timestamped records
- To export accumulated operational data in JSON, CSV, or plain text for downstream analysis
- As part of a larger automation pipeline for system monitoring and maintenance
- When you need to search across historical sysops and processing entries

## Examples

```bash
# Record a scan entry
image-processor scan "/var/log/syslog for errors"

# Monitor something
image-processor monitor "disk usage on /dev/sda1"

# Create an alert
image-processor alert "CPU usage above 90%"

# Log a backup operation
image-processor backup "/home/admin/data to s3://bucket"

# Run a benchmark
image-processor benchmark "resize 1000 images 1920x1080"

# Compare two operations
image-processor compare "v1.0 vs v2.0 processing time"

# Check system health
image-processor check "memory utilization"

# Cleanup old data
image-processor cleanup "logs older than 30 days"

# View recent activity
image-processor recent

# Search across all logs
image-processor search "backup"

# Export everything to JSON
image-processor export json

# Show stats
image-processor stats

# Health check
image-processor status
```

## Output

All commands output results to stdout. Redirect to a file if needed:

```bash
image-processor stats > report.txt
image-processor export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
