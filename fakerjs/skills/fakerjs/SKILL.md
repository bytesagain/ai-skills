---
name: FakerJS
description: "Generate realistic test data: names, addresses, companies, dates, and more. Use when seeding databases, mocking APIs, or building demo datasets."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["faker","data","mock","testing","development","fixture","sample","generator"]
categories: ["Developer Tools", "Utility"]
---

# FakerJS

Data toolkit for logging and managing test data operations (v2.0.0). Record data ingestion, transformation, querying, filtering, aggregation, visualization, export, sampling, schema definitions, validation rules, pipeline configurations, and profiling results. Each command logs timestamped entries to its own log file, providing a structured record of all data generation and manipulation activities.

## Commands

| Command | Description |
|---------|-------------|
| `fakerjs ingest <input>` | Record a data ingestion event (source, format, volume, etc.). Without args, shows recent ingest entries. |
| `fakerjs transform <input>` | Log a data transformation step (format conversion, mapping, normalization). Without args, shows recent transforms. |
| `fakerjs query <input>` | Record a query operation or data retrieval request. Without args, shows recent queries. |
| `fakerjs filter <input>` | Log a filtering rule or condition applied to datasets. Without args, shows recent filters. |
| `fakerjs aggregate <input>` | Record an aggregation step (counts, sums, averages, groupings). Without args, shows recent aggregations. |
| `fakerjs visualize <input>` | Log a visualization request or chart specification. Without args, shows recent visualizations. |
| `fakerjs export <input>` | Record an export operation (destination, format, record count). Without args, shows recent exports. |
| `fakerjs sample <input>` | Log a data sampling step (sample size, method, random seed). Without args, shows recent samples. |
| `fakerjs schema <input>` | Record a schema definition or structure change. Without args, shows recent schema entries. |
| `fakerjs validate <input>` | Log a data validation rule or check result. Without args, shows recent validations. |
| `fakerjs pipeline <input>` | Record a pipeline configuration or execution step. Without args, shows recent pipeline entries. |
| `fakerjs profile <input>` | Log a data profiling result (null rates, distributions, anomalies). Without args, shows recent profiles. |
| `fakerjs stats` | Show summary statistics: entry counts per category, total entries, data size, and earliest record date. |
| `fakerjs export <fmt>` | Export all logged data to a file. Supported formats: `json`, `csv`, `txt`. (Separate code path from the `export` log command.) |
| `fakerjs search <term>` | Search across all log files for a keyword (case-insensitive). |
| `fakerjs recent` | Show the 20 most recent entries from the activity history log. |
| `fakerjs status` | Health check: version, data directory, total entries, disk usage, last activity. |
| `fakerjs help` | Show the built-in help with all available commands. |
| `fakerjs version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored as plain-text log files in `~/.local/share/fakerjs/`:

- **Per-command logs** — Each command (ingest, transform, query, etc.) writes to its own `.log` file (e.g., `ingest.log`, `transform.log`).
- **History log** — Every operation is also appended to `history.log` with a timestamp and command name.
- **Export files** — Generated in the same directory as `export.json`, `export.csv`, or `export.txt`.

Entries are stored in `timestamp|value` format, making them easy to grep, parse, or pipe into downstream tools.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **coreutils** — `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cut`
- No external dependencies, API keys, or network access required
- Works fully offline on any POSIX-compatible system

## When to Use

1. **Test data generation tracking** — Log what fake data you generated (user records, orders, products), how many rows, and in what format, so you can reproduce test datasets consistently.
2. **Mock API data management** — Use `ingest` and `export` to record the lifecycle of mock data: what you ingested from templates, how you transformed it, and where you exported it for API stubs.
3. **Data quality validation** — Use `validate` to log data quality rules (e.g., "email format check: 0 failures") and `profile` to record column-level statistics and anomaly findings.
4. **Schema evolution tracking** — Use `schema` to document table structures and track changes over time, creating a historical record of how your test data schemas evolved.
5. **Pipeline orchestration for test environments** — Use `pipeline` to record multi-step data generation workflows (generate → transform → validate → load), and `stats` to monitor overall activity across all operations.

## Examples

```bash
# Log ingestion of fake user data
fakerjs ingest "Generated 10,000 fake user records with faker.js — names, emails, addresses"

# Record a transformation step
fakerjs transform "Normalize phone numbers to E.164 format, convert dates to ISO 8601"

# Log a validation check
fakerjs validate "Email uniqueness check: 0 duplicates in 10,000 records"

# Define a schema for test data
fakerjs schema "users: id UUID PK, name VARCHAR(100), email VARCHAR(255), created_at TIMESTAMP"

# Record a pipeline execution
fakerjs pipeline "seed_test_db: generate(users,10k) -> generate(orders,50k) -> validate -> load(postgres)"

# Search logs for anything related to 'email'
fakerjs search email

# Export all activity logs to JSON
fakerjs export json

# View summary statistics across all categories
fakerjs stats

# Check system status
fakerjs status

# View recent activity
fakerjs recent
```

## Tips

- Run any data command without arguments to see recent entries (e.g., `fakerjs ingest` shows the last 20 ingest entries).
- Use `fakerjs recent` for a quick overview of all activity across all categories.
- Combine with actual faker.js scripts: `node generate-users.js && fakerjs ingest "Generated 5000 users"`
- Back up your data by copying `~/.local/share/fakerjs/` to your preferred backup location.

---
*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
