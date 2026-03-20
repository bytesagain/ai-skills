---
version: "1.0.0"
name: Sampler
description: "Tool for shell commands execution, visualization and alerting. Configured with a simple YAML file. terminal-dashboard, go, alerting, charts, cmd."
---

# Terminal Dashboard

Terminal Dashboard v2.0.0 — a data toolkit for building data pipelines and tracking data operations from the command line. Ingest, transform, query, filter, aggregate, and visualize your data — all logged locally with timestamps for full traceability.

## Why Terminal Dashboard?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Timestamped logging for every operation
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity tracking
- Searchable records across all data pipeline stages

## Getting Started

```bash
# See all available commands
terminal-dashboard help

# Check current health status
terminal-dashboard status

# View summary statistics
terminal-dashboard stats
```

## Commands

### Data Pipeline Commands

Each command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `terminal-dashboard ingest <input>` | Record data ingestion events (file imports, API pulls, stream captures) |
| `terminal-dashboard transform <input>` | Log data transformations (format conversions, cleaning steps, enrichments) |
| `terminal-dashboard query <input>` | Record queries executed (SQL, API calls, search operations) |
| `terminal-dashboard filter <input>` | Log filter operations (row filtering, column selection, deduplication) |
| `terminal-dashboard aggregate <input>` | Record aggregation operations (group-by, rollups, summaries) |
| `terminal-dashboard visualize <input>` | Log visualization outputs (charts generated, dashboards updated) |
| `terminal-dashboard export <input>` | Record export operations (file writes, API pushes, report generation) |
| `terminal-dashboard sample <input>` | Log sampling operations (random samples, stratified picks, head/tail) |
| `terminal-dashboard schema <input>` | Record schema operations (schema detection, validation rules, migrations) |
| `terminal-dashboard validate <input>` | Log validation results (data quality checks, constraint tests, anomalies) |
| `terminal-dashboard pipeline <input>` | Record pipeline operations (end-to-end runs, DAG executions, orchestration) |
| `terminal-dashboard profile <input>` | Log profiling results (data profiling, column stats, distribution analysis) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `terminal-dashboard stats` | Show summary statistics across all log categories |
| `terminal-dashboard export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `terminal-dashboard search <term>` | Search across all entries for a keyword |
| `terminal-dashboard recent` | Show the 20 most recent history entries |
| `terminal-dashboard status` | Health check — version, data dir, entry count, disk usage |
| `terminal-dashboard help` | Show the built-in help message |
| `terminal-dashboard version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/terminal-dashboard/`. Structure:

- **`ingest.log`**, **`transform.log`**, **`query.log`**, etc. — one log file per command, pipe-delimited (`timestamp|value`)
- **`history.log`** — unified activity log across all commands
- **`export.json`** / **`export.csv`** / **`export.txt`** — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<input>`. Use `export` to back up your data anytime.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies or internet access needed

## When to Use

1. **Data pipeline logging** — Track every step of your ETL/ELT pipeline from ingestion through transformation to export, creating a complete audit trail
2. **Data quality monitoring** — Use `validate` and `profile` to record data quality checks and catch anomalies before they reach production
3. **Schema change tracking** — Log schema migrations and validation rules so you always know what changed and when
4. **Ad-hoc analysis journaling** — Record queries, filters, and aggregations during exploratory analysis so you can reproduce your findings later
5. **Pipeline debugging** — When a data pipeline breaks, search through ingest, transform, and export logs to pinpoint where things went wrong

## Examples

```bash
# Record a data ingestion event
terminal-dashboard ingest "Loaded 2.4M rows from sales_2024.csv into staging"

# Log a transformation step
terminal-dashboard transform "Normalized phone numbers, deduplicated by email — 12k dupes removed"

# Record a query
terminal-dashboard query "SELECT region, SUM(revenue) FROM sales GROUP BY region — 8 rows returned"

# Log a validation check
terminal-dashboard validate "Schema check passed: all 47 columns match expected types"

# Record a pipeline run
terminal-dashboard pipeline "Daily ETL completed: ingest→clean→aggregate→export in 4m 23s"

# Export everything to JSON
terminal-dashboard export json

# Search logs for a dataset
terminal-dashboard search "sales_2024"
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
terminal-dashboard stats > pipeline-report.txt
terminal-dashboard export csv
```

## Configuration

Set `TERMINAL_DASHBOARD_DIR` environment variable to override the default data directory (`~/.local/share/terminal-dashboard/`).

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
