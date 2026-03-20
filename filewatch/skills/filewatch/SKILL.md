---
name: FileWatch
description: "Monitor files for changes and trigger actions on modification events. Use when watching config changes, triggering rebuilds, or tracking file versions."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["file","watch","monitor","change","inotify","developer"]
categories: ["Developer Tools", "Utility"]
---
# FileWatch

A utility toolkit for logging, tracking, and managing file-related operations. Each command records timestamped entries to its own log file for auditing and review.

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `run <input>` | Log a run entry (view recent entries if no input given) |
| `check <input>` | Log a check entry for verification tasks |
| `convert <input>` | Log a convert entry for format conversion tasks |
| `analyze <input>` | Log an analyze entry for analysis tasks |
| `generate <input>` | Log a generate entry for generation tasks |
| `preview <input>` | Log a preview entry for preview tasks |
| `batch <input>` | Log a batch entry for batch processing tasks |
| `compare <input>` | Log a compare entry for comparison tasks |
| `export <input>` | Log an export entry for export tasks |
| `config <input>` | Log a config entry for configuration tasks |
| `status <input>` | Log a status entry for status tracking |
| `report <input>` | Log a report entry for reporting tasks |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Search all log entries for a term (case-insensitive) |
| `recent` | Show the 20 most recent entries from history |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show available commands |
| `version` | Show version (v2.0.0) |

## Data Storage

All data is stored in `~/.local/share/filewatch/`:

- Each command writes to its own log file (e.g., `run.log`, `check.log`, `analyze.log`)
- All actions are also recorded in `history.log` with timestamps
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`
- Log format: `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)

## Requirements

- Bash (no external dependencies)
- Works on Linux and macOS

## When to Use

- When you need to log and track file-related operations over time
- To maintain an audit trail of run, check, convert, analyze, or generate actions
- When you want to search or export historical operation records
- For batch tracking of file processing pipelines
- To get summary statistics on recorded operations

## Examples

```bash
# Log operations
filewatch run "process data.csv"
filewatch check "verify output integrity"
filewatch convert "json to csv"
filewatch analyze "scan logs for errors"
filewatch generate "create report template"
filewatch batch "process all .txt files"

# View recent entries for a command (no args)
filewatch run
filewatch check

# Search and export
filewatch search "data.csv"
filewatch export json
filewatch stats
filewatch recent
filewatch status
```

## Output

All commands output to stdout. Redirect with `filewatch run > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
