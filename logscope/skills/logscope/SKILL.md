---
version: "1.0.0"
name: logscope
description: "Analyze web server logs with real-time dashboards and traffic breakdowns. Use when reviewing access logs, identifying top pages, monitoring visitor stats."
---

# Logscope

Logscope v2.0.0 — a sysops toolkit for logging, monitoring, benchmarking, and managing system operations from the command line. Track scans, alerts, backups, restores, and more with timestamped entries stored locally.

## Commands

Run `scripts/script.sh <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `scan <input>` | Record a scan entry. Without args, shows the 20 most recent scan entries. |
| `monitor <input>` | Record a monitoring entry. Without args, shows recent monitor entries. |
| `report <input>` | Record a report entry. Without args, shows recent report entries. |
| `alert <input>` | Record an alert entry. Without args, shows recent alert entries. |
| `top <input>` | Record a top-level entry. Without args, shows recent top entries. |
| `usage <input>` | Record a usage entry. Without args, shows recent usage entries. |
| `check <input>` | Record a check entry. Without args, shows recent check entries. |
| `fix <input>` | Record a fix entry. Without args, shows recent fix entries. |
| `cleanup <input>` | Record a cleanup entry. Without args, shows recent cleanup entries. |
| `backup <input>` | Record a backup entry. Without args, shows recent backup entries. |
| `restore <input>` | Record a restore entry. Without args, shows recent restore entries. |
| `log <input>` | Record a log entry. Without args, shows recent log entries. |
| `benchmark <input>` | Record a benchmark entry. Without args, shows recent benchmark entries. |
| `compare <input>` | Record a comparison entry. Without args, shows recent compare entries. |
| `stats` | Show summary statistics across all entry types (counts, data size). |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search all log files for a term (case-insensitive). |
| `recent` | Show the 20 most recent entries from the activity history. |
| `status` | Health check — version, data directory, entry count, disk usage. |
| `help` | Show help message with all available commands. |
| `version` | Show version string (`logscope v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/logscope/`:

- Each command type writes to its own `.log` file (e.g., `scan.log`, `alert.log`, `backup.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|<value>` format
- A unified `history.log` tracks all actions across command types
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies — works out of the box on Linux and macOS

## When to Use

1. **Tracking system operations** — log scans, checks, fixes, and cleanups during maintenance windows to keep an audit trail
2. **Monitoring and alerting** — record monitoring observations and alert events for later review and trend analysis
3. **Backup and restore tracking** — document backup and restore operations with timestamps for compliance and verification
4. **Benchmarking and comparison** — record benchmark results and compare entries over time to track performance changes
5. **Exporting operational data** — export your accumulated sysops data to JSON, CSV, or TXT for reporting or integration with other tools

## Examples

```bash
# Record a scan result
logscope scan "Full system scan completed, 0 vulnerabilities found"

# Log an alert
logscope alert "Disk usage exceeded 90% on /dev/sda1"

# Record a backup operation
logscope backup "Daily backup of /var/data completed successfully"

# Search across all entries for a keyword
logscope search "disk"

# Export all data as JSON
logscope export json

# View summary statistics
logscope stats

# Check system health status
logscope status
```

## Output

All commands print results to stdout. Each recording command confirms the save and shows the total entry count. Redirect output to a file with:

```bash
logscope stats > report.txt
```

## Configuration

Set the `DATA_DIR` inside the script or modify the default path `~/.local/share/logscope/` to change where data is stored.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
