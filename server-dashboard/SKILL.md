---
version: "1.0.0"
name: Komodo
description: "Build and deploy software across server fleets with pipelines. Use when orchestrating deploys, monitoring services, aggregating metrics."
---

# Server Dashboard

Terminal-first data toolkit for ingesting, transforming, querying, and managing server data pipelines — all from the command line.

## Why Server Dashboard?

- Works entirely offline — your data never leaves your machine
- Full data pipeline in a single CLI: ingest → transform → query → filter → aggregate → visualize → export
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging with timestamps
- Schema validation and data profiling built in

## Getting Started

```bash
# See all available commands
server-dashboard help

# Check current health status
server-dashboard status

# View summary statistics
server-dashboard stats

# Show recent activity
server-dashboard recent
```

## Commands

| Command | What it does |
|---------|-------------|
| `server-dashboard ingest <input>` | Ingest data into the pipeline (or view recent ingests with no args) |
| `server-dashboard transform <input>` | Transform data entries (or view recent transforms) |
| `server-dashboard query <input>` | Query stored data (or view recent queries) |
| `server-dashboard filter <input>` | Filter data by criteria (or view recent filters) |
| `server-dashboard aggregate <input>` | Aggregate data points (or view recent aggregations) |
| `server-dashboard visualize <input>` | Visualize data (or view recent visualizations) |
| `server-dashboard export <input>` | Export data entries (or view recent exports) |
| `server-dashboard sample <input>` | Sample data subsets (or view recent samples) |
| `server-dashboard schema <input>` | Define or inspect data schema (or view recent schemas) |
| `server-dashboard validate <input>` | Validate data against rules (or view recent validations) |
| `server-dashboard pipeline <input>` | Run full data pipeline (or view recent pipeline runs) |
| `server-dashboard profile <input>` | Profile data for quality insights (or view recent profiles) |
| `server-dashboard stats` | Show summary statistics across all data categories |
| `server-dashboard export <fmt>` | Export all data in a format: json, csv, or txt |
| `server-dashboard search <term>` | Search across all log entries for a keyword |
| `server-dashboard recent` | Show the 20 most recent activity entries |
| `server-dashboard status` | Health check: version, disk usage, entry counts |
| `server-dashboard help` | Show the full help message |
| `server-dashboard version` | Print current version (v2.0.0) |

Each data command works in two modes:
- **With arguments:** saves the input with a timestamp to `<command>.log` and logs to history
- **Without arguments:** displays the 20 most recent entries for that command

## Data Storage

All data is stored locally at `~/.local/share/server-dashboard/`:

- `ingest.log`, `transform.log`, `query.log`, etc. — one log file per command
- `history.log` — unified activity log with timestamps
- `export.json`, `export.csv`, `export.txt` — generated export files

Data format: each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

Set the `SERVER_DASHBOARD_DIR` environment variable to change the data directory.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard UNIX utilities: `wc`, `du`, `grep`, `tail`, `sed`, `date`, `cat`, `basename`
- No external dependencies or network access required

## When to Use

1. **Ingesting raw data** — log incoming data points from sensors, APIs, or manual input for later analysis
2. **Building data pipelines** — chain ingest → transform → filter → aggregate → export in scripted workflows
3. **Validating and profiling data** — check data quality with `validate` and get insights with `profile`
4. **Exporting reports** — generate JSON, CSV, or TXT snapshots of all accumulated data for sharing or backup
5. **Searching and auditing activity** — use `search` and `recent` to trace what happened and when

## Examples

```bash
# Ingest a new data point
server-dashboard ingest "cpu_usage: 73% host=web-01"

# Transform and filter
server-dashboard transform "normalize cpu values to 0-1 range"
server-dashboard filter "host=web-01 metric=cpu"

# Aggregate results and visualize
server-dashboard aggregate "daily avg cpu by host"
server-dashboard visualize "cpu trend chart for last 7 days"

# Validate schema and profile data
server-dashboard validate "all entries have host field"
server-dashboard schema "host:string, cpu:float, ts:datetime"

# Export everything as CSV, then search
server-dashboard export csv
server-dashboard search "web-01"

# Check overall health
server-dashboard status
server-dashboard stats
```

## Output

All commands return human-readable output to stdout. Redirect to a file for scripting:

```bash
server-dashboard stats > report.txt
server-dashboard export json
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
