---
name: Dbeaver
description: "Connect to databases with a universal SQL client for major engines. Use when querying databases, browsing schemas, exporting results."
version: "1.0.0"
license: Apache-2.0
runtime: python3
---

# Dbeaver

Dbeaver v2.0.0 — a utility toolkit for running tasks, checking results, converting data, analyzing output, generating content, and more from the command line.

## Commands

Run via: `bash scripts/script.sh <command> [args]`

| Command | Description |
|---------|-------------|
| `run <input>` | Execute a task or log a run entry. Without args, shows recent runs. |
| `check <input>` | Perform or log a check — validation, verification, or health probe. |
| `convert <input>` | Record a data conversion or transformation operation. |
| `analyze <input>` | Log analysis results — insights, findings, or diagnostic output. |
| `generate <input>` | Record generated content — reports, configs, templates. |
| `preview <input>` | Log a preview action — quick look at data or output before committing. |
| `batch <input>` | Record batch operations — bulk processing or multi-item tasks. |
| `compare <input>` | Log comparison results between datasets, schemas, or configs. |
| `export <input>` | Record export operations or data transfer logs. |
| `config <input>` | Log configuration changes or settings updates. |
| `status <input>` | Record status updates or system check-ins. |
| `report <input>` | Create or view report entries for summaries and analysis. |
| `stats` | Show summary statistics across all entry types. |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search across all log files for a keyword. |
| `recent` | Show the 20 most recent activity entries from the history log. |
| `status` | Health check — version, data directory, entry count, disk usage. |
| `help` | Show the built-in help message with all available commands. |
| `version` | Print the current version (`dbeaver v2.0.0`). |

Each data command works in two modes:
- **With arguments**: saves the input with a timestamp to its dedicated log file.
- **Without arguments**: displays the 20 most recent entries from that log.

## Data Storage

All data is stored locally in `~/.local/share/dbeaver/`:

- Each command has its own log file (e.g., `run.log`, `check.log`, `convert.log`)
- Entries are saved in `timestamp|value` format
- A unified `history.log` records all activity across commands
- Export files are written to the same directory

## Requirements

- Bash (standard system shell)
- No external dependencies — uses only coreutils (`date`, `wc`, `du`, `grep`, `tail`, `cat`)

## When to Use

- When you need to log database operations and task runs from the terminal
- To track data conversions and transformations
- For analyzing and comparing datasets or schemas
- To generate and preview reports before finalizing
- When managing batch operations across multiple items
- To record configuration changes for audit trails
- For lightweight, file-based operations logging and tracking

## Examples

```bash
# Run a task
dbeaver run "Execute migration script v3.2 on staging"

# Check something
dbeaver check "Verified all foreign keys are valid after migration"

# Convert data
dbeaver convert "Converted users table from Latin1 to UTF-8"

# Analyze results
dbeaver analyze "Query plan shows full table scan on orders — needs index"

# Generate a report
dbeaver generate "Monthly usage report for March 2025"

# Preview output
dbeaver preview "Sample: first 100 rows from new materialized view"

# Batch operation
dbeaver batch "Processed 15,000 records in 3 batches"

# Compare schemas
dbeaver compare "Staging vs Production: 2 column differences in users table"

# Export data
dbeaver export json

# Update config
dbeaver config "Set max_connections to 200 on primary"

# Log a status update
dbeaver status "All replicas in sync, lag < 1s"

# Create a report
dbeaver report "Weekly performance summary: 99.8% uptime"

# View all statistics
dbeaver stats

# Search for entries mentioning "migration"
dbeaver search migration

# Check recent activity
dbeaver recent
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
