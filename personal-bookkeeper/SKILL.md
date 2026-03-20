---
version: "2.0.0"
name: personal-bookkeeper
description: "Record double-entry bookkeeping for personal finances. Use when logging transactions, categorizing accounts, balancing ledgers, trending expenses."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Personal Bookkeeper

A command-line finance toolkit for individuals and freelancers. Personal Bookkeeper provides 12 dedicated commands for recording transactions, categorizing expenses, checking balances, tracking trends, forecasting budgets, generating reports, and managing tax notes — all backed by simple timestamped log files.

## Commands

| Command | Description |
|---------|-------------|
| `personal-bookkeeper record <input>` | Record a financial transaction (income, expense, transfer). Without args, shows recent record entries. |
| `personal-bookkeeper categorize <input>` | Categorize a transaction (food, rent, transport, entertainment). Without args, shows recent entries. |
| `personal-bookkeeper balance <input>` | Log a balance snapshot (account balance, net worth checkpoint). Without args, shows recent balance entries. |
| `personal-bookkeeper trend <input>` | Record a spending or income trend observation. Without args, shows recent trend entries. |
| `personal-bookkeeper forecast <input>` | Log a budget forecast or projection. Without args, shows recent forecast entries. |
| `personal-bookkeeper export-report <input>` | Save a report entry (monthly summary, quarterly review). Without args, shows recent export-report entries. |
| `personal-bookkeeper budget-check <input>` | Record a budget check (over/under budget notes). Without args, shows recent budget-check entries. |
| `personal-bookkeeper summary <input>` | Log a financial summary (weekly recap, category totals). Without args, shows recent summary entries. |
| `personal-bookkeeper alert <input>` | Record a financial alert (overspending, low balance, due date). Without args, shows recent alert entries. |
| `personal-bookkeeper history <input>` | Log a history note or view recent history entries. |
| `personal-bookkeeper compare <input>` | Record period-over-period comparisons (this month vs last). Without args, shows recent compare entries. |
| `personal-bookkeeper tax-note <input>` | Save tax-related notes (deductible expenses, filing reminders). Without args, shows recent tax-note entries. |
| `personal-bookkeeper stats` | Show summary statistics across all categories — entry counts per log file, total entries, and data size. |
| `personal-bookkeeper export <fmt>` | Export all data to a file. Supported formats: `json`, `csv`, `txt`. |
| `personal-bookkeeper search <term>` | Search across all log files for a keyword (case-insensitive). |
| `personal-bookkeeper recent` | Show the 20 most recent entries from the activity history log. |
| `personal-bookkeeper status` | Health check — version, data directory, total entries, disk usage, last activity. |
| `personal-bookkeeper help` | Display the full help message with all available commands. |
| `personal-bookkeeper version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored as plain-text log files in `~/.local/share/personal-bookkeeper/`:

- Each command writes to its own log file (e.g. `record.log`, `categorize.log`, `tax-note.log`)
- Every action is also recorded in `history.log` with a timestamp
- Entries use the format `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)
- Export produces files at `~/.local/share/personal-bookkeeper/export.{json,csv,txt}`
- No database required — all data is grep-friendly and human-readable

## Requirements

- **Bash 4+** (uses `set -euo pipefail`)
- **Standard Unix utilities**: `date`, `wc`, `du`, `head`, `tail`, `grep`, `cat`, `cut`
- **No external dependencies** — pure bash, no Python, no API keys
- Works on **Linux** and **macOS**

## When to Use

1. **Daily expense tracking** — Use `record` every time you make a purchase, then `categorize` to tag it (food, transport, entertainment) for end-of-month analysis.
2. **Monthly budget reviews** — Run `budget-check` to note whether you're over or under budget, `summary` to log category totals, and `compare` to see this month vs. last.
3. **Tax season preparation** — Use `tax-note` throughout the year to flag deductible expenses, then `export csv` to hand your accountant a clean spreadsheet.
4. **Financial forecasting** — Log `forecast` entries with projected income and expenses for upcoming months, then `trend` to track whether actuals match your projections.
5. **Freelancer income management** — `record` each invoice payment, `balance` to snapshot your account after deposits, and `alert` to flag overdue invoices or low cash reserves.

## Examples

```bash
# Record a grocery expense
personal-bookkeeper record "Groceries at Costco -¥358.50"

# Categorize a transaction
personal-bookkeeper categorize "Costco receipt -> food/groceries"

# Check if you're on budget this month
personal-bookkeeper budget-check "March budget: spent ¥4200 of ¥5000 limit"

# Add a tax-deductible note
personal-bookkeeper tax-note "Home office internet bill ¥199/mo — deductible"

# Export everything to CSV for spreadsheet review
personal-bookkeeper export csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
