---
version: "2.0.0"
name: Mortgage Calculator
description: "Calculate mortgage payments with equal-principal and equal-interest comparisons. Use when comparing loans, calculating payments, evaluating prepayment."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Mortgage Calculator

Multi-purpose utility tool for managing structured data entries related to mortgage and financial calculations. Add, list, search, remove, and export data items — all stored locally in a simple log-based format with full history tracking.

## Commands

All commands are invoked via `mortgage-calculator <command> [args]`.

| Command | Description |
|---------|-------------|
| `run <args>` | Execute the main function — logs and confirms execution of the specified operation |
| `config` | Show the configuration file path (`$DATA_DIR/config.json`) |
| `status` | Show current status (reports "ready" when the tool is operational) |
| `init` | Initialize the data directory (creates the data folder if it doesn't exist) |
| `list` | List all data entries from the data log file |
| `add <text>` | Add a new dated entry to the data log (auto-prefixed with `YYYY-MM-DD`) |
| `remove <item>` | Remove an entry and log the removal |
| `search <term>` | Search the data log for a keyword (case-insensitive match via `grep -i`) |
| `export` | Export all data from the data log to stdout |
| `info` | Show current version number and data directory path |
| `help` | Show the built-in help message with all available commands |
| `version` | Print version string (`mortgage-calculator v2.0.0`) |

## Data Storage

- **Location:** `~/.local/share/mortgage-calculator/` (override with `MORTGAGE_CALCULATOR_DIR` environment variable, or `XDG_DATA_HOME`)
- **Data log:** `data.log` — stores all entries added via `add`, one per line, prefixed with `YYYY-MM-DD`
- **History:** `history.log` — every command execution is recorded with a timestamp (`MM-DD HH:MM command: details`) for auditing
- **Format:** Plain text, one entry per line, human-readable

## Requirements

- Bash 4+
- Standard Unix utilities (`date`, `grep`, `cat`, `echo`)
- No external dependencies, no API keys, no network access needed

## When to Use

1. **Financial record keeping** — Use `mortgage-calculator add` to log mortgage-related events (payments made, rate changes, lender communications) and build a local history
2. **Payment tracking** — Record monthly payments, extra payments, or escrow changes with `add`, then review the full log with `list`
3. **Comparison notes** — Store notes from different loan scenarios or lender quotes using `add`, then `search` to find specific terms or rates
4. **Data export for spreadsheets** — Use `mortgage-calculator export` to dump all entries to stdout and redirect to a file for import into Excel or Google Sheets
5. **Automation and scripting** — Integrate `mortgage-calculator add` and `mortgage-calculator export` into shell scripts or cron jobs for automated financial logging workflows

## Examples

```bash
# Initialize the data directory
mortgage-calculator init

# Add a mortgage payment record
mortgage-calculator add "Monthly payment: ¥4,235.00 — principal ¥2,100 + interest ¥2,135"

# Add a rate change note
mortgage-calculator add "Rate adjusted from 3.85% to 3.50% effective 2025-01-01"

# Add a prepayment record
mortgage-calculator add "Prepayment: ¥50,000 applied to principal, new balance ¥680,000"

# List all entries
mortgage-calculator list

# Search for entries about rate changes
mortgage-calculator search "rate"

# Search for prepayment records
mortgage-calculator search "prepayment"

# Export all data to a file
mortgage-calculator export > mortgage-history.txt

# Check current status
mortgage-calculator status

# Show version and data path
mortgage-calculator info

# Run a custom operation
mortgage-calculator run "quarterly review"
```

## Output

All command output goes to stdout. Redirect to save:

```bash
mortgage-calculator list > all-records.txt
mortgage-calculator export > backup.txt
```

## Configuration

Set the `MORTGAGE_CALCULATOR_DIR` environment variable to change the data directory:

```bash
export MORTGAGE_CALCULATOR_DIR="$HOME/my-mortgage-data"
mortgage-calculator init
```

Default location: `~/.local/share/mortgage-calculator/`

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
