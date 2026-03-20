---
name: Deployer
description: "Deploy PHP apps with zero-downtime releases and framework support. Use when deploying Laravel, running releases, configuring recipes."
version: "1.0.0"
license: MIT
runtime: python3
---

# Deployer

Deployer v2.0.0 — a utility toolkit for logging, tracking, and managing deployment-related entries from the command line.

## Commands

All commands accept optional input arguments. Without arguments, they display recent entries from the corresponding log. With arguments, they record a new timestamped entry.

| Command | Description |
|---------|-------------|
| `run <input>` | Record or view run entries |
| `check <input>` | Record or view check entries |
| `convert <input>` | Record or view convert entries |
| `analyze <input>` | Record or view analyze entries |
| `generate <input>` | Record or view generate entries |
| `preview <input>` | Record or view preview entries |
| `batch <input>` | Record or view batch entries |
| `compare <input>` | Record or view compare entries |
| `export <input>` | Record or view export entries |
| `config <input>` | Record or view config entries |
| `status <input>` | Record or view status entries |
| `report <input>` | Record or view report entries |
| `stats` | Show summary statistics across all log files |
| `search <term>` | Search all log entries for a keyword (case-insensitive) |
| `recent` | Display the 20 most recent history log entries |
| `help` | Show usage information |
| `version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/deployer/`:

- **Per-command logs** — Each command (run, check, convert, etc.) writes to its own `.log` file with pipe-delimited `timestamp|value` format.
- **history.log** — A unified activity log recording every write operation with timestamps.
- **Export formats** — The `export` utility function supports JSON, CSV, and TXT output, written to `~/.local/share/deployer/export.<fmt>`.

No external services, databases, or API keys are required. Everything is flat-file and human-readable.

## Requirements

- **Bash** (v4+ recommended)
- No external dependencies — uses only standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`)

## When to Use

- When you need to log and track deployment activities from the command line
- To maintain a searchable history of deployment operations
- For batch recording of deployment tasks with timestamps
- When you want to export deployment logs in JSON, CSV, or TXT format
- As part of a larger CI/CD automation pipeline for tracking releases
- To get quick statistics and summaries of past deployment activities

## Examples

```bash
# Record a new run entry
deployer run "deployed Laravel app to staging"

# View recent run entries (no args = show history)
deployer run

# Check something and log it
deployer check "database migrations completed"

# Analyze and record
deployer analyze "release v2.1.0 rollback risk: low"

# Generate a record
deployer generate "release notes for v2.1.0"

# Search across all logs
deployer search "staging"

# View summary statistics
deployer stats

# Show recent activity across all commands
deployer recent

# Show tool version
deployer version

# Show full help
deployer help
```

## How It Works

Each command follows the same pattern:
1. **With arguments** — Timestamps the input, appends it to the command-specific log file, prints confirmation, and logs to `history.log`.
2. **Without arguments** — Shows the last 20 entries from that command's log file.

The `stats` command iterates all `.log` files, counts entries per file, and reports totals plus disk usage. The `search` command performs case-insensitive grep across all log files. The `recent` command tails the last 20 lines of `history.log`.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
