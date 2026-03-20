---
version: "1.0.0"
name: spend-tracker
description: "Track expenses, categorize spending, and generate finance reports. Use when logging purchases, checking balances, converting currencies, analyzing trends."
---

# Spend Tracker

Personal expense tracking and financial management toolkit. Log spending entries, run financial checks, convert currencies, analyze trends, generate reports, and export data — all from the command line.

## Commands

Run `spend-tracker <command> [args]` to use. Each command records timestamped entries to its own log file.

### Core Operations

| Command | Description |
|---------|-------------|
| `run <input>` | Log a general run entry (or view recent with no args) |
| `check <input>` | Record a financial check or verification |
| `convert <input>` | Log a currency or unit conversion |
| `analyze <input>` | Record an analysis note (spending patterns, trends) |
| `generate <input>` | Generate or log a computed result |
| `preview <input>` | Preview an entry before committing |
| `batch <input>` | Batch-process multiple entries at once |
| `compare <input>` | Compare spending across periods or categories |
| `export <input>` | Log an export operation |
| `config <input>` | Record a configuration change |
| `status <input>` | Log a status update |
| `report <input>` | Record a report generation event |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files (entry counts, disk usage) |
| `export <fmt>` | Export all data in a given format: `json`, `csv`, or `txt` |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Display the last 20 lines from the activity history log |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show the full command reference |
| `version` | Print current version (v2.0.0) |

> **Note:** Each core command works in two modes — call with no arguments to view recent entries (last 20), or pass input to record a new timestamped entry.

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/spend-tracker/
├── run.log            # General run entries
├── check.log          # Financial checks
├── convert.log        # Currency conversions
├── analyze.log        # Analysis notes
├── generate.log       # Generated results
├── preview.log        # Preview entries
├── batch.log          # Batch operations
├── compare.log        # Comparison records
├── export.log         # Export operations
├── config.log         # Configuration changes
├── status.log         # Status updates
├── report.log         # Report events
└── history.log        # Unified activity log (all commands)
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). The `history.log` file receives a line for every command executed, providing a single timeline of all activity.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies — pure bash, works on any Linux or macOS system

## When to Use

1. **Daily expense logging** — quickly record purchases, bills, or income from the terminal without opening a spreadsheet
2. **Financial reviews** — use `analyze` and `compare` to note spending patterns and period-over-period changes
3. **Currency conversion tracking** — log conversions with `convert` when dealing with multi-currency expenses
4. **Batch processing** — use `batch` to record multiple related transactions in one session
5. **Data export and reporting** — export all records to JSON/CSV/TXT for import into other tools or for archival

## Examples

```bash
# Record a lunch expense
spend-tracker run "lunch 35.50 food"

# Log a currency conversion
spend-tracker convert "USD 100 -> CNY 725.30"

# Analyze monthly spending
spend-tracker analyze "March total: 4,280 CNY — 12% over budget"

# Compare two months
spend-tracker compare "Feb vs Mar: groceries +18%, transport -5%"

# View recent activity
spend-tracker recent

# Export everything to CSV
spend-tracker export csv

# Search for all food-related entries
spend-tracker search food

# Check overall health and stats
spend-tracker stats
```

## Configuration

Set the `SPEND_TRACKER_DIR` environment variable to change the data directory:

```bash
export SPEND_TRACKER_DIR="/custom/path/to/data"
```

Default: `~/.local/share/spend-tracker/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
