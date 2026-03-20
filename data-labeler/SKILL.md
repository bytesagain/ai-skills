---
version: "1.0.0"
name: Label Studio
description: "Label Studio is a multi-type data labeling and annotation tool with standardized output format label studio, typescript, annotation, annotation-tool."
---

# Data Labeler

A data processing and labeling toolkit for ingesting, transforming, querying, and managing data entries from the command line. All operations are logged with timestamps and stored locally.

## Commands

### Data Operations

Each data command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `data-labeler ingest <input>` | Ingest data — record a new ingest entry or view recent ones |
| `data-labeler transform <input>` | Transform data — record a transformation or view recent ones |
| `data-labeler query <input>` | Query data — record a query or view recent ones |
| `data-labeler filter <input>` | Filter data — record a filter operation or view recent ones |
| `data-labeler aggregate <input>` | Aggregate data — record an aggregation or view recent ones |
| `data-labeler visualize <input>` | Visualize data — record a visualization or view recent ones |
| `data-labeler export <input>` | Export data — record an export entry or view recent ones |
| `data-labeler sample <input>` | Sample data — record a sample or view recent ones |
| `data-labeler schema <input>` | Schema management — record a schema entry or view recent ones |
| `data-labeler validate <input>` | Validate data — record a validation or view recent ones |
| `data-labeler pipeline <input>` | Pipeline management — record a pipeline step or view recent ones |
| `data-labeler profile <input>` | Profile data — record a profile or view recent ones |

### Utility Commands

| Command | Description |
|---------|-------------|
| `data-labeler stats` | Show summary statistics — entry counts per category, total entries, disk usage |
| `data-labeler export <fmt>` | Export all data to a file (formats: `json`, `csv`, `txt`) |
| `data-labeler search <term>` | Search all log files for a term (case-insensitive) |
| `data-labeler recent` | Show last 20 entries from activity history |
| `data-labeler status` | Health check — version, data directory, entry count, disk usage, last activity |
| `data-labeler help` | Show available commands |
| `data-labeler version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally at `~/.local/share/data-labeler/`:

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
- When you need a lightweight, local-only data operation tracker

## Examples

```bash
# Record a new ingest entry
data-labeler ingest "loaded customer_data.csv 5000 rows"

# View recent transform entries
data-labeler transform

# Search across all logs
data-labeler search "customer"

# Export everything as JSON
data-labeler export json

# Check overall statistics
data-labeler stats

# View recent activity
data-labeler recent

# Health check
data-labeler status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
