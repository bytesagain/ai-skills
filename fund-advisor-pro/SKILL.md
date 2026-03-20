---
version: "2.0.0"
name: Fund Advisor
description: "Calculate DCA with annualized rates and plan rebalancing strategies easily. Use when modeling growth, comparing allocations, or simulating drawdown scenarios."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Fund Advisor Pro

Financial tracking and analysis tool. Record transactions, check balances, view summaries, manage budgets, set alerts, compare periods, forecast trends, and categorize spending — all from the command line with local storage.

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `track` | `fund-advisor-pro track <description> <amount>` | Record a transaction with description and amount |
| `balance` | `fund-advisor-pro balance` | Show current balance (references local ledger) |
| `summary` | `fund-advisor-pro summary` | Financial summary for current period (income vs expenses) |
| `export` | `fund-advisor-pro export` | Export transaction data to CSV format |
| `budget` | `fund-advisor-pro budget` | Budget overview — category, budget, spent, remaining |
| `history` | `fund-advisor-pro history` | Show the 20 most recent transactions from data log |
| `alert` | `fund-advisor-pro alert <item> <threshold>` | Set a price or budget alert for an item at a threshold |
| `compare` | `fund-advisor-pro compare` | Compare current period vs previous period |
| `forecast` | `fund-advisor-pro forecast` | Simple trend-based financial projection |
| `categories` | `fund-advisor-pro categories` | List spending categories (Food, Transport, Housing, etc.) |
| `help` | `fund-advisor-pro help` | Show help with all available commands |
| `version` | `fund-advisor-pro version` | Print version string |

## Data Storage

All data is stored locally at `~/.local/share/fund-advisor-pro/` (override with `FUND_ADVISOR_PRO_DIR` env var):

- `data.log` — Main transaction and data log
- `history.log` — Unified activity log across all commands
- Follows XDG Base Directory spec (`XDG_DATA_HOME` supported)

No cloud services, no network calls, no external API calls needed. Fully offline.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `tail`, `cat`)
- No external dependencies or API keys

## When to Use

1. **Tracking daily expenses** — Use `fund-advisor-pro track "lunch" 35` to record each transaction with a description and amount, building a local spending diary.
2. **Monthly budget reviews** — Use `fund-advisor-pro budget` to see category-level budget vs actual spending, then `fund-advisor-pro summary` for the overall period picture.
3. **Setting spending alerts** — Use `fund-advisor-pro alert "dining" 2000` to set thresholds and get notified when spending approaches limits.
4. **Period-over-period comparison** — Use `fund-advisor-pro compare` to see how current spending stacks up against the previous period and spot trends.
5. **Exporting data for external analysis** — Use `fund-advisor-pro export` to dump all transactions as CSV for import into spreadsheets or BI tools.

## Examples

```bash
# Record a transaction
fund-advisor-pro track "grocery shopping" 150

# Check current balance
fund-advisor-pro balance

# View financial summary for current month
fund-advisor-pro summary

# See budget breakdown by category
fund-advisor-pro budget

# View last 20 transactions
fund-advisor-pro history

# Set an alert
fund-advisor-pro alert "entertainment" 500

# Compare current vs previous period
fund-advisor-pro compare

# Get a simple forecast
fund-advisor-pro forecast

# List all spending categories
fund-advisor-pro categories

# Export all data as CSV
fund-advisor-pro export
```

## How It Works

Fund Advisor Pro stores all data locally in `~/.local/share/fund-advisor-pro/`. Every command logs its activity to `history.log` with timestamps in `MM-DD HH:MM` format. The main `data.log` file holds transaction records. All operations are purely local — no network access, no external APIs.

## Notes

- All financial projections are simplified estimates, not professional financial advice
- Data is stored as plain text logs for easy inspection and portability
- ⚠️ This is a tracking tool, not investment advice — consult a professional for financial decisions

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
