---
version: "1.0.0"
name: 90Daysofdevops
description: "This repository started out as a learning in public project for myself and has now become a structur devops-journey, shell, ansible, backup, containers."
---

# Devops Journey

A DevOps learning journey toolkit for tracking, logging, and managing study and practice entries. Records timestamped entries across multiple categories and provides search, export, and reporting capabilities.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display the 20 most recent entries from the corresponding log. With arguments, they record a new timestamped entry.

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
| `version` | Show version string (`devops-journey v2.0.0`) |

## Data Storage

- **Data directory:** `~/.local/share/devops-journey/`
- **Log format:** Each command writes to its own `.log` file (e.g., `run.log`, `check.log`)
- **Entry format:** `YYYY-MM-DD HH:MM|<input>` (pipe-delimited timestamp + value)
- **History log:** All actions are also appended to `history.log` with timestamps
- **Export output:** Written to `export.json`, `export.csv`, or `export.txt` in the data directory

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or package installations required

## When to Use

- To track and log DevOps learning journey activities with timestamps
- For recording study progress, lab checks, analyses, or batch operations
- When you need to search across historical learning activity logs
- To export tracked data to JSON, CSV, or plain text for external review
- For monitoring data directory health and entry statistics

## Examples

```bash
# Record a new run entry
devops-journey run "completed Day 45 - Kubernetes networking"

# Check recent analysis entries
devops-journey analyze

# Search all logs for a keyword
devops-journey search "kubernetes"

# Export all data as JSON
devops-journey export json

# View summary statistics
devops-journey stats

# Show recent activity
devops-journey recent

# Health check
devops-journey status
```

## Configuration

Set the `DEVOPS_JOURNEY_DIR` environment variable to override the default data directory. Default: `~/.local/share/devops-journey/`

## Output

All commands write results to stdout. Redirect output with `devops-journey <command> > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
