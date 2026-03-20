---
version: "1.0.0"
name: Pattern
description: "Web mining module for Python, with tools for scraping, natural language processing, machine learning text-mining, python, machine-learning."
---

# Text Mining

A finance-oriented toolkit for recording, categorizing, and analyzing financial data from the command line. Each command logs timestamped entries to dedicated log files, with built-in statistics, multi-format export, search, and health-check capabilities.

## Why Text Mining?

- Works entirely offline — financial data stays on your machine
- Purpose-built commands for finance workflows (record, categorize, balance, forecast, budget-check, tax-note)
- Each command type maintains its own log file for clean data separation
- Built-in multi-format export (JSON, CSV, plain text)
- Full activity history with timestamped audit trail
- Summary statistics with entry counts and disk usage

## Commands

### Finance Operations

| Command | Description |
|---------|-------------|
| `text-mining record <input>` | Record a financial entry (no args: show recent) |
| `text-mining categorize <input>` | Categorize a transaction (no args: show recent) |
| `text-mining balance <input>` | Log a balance entry (no args: show recent) |
| `text-mining trend <input>` | Record a trend observation (no args: show recent) |
| `text-mining forecast <input>` | Log a forecast entry (no args: show recent) |
| `text-mining export-report <input>` | Record an export report entry (no args: show recent) |
| `text-mining budget-check <input>` | Log a budget check (no args: show recent) |
| `text-mining summary <input>` | Record a summary entry (no args: show recent) |
| `text-mining alert <input>` | Log a financial alert (no args: show recent) |
| `text-mining history <input>` | Record a history entry (no args: show recent) |
| `text-mining compare <input>` | Log a comparison entry (no args: show recent) |
| `text-mining tax-note <input>` | Record a tax note (no args: show recent) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `text-mining stats` | Show summary statistics (entry counts per type, total, disk usage) |
| `text-mining export <fmt>` | Export all data in json, csv, or txt format |
| `text-mining search <term>` | Search across all log files (case-insensitive) |
| `text-mining recent` | Show the 20 most recent activity log entries |
| `text-mining status` | Health check (version, entries, disk, last activity) |
| `text-mining help` | Display all available commands |
| `text-mining version` | Print version string |

Each finance command works in two modes:
- **With arguments**: Saves a timestamped entry to `<command>.log` and logs to `history.log`
- **Without arguments**: Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/text-mining/`. The directory contains:

- **`record.log`**, **`categorize.log`**, **`balance.log`**, **`trend.log`**, **`forecast.log`**, etc. — One log file per command type, storing `YYYY-MM-DD HH:MM|input` entries
- **`history.log`** — Unified activity log with timestamped records of every command executed
- **`export.json`** / **`export.csv`** / **`export.txt`** — Generated export files

## Requirements

- **Bash** 4.0+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `grep`, `cat`, `tail`, `wc`, `du`, `date`, `sed`
- No external dependencies or network access required

## When to Use

1. **Tracking daily expenses** — Use `text-mining record "lunch 45 CNY"` to log transactions with automatic timestamps
2. **Budget monitoring** — Run `text-mining budget-check "March: 3200/5000 CNY spent"` to track spending against limits
3. **Financial trend analysis** — Record observations with `text-mining trend "Q1 savings rate up 12%"` and review with `text-mining search "savings"`
4. **Tax preparation** — Keep tax-related notes with `text-mining tax-note "deductible: home office 1200 CNY"` for year-end review
5. **Exporting financial summaries** — Run `text-mining export csv` to get all recorded entries across all categories in spreadsheet-ready CSV format

## Examples

```bash
# Record financial transactions
text-mining record "salary received 15000 CNY"
text-mining record "rent payment 3500 CNY"
text-mining categorize "groceries: 280 CNY weekly average"

# Balance and budget tracking
text-mining balance "checking: 12,500 CNY | savings: 45,000 CNY"
text-mining budget-check "food budget: 1800/2000 CNY (90%)"
text-mining forecast "projected savings by June: 55,000 CNY"

# Tax and comparison notes
text-mining tax-note "freelance income Q1: 8,000 CNY"
text-mining compare "Feb vs Mar spending: -15% reduction"

# Search, review, and export
text-mining search "rent"
text-mining recent
text-mining stats
text-mining export json
text-mining export csv
```

## Configuration

The data directory defaults to `~/.local/share/text-mining/`. All log files are plain text with pipe-delimited fields (`timestamp|value`), making them easy to parse with standard Unix tools.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
