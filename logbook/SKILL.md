---
name: LogBook
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["journal","diary","log","daily","writing","personal","productivity","notes"]
categories: ["Personal Management", "Productivity", "Writing"]
description: "Write journal entries, search history, and export your personal log digitally. Use when journaling thoughts, searching past entries, exporting notes."
---

# LogBook

LogBook is a data processing and analysis toolkit for querying, importing, exporting, transforming, validating, and visualizing datasets from the terminal. It provides 10 core commands for working with structured data, plus built-in history logging and a quick dashboard view. All operations are local — no external APIs, databases, or network connections required.

## Commands

| Command | Description |
|---------|-------------|
| `logbook query <args>` | Query data from the local data store. Logs the query action to history for auditing. |
| `logbook import <file>` | Import a data file into the local store. Accepts any file path as input. |
| `logbook export <dest>` | Export processed results to a specified destination (defaults to stdout). |
| `logbook transform <src> <dst>` | Transform data from one format or structure to another. |
| `logbook validate <args>` | Validate data against the built-in schema. Reports schema compliance status. |
| `logbook stats <args>` | Display basic statistics — total record count from the data log. |
| `logbook schema <args>` | Show the current data schema. Default fields: `id, name, value, timestamp`. |
| `logbook sample <args>` | Preview the first 5 records from the data store, or "No data" if the store is empty. |
| `logbook clean <args>` | Clean and deduplicate the data store, removing redundant entries. |
| `logbook dashboard <args>` | Quick dashboard showing total record count and summary metrics. |
| `logbook help` | Show help with all available commands and usage information. |
| `logbook version` | Print version string (`logbook v2.0.0`). |

## Data Storage

All data is stored locally in `~/.local/share/logbook/` (override with `LOGBOOK_DIR` or `XDG_DATA_HOME` environment variables).

**Directory structure:**
```
~/.local/share/logbook/
├── data.log         # Main data store (line-based records)
└── history.log      # Unified activity log with timestamps
```

Every command logs its action to `history.log` with a timestamp (`MM-DD HH:MM`) for full traceability. The main data file `data.log` holds all imported and processed records.

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `head`, `du`, `echo`
- No external dependencies, databases, or API keys required
- Optional: Set `LOGBOOK_DIR` environment variable to customize the data directory location

## When to Use

1. **Importing and querying datasets** — Pull in CSV, log, or structured data files and run quick queries against them from the terminal without needing a full database setup.
2. **Data validation workflows** — Validate incoming data against the built-in schema (`id, name, value, timestamp`) before processing to catch format issues early.
3. **Data transformation pipelines** — Transform data between formats or structures as part of an ETL-like workflow, all within a lightweight bash script.
4. **Quick dashboard and statistics** — Get instant record counts and summary metrics via `dashboard` or `stats` without writing custom aggregation scripts.
5. **Data cleanup and deduplication** — Use `clean` to remove duplicate records and normalize the data store before exporting or feeding into downstream analysis.

## Examples

```bash
# Import a data file
logbook import transactions.csv

# Query the data store
logbook query "status=active"

# View the data schema
logbook schema

# Preview first 5 records
logbook sample

# Get basic statistics (record count)
logbook stats

# Transform data between formats
logbook transform raw.csv cleaned.csv

# Validate data integrity against schema
logbook validate

# Quick dashboard view
logbook dashboard

# Export results
logbook export results.json

# Clean and deduplicate the data store
logbook clean

# Show version
logbook version
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LOGBOOK_DIR` | Custom data directory path | `~/.local/share/logbook` |
| `XDG_DATA_HOME` | XDG base data directory (fallback) | `~/.local/share` |

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
