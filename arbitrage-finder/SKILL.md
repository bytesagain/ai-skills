---
version: "2.0.0"
name: Arbitrage Finder
description: "Scan cross-exchange price gaps and score arbitrage profitability. Use when comparing crypto prices, tracking spreads, or evaluating trades."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Arbitrage Finder

A financial tracking and analysis tool for recording transactions, monitoring budgets, comparing spending periods, and generating simple forecasts. Provides a CLI interface for personal finance management with persistent local storage.

## Commands

| Command      | Description                                          |
|--------------|------------------------------------------------------|
| `track`      | Record a transaction with description and amount     |
| `balance`    | Show current balance from the ledger                 |
| `summary`    | Display financial summary for the current period     |
| `export`     | Export transaction data to CSV format                |
| `budget`     | Show budget overview by category with remaining      |
| `history`    | View recent transaction history (last 20 entries)    |
| `alert`      | Set a price or budget alert with threshold           |
| `compare`    | Compare spending between current and previous period |
| `forecast`   | Generate a simple financial forecast based on trends |
| `categories` | List all spending categories                         |
| `help`       | Show the help message with all available commands    |
| `version`    | Print the current version number                     |

## Data Storage

- **Data directory:** `~/.local/share/arbitrage-finder/` (override with `ARBITRAGE_FINDER_DIR` env variable)
- **Data log:** `$DATA_DIR/data.log` — stores transaction records
- **History log:** `$DATA_DIR/history.log` — tracks all command executions with timestamps
- **Ledger:** `$DATA_DIR/ledger` — balance tracking file

## Requirements

- Bash 4.0+
- Standard Unix utilities (`grep`, `cat`, `date`, `tail`)
- No API keys or external services needed
- Works on Linux and macOS

## When to Use

1. **Transaction tracking** — When you need to log income and expenses with timestamps and descriptions
2. **Budget monitoring** — When you want to see how much you've spent vs. budgeted across categories like Food, Transport, Housing, Entertainment, and Savings
3. **Period comparison** — When you need to compare your spending habits between the current and previous period to spot trends
4. **Data export** — When you need to export your financial records to CSV format for use in spreadsheets or other tools
5. **Financial forecasting** — When you want a quick projection based on historical spending trends

## Examples

```bash
# Record a transaction
arbitrage-finder track "Grocery shopping" 85.50

# Check current balance
arbitrage-finder balance

# View financial summary for the current month
arbitrage-finder summary

# View recent transaction history
arbitrage-finder history

# Set an alert for a budget threshold
arbitrage-finder alert "Food" 500

# Compare current vs previous period spending
arbitrage-finder compare

# List all spending categories
arbitrage-finder categories

# Export transactions to CSV
arbitrage-finder export > transactions.csv

# Generate a simple forecast
arbitrage-finder forecast
```

## Output

All command results are printed to stdout. You can redirect output with standard shell operators:

```bash
arbitrage-finder export > financial-data.csv
arbitrage-finder history | grep "Grocery"
```

## Configuration

Set the `ARBITRAGE_FINDER_DIR` environment variable to change the data directory:

```bash
export ARBITRAGE_FINDER_DIR="/custom/path/to/arbitrage-finder"
```

Default location: `~/.local/share/arbitrage-finder/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
