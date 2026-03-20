---
version: "1.0.0"
name: diskview
description: "Display disk usage and free space across mounted filesystems clearly. Use when checking mounts, comparing utilization, monitoring capacity."
---

# Diskview

A system operations toolkit for tracking, logging, and managing disk and infrastructure entries. Records timestamped entries across multiple categories and provides search, export, and reporting capabilities.

This skill uses a **sysops-oriented command set** — scan, monitor, alert, cleanup, backup, restore, benchmark — designed for disk and system administration workflows.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display the 20 most recent entries from the corresponding log. With arguments, they record a new timestamped entry.

### Core Tracking Commands

| Command | Description |
|---------|-------------|
| `scan <input>` | Record or view scan entries |
| `monitor <input>` | Record or view monitoring entries |
| `report <input>` | Record or view report entries |
| `alert <input>` | Record or view alert entries |
| `top <input>` | Record or view top entries |
| `usage <input>` | Record or view usage entries |
| `check <input>` | Record or view check entries |
| `fix <input>` | Record or view fix entries |
| `cleanup <input>` | Record or view cleanup entries |
| `backup <input>` | Record or view backup entries |
| `restore <input>` | Record or view restore entries |
| `log <input>` | Record or view log entries |
| `benchmark <input>` | Record or view benchmark entries |
| `compare <input>` | Record or view comparison entries |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files (entry counts, data size) |
| `export <fmt>` | Export all data in a specified format: `json`, `csv`, or `txt` |
| `search <term>` | Search all log files for a term (case-insensitive) |
| `recent` | Show the 20 most recent entries from the activity history |
| `status` | Display health check: version, data directory, entry count, disk usage |
| `help` | Show help message with all available commands |
| `version` | Show version string (`diskview v2.0.0`) |

## Data Storage

- **Data directory:** `~/.local/share/diskview/`
- **Log format:** Each command writes to its own `.log` file (e.g., `scan.log`, `monitor.log`)
- **Entry format:** `YYYY-MM-DD HH:MM|<input>` (pipe-delimited timestamp + value)
- **History log:** All actions are also appended to `history.log` with timestamps
- **Export output:** Written to `export.json`, `export.csv`, or `export.txt` in the data directory

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or package installations required

## When to Use

- To track and log disk monitoring and system administration activities
- For recording scan results, alerts, cleanup operations, or backup/restore events
- When you need to search across historical sysops activity logs
- To export tracked data to JSON, CSV, or plain text for capacity planning
- For monitoring data directory health and entry statistics
- When managing disk benchmarks, comparisons, and usage tracking

## Examples

```bash
# Record a new scan entry
diskview scan "/dev/sda1 — 85% used, 12GB free"

# Record a cleanup operation
diskview cleanup "removed /tmp/*.log — freed 2.3GB"

# Record a backup event
diskview backup "full backup of /home to s3://backups/2026-03-18"

# Set an alert
diskview alert "/dev/sdb1 exceeds 90% threshold"

# Search all logs for a keyword
diskview search "backup"

# Export all data as JSON
diskview export json

# View summary statistics
diskview stats

# Show recent activity
diskview recent

# Health check
diskview status

# Record a benchmark
diskview benchmark "sequential read: 520MB/s on /dev/nvme0n1"
```

## Configuration

Set the `DISKVIEW_DIR` environment variable to override the default data directory. Default: `~/.local/share/diskview/`

## Output

All commands write results to stdout. Redirect output with `diskview <command> > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
