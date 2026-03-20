---
name: DiffView
description: "Visualize file diffs side-by-side with syntax-highlighted change views. Use when reviewing changes, comparing versions, inspecting merge results."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["diff","compare","files","viewer","patch","merge","developer","utility"]
categories: ["Developer Tools", "Utility"]
---

# DiffView

A developer-focused toolkit for checking, validating, generating, formatting, linting, explaining, converting, templating, diffing, previewing, fixing, and reporting on code and text artifacts — all from the command line with full history tracking.

## Commands

| Command | Description |
|---------|-------------|
| `diffview check <input>` | Record and review check entries (run without args to see recent) |
| `diffview validate <input>` | Record and review validation entries |
| `diffview generate <input>` | Record and review generation entries |
| `diffview format <input>` | Record and review formatting entries |
| `diffview lint <input>` | Record and review lint entries |
| `diffview explain <input>` | Record and review explanation entries |
| `diffview convert <input>` | Record and review conversion entries |
| `diffview template <input>` | Record and review template entries |
| `diffview diff <input>` | Record and review diff entries |
| `diffview preview <input>` | Record and review preview entries |
| `diffview fix <input>` | Record and review fix entries |
| `diffview report <input>` | Record and review report entries |
| `diffview stats` | Show summary statistics across all log files |
| `diffview export <fmt>` | Export all data in JSON, CSV, or TXT format |
| `diffview search <term>` | Search across all logged entries |
| `diffview recent` | Show the 20 most recent activity entries |
| `diffview status` | Health check — version, data dir, entry count, disk usage |
| `diffview help` | Show usage info and all available commands |
| `diffview version` | Print version string |

Each data command (check, validate, generate, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves to the corresponding `.log` file
- **Without arguments:** Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/diffview/`. Each command writes to its own log file (e.g., `check.log`, `lint.log`, `diff.log`). A unified `history.log` tracks all activity across commands with timestamps.

- Log format: `YYYY-MM-DD HH:MM|<input>`
- History format: `MM-DD HH:MM <command>: <input>`
- No external database or network access required

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard POSIX utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No root privileges needed
- No API keys or external dependencies

## When to Use

1. **Tracking code review notes** — Use `diffview check` or `diffview report` to log observations during code reviews, creating a searchable history of what you've inspected
2. **Recording lint and format decisions** — Use `diffview lint` and `diffview format` to keep a timestamped record of linting results or formatting choices across sessions
3. **Building a diff journal** — Use `diffview diff` to log file comparison notes over time, then `diffview search` to find specific changes later
4. **Generating exportable audit trails** — Use `diffview export json` to produce a structured JSON file of all logged activity for compliance or reporting purposes
5. **Quick project health checks** — Run `diffview status` and `diffview stats` to see how much data has been collected, disk usage, and last activity time at a glance

## Examples

### Log a check entry and review history

```bash
# Record a check
diffview check "Reviewed auth module for SQL injection"

# View recent check entries
diffview check
```

### Use lint and format tracking

```bash
# Log a lint finding
diffview lint "ESLint: no-unused-vars in utils.js line 42"

# Log a format action
diffview format "Ran prettier on src/ directory"

# Search across all entries
diffview search "utils.js"
```

### Export data for reporting

```bash
# Export everything as JSON
diffview export json

# Export as CSV for spreadsheet import
diffview export csv

# Export as plain text
diffview export txt
```

### View statistics and status

```bash
# Summary stats across all log files
diffview stats

# Health check
diffview status

# Recent activity (last 20 entries)
diffview recent
```

### Diff and explain workflow

```bash
# Log a diff observation
diffview diff "config.yaml changed: added redis cache block"

# Log an explanation
diffview explain "Redis cache added to reduce DB load on /api/users"

# Generate a report entry
diffview report "Sprint 12 review: 3 config changes, 1 new service"
```

## How It Works

DiffView uses a simple case-dispatch architecture in a single Bash script. Each command maps to a log file under `~/.local/share/diffview/`. When called with arguments, the input is appended with a timestamp. When called without arguments, the last 20 lines of that log are displayed. The `stats` command aggregates counts across all logs, `export` serializes everything into your chosen format, and `search` greps across all log files for a given term.

## Support

- Website: [bytesagain.com](https://bytesagain.com)
- Feedback: [bytesagain.com/feedback](https://bytesagain.com/feedback)
- Email: hello@bytesagain.com

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
