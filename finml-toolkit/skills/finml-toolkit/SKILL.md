---
version: "1.0.0"
name: Financial Machine Learning
description: "A curated list of practical financial machine learning tools and applications. financial machine learning, python, algorithmic-trading, cryptocurrency."
---
# FinML Toolkit

A utility toolkit for logging, tracking, and managing financial ML operations. Each command records timestamped entries to its own log file for auditing and review.

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `run <input>` | Log a run entry (view recent entries if no input given) |
| `check <input>` | Log a check entry for verification tasks |
| `convert <input>` | Log a convert entry for format conversion tasks |
| `analyze <input>` | Log an analyze entry for analysis tasks |
| `generate <input>` | Log a generate entry for generation tasks |
| `preview <input>` | Log a preview entry for preview tasks |
| `batch <input>` | Log a batch entry for batch processing tasks |
| `compare <input>` | Log a compare entry for comparison tasks |
| `export <input>` | Log an export entry for export tasks |
| `config <input>` | Log a config entry for configuration tasks |
| `status <input>` | Log a status entry for status tracking |
| `report <input>` | Log a report entry for reporting tasks |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Search all log entries for a term (case-insensitive) |
| `recent` | Show the 20 most recent entries from history |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show available commands |
| `version` | Show version (v2.0.0) |

## Data Storage

All data is stored in `~/.local/share/finml-toolkit/`:

- Each command writes to its own log file (e.g., `run.log`, `check.log`, `analyze.log`)
- All actions are also recorded in `history.log` with timestamps
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`
- Log format: `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)

## Requirements

- Bash (no external dependencies)
- Works on Linux and macOS

## When to Use

- When you need to log and track financial ML operations over time
- To maintain an audit trail of run, check, convert, analyze, or generate actions
- When you want to search or export historical operation records
- For batch tracking of ML processing pipelines
- To compare and report on financial data processing tasks
- When managing configurations for finml workflows

## Examples

```bash
# Log operations
finml-toolkit run "backtest strategy alpha-3"
finml-toolkit check "validate portfolio weights"
finml-toolkit convert "csv to parquet format"
finml-toolkit analyze "correlation matrix on sector data"
finml-toolkit generate "monthly performance report"
finml-toolkit batch "process all Q4 earnings files"
finml-toolkit compare "strategy A vs strategy B returns"
finml-toolkit config "set risk_threshold=0.05"

# View recent entries for a command (no args)
finml-toolkit run
finml-toolkit analyze

# Search and export
finml-toolkit search "portfolio"
finml-toolkit export json
finml-toolkit stats
finml-toolkit recent
finml-toolkit status
```

## Configuration

Set `FINML_TOOLKIT_DIR` environment variable to change the data directory. Default: `~/.local/share/finml-toolkit/`

## Output

All commands output to stdout. Redirect with `finml-toolkit run > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
