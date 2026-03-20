---
version: "1.0.0"
name: Trippy
description: "Visualize network paths with hop latency and geo mapping. Use when ingesting traces, transforming hops, querying routes, aggregating stats."
---

# Traceroute Visual

Traceroute Visual v2.0.0 — a data toolkit for ingesting, transforming, querying, and visualizing network trace data from the command line. All data is stored locally in flat log files with timestamps, making it easy to review history, export records, and search across entries.

## Commands

Run `scripts/script.sh <command> [args]` to use.

### Core Operations

| Command | Description |
|---------|-------------|
| `ingest <input>` | Log an ingest entry (e.g. import raw traceroute data, capture hop records) |
| `transform <input>` | Log a transform entry (e.g. normalize hop data, parse latency values) |
| `query <input>` | Log a query entry (e.g. look up specific routes, filter by destination) |
| `filter <input>` | Log a filter entry (e.g. filter hops by latency threshold, exclude private IPs) |
| `aggregate <input>` | Log an aggregate entry (e.g. aggregate hop counts, average latency per route) |
| `visualize <input>` | Log a visualize entry (e.g. generate ASCII path maps, latency charts) |
| `export <input>` | Log an export entry (e.g. export trace data, share route records) |
| `sample <input>` | Log a sample entry (e.g. sample subset of traces, test data generation) |
| `schema <input>` | Log a schema entry (e.g. define data schema, validate field types) |
| `validate <input>` | Log a validate entry (e.g. validate trace integrity, check for missing hops) |
| `pipeline <input>` | Log a pipeline entry (e.g. define ingest→transform→visualize workflows) |
| `profile <input>` | Log a profile entry (e.g. profile route performance, latency distribution) |

Each command without arguments shows the 20 most recent entries for that category.

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Summary statistics across all log categories with entry counts and disk usage |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Show the 20 most recent entries from the global activity history |
| `status` | Health check — version, data directory, total entries, disk usage, last activity |
| `help` | Show full usage information |
| `version` | Show version string (`traceroute-visual v2.0.0`) |

## Data Storage

All data is persisted locally under `~/.local/share/traceroute-visual/`:

- **`<command>.log`** — One log file per command (e.g. `ingest.log`, `transform.log`, `query.log`)
- **`history.log`** — Global activity log with timestamps for every operation
- **`export.<fmt>`** — Generated export files (json/csv/txt)

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). No external services, no API keys, no network calls — everything stays on your machine.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or packages required
- No API keys or accounts needed

## When to Use

1. **Capturing traceroute results** — Use `ingest` to log raw traceroute output from different sources, building a searchable archive of network path data over time
2. **Processing and normalizing data** — Use `transform` and `validate` to record data cleaning steps, ensuring consistent formats before analysis
3. **Querying specific routes** — Use `query` and `filter` to log lookups by destination, latency threshold, or hop count, keeping a record of what was investigated
4. **Building analysis pipelines** — Use `pipeline` to document multi-step workflows (ingest → transform → aggregate → visualize) for repeatable network diagnostics
5. **Profiling network performance** — Use `profile` and `aggregate` to record latency distributions and hop statistics, then `export csv` for charting and reporting

## Examples

```bash
# Ingest a traceroute result
traceroute-visual ingest "traceroute to 8.8.8.8: 12 hops, avg 34ms, max 120ms at hop 7"

# Transform raw data
traceroute-visual transform "Normalized 50 traces: removed private IPs, converted ms to μs"

# Query a specific route
traceroute-visual query "Routes to cloudflare.com — 3 unique paths found in last 24h"

# Filter by latency
traceroute-visual filter "Hops > 100ms: hop 7 (ISP handoff), hop 11 (transatlantic)"

# Aggregate statistics
traceroute-visual aggregate "Weekly summary: avg hops 11.3, avg latency 42ms, 2 packet loss events"

# Define a pipeline
traceroute-visual pipeline "Daily: ingest cron traces → transform → aggregate → export json"

# Search for all entries mentioning a specific IP
traceroute-visual search "8.8.8.8"

# Export everything to JSON
traceroute-visual export json

# View summary statistics
traceroute-visual stats
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
