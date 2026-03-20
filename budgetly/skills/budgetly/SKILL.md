---
name: BudgetLy
description: "Set category budgets, log expenses, and visualize spending limits. Use when tracking grocery costs, monitoring subscriptions, or forecasting spend."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["budget","finance","money","spending","savings","personal-finance","categories"]
categories: ["Finance", "Personal Management", "Productivity"]
---

# BudgetLy

BudgetLy v2.0.0 — a personal finance toolkit for recording expenses, categorizing spending, checking balances, analyzing trends, forecasting budgets, and generating reports from the command line.

## Why BudgetLy?

- Full-featured personal finance tracker with 12 specialized commands
- No external dependencies, accounts, or API keys needed — your data remains on disk
- All entries are timestamped and stored in plain-text log files
- Export to JSON, CSV, or TXT for analysis in spreadsheets or other tools
- Built-in search, statistics, and health-check utilities
- Works on any system with Bash

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `record` | `budgetly record <input>` | Record a financial transaction or expense entry |
| `categorize` | `budgetly categorize <input>` | Categorize a transaction (e.g., food, transport, rent) |
| `balance` | `budgetly balance <input>` | Log or check account balance information |
| `trend` | `budgetly trend <input>` | Log trend data for spending pattern analysis |
| `forecast` | `budgetly forecast <input>` | Record a budget forecast or projection |
| `export-report` | `budgetly export-report <input>` | Generate and log an export report entry |
| `budget-check` | `budgetly budget-check <input>` | Check budget limits and log the result |
| `summary` | `budgetly summary <input>` | Log a financial summary (daily, weekly, monthly) |
| `alert` | `budgetly alert <input>` | Set or log a budget alert (overspend warnings, etc.) |
| `history` | `budgetly history <input>` | Log or view financial history entries |
| `compare` | `budgetly compare <input>` | Compare spending across periods or categories |
| `tax-note` | `budgetly tax-note <input>` | Record tax-related notes and deductions |
| `stats` | `budgetly stats` | Show summary statistics across all log files |
| `export` | `budgetly export <fmt>` | Export all data (json, csv, or txt) |
| `search` | `budgetly search <term>` | Search across all log files for a keyword |
| `recent` | `budgetly recent` | Show the 20 most recent history entries |
| `status` | `budgetly status` | Health check — version, entry count, disk usage |
| `help` | `budgetly help` | Show the help message with all commands |
| `version` | `budgetly version` | Print the current version |

All entry commands (record, categorize, balance, trend, forecast, export-report, budget-check, summary, alert, history, compare, tax-note) work the same way:
- **With arguments**: saves a timestamped entry to `<command>.log` and logs to `history.log`
- **Without arguments**: displays the 20 most recent entries from that command's log

## Data Storage

All data is stored in `~/.local/share/budgetly/`:

- `record.log`, `categorize.log`, `balance.log`, etc. — one log file per command
- `history.log` — unified activity log across all commands
- `export.json` / `export.csv` / `export.txt` — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited timestamp and content).

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `head`, `tail`, `cat`
- No external dependencies, no Python, no API keys

## When to Use

1. **Daily expense logging** — Use `budgetly record "Lunch at cafe ¥45"` to maintain a running log of daily expenses and review them later with `budgetly record` (no args shows recent entries).
2. **Category-based spending analysis** — Use `budgetly categorize "food: ¥2,300 this month"` to organize expenses by category and then search with `budgetly search "food"` to analyze patterns.
3. **Monthly budget forecasting** — Use `budgetly forecast "April budget: rent ¥3000, food ¥2500, transport ¥800"` to plan ahead and compare actuals later with `budgetly compare`.
4. **Tax preparation** — Use `budgetly tax-note "Home office deduction: ¥1,200/month, receipts in folder Q1-2026"` to keep tax-related notes organized and export them with `budgetly export csv`.
5. **Spending alerts and limits** — Use `budgetly alert "Entertainment budget exceeded: ¥1,500/¥1,000 limit"` to log overspend warnings and review alerts with `budgetly alert`.

## Examples

```bash
# Record daily expenses
budgetly record "Coffee ¥15, lunch ¥42, groceries ¥128"
budgetly record "Monthly rent ¥3,500"

# Categorize spending
budgetly categorize "transport: Uber ¥30, subway ¥8, gas ¥200"
budgetly categorize "subscriptions: Netflix ¥45, Spotify ¥15, iCloud ¥6"

# Check and log balance
budgetly balance "Checking account: ¥15,230 as of March 18"

# Analyze spending trends
budgetly trend "Food spending up 15% vs last month"

# Forecast next month
budgetly forecast "April projection: total ¥8,500 (down from ¥9,200 in March)"

# Set budget alerts
budgetly alert "Warning: dining out already at 80% of monthly limit"

# Log tax-related items
budgetly tax-note "Charitable donation ¥500 to Red Cross, receipt #RC-2026-0318"

# Compare periods
budgetly compare "Q1 vs Q4: food +12%, transport -8%, entertainment -20%"

# View summary statistics
budgetly stats

# Search for specific entries
budgetly search "groceries"

# Export everything to JSON
budgetly export json

# Check system status
budgetly status

# View recent activity
budgetly recent
```

## Configuration

Data directory: `~/.local/share/budgetly/` (hardcoded, no environment variable override).

## Output

All commands print results to stdout. Redirect output to a file if needed:

```bash
budgetly stats > my-finance-stats.txt
budgetly export csv
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
