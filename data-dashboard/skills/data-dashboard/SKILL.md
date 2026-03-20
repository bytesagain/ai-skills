---
version: "1.0.0"
name: Dataease
description: "🔥 人人可用的开源 BI 工具，数据可视化神器。An open-source BI tool alternative to Tableau. data-dashboard, java, apache-doris, business-intelligence, data-analysis."
---

# Data Dashboard

A data toolkit for logging and managing dashboard and visualization operations. Each command records timestamped entries to dedicated log files, covering the full data lifecycle from ingestion through validation and profiling.

Data stored in `~/.local/share/data-dashboard/`

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
| `version` | Print version string (data-dashboard v2.0.0). |

## Requirements

- Bash 4+

## When to Use

- Tracking dashboard data ingestion and visualization operations
- Logging data pipeline steps for dashboard builds and updates
- Searching historical entries to trace when data was filtered, aggregated, or visualized
- Monitoring dashboard data health with status and stats commands
- Recording schema changes and validation results for dashboard data governance

## Examples

```bash
# Record a data ingestion for a dashboard
data-dashboard ingest "loaded monthly KPI data from warehouse"

# Log a visualization step
data-dashboard visualize "created revenue trend chart for Q1"

# Search all logs for a specific metric
data-dashboard search "KPI"

# View overall statistics
data-dashboard stats

# Check system health
data-dashboard status
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
