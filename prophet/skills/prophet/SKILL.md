---
name: Prophet
description: "Forecast time-series data with seasonal trend modeling. Use when predicting sales, checking model accuracy, converting frequencies, analyzing growth."
version: "1.0.0"
license: MIT
runtime: python3
---

# Prophet

A utility toolkit for running, checking, converting, analyzing, and generating time-series forecasts. Record predictions, compare models, batch-process data, and generate reports — all from the command line with persistent local storage.

## Quick Start

```bash
bash scripts/script.sh <command> [args...]
```

## Commands

**Core Operations**
- `run <input>` — Execute and record a forecast run (without args: show recent runs)
- `check <input>` — Log a validation or accuracy check (without args: show recent checks)
- `convert <input>` — Record a data conversion or frequency change (without args: show recent conversions)
- `analyze <input>` — Log an analysis finding (without args: show recent analyses)
- `generate <input>` — Record generated output such as forecast data (without args: show recent generations)
- `preview <input>` — Log a preview or dry-run result (without args: show recent previews)

**Batch & Comparison**
- `batch <input>` — Record a batch processing job (without args: show recent batch entries)
- `compare <input>` — Log comparison data between models or runs (without args: show recent comparisons)

**Configuration & Reporting**
- `export <input>` — Record an export operation (without args: show recent exports)
- `config <input>` — Log a configuration change (without args: show recent config entries)
- `status <input>` — Record a status observation (without args: show recent status entries)
- `report <input>` — Create a summary report entry (without args: show recent reports)

**Utilities**
- `stats` — Show summary statistics across all entry types
- `export <fmt>` — Export all data (formats: `json`, `csv`, `txt`) via the built-in export function
- `search <term>` — Search across all log files for a keyword
- `recent` — Show the 20 most recent activity log entries
- `status` — Display health check: version, data dir, entry count, disk usage (via built-in status function)
- `help` — Show available commands
- `version` — Print version (v2.0.0)

Each command accepts free-text input. When called without arguments, it displays the most recent 20 entries for that category.

> **Note:** The script has both a `status` subcommand (for recording status notes) and a built-in `_status` health-check function. Similarly, `export` serves as both a data-recording subcommand and a built-in export-to-file function.

## Data Storage

All data is stored as plain-text log files in:

```
~/.local/share/prophet/
├── run.log           # Forecast run records
├── check.log         # Validation and accuracy checks
├── convert.log       # Data conversion records
├── analyze.log       # Analysis findings
├── generate.log      # Generated forecast data
├── preview.log       # Preview and dry-run results
├── batch.log         # Batch processing jobs
├── compare.log       # Model comparison data
├── export.log        # Export operation records
├── config.log        # Configuration changes
├── status.log        # Status observations
├── report.log        # Summary reports
└── history.log       # Unified activity history
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` — one line per record. The `history.log` file tracks all commands chronologically.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies, no network access required
- Write access to `~/.local/share/prophet/`

## When to Use

1. **Tracking forecast experiments** — Use `run` and `check` to log forecast runs and validation results for systematic comparison over time
2. **Converting time-series frequencies** — Use `convert` to document frequency changes (daily → weekly, hourly → daily) and their impact on predictions
3. **Batch forecasting pipelines** — Use `batch` to record batch jobs across multiple datasets or product lines, then `compare` to contrast results
4. **Analyzing seasonal trends** — Use `analyze` to log observations about seasonality, growth patterns, and anomalies discovered during data exploration
5. **Building forecast reports** — Use `report` and `export json` to generate structured summaries for stakeholders, combining run results with configuration notes

## Examples

```bash
# Run a forecast and record it
prophet run "Q3 2025 sales forecast: 12,500 units, MAPE 4.2%"

# Log a validation check
prophet check "Holdout test: predicted 8,200 vs actual 8,450, error 2.96%"

# Record a frequency conversion
prophet convert "Converted daily sales to weekly aggregates for smoother trend"

# Analyze seasonal patterns
prophet analyze "Strong weekly seasonality detected: peaks Mon/Tue, trough Sat/Sun"

# Compare two model configurations
prophet compare "Multiplicative vs additive seasonality: multiplicative MAPE 3.1% vs 4.7%"

# View summary statistics
prophet stats

# Export all data as CSV
prophet export csv

# Search for entries about a specific metric
prophet search "MAPE"
```

## Configuration

Set `PROPHET_DIR` environment variable to override the default data directory. Default: `~/.local/share/prophet/`

## Output

All commands output to stdout. Redirect to a file with `prophet <command> > output.txt`. Export formats (json, csv, txt) write to the data directory and report the output path and file size.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
