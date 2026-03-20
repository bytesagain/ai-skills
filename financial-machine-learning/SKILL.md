---
name: Financial Machine Learning
description: "Explore curated financial ML tools for trading, risk models, and predictions. Use when building models, benchmarking accuracy, or researching quant tools."
version: "1.0.0"
license: MIT-0
runtime: python3
---
# Financial Machine Learning

An AI toolkit for logging, tracking, and managing financial machine learning operations. Each command records timestamped entries to its own log file for auditing and review.

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `configure <input>` | Log a configuration entry (view recent entries if no input given) |
| `benchmark <input>` | Log a benchmark entry for performance testing |
| `compare <input>` | Log a compare entry for model comparison tasks |
| `prompt <input>` | Log a prompt entry for prompt engineering tasks |
| `evaluate <input>` | Log an evaluate entry for model evaluation |
| `fine-tune <input>` | Log a fine-tune entry for model fine-tuning tasks |
| `analyze <input>` | Log an analyze entry for data analysis |
| `cost <input>` | Log a cost entry for cost tracking |
| `usage <input>` | Log a usage entry for usage monitoring |
| `optimize <input>` | Log an optimize entry for optimization tasks |
| `test <input>` | Log a test entry for testing tasks |
| `report <input>` | Log a report entry for reporting |

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

All data is stored in `~/.local/share/financial-machine-learning/`:

- Each command writes to its own log file (e.g., `configure.log`, `benchmark.log`, `fine-tune.log`)
- All actions are also recorded in `history.log` with timestamps
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`
- Log format: `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)

## Requirements

- Bash (no external dependencies)
- Works on Linux and macOS

## When to Use

- When you need to track financial ML experiments (benchmarks, fine-tuning, evaluations)
- To maintain an audit trail of model configurations and prompt engineering
- When comparing model performance across different runs
- For tracking costs and usage across ML operations
- To search or export historical experiment records
- When building a log of optimization and testing iterations

## Examples

```bash
# Log ML operations
financial-machine-learning configure "set learning_rate=0.001"
financial-machine-learning benchmark "GPT-4 accuracy test on portfolio data"
financial-machine-learning fine-tune "BERT model on earnings calls"
financial-machine-learning evaluate "backtest Q3 predictions"
financial-machine-learning compare "LSTM vs transformer on forex data"
financial-machine-learning cost "API usage March 2025: $142"
financial-machine-learning optimize "hyperparameter sweep batch 3"
financial-machine-learning prompt "risk assessment template v2"

# View recent entries for a command (no args)
financial-machine-learning benchmark
financial-machine-learning cost

# Search and export
financial-machine-learning search "BERT"
financial-machine-learning export csv
financial-machine-learning stats
financial-machine-learning recent
financial-machine-learning status
```

## Configuration

Set `FINANCIAL_MACHINE_LEARNING_DIR` environment variable to change the data directory. Default: `~/.local/share/financial-machine-learning/`

## Output

All commands output to stdout. Redirect with `financial-machine-learning report > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
