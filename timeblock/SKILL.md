---
name: TimeBlock
description: "Plan your day hour-by-hour with intentional time blocking. Use when blocking sessions, checking plans, analyzing allocation, generating agendas."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["timeblocking","schedule","planner","calendar","productivity","focus","daily"]
categories: ["Productivity", "Personal Management"]
---

# Timeblock

Timeblock v2.0.0 — a utility toolkit for logging, tracking, and managing time-blocking operations from the command line. All data is stored locally in flat log files with timestamps, making it easy to review history, export records, and search across entries.

## Commands

Run `scripts/script.sh <command> [args]` to use.

### Core Operations

| Command | Description |
|---------|-------------|
| `run <input>` | Log a run entry (e.g. execute a time block, start a session) |
| `check <input>` | Log a check entry (e.g. verify block completion, review schedule) |
| `convert <input>` | Log a convert entry (e.g. convert time formats, transform schedules) |
| `analyze <input>` | Log an analyze entry (e.g. analyze time allocation, productivity patterns) |
| `generate <input>` | Log a generate entry (e.g. generate daily schedules, weekly plans) |
| `preview <input>` | Log a preview entry (e.g. preview tomorrow's blocks, upcoming week) |
| `batch <input>` | Log a batch entry (e.g. batch-create time blocks for a week) |
| `compare <input>` | Log a compare entry (e.g. compare planned vs actual time usage) |
| `export <input>` | Log an export entry (e.g. export schedule to calendar, share plan) |
| `config <input>` | Log a config entry (e.g. set block durations, default categories) |
| `status <input>` | Log a status entry (e.g. current block status, schedule progress) |
| `report <input>` | Log a report entry (e.g. daily/weekly time reports, utilization summaries) |

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
| `version` | Show version string (`timeblock v2.0.0`) |

## Data Storage

All data is persisted locally under `~/.local/share/timeblock/`:

- **`<command>.log`** — One log file per command (e.g. `run.log`, `check.log`, `analyze.log`)
- **`history.log`** — Global activity log with timestamps for every operation
- **`export.<fmt>`** — Generated export files (json/csv/txt)

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). No external services, no API keys, no network calls — everything stays on your machine.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or packages required
- No API keys or accounts needed

## When to Use

1. **Planning your day** — Use `generate` and `run` to create and log time blocks for each hour, building a structured daily schedule you can search and review later
2. **Tracking schedule adherence** — Use `check` and `compare` to record whether you completed blocks as planned, then `stats` to see completion patterns over time
3. **Analyzing time allocation** — Use `analyze` to log how you actually spent your time, then `search` to find patterns across categories like deep work, meetings, or breaks
4. **Batch-creating weekly plans** — Use `batch` to log entire week schedules at once, then `preview` to review upcoming blocks before each day starts
5. **Generating productivity reports** — Use `report` to log daily summaries, then `export csv` to pull structured data for time-tracking spreadsheets or dashboards

## Examples

```bash
# Log a time block session
timeblock run "09:00-10:30 Deep work on project Alpha"

# Generate a daily schedule
timeblock generate "Monday: 09:00 deep work, 10:30 standup, 11:00 code review, 14:00 planning"

# Check schedule completion
timeblock check "Morning blocks completed: 3/4, missed 10:30 standup"

# Compare planned vs actual
timeblock compare "Planned 4h deep work, actual 2.5h — meetings overran by 1.5h"

# Search for all deep work entries
timeblock search "deep work"

# Export everything to JSON
timeblock export json

# View overall statistics
timeblock stats
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
