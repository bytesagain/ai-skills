---
version: "1.0.0"
name: gymlog
description: "Log workouts, track sets and reps, and chart training progress over time. Use when recording sessions, tracking PRs, or reviewing weekly volume."
---

# Gymlog

Gymlog v2.0.0 — a sysops toolkit for logging and tracking operations from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `gymlog scan <input>` | Log a scan entry (no args = show recent) |
| `gymlog monitor <input>` | Log a monitor entry (no args = show recent) |
| `gymlog report <input>` | Log a report entry (no args = show recent) |
| `gymlog alert <input>` | Log an alert entry (no args = show recent) |
| `gymlog top <input>` | Log a top entry (no args = show recent) |
| `gymlog usage <input>` | Log a usage entry (no args = show recent) |
| `gymlog check <input>` | Log a check entry (no args = show recent) |
| `gymlog fix <input>` | Log a fix entry (no args = show recent) |
| `gymlog cleanup <input>` | Log a cleanup entry (no args = show recent) |
| `gymlog backup <input>` | Log a backup entry (no args = show recent) |
| `gymlog restore <input>` | Log a restore entry (no args = show recent) |
| `gymlog log <input>` | Log a log entry (no args = show recent) |
| `gymlog benchmark <input>` | Log a benchmark entry (no args = show recent) |
| `gymlog compare <input>` | Log a compare entry (no args = show recent) |
| `gymlog stats` | Show summary statistics across all log files |
| `gymlog export <fmt>` | Export all data (json, csv, or txt) |
| `gymlog search <term>` | Search across all log entries |
| `gymlog recent` | Show last 20 history entries |
| `gymlog status` | Health check (version, data dir, entry count, disk usage) |
| `gymlog help` | Show usage information |
| `gymlog version` | Show version string |

## Data Storage

All data is stored locally in `~/.local/share/gymlog/`. Each command writes timestamped entries to its own `.log` file (e.g., `scan.log`, `monitor.log`, `backup.log`). A unified `history.log` tracks all operations for the `recent` command.

Log format per entry: `YYYY-MM-DD HH:MM|<input>`

## Requirements

- Bash (with `set -euo pipefail`)
- No external dependencies — uses only standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `cat`, `sed`)

## When to Use

- To log and track sysops operations over time
- To maintain a searchable history of scan/monitor/alert/check tasks
- To track backup/restore operations and cleanup tasks
- To export accumulated data in JSON, CSV, or plain text for reporting
- To get a quick health check on your gymlog data directory
- For benchmarking and comparing system performance metrics

## Examples

```bash
# Log a scan entry
gymlog scan "full port scan on 192.168.1.0/24"

# Log a monitor entry
gymlog monitor "CPU usage 85% on web-server-01"

# Log an alert entry
gymlog alert "disk space below 10% on /dev/sda1"

# Log a backup entry
gymlog backup "nightly backup of /var/data completed"

# Log a benchmark entry
gymlog benchmark "disk I/O test: 450MB/s sequential read"

# View recent check entries
gymlog check

# Search all logs for a term
gymlog search "disk"

# Export everything as CSV
gymlog export csv

# View aggregate statistics
gymlog stats

# Health check
gymlog status

# Show last 20 history entries
gymlog recent

# Log a cleanup operation
gymlog cleanup "removed 2.3GB of old log files"

# Log a restore operation
gymlog restore "restored database from 2024-01-15 snapshot"
```

## Configuration

Set the `GYMLOG_DIR` environment variable to override the default data directory. Default: `~/.local/share/gymlog/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
