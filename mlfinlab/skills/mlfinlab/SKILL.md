---
name: Mlfinlab
description: "Apply ML to finance with portfolio optimization, signals, and backtesting tools. Use when building trading models, optimizing portfolios, backtesting."
version: "1.0.0"
license: NOASSERTION
runtime: python3
---

# Mlfinlab

A utility toolkit for applying machine learning to finance. Run analyses, check models, convert data formats, generate reports, and manage configurations — all from the command line. Designed for portfolio managers and traders who want reproducible, interpretable ML workflows.

## Commands

| Command | Description |
|---------|-------------|
| `mlfinlab run <input>` | Run an ML finance operation or record an execution |
| `mlfinlab check <input>` | Check model validity, data integrity, or prerequisites |
| `mlfinlab convert <input>` | Convert data between formats or record a conversion step |
| `mlfinlab analyze <input>` | Analyze financial data, signals, or model outputs |
| `mlfinlab generate <input>` | Generate reports, features, or synthetic data |
| `mlfinlab preview <input>` | Preview results before committing a full run |
| `mlfinlab batch <input>` | Run batch operations across multiple datasets or models |
| `mlfinlab compare <input>` | Compare model results, strategies, or portfolios |
| `mlfinlab export <input>` | Record an export operation or export all data |
| `mlfinlab config <input>` | Manage configuration entries and settings |
| `mlfinlab status <input>` | Log a status check or system state |
| `mlfinlab report <input>` | Generate or record a summary report |
| `mlfinlab stats` | Show summary statistics across all entry types |
| `mlfinlab export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `mlfinlab search <term>` | Search across all entries by keyword |
| `mlfinlab recent` | Show the 20 most recent activity log entries |
| `mlfinlab status` | Health check — version, disk usage, last activity |
| `mlfinlab help` | Show the built-in help message |
| `mlfinlab version` | Print the current version (v2.0.0) |

Each domain command (run, check, analyze, etc.) works in two modes:
- **Without arguments** — displays the 20 most recent entries of that type
- **With arguments** — saves the input as a new timestamped entry

## Data Storage

All data is stored as plain-text log files in `~/.local/share/mlfinlab/`:

- Each command type gets its own log file (e.g., `run.log`, `analyze.log`, `compare.log`)
- Entries are stored in `timestamp|value` format for easy parsing
- A unified `history.log` tracks all activity across command types
- Export to JSON, CSV, or TXT at any time with the `export` command

Set the `MLFINLAB_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Building quantitative trading models** — use `run` and `analyze` to log ML model training runs on financial data (returns prediction, volatility forecasting, signal extraction)
2. **Comparing portfolio strategies** — use `compare` to record side-by-side comparisons of different allocation strategies, risk metrics, or factor exposures
3. **Batch backtesting** — use `batch` to log large-scale backtesting runs across multiple assets, timeframes, or parameter grids
4. **Generating financial reports** — use `report` and `generate` to document performance summaries, risk analyses, and feature importance rankings
5. **Auditing your ML finance workflow** — use `search`, `recent`, and `stats` to trace every operation, find specific analyses, and track productivity over time

## Examples

```bash
# Log an analysis run
mlfinlab analyze "Mean-variance optimization on SP500 constituents — Sharpe ratio 1.42"

# Record a model comparison
mlfinlab compare "LSTM vs GBM for 5-day return prediction: LSTM RMSE 0.032, GBM RMSE 0.028"

# Run a batch backtesting session
mlfinlab batch "Backtest momentum strategy across 50 ETFs, 2015-2024, monthly rebalance"

# Generate a report entry
mlfinlab report "Q4 portfolio performance: +8.3% return, max drawdown -4.1%, Sharpe 1.87"

# Export all entries as CSV
mlfinlab export csv
```

## Output

All commands print results to stdout. Redirect to a file if needed:

```bash
mlfinlab stats > finlab-report.txt
mlfinlab export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
