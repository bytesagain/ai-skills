---
version: "2.0.0"
name: Crypto Tax Calculator
description: "Calculate crypto taxes by importing trades and generating tax reports. Use when importing trades, calculating gains, generating tax reports."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Crypto Tax Calculator

A financial tracking and analysis tool for recording transactions, managing budgets, reviewing spending categories, generating summaries, and forecasting trends. Crypto Tax Calculator provides 10 focused commands for personal financial management with local data storage.

## Commands

| Command | Description |
|---------|-------------|
| `crypto-tax-calc track <description> <amount>` | Record a transaction with a description and amount |
| `crypto-tax-calc balance` | Show current balance information (references local ledger) |
| `crypto-tax-calc summary` | Display a financial summary for the current month (income vs expenses) |
| `crypto-tax-calc export` | Export transaction data to CSV format (outputs to stdout) |
| `crypto-tax-calc budget` | Show budget overview with category breakdown (budget, spent, remaining) |
| `crypto-tax-calc history` | Display the 20 most recent transactions from the data log |
| `crypto-tax-calc alert <item> <threshold>` | Set a price or budget alert for a specific item at a given threshold |
| `crypto-tax-calc compare` | Compare the current period against the previous period |
| `crypto-tax-calc forecast` | Generate a simple financial forecast based on current trends |
| `crypto-tax-calc categories` | Display available spending categories (Food, Transport, Housing, Entertainment, Savings) |
| `crypto-tax-calc help` | Display available commands and usage information |
| `crypto-tax-calc version` | Print current version (v2.0.0) |

## Data Storage

All data is stored locally in plain-text files:

- **Location**: `~/.local/share/crypto-tax-calc/` (override with `CRYPTO_TAX_CALC_DIR` env var, or `XDG_DATA_HOME`)
- **Data file**: `data.log` — main transaction ledger
- **History log**: `history.log` — timestamped operation log for audit trail
- **Format**: Pipe-delimited entries with timestamps
- **No cloud sync** — everything stays on your machine, no API keys needed

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `tail`, `cat`
- No external dependencies, no API keys, no network access required
- Works on Linux and macOS

## When to Use

1. **Transaction logging** — Record daily purchases, income, and transfers with `crypto-tax-calc track` to build a thorough financial history
2. **Budget monitoring** — Use `budget` and `categories` to review spending by category and see where your money goes each month
3. **Monthly summaries** — Run `summary` to get a quick income-vs-expenses overview for the current period without opening a spreadsheet
4. **Period comparison** — Use `compare` to see how your current spending and income stack up against the previous period and spot trends
5. **Data export** — Use `export` to generate CSV output that can be imported into spreadsheets, tax software, or other financial tools

## Examples

```bash
# Record a transaction
crypto-tax-calc track "coffee shop" 4.50

# Check your current balance
crypto-tax-calc balance

# View monthly financial summary
crypto-tax-calc summary

# Export all transactions to CSV (pipe to file)
crypto-tax-calc export > transactions.csv

# Review budget breakdown by category
crypto-tax-calc budget

# View recent transaction history
crypto-tax-calc history

# Set a price alert
crypto-tax-calc alert "BTC" 70000

# Compare current vs previous period
crypto-tax-calc compare

# Get a simple forecast based on trends
crypto-tax-calc forecast

# View available spending categories
crypto-tax-calc categories
```

## Configuration

Set the `CRYPTO_TAX_CALC_DIR` environment variable to change the data directory. Alternatively, set `XDG_DATA_HOME` to relocate all XDG-compliant app data. Default location: `~/.local/share/crypto-tax-calc/`

## Disclaimer

⚠️ This tool is for **informational and personal tracking purposes only**. It is NOT financial or tax advice. Always consult a qualified professional for tax filing and financial decisions.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
