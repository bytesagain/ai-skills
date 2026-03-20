---
name: Stopwatch
description: "Run stopwatch, timer, and lap tracking with precision in terminal. Use when timing tasks, checking durations, running countdowns, analyzing splits."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["timer","stopwatch","countdown","time","lap"]
categories: ["Developer Tools", "Utility"]
---
# Stopwatch

Stopwatch v2.0.0 — a versatile utility toolkit for logging, tracking, and managing time-related entries from the command line. Each command logs timestamped entries to individual log files, provides history viewing, summary statistics, data export, and full-text search across all records.

## Commands

Run `stopwatch <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `run <input>` | Log a run entry (or view recent run entries if no input given) |
| `check <input>` | Log a check entry (or view recent check entries if no input given) |
| `convert <input>` | Log a convert entry (or view recent convert entries if no input given) |
| `analyze <input>` | Log an analyze entry (or view recent analyze entries if no input given) |
| `generate <input>` | Log a generate entry (or view recent generate entries if no input given) |
| `preview <input>` | Log a preview entry (or view recent preview entries if no input given) |
| `batch <input>` | Log a batch entry (or view recent batch entries if no input given) |
| `compare <input>` | Log a compare entry (or view recent compare entries if no input given) |
| `export <input>` | Log an export entry (or view recent export entries if no input given) |
| `config <input>` | Log a config entry (or view recent config entries if no input given) |
| `status <input>` | Log a status entry (or view recent status entries if no input given) |
| `report <input>` | Log a report entry (or view recent report entries if no input given) |
| `stats` | Show summary statistics across all log files (entry counts, data size) |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Full-text search across all log entries (case-insensitive) |
| `recent` | Show the 20 most recent entries from history.log |
| `help` | Show usage help |
| `version` | Show version (v2.0.0) |

## How It Works

Every command (run, check, convert, analyze, etc.) works the same way:

- **With arguments:** Saves a timestamped entry (`YYYY-MM-DD HH:MM|input`) to `<command>.log` and writes to `history.log`.
- **Without arguments:** Displays the 20 most recent entries from that command's log file.

This gives you a lightweight, file-based logging system for any kind of time-tracking workflow.

## Data Storage

All data is stored locally in `~/.local/share/stopwatch/`:

```
~/.local/share/stopwatch/
├── run.log          # Run entries (timestamp|value)
├── check.log        # Check entries
├── convert.log      # Convert entries
├── analyze.log      # Analyze entries
├── generate.log     # Generate entries
├── preview.log      # Preview entries
├── batch.log        # Batch entries
├── compare.log      # Compare entries
├── export.log       # Export entries
├── config.log       # Config entries
├── status.log       # Status entries
├── report.log       # Report entries
├── history.log      # Master activity log
└── export.<fmt>     # Exported data files
```

Override the data directory by setting `STOPWATCH_DIR` (if supported) or editing the `DATA_DIR` variable in the script.

## Requirements

- Bash (4.0+)
- Standard POSIX utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies — works on any Linux or macOS system out of the box

## When to Use

1. **Tracking timed activities** — Log start/stop times for tasks, pomodoro sessions, or work intervals throughout the day.
2. **Comparing performance across runs** — Use `compare` and `analyze` to log different attempts, then `search` or `stats` to review trends.
3. **Batch processing records** — Use `batch` to log bulk operations, then `export json` to feed results into other tools.
4. **Quick status checks in automation** — Integrate `stopwatch status` or `stopwatch stats` into cron jobs or CI pipelines for operational dashboards.
5. **Generating reports from logged data** — Use `report` to log milestones, then `export csv` to create spreadsheets or feed into reporting tools.

## Examples

```bash
# Log a run entry
stopwatch run "Morning sprint: 25 minutes"

# Check recent activity
stopwatch recent

# View all run entries
stopwatch run

# Search for a specific term across all logs
stopwatch search "sprint"

# Get summary statistics
stopwatch stats

# Export everything to JSON
stopwatch export json

# Export to CSV for spreadsheet import
stopwatch export csv
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
stopwatch stats > report.txt
stopwatch export json  # writes to ~/.local/share/stopwatch/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
