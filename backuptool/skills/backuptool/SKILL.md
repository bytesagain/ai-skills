---
name: BackupTool
description: "Create timestamped backups with compression, rotation, and scheduling. Use when archiving directories, restoring snapshots, or managing retention."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["backup","archive","restore","compress","admin","data"]
categories: ["Developer Tools", "Utility"]
---

# BackupTool

Sysops toolkit for logging, tracking, and managing system operations entries. Each command records timestamped entries to individual log files and supports viewing recent entries, searching, exporting, and statistics.

## Commands

| Command | Description |
|---------|-------------|
| `backuptool scan <input>` | Record a scan entry; without args shows recent scan entries |
| `backuptool monitor <input>` | Record a monitor entry; without args shows recent monitor entries |
| `backuptool report <input>` | Record a report entry; without args shows recent report entries |
| `backuptool alert <input>` | Record an alert entry; without args shows recent alert entries |
| `backuptool top <input>` | Record a top entry; without args shows recent top entries |
| `backuptool usage <input>` | Record a usage entry; without args shows recent usage entries |
| `backuptool check <input>` | Record a check entry; without args shows recent check entries |
| `backuptool fix <input>` | Record a fix entry; without args shows recent fix entries |
| `backuptool cleanup <input>` | Record a cleanup entry; without args shows recent cleanup entries |
| `backuptool backup <input>` | Record a backup entry; without args shows recent backup entries |
| `backuptool restore <input>` | Record a restore entry; without args shows recent restore entries |
| `backuptool log <input>` | Record a log entry; without args shows recent log entries |
| `backuptool benchmark <input>` | Record a benchmark entry; without args shows recent benchmark entries |
| `backuptool compare <input>` | Record a compare entry; without args shows recent compare entries |
| `backuptool stats` | Show summary statistics across all log files (entry counts, data size) |
| `backuptool export <fmt>` | Export all data in json, csv, or txt format |
| `backuptool search <term>` | Search all log files for a term (case-insensitive) |
| `backuptool recent` | Show last 20 lines from history.log |
| `backuptool status` | Show health check: version, entry count, disk usage, last activity |
| `backuptool help` | Show help message with all available commands |
| `backuptool version` | Show version (v2.0.0) |

## Data Storage

Data stored in `~/.local/share/backuptool/`

Each command writes timestamped entries to its own `.log` file (e.g., `scan.log`, `backup.log`, `restore.log`). All actions are also recorded in `history.log`.

## Requirements

- Bash 4+

## When to Use

- Logging backup and restore operations with timestamps for audit trails
- Tracking system scans, alerts, and monitoring events
- Searching historical operations logs for specific incidents or keywords
- Exporting accumulated operations data in JSON, CSV, or TXT format
- Getting summary statistics on all tracked system activities

## Examples

```bash
# Record a backup operation
backuptool backup "/var/www full backup completed"

# Record a scan finding
backuptool scan "disk usage at 85% on /dev/sda1"

# Search all logs for a keyword
backuptool search "disk"

# Export all data as CSV
backuptool export csv

# View health check status
backuptool status
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
