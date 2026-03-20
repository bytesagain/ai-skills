---
name: Datasets
description: "Browse and load ready-to-use AI/ML datasets with fast manipulation. Use when searching datasets, loading training data, transforming formats."
version: "1.0.0"
license: Apache-2.0
runtime: python3
---

# Datasets

A data processing toolkit for ingesting, transforming, querying, and managing dataset entries from the command line. All operations are logged with timestamps and stored locally.

## Commands

### Data Operations

Each data command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `datasets ingest <input>` | Ingest data — record a new ingest entry or view recent ones |
| `datasets transform <input>` | Transform data — record a transformation or view recent ones |
| `datasets query <input>` | Query data — record a query or view recent ones |
| `datasets filter <input>` | Filter data — record a filter operation or view recent ones |
| `datasets aggregate <input>` | Aggregate data — record an aggregation or view recent ones |
| `datasets visualize <input>` | Visualize data — record a visualization or view recent ones |
| `datasets export <input>` | Export data — record an export entry or view recent ones |
| `datasets sample <input>` | Sample data — record a sample or view recent ones |
| `datasets schema <input>` | Schema management — record a schema entry or view recent ones |
| `datasets validate <input>` | Validate data — record a validation or view recent ones |
| `datasets pipeline <input>` | Pipeline management — record a pipeline step or view recent ones |
| `datasets profile <input>` | Profile data — record a profile or view recent ones |

### Utility Commands

| Command | Description |
|---------|-------------|
| `datasets stats` | Show summary statistics — entry counts per category, total entries, disk usage |
| `datasets export <fmt>` | Export all data to a file (formats: `json`, `csv`, `txt`) |
| `datasets search <term>` | Search all log files for a term (case-insensitive) |
| `datasets recent` | Show last 20 entries from activity history |
| `datasets status` | Health check — version, data directory, entry count, disk usage, last activity |
| `datasets help` | Show available commands |
| `datasets version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally at `~/.local/share/datasets/`:

- Each data command writes to its own log file (e.g., `ingest.log`, `transform.log`)
- Entries are stored as `timestamp|value` pairs (pipe-delimited)
- All actions are tracked in `history.log` with timestamps
- Export generates files in the data directory (`export.json`, `export.csv`, or `export.txt`)

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`
- No external dependencies or API keys required

## When to Use

- To log and track data processing operations (ingest, transform, query, etc.)
- To maintain a searchable history of data pipeline activities
- To export accumulated records in JSON, CSV, or plain text format
- As part of larger automation or data-pipeline workflows
- When you need a lightweight, local-only dataset operation tracker

## Examples

```bash
# Record a new ingest entry
datasets ingest "loaded training_data.csv 10000 rows"

# View recent transform entries
datasets transform

# Record a query
datasets query "filter by date > 2026-01-01"

# Search across all logs
datasets search "training"

# Export everything as JSON
datasets export json

# Check overall statistics
datasets stats

# View recent activity
datasets recent

# Health check
datasets status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
