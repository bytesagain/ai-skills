---
name: DataView
description: "Explore CSV and JSON files with quick queries, filters, and aggregation. Use when inspecting data, running queries, filtering rows, aggregating."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["data","csv","json","analysis","statistics","viewer","explorer","developer"]
categories: ["Developer Tools", "Data Analysis", "Utility"]
---

# DataView

A data processing toolkit for ingesting, transforming, querying, and managing data entries from the command line. All operations are logged with timestamps and stored locally.

## Commands

### Data Operations

Each data command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `dataview ingest <input>` | Ingest data — record a new ingest entry or view recent ones |
| `dataview transform <input>` | Transform data — record a transformation or view recent ones |
| `dataview query <input>` | Query data — record a query or view recent ones |
| `dataview filter <input>` | Filter data — record a filter operation or view recent ones |
| `dataview aggregate <input>` | Aggregate data — record an aggregation or view recent ones |
| `dataview visualize <input>` | Visualize data — record a visualization or view recent ones |
| `dataview export <input>` | Export data — record an export entry or view recent ones |
| `dataview sample <input>` | Sample data — record a sample or view recent ones |
| `dataview schema <input>` | Schema management — record a schema entry or view recent ones |
| `dataview validate <input>` | Validate data — record a validation or view recent ones |
| `dataview pipeline <input>` | Pipeline management — record a pipeline step or view recent ones |
| `dataview profile <input>` | Profile data — record a profile or view recent ones |

### Utility Commands

| Command | Description |
|---------|-------------|
| `dataview stats` | Show summary statistics — entry counts per category, total entries, disk usage |
| `dataview export <fmt>` | Export all data to a file (formats: `json`, `csv`, `txt`) |
| `dataview search <term>` | Search all log files for a term (case-insensitive) |
| `dataview recent` | Show last 20 entries from activity history |
| `dataview status` | Health check — version, data directory, entry count, disk usage, last activity |
| `dataview help` | Show available commands |
| `dataview version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally at `~/.local/share/dataview/`:

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
- To maintain a searchable history of data viewing and analysis activities
- To export accumulated records in JSON, CSV, or plain text format
- As part of larger automation or data inspection workflows
- When you need a lightweight, local-only data operation tracker

## Examples

```bash
# Record a new ingest entry
dataview ingest "loaded sales_report.csv 2500 rows"

# View recent transform entries
dataview transform

# Record a query
dataview query "top 10 products by revenue"

# Filter data
dataview filter "region=APAC"

# Search across all logs
dataview search "sales"

# Export everything as CSV
dataview export csv

# Check overall statistics
dataview stats

# View recent activity
dataview recent

# Health check
dataview status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
