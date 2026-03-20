---
version: "2.0.0"
name: raspberry-pi-manager
description: "Manage Raspberry Pi devices — GPIO control, system monitoring (CPU/temp/memory), service management, sensor data reading."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Raspberry Pi Manager

A command-line toolkit for managing Raspberry Pi operations. Log, track, and organize entries across multiple operational categories — from device connections and syncing to monitoring, automation, notifications, and reporting. All data is stored locally with timestamped history, full-text search, and multi-format export.

## Commands

The following commands are available via `raspberry-pi-manager <command> [args]`:

### Core Operations

| Command | Description |
|---------|-------------|
| `connect <input>` | Log a connection event (e.g. SSH session, network link, peripheral attach). Called without args, shows recent connect entries. |
| `sync <input>` | Record a sync operation (e.g. file sync, config push, backup mirror). Called without args, shows recent sync entries. |
| `monitor <input>` | Log a monitoring observation (e.g. CPU temp spike, disk usage alert). Called without args, shows recent monitor entries. |
| `automate <input>` | Record an automation task (e.g. cron job setup, GPIO script trigger). Called without args, shows recent automate entries. |
| `notify <input>` | Log a notification event (e.g. email alert sent, Telegram ping). Called without args, shows recent notify entries. |
| `report <input>` | Save a report note (e.g. weekly summary, incident write-up). Called without args, shows recent report entries. |
| `schedule <input>` | Record a scheduled task (e.g. reboot at 3 AM, backup every Sunday). Called without args, shows recent schedule entries. |
| `template <input>` | Store a template entry (e.g. config template, deploy script skeleton). Called without args, shows recent template entries. |
| `webhook <input>` | Log a webhook event (e.g. incoming POST, IFTTT trigger). Called without args, shows recent webhook entries. |
| `status <input>` | Record a status update (e.g. Pi online, service healthy). Called without args, shows recent status entries. |
| `analytics <input>` | Log an analytics data point (e.g. uptime percentage, request count). Called without args, shows recent analytics entries. |
| `export <input>` | Record an export action. Called without args, shows recent export entries. |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics — entry counts per category, total entries, data size, and earliest record timestamp. |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. Output file saved to the data directory. |
| `search <term>` | Full-text search across all log files (case-insensitive). |
| `recent` | Show the 20 most recent activity entries from the global history log. |
| `status` | Health check — version, data directory path, total entries, disk usage, last activity, and OK status. |
| `help` | Display the full command reference. |
| `version` | Print the current version (`v2.0.0`). |

## Data Storage

All data is persisted locally in `~/.local/share/raspberry-pi-manager/`:

- **Per-command logs** — Each command (connect, sync, monitor, etc.) writes to its own `.log` file with `YYYY-MM-DD HH:MM|<input>` format.
- **Global history** — Every action is also appended to `history.log` with `MM-DD HH:MM <command>: <input>` format for unified audit trail.
- **Export files** — Generated exports are saved as `export.json`, `export.csv`, or `export.txt` in the same directory.

No external services, databases, or network connections are required. Everything runs locally via bash.

## Requirements

- **Bash 4+** (uses `local` variables, `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No root privileges needed
- No external dependencies or package installs

## When to Use

1. **Tracking Pi fleet operations** — Log connect/sync/monitor events across multiple Raspberry Pi devices to maintain an operational journal.
2. **Building an automation audit trail** — Record every automation task and webhook trigger so you can trace what happened and when.
3. **Generating operational reports** — Use `stats`, `recent`, and `export` to produce summaries for weekly reviews or incident investigations.
4. **Organizing scheduled maintenance** — Use `schedule` to document planned tasks (reboots, updates, backups) and `notify` to log alert dispatches.
5. **Searching historical records** — Use `search` to quickly find past events across all categories when troubleshooting an issue.

## Examples

```bash
# Log a new SSH connection to a Pi
raspberry-pi-manager connect "SSH to pi@192.168.1.50 — firmware update session"

# Record a file sync event
raspberry-pi-manager sync "rsync /home/pi/data → NAS backup completed, 2.3GB transferred"

# Log a temperature monitoring alert
raspberry-pi-manager monitor "CPU temp 72°C on pi-node-3 — fan triggered"

# Record an automation task
raspberry-pi-manager automate "Cron job added: /home/pi/scripts/backup.sh every Sunday 02:00"

# View summary statistics
raspberry-pi-manager stats

# Export all data as JSON
raspberry-pi-manager export json

# Search for all entries mentioning 'backup'
raspberry-pi-manager search backup

# Check overall health status
raspberry-pi-manager status

# View the 20 most recent activities
raspberry-pi-manager recent
```

## How It Works

Each command follows the same pattern:

1. **With arguments** — Timestamps the input, appends it to the command-specific log file, increments the entry count, and writes to the global history log.
2. **Without arguments** — Displays the 20 most recent entries from that command's log file.

The `stats` command aggregates counts across all log files. The `export` command iterates through all logs and produces a unified output in your chosen format. The `search` command performs a case-insensitive grep across every log file.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
