---
name: CashFlow
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["finance","money","budget","cashflow","expense","income","tracker","personal-finance"]
categories: ["Finance", "Personal Management", "Productivity"]
description: "Track personal cash flow with simple terminal commands and local storage. Use when logging daily expenses, reviewing balance, or exporting records."
---

# CashFlow

CashFlow is a multi-purpose utility tool for tracking and managing data entries from the terminal. It provides a simple log-based system for adding, listing, searching, and exporting entries with timestamped records.

## Commands

| Command | Description |
|---------|-------------|
| `cashflow run <args>` | Execute the main function with given arguments |
| `cashflow config` | Show configuration file location (`config.json`) |
| `cashflow status` | Show current status (ready/not ready) |
| `cashflow init` | Initialize the data directory |
| `cashflow list` | List all entries in the data log |
| `cashflow add <entry>` | Add a new dated entry to the data log |
| `cashflow remove <entry>` | Remove an entry |
| `cashflow search <term>` | Search entries (case-insensitive grep) |
| `cashflow export` | Export all data to stdout |
| `cashflow info` | Show version and data directory path |
| `cashflow help` | Show all available commands |
| `cashflow version` | Show version number |

## How It Works

CashFlow uses a flat-file approach. All entries are stored in `data.log` as dated lines (`YYYY-MM-DD <content>`). Every command also appends a timestamped record to `history.log` for auditing.

- `add` appends a new line with today's date
- `list` prints the full data log
- `search` performs case-insensitive matching via `grep`
- `export` dumps the raw data log to stdout for piping/redirection

## Data Storage

All data is stored locally in `~/.local/share/cashflow/` by default:

- `data.log` — Main data file with all entries (one per line, date-prefixed)
- `history.log` — Timestamped audit trail of every command executed
- `config.json` — Configuration file (referenced by `cashflow config`)

Override the storage location by setting the `CASHFLOW_DIR` environment variable:

```bash
export CASHFLOW_DIR="$HOME/my-data/cashflow"
```

Alternatively, `XDG_DATA_HOME` is respected if `CASHFLOW_DIR` is not set.

## Requirements

- **bash 4+** (uses `set -euo pipefail` for strict mode)
- Standard Unix tools (`grep`, `date`, `cat`)
- No API keys needed
- No external dependencies

## When to Use

1. **Quick data logging** — Use `cashflow add` to rapidly log entries (expenses, tasks, notes) with automatic date stamps
2. **Reviewing stored entries** — Run `cashflow list` to see everything you've logged, or `cashflow search` to find specific entries
3. **Exporting data for analysis** — Use `cashflow export > data.csv` to dump all entries for import into spreadsheets or other tools
4. **Project initialization** — Run `cashflow init` to set up the data directory on a new machine or project
5. **Checking tool status** — Use `cashflow status` and `cashflow info` to verify the tool is ready and see version/path information

## Examples

```bash
# Initialize the data directory
cashflow init

# Add entries
cashflow add "Monthly rent payment 2500"
cashflow add "Freelance invoice received 8000"
cashflow add "Grocery shopping 350"

# List all entries
cashflow list
```

```bash
# Search for specific entries
cashflow search rent
cashflow search invoice

# Export data to a file
cashflow export > my-records.txt

# Check status and info
cashflow status
cashflow info
```

```bash
# Run a custom operation
cashflow run process-monthly

# View configuration location
cashflow config

# Remove an entry
cashflow remove "old entry"

# Show version
cashflow version
```

## Output

All command output goes to stdout. The history log is always written to `$DATA_DIR/history.log`. Redirect output as needed:

```bash
cashflow list > all-entries.txt
cashflow export | grep "2026-03" > march-data.txt
```

## Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `CASHFLOW_DIR` | Override data/config directory | `~/.local/share/cashflow/` |
| `XDG_DATA_HOME` | Fallback base directory | `~/.local/share/` |

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
