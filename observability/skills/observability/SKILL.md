---
version: "1.0.0"
name: Signoz
description: "SigNoz is an open-source observability platform native to OpenTelemetry with logs, traces and metric observability, typescript, apm, application-monitoring."
---

# Observability

Observability v2.0.0 — a data toolkit for ingesting, transforming, querying, filtering, aggregating, and visualizing observability data from the command line. Features data pipelines, schema management, profiling, validation, and full data export.

## Commands

Run `observability <command> [args]` to use. Each data command accepts optional input — with no arguments it shows recent entries; with arguments it records a new entry.

| Command | Description |
|---------|-------------|
| `ingest [input]` | Ingest raw observability data (logs, metrics, traces) |
| `transform [input]` | Record or review data transformation operations |
| `query [input]` | Log and review data queries |
| `filter [input]` | Record filter criteria and filtered results |
| `aggregate [input]` | Log aggregation operations and results |
| `visualize [input]` | Record visualization configurations and outputs |
| `export [input]` | Log data export operations |
| `sample [input]` | Record data sampling operations |
| `schema [input]` | Document and manage data schemas |
| `validate [input]` | Log data validation checks and results |
| `pipeline [input]` | Record data pipeline configurations and runs |
| `profile [input]` | Log data profiling operations and findings |
| `stats` | Show summary statistics across all entry types |
| `export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `search <term>` | Full-text search across all log entries |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show built-in help message |
| `version` | Print version string (`observability v2.0.0`) |

## Features

- **18+ subcommands** covering the full observability data lifecycle
- **Data-pipeline focused** — ingest, transform, query, filter, aggregate, visualize
- **Schema and validation** — built-in schema management and data validation tracking
- **Local-first storage** — all data in `~/.local/share/observability/` as plain-text logs
- **Timestamped entries** — every record includes `YYYY-MM-DD HH:MM` timestamps
- **Unified history log** — `history.log` tracks every action for auditability
- **Multi-format export** — JSON, CSV, and plain-text export built in
- **Full-text search** — grep-based search across all log files
- **Zero external dependencies** — pure Bash, runs anywhere
- **Automatic data directory creation** — no setup required

## Data Storage

All data is stored in `~/.local/share/observability/`:

- `ingest.log`, `transform.log`, `query.log`, `filter.log`, `aggregate.log`, `visualize.log`, `export.log`, `sample.log`, `schema.log`, `validate.log`, `pipeline.log`, `profile.log` — per-command entry logs
- `history.log` — unified audit trail of all operations
- `export.json`, `export.csv`, `export.txt` — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No root privileges required
- No internet connection required

## When to Use

1. **Ingesting logs and metrics** — run `observability ingest "nginx access.log: 1.2M requests, 99.8% 2xx"` to record ingestion results from log pipelines
2. **Transforming and filtering data** — use `observability transform "Normalized timestamps to UTC"` and `observability filter "status >= 500"` to document data processing steps
3. **Querying and aggregating metrics** — log queries with `observability query "SELECT avg(latency) FROM traces WHERE service='api'"` and aggregation results
4. **Managing data schemas and validation** — use `observability schema "Added field: trace_id (string, required)"` and `observability validate "Schema check passed: 0 violations"` to track data quality
5. **Building and monitoring pipelines** — record pipeline runs with `observability pipeline "ETL run #42: 500K records processed in 12s"` and profile performance with `observability profile "P99 latency: 230ms"`

## Examples

```bash
# Show all available commands
observability help

# Ingest observability data
observability ingest "Prometheus scrape: 4,200 time series from 12 targets"

# Record a transformation
observability transform "Converted trace spans to Jaeger format"

# Log a query
observability query "Top 10 endpoints by error rate in last 24h"

# Filter data
observability filter "Dropped health-check requests from metrics"

# Aggregate metrics
observability aggregate "Daily active users: 12,400 (7-day avg: 11,800)"

# Record a pipeline run
observability pipeline "Log pipeline: filebeat → kafka → elasticsearch, 2.1GB/day"

# Validate data quality
observability validate "All traces have valid trace_id and span_id"

# View summary statistics
observability stats

# Search all logs
observability search "latency"

# Export everything to JSON
observability export json

# Check tool health
observability status
```

## How It Works

Observability stores all data locally in `~/.local/share/observability/`. Each command logs activity with timestamps for full traceability. When called without arguments, data commands display their most recent 20 entries. When called with arguments, they append a new timestamped entry and update the unified history log.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
