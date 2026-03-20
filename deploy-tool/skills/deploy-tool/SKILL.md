---
version: "1.0.0"
name: Deployer
description: "The PHP deployment tool with support for popular frameworks out of the box deploy-tool, php, deploy, deployment, php, provision."
---

# Deploy Tool

Deploy Tool v2.0.0 — a utility toolkit for logging, tracking, and managing deployment-related entries from the command line.

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

All data is stored locally in `~/.local/share/deploy-tool/`:

- **Per-command logs** — Each command (run, check, convert, etc.) writes to its own `.log` file with pipe-delimited `timestamp|value` format.
- **history.log** — A unified activity log recording every write operation with timestamps.
- **Export formats** — The `export` utility function supports JSON, CSV, and TXT output, written to `~/.local/share/deploy-tool/export.<fmt>`.

No external services, databases, or API keys are required. Everything is flat-file and human-readable.

## Requirements

- **Bash** (v4+ recommended)
- No external dependencies — uses only standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`)

## When to Use

- When you need to log and track deployment-related activities from the command line
- To maintain a searchable history of deployment operations
- For batch recording of deployment tasks with timestamps
- When you want to export deployment logs in JSON, CSV, or TXT format
- As part of a larger automation pipeline for tracking deployment workflows
- To get quick statistics and summaries of past deployment activities

## Examples

```bash
# Record a new run entry
deploy-tool run "deployed v1.2.3 to production"

# View recent run entries (no args = show history)
deploy-tool run

# Check something and log it
deploy-tool check "nginx config validated"

# Analyze and record
deploy-tool analyze "memory usage at 72%"

# Search across all logs
deploy-tool search "production"

# View summary statistics
deploy-tool stats

# Show recent activity across all commands
deploy-tool recent

# Show tool version
deploy-tool version

# Show full help
deploy-tool help
```

## How It Works

Each command follows the same pattern:
1. **With arguments** — Timestamps the input, appends it to the command-specific log file, prints confirmation, and logs to `history.log`.
2. **Without arguments** — Shows the last 20 entries from that command's log file.

The `stats` command iterates all `.log` files, counts entries per file, and reports totals plus disk usage. The `search` command performs case-insensitive grep across all log files. The `recent` command tails the last 20 lines of `history.log`.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
