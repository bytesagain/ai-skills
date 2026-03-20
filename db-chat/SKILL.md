---
version: "1.0.0"
name: Chat2Db
description: "AI-driven database tool and SQL client, The hottest GUI client, supporting MySQL, Oracle, PostgreSQL db-chat, java, ai, bi, chatgpt, clickhouse."
---

# Db Chat

Db Chat v2.0.0 — a social/communication toolkit for managing connections, syncing data, monitoring activity, automating tasks, and more from the command line.

## Commands

Run via: `bash scripts/script.sh <command> [args]`

| Command | Description |
|---------|-------------|
| `connect <input>` | Log a connection entry (e.g., new contact, service link). Without args, shows recent entries. |
| `sync <input>` | Record sync operations or data synchronization notes. |
| `monitor <input>` | Log monitoring entries — track what you're watching or observing. |
| `automate <input>` | Record automation tasks or scripted workflows. |
| `notify <input>` | Log notification entries — messages, alerts, pings. |
| `report <input>` | Create or view report entries for summaries and analysis. |
| `schedule <input>` | Log scheduled items — meetings, events, recurring tasks. |
| `template <input>` | Save or view template entries for reusable patterns. |
| `webhook <input>` | Record webhook configurations or event triggers. |
| `status <input>` | Log status updates or check-ins. |
| `analytics <input>` | Record analytics data points and observations. |
| `export <input>` | Log export operations or data transfer records. |
| `stats` | Show summary statistics across all entry types. |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search across all log files for a keyword. |
| `recent` | Show the 20 most recent activity entries from the history log. |
| `help` | Show the built-in help message with all available commands. |
| `version` | Print the current version (`db-chat v2.0.0`). |

Each data command works in two modes:
- **With arguments**: saves the input with a timestamp to its dedicated log file.
- **Without arguments**: displays the 20 most recent entries from that log.

## Data Storage

All data is stored locally in `~/.local/share/db-chat/`:

- Each command has its own log file (e.g., `connect.log`, `sync.log`, `monitor.log`)
- Entries are saved in `timestamp|value` format
- A unified `history.log` records all activity across commands
- Export files are written to the same directory

## Requirements

- Bash (standard system shell)
- No external dependencies — uses only coreutils (`date`, `wc`, `du`, `grep`, `tail`, `cat`)

## When to Use

- When you need to log database connections or service links from the terminal
- To track sync operations and data synchronization events
- For monitoring and recording automation workflows
- To manage notification logs and webhook configurations
- When you want to schedule and template recurring tasks
- To export activity data for reporting or backup purposes
- For lightweight, file-based activity and communication tracking

## Examples

```bash
# Log a new connection
db-chat connect "Connected to production MySQL replica"

# Record a sync operation
db-chat sync "Synced user table from staging to dev"

# Log a monitoring entry
db-chat monitor "CPU usage spike on db-primary at 14:30"

# Set up an automation record
db-chat automate "Nightly backup script configured for 2am"

# Log a notification
db-chat notify "Alert: disk usage exceeded 90% on db-02"

# Schedule something
db-chat schedule "Weekly standup every Monday 10am"

# Save a template
db-chat template "SELECT * FROM users WHERE created_at > NOW() - INTERVAL 7 DAY"

# Record a webhook
db-chat webhook "POST /api/hooks/deploy — triggers on push to main"

# View all statistics
db-chat stats

# Export everything as CSV
db-chat export csv

# Search for entries mentioning "backup"
db-chat search backup

# Check recent activity
db-chat recent
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
