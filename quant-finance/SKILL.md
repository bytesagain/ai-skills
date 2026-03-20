---
version: "1.0.0"
name: Mlfinlab
description: "MlFinLab helps portfolio managers and traders who want to use the power of machine learning by quant-finance, python, algorithmic-trading, finance."
---

# Quant Finance

A finance toolkit for recording transactions, categorizing expenses, tracking budgets, forecasting trends, and managing tax notes. Build a complete financial journal from the command line with persistent local storage.

## Quick Start

```bash
bash scripts/script.sh <command> [args...]
```

## Commands

**Transaction & Categorization**
- `record <input>` — Record a financial transaction or data point (without args: show recent records)
- `categorize <input>` — Categorize a transaction or expense (without args: show recent categorizations)
- `tax-note <input>` — Add a tax-related note or deduction record (without args: show recent tax notes)

**Balances & Budgets**
- `balance <input>` — Log a balance snapshot or reconciliation (without args: show recent balances)
- `budget-check <input>` — Record a budget check or spending limit review (without args: show recent budget checks)
- `summary <input>` — Create a financial summary entry (without args: show recent summaries)

**Analysis & Forecasting**
- `trend <input>` — Log a trend observation (without args: show recent trends)
- `forecast <input>` — Record a financial forecast or projection (without args: show recent forecasts)
- `compare <input>` — Log comparison data between periods or portfolios (without args: show recent comparisons)

**Alerting & History**
- `alert <input>` — Log a financial alert or threshold warning (without args: show recent alerts)
- `history <input>` — Add a historical note or record (without args: show recent history entries)

**Reporting & Export**
- `export-report <input>` — Record an export or report generation event (without args: show recent export reports)

**Utilities**
- `stats` — Show summary statistics across all entry types
- `export <fmt>` — Export all data (formats: `json`, `csv`, `txt`)
- `search <term>` — Search across all log files for a keyword
- `recent` — Show the 20 most recent activity log entries
- `status` — Display health check: version, data dir, entry count, disk usage
- `help` — Show available commands
- `version` — Print version (v2.0.0)

Each command accepts free-text input. When called without arguments, it displays the most recent 20 entries for that category.

## Data Storage

All data is stored as plain-text log files in:

```
~/.local/share/quant-finance/
├── record.log        # Financial transactions
├── categorize.log    # Categorization entries
├── tax-note.log      # Tax-related notes
├── balance.log       # Balance snapshots
├── budget-check.log  # Budget reviews
├── summary.log       # Financial summaries
├── trend.log         # Trend observations
├── forecast.log      # Financial forecasts
├── compare.log       # Period/portfolio comparisons
├── alert.log         # Financial alerts
├── history.log       # Unified activity history
├── export-report.log # Export/report events
└── history.log       # Unified activity history
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` — one line per record. The `history.log` file tracks all commands chronologically.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies, no network access required
- Write access to `~/.local/share/quant-finance/`

## When to Use

1. **Tracking daily financial transactions** — Use `record` and `categorize` to build a structured transaction journal for personal or business finances
2. **Budget monitoring and spending control** — Use `budget-check` and `balance` to log spending against limits and track account balances over time
3. **Financial forecasting and trend analysis** — Use `trend` and `forecast` to document observations about revenue patterns, market movements, or portfolio performance
4. **Tax preparation and deduction tracking** — Use `tax-note` to maintain a running log of deductible expenses, income events, and tax-relevant transactions throughout the year
5. **Portfolio comparison and reporting** — Use `compare` to contrast different time periods or investment strategies, then `export csv` to generate data for spreadsheets or external analysis tools

## Examples

```bash
# Record a transaction
quant-finance record "AAPL buy 100 shares @ $185.50, total $18,550"

# Categorize an expense
quant-finance categorize "AWS hosting: $450/month → infrastructure"

# Log a budget check
quant-finance budget-check "Q1 marketing: $12,000 of $15,000 budget used (80%)"

# Track a trend
quant-finance trend "Revenue up 15% MoM, driven by enterprise segment"

# Add a tax note
quant-finance tax-note "Home office deduction: 200 sq ft, $1,500 annual"

# View summary statistics
quant-finance stats

# Export all data as JSON
quant-finance export json

# Search for entries about a specific stock
quant-finance search "AAPL"
```

## Configuration

Set `QUANT_FINANCE_DIR` environment variable to override the default data directory. Default: `~/.local/share/quant-finance/`

## Output

All commands output to stdout. Redirect to a file with `quant-finance <command> > output.txt`. Export formats (json, csv, txt) write to the data directory and report the output path and file size.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
