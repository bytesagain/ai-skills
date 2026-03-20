---
version: "1.0.0"
name: Metabase
description: "The easy-to-use open source Business Intelligence and Embedded Analytics tool that lets everyone wor data-analytics, clojure, analytics, bi."
---

# Data Analytics

A data toolkit for logging and managing data pipeline operations. Each command records timestamped entries to dedicated log files, covering the full data lifecycle from ingestion through validation and profiling.

Data stored in `~/.local/share/data-analytics/`

## Commands

| Command | Description |
|---------|-------------|
| `ingest <input>` | Record an ingest entry. Without args, shows recent ingest entries. |
| `transform <input>` | Record a transform entry. Without args, shows recent transform entries. |
| `query <input>` | Record a query entry. Without args, shows recent query entries. |
| `filter <input>` | Record a filter entry. Without args, shows recent filter entries. |
| `aggregate <input>` | Record an aggregate entry. Without args, shows recent aggregate entries. |
| `visualize <input>` | Record a visualize entry. Without args, shows recent visualize entries. |
| `export <input>` | Record an export entry. Without args, shows recent export entries. |
| `sample <input>` | Record a sample entry. Without args, shows recent sample entries. |
| `schema <input>` | Record a schema entry. Without args, shows recent schema entries. |
| `validate <input>` | Record a validate entry. Without args, shows recent validate entries. |
| `pipeline <input>` | Record a pipeline entry. Without args, shows recent pipeline entries. |
| `profile <input>` | Record a profile entry. Without args, shows recent profile entries. |
| `stats` | Show summary statistics across all log files (entry counts, data size). |
| `search <term>` | Search all log files for a term (case-insensitive). |
| `recent` | Show the last 20 lines from history.log. |
| `status` | Show health check info: version, data dir, total entries, disk usage. |
| `help` | Show usage and available commands. |
| `version` | Print version string (data-analytics v2.0.0). |

## Requirements

- Bash 4+

## When to Use

- Tracking data ingestion, transformation, and query operations over time
- Logging data pipeline steps for audit and reproducibility
- Searching historical entries to trace when data was filtered, aggregated, or exported
- Monitoring data operation health with status and stats commands
- Recording schema changes and validation results for data governance

## Examples

```bash
# Record a data ingestion event
data-analytics ingest "loaded 50k rows from sales_2026.csv"

# Log a transformation step
data-analytics transform "normalized column names, removed nulls"

# Search all logs for a dataset reference
data-analytics search "sales_2026"

# View overall statistics
data-analytics stats

# Check system health
data-analytics status
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
