---
version: "1.0.0"
name: Devops Bash Tools
description: "1000+ DevOps Bash Scripts - AWS, GCP, Kubernetes, Docker, CI/CD, APIs, SQL, PostgreSQL, MySQL, Hive, devops bash tools, shell, api, aws, bash, ci."
---

# Devops Scripts

A DevOps scripting toolkit for tracking, logging, and managing development operations entries. Records timestamped entries across multiple categories and provides search, export, and reporting capabilities.

This skill uses a **different command set** than devops-bash-tools — it is oriented toward code quality and scripting workflows (lint, validate, format, template, diff, fix, explain).

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display the 20 most recent entries from the corresponding log. With arguments, they record a new timestamped entry.

### Core Tracking Commands

| Command | Description |
|---------|-------------|
| `check <input>` | Record or view check entries |
| `validate <input>` | Record or view validation entries |
| `generate <input>` | Record or view generation entries |
| `format <input>` | Record or view formatting entries |
| `lint <input>` | Record or view lint entries |
| `explain <input>` | Record or view explanation entries |
| `convert <input>` | Record or view conversion entries |
| `template <input>` | Record or view template entries |
| `diff <input>` | Record or view diff entries |
| `preview <input>` | Record or view preview entries |
| `fix <input>` | Record or view fix entries |
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
| `version` | Show version string (`devops-scripts v2.0.0`) |

## Data Storage

- **Data directory:** `~/.local/share/devops-scripts/`
- **Log format:** Each command writes to its own `.log` file (e.g., `check.log`, `lint.log`)
- **Entry format:** `YYYY-MM-DD HH:MM|<input>` (pipe-delimited timestamp + value)
- **History log:** All actions are also appended to `history.log` with timestamps
- **Export output:** Written to `export.json`, `export.csv`, or `export.txt` in the data directory

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or package installations required

## When to Use

- To track and log DevOps scripting activities with timestamps
- For recording lint results, validations, formatting changes, or template operations
- When you need to search across historical scripting activity logs
- To export tracked data to JSON, CSV, or plain text for external analysis
- For monitoring data directory health and entry statistics
- When working with code quality workflows (lint, format, fix, validate, diff)

## Examples

```bash
# Record a new lint entry
devops-scripts lint "Dockerfile passed hadolint checks"

# Check recent validation entries
devops-scripts validate

# Record a template operation
devops-scripts template "generated nginx.conf from template"

# Search all logs for a keyword
devops-scripts search "nginx"

# Export all data as CSV
devops-scripts export csv

# View summary statistics
devops-scripts stats

# Show recent activity
devops-scripts recent

# Health check
devops-scripts status
```

## Configuration

Set the `DEVOPS_SCRIPTS_DIR` environment variable to override the default data directory. Default: `~/.local/share/devops-scripts/`

## Output

All commands write results to stdout. Redirect output with `devops-scripts <command> > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
