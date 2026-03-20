---
name: APIMon
description: "Monitor API endpoints and track response times to catch outages. Use when checking uptime, validating schemas, or generating status reports."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["api","monitor","health","uptime","response","latency","rest","devops"]
categories: ["Developer Tools", "System Tools"]
---

# APIMon

Apimon v2.0.0 — a devtools command-line toolkit for checking, validating, generating, formatting, linting, explaining, converting, templating, diffing, previewing, fixing, and reporting on API-related tasks. All operations are timestamped and logged, with built-in search, statistics, and multi-format export.

## Commands

| Command | Description |
|---------|-------------|
| `apimon check <input>` | Record a check entry (no args = show recent checks) |
| `apimon validate <input>` | Record a validation entry (no args = show recent validations) |
| `apimon generate <input>` | Record a generation entry (no args = show recent generations) |
| `apimon format <input>` | Record a format entry (no args = show recent formats) |
| `apimon lint <input>` | Record a lint entry (no args = show recent lints) |
| `apimon explain <input>` | Record an explain entry (no args = show recent explains) |
| `apimon convert <input>` | Record a conversion entry (no args = show recent conversions) |
| `apimon template <input>` | Record a template entry (no args = show recent templates) |
| `apimon diff <input>` | Record a diff entry (no args = show recent diffs) |
| `apimon preview <input>` | Record a preview entry (no args = show recent previews) |
| `apimon fix <input>` | Record a fix entry (no args = show recent fixes) |
| `apimon report <input>` | Record a report entry (no args = show recent reports) |
| `apimon stats` | Show summary statistics across all log files |
| `apimon export <fmt>` | Export all data in json, csv, or txt format |
| `apimon search <term>` | Search across all entries for a keyword |
| `apimon recent` | Show the 20 most recent activity entries |
| `apimon status` | Health check — version, data dir, entry count, disk usage |
| `apimon help` | Show usage info and all available commands |
| `apimon version` | Show version (v2.0.0) |

## How It Works

Each command (check, validate, generate, format, etc.) works as a timestamped log recorder:

- **With arguments**: saves the input to `~/.local/share/apimon/<command>.log` with a timestamp, then confirms the entry count.
- **Without arguments**: displays the 20 most recent entries from that command's log file.

All activity is also recorded in a central `history.log` for cross-command traceability.

## Data Storage

- **Location**: `~/.local/share/apimon/`
- **Log files**: One `.log` file per command (e.g., `check.log`, `validate.log`, `format.log`)
- **History**: `history.log` — central activity log across all commands
- **Export**: `export.json`, `export.csv`, or `export.txt` generated on demand
- **Format**: Each log line is `YYYY-MM-DD HH:MM|<input>`

## Requirements

- Bash (4.0+)
- Standard Unix utilities (`wc`, `du`, `grep`, `tail`, `head`, `date`)
- No external dependencies or API keys required

## When to Use

1. **API health monitoring** — use `apimon check "GET /health returned 200 in 45ms"` to log each endpoint check with response details
2. **Schema validation tracking** — run `apimon validate "OpenAPI spec v3.1 passed all rules"` to record validation outcomes over time
3. **Generating mock data records** — use `apimon generate "Mock /users response with 50 entries"` to log data generation tasks
4. **Linting API definitions** — run `apimon lint "spectral lint passed for orders.yaml"` to track lint history
5. **Uptime reporting** — use `apimon report "Daily uptime: 99.97%"` to log uptime metrics, then `apimon export json` to build dashboards

## Examples

```bash
# Check an API endpoint
apimon check "GET https://api.example.com/health — 200 OK, 32ms"

# Validate a response schema
apimon validate "POST /orders response matches OrderSchema v2"

# Generate mock data
apimon generate "10 sample user objects for /api/users"

# Format an API response
apimon format "pretty-print JSON response from /api/products"

# Lint an API spec
apimon lint "openapi-lint passed for petstore.yaml"

# Explain an HTTP status
apimon explain "502 Bad Gateway — upstream server not responding"

# Convert request format
apimon convert "curl command to Python requests"

# Create a request template
apimon template "GET with auth headers and pagination"

# Diff two API versions
apimon diff "v1 vs v2 breaking changes in /users endpoint"

# Preview a request
apimon preview "GET /api/search?q=test&limit=20"

# Record a fix
apimon fix "resolved timeout issue on /api/export endpoint"

# Generate a report entry
apimon report "Weekly API health summary: 99.9% uptime"

# View summary statistics
apimon stats

# Export all data as CSV
apimon export csv

# Search for keywords
apimon search "timeout"

# View recent activity
apimon recent

# Health check
apimon status
```

## Output

Results go to stdout. Save with `apimon export json > backup.json`. All entries are persisted to the data directory for later retrieval and analysis.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
