---
version: "1.0.0"
name: Monolith
description: "⬛️ CLI tool and library for saving complete web pages as a single HTML file page-saver, rust, come-and-take-it, e-hoarding, its-mine."
---

# Page Saver

Utility toolkit v2.0.0 — run, check, convert, analyze, and manage utility tasks from the command line.

## Commands

All commands follow the pattern: `page-saver <command> [input]`

When called without input, each command displays its recent entries. When called with input, it records a new timestamped entry.

| Command        | Description                                      |
|----------------|--------------------------------------------------|
| `run`          | Record or view run entries                       |
| `check`        | Record or view check entries                     |
| `convert`      | Record or view convert entries                   |
| `analyze`      | Record or view analyze entries                   |
| `generate`     | Record or view generate entries                  |
| `preview`      | Record or view preview entries                   |
| `batch`        | Record or view batch processing entries          |
| `compare`      | Record or view compare entries                   |
| `export`       | Record or view export entries                    |
| `config`       | Record or view config entries                    |
| `status`       | Record or view status entries                    |
| `report`       | Record or view report entries                    |
| `stats`        | Summary statistics across all log files          |
| `export <fmt>` | Export all data (json, csv, or txt)              |
| `search <term>`| Search across all log entries                    |
| `recent`       | Show the 20 most recent activity log entries     |
| `status`       | Health check — version, entry count, disk usage  |
| `help`         | Show help with all available commands            |
| `version`      | Print version string                             |

## How It Works

Each domain command (`run`, `check`, `convert`, etc.) works in two modes:

- **Read mode** (no arguments): displays the last 20 entries from its log file
- **Write mode** (with arguments): appends a timestamped `YYYY-MM-DD HH:MM|<input>` line to its log file and logs the action to `history.log`

The built-in utility commands (`stats`, `export <fmt>`, `search`, `recent`, `status`) aggregate data across all log files for reporting and analysis.

## Data Storage

All data is stored locally in `~/.local/share/page-saver/`:

- Each command writes to its own log file (e.g., `run.log`, `check.log`, `convert.log`)
- `history.log` records all write operations with timestamps
- Export files are saved as `export.json`, `export.csv`, or `export.txt`
- No external network calls — everything stays on disk

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies or package installations needed

## When to Use

1. **Running utility tasks** — execute and log operations with `run`, then review them later
2. **Checking and validating** — use `check` to record validation results for pages or files
3. **Converting formats** — track conversion operations (e.g., HTML to PDF) with `convert`
4. **Analyzing content** — log analysis results with `analyze` for future reference
5. **Batch processing** — record batch job results with `batch` and compare outcomes with `compare`

## Examples

```bash
# Run a task and log it
page-saver run "Saved homepage — 2.3MB single HTML"

# Record a check result
page-saver check "All images embedded: OK, CSS inlined: OK"

# Log a conversion
page-saver convert "index.html → index.pdf (384KB)"

# Analyze a page
page-saver analyze "Page load time: 1.2s, 42 resources inlined"

# Generate a report
page-saver report "Weekly summary: 15 pages saved, 3 failures"

# Export everything to CSV
page-saver export csv

# Search for entries mentioning "failure"
page-saver search failure

# Check system health
page-saver status
```

## Output

All commands return results to stdout. Redirect to a file if needed:

```bash
page-saver stats > summary.txt
page-saver export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
