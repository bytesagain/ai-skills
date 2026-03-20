---
version: "1.0.0"
name: It Tools
description: "Collection of handy online tools for developers, with great UX. it tools, vue, converter, developer-productivity, developer-tools, frontend."
---

# Dev Utilities

A developer utility toolkit for tracking, logging, and managing development workflow entries. Records timestamped entries across multiple categories and provides search, export, and reporting capabilities.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from the corresponding log. With arguments, they record a new timestamped entry.

### Core Tracking Commands

| Command | Description |
|---------|-------------|
| `run <input>` | Record or view run entries |
| `check <input>` | Record or view check entries |
| `convert <input>` | Record or view conversion entries |
| `analyze <input>` | Record or view analysis entries |
| `generate <input>` | Record or view generation entries |
| `preview <input>` | Record or view preview entries |
| `batch <input>` | Record or view batch processing entries |
| `compare <input>` | Record or view comparison entries |
| `export <input>` | Record or view export entries |
| `config <input>` | Record or view configuration entries |
| `status <input>` | Record or view status entries |
| `report <input>` | Record or view report entries |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files (entry counts, data size) |
| `export <fmt>` | Export all data in a specified format: `json`, `csv`, or `txt` |
| `search <term>` | Search all log files for a term (case-insensitive) |
| `recent` | Show the 20 most recent entries from the activity history |
| `status` | Display health check: version, data directory, entry count, disk usage |
| `help` | Show help message with all available commands |
| `version` | Show version string (`dev-utilities v2.0.0`) |

## Data Storage

- **Data directory:** `~/.local/share/dev-utilities/`
- **Log format:** Each command writes to its own `.log` file (e.g., `run.log`, `check.log`)
- **Entry format:** `YYYY-MM-DD HH:MM|<input>` (pipe-delimited timestamp + value)
- **History log:** All actions are also appended to `history.log` with timestamps
- **Export output:** Written to `export.json`, `export.csv`, or `export.txt` in the data directory

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or package installations required

## When to Use

- To track and log developer workflow activities with timestamps
- For recording check results, conversions, analyses, or batch operations
- When you need to search across historical development activity logs
- To export tracked data to JSON, CSV, or plain text for external analysis
- For monitoring data directory health and entry statistics

## Examples

```bash
# Record a new run entry
dev-utilities run "build frontend v3.2"

# Check recent analysis entries
dev-utilities analyze

# Search all logs for a keyword
dev-utilities search "frontend"

# Export all data as JSON
dev-utilities export json

# View summary statistics
dev-utilities stats

# Show recent activity
dev-utilities recent

# Health check
dev-utilities status
```

## Configuration

Set the `DEV_UTILITIES_DIR` environment variable to override the default data directory. Default: `~/.local/share/dev-utilities/`

## Output

All commands write results to stdout. Redirect output with `dev-utilities <command> > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
