---
name: LineCount
description: "Count source lines by language, exclude comments, and compare codebase sizes. Use when measuring codebase size, comparing projects, reporting LOC stats."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["code","lines","counter","statistics","developer","loc"]
categories: ["Developer Tools", "Utility"]
---
# LineCount

A data toolkit for ingesting, transforming, querying, filtering, aggregating, and managing structured data entries. Each command logs timestamped records to local files, supports viewing recent entries, and provides full export/search/stats capabilities.

## Commands

### Core Data Operations

| Command | Description |
|---------|-------------|
| `linecount ingest <input>` | Ingest a new data entry (or view recent ingests with no args) |
| `linecount transform <input>` | Record a transform operation on data |
| `linecount query <input>` | Log a query against stored data |
| `linecount filter <input>` | Apply and record a filter operation |
| `linecount aggregate <input>` | Record an aggregation step |
| `linecount visualize <input>` | Log a visualization task |
| `linecount export <input>` | Log an export operation entry |
| `linecount sample <input>` | Record a sampling operation |
| `linecount schema <input>` | Log a schema definition or change |
| `linecount validate <input>` | Record a validation check |
| `linecount pipeline <input>` | Log a pipeline execution step |
| `linecount profile <input>` | Record a data profiling result |

### Utility Commands

| Command | Description |
|---------|-------------|
| `linecount stats` | Show summary statistics across all log files |
| `linecount export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `linecount search <term>` | Search all entries for a keyword (case-insensitive) |
| `linecount recent` | Show the 20 most recent activity log entries |
| `linecount status` | Health check: version, entry count, disk usage, last activity |
| `linecount help` | Display full command reference |
| `linecount version` | Print current version (v2.0.0) |

## How It Works

Every core command accepts free-text input. When called with arguments, LineCount:

1. Timestamps the entry (`YYYY-MM-DD HH:MM`)
2. Appends it to the command-specific log file (e.g. `ingest.log`, `transform.log`)
3. Records the action in a central `history.log`
4. Reports the saved entry and running total

When called with **no arguments**, each command displays the 20 most recent entries from its log file.

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/linecount/
├── ingest.log        # Ingested data entries
├── transform.log     # Transform operations
├── query.log         # Query records
├── filter.log        # Filter operations
├── aggregate.log     # Aggregation steps
├── visualize.log     # Visualization tasks
├── export.log        # Export operation entries
├── sample.log        # Sampling records
├── schema.log        # Schema definitions
├── validate.log      # Validation checks
├── pipeline.log      # Pipeline execution steps
├── profile.log       # Profiling results
├── history.log       # Central activity log
└── export.{json,csv,txt}  # Exported snapshots
```

Each log uses pipe-delimited format: `timestamp|value`.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `wc`, `du`, `grep`, `tail`, `date`, `sed`
- No external dependencies — pure bash

## When to Use

1. **Tracking data pipeline steps** — log each ingest, transform, filter, and aggregate as you process data through a multi-step pipeline
2. **Building an audit trail** — record every query and validation run so you can trace what happened and when
3. **Profiling and sampling datasets** — quickly log schema snapshots, sample outputs, and profiling results for later review
4. **Exporting operational records** — dump all logged activity to JSON, CSV, or plain text for reporting or ingestion into other tools
5. **Monitoring data processing health** — use `status` and `stats` to check entry counts, disk usage, and last-activity timestamps at a glance

## Examples

```bash
# Ingest a new data record
linecount ingest "user_events batch 2024-03-18 — 4200 rows loaded"

# Record a transformation step
linecount transform "normalized timestamps to UTC, removed duplicates"

# Log a filter operation
linecount filter "country=US AND age>=18"

# View aggregation history (no args = show recent)
linecount aggregate

# Run a validation and record the result
linecount validate "schema check passed — 0 null columns"

# Search all logs for a keyword
linecount search "duplicates"

# Export everything to CSV
linecount export csv

# Check overall health
linecount status

# View summary stats across all log types
linecount stats
```

## Configuration

Set the `DATA_DIR` variable in the script or modify the default path to change storage location. Default: `~/.local/share/linecount/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
