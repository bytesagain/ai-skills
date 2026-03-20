---
version: "1.0.0"
name: Omni
description: "The all-in-one tool to boost your productivity ⌨️ omni-tool, javascript, bookmark, bookmarks, bookmarks-manager, chrome."
---

# Omni Tool

All-in-one terminal utility toolkit for running, checking, converting, analyzing, generating, and managing tasks from the command line. Omni Tool provides 12 core action commands plus built-in statistics, data export, search, and health-check capabilities — all backed by local log-based storage.

## Commands

All commands follow the pattern: `omni-tool <command> [input]`

When called **without arguments**, each command displays its most recent 20 log entries.
When called **with arguments**, it records the input with a timestamp.

### Core Action Commands

| Command | Description |
|---------|-------------|
| `run <input>` | Record and execute a run entry |
| `check <input>` | Record a check / verification entry |
| `convert <input>` | Record a conversion task |
| `analyze <input>` | Record an analysis entry |
| `generate <input>` | Record a generation task |
| `preview <input>` | Record a preview action |
| `batch <input>` | Record a batch processing task |
| `compare <input>` | Record a comparison entry |
| `export <input>` | Record an export operation |
| `config <input>` | Record a configuration change |
| `status <input>` | Record a status update |
| `report <input>` | Record a report entry |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files (entry counts, disk usage) |
| `export <fmt>` | Export all data to a file — supported formats: `json`, `csv`, `txt` |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Show the 20 most recent entries from the activity history |
| `status` | Health check — version, data directory, total entries, disk usage, last activity |
| `help` | Display the full help message with all available commands |
| `version` | Print the current version (`omni-tool v2.0.0`) |

## Data Storage

All data is stored locally in plain-text log files:

- **Location:** `~/.local/share/omni-tool/`
- **Format:** Each entry is a line of `YYYY-MM-DD HH:MM|<input>` in the corresponding `<command>.log` file
- **History:** Every action is also appended to `history.log` with a timestamp and command label
- **Export formats:** JSON (array of objects), CSV (with headers), plain text (grouped by command)
- **No external dependencies** — pure bash, runs anywhere

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **Core utilities:** `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No network access required — fully offline
- No configuration needed — works out of the box

## When to Use

1. **Quick task logging** — capture run results, check outcomes, or conversion records from the terminal without opening a separate app
2. **Batch processing workflows** — use `omni-tool batch` to log batch job details, then `omni-tool stats` to review totals
3. **Data analysis pipelines** — record analysis steps with `omni-tool analyze`, then `omni-tool export json` for downstream processing
4. **Configuration auditing** — track config changes with `omni-tool config` and search history with `omni-tool search`
5. **Cross-entry reporting** — combine `omni-tool report` with `omni-tool stats` and `omni-tool export csv` to produce summary reports across all command categories

## Examples

### Record a run and view recent entries

```bash
# Log a task
omni-tool run "deploy staging v2.3.1"

# View recent run entries
omni-tool run
```

### Analyze, then export results

```bash
# Record analysis entries
omni-tool analyze "CPU usage spike on node-3"
omni-tool analyze "Memory leak in worker pool"

# Export everything to JSON
omni-tool export json
```

### Search and report

```bash
# Search across all logs
omni-tool search "staging"

# Check overall statistics
omni-tool stats

# View recent activity
omni-tool recent
```

### Batch processing workflow

```bash
# Log batch operations
omni-tool batch "process images batch-042"
omni-tool batch "resize thumbnails batch-042"

# Review and export
omni-tool stats
omni-tool export csv
```

### Health check and comparison

```bash
# System health overview
omni-tool status

# Record comparisons
omni-tool compare "prod-v2 vs staging-v2.1 latency"

# View comparison history
omni-tool compare
```

## Output

All commands output to stdout. Redirect to a file with:

```bash
omni-tool stats > report.txt
omni-tool export json   # writes to ~/.local/share/omni-tool/export.json
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
