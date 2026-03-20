---
version: "1.0.0"
name: streakup
description: "Build better habits by tracking daily streaks and progress. Use when logging habits, checking streaks, analyzing consistency, generating reports."
---
# Streakup

Streakup v2.0.0 — a versatile utility toolkit for logging, tracking, and managing habit-related entries from the command line. Each command logs timestamped entries to individual log files, provides history viewing, summary statistics, data export, and full-text search across all records.

## Commands

Run `streakup <command> [args]` to use.

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

This gives you a lightweight, file-based logging system for tracking habits, streaks, and daily progress.

## Data Storage

All data is stored locally in `~/.local/share/streakup/`:

```
~/.local/share/streakup/
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

## Requirements

- Bash (4.0+)
- Standard POSIX utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies — works on any Linux or macOS system out of the box

## When to Use

1. **Daily habit check-ins** — Use `streakup check "meditation done"` each day to build a log of completed habits and track your consistency.
2. **Analyzing habit patterns** — Use `streakup analyze "week 12 review"` to log periodic reviews, then `search` or `stats` to spot trends.
3. **Comparing habit performance** — Use `streakup compare "running vs reading"` to log comparisons and review which habits stick.
4. **Generating streak reports** — Use `streakup report "monthly summary"` to log milestones, then `export csv` for spreadsheet analysis.
5. **Batch logging multiple habits** — Use `streakup batch "exercise, reading, journaling"` to record several habits in one entry.

## Examples

```bash
# Log a habit check-in
streakup check "Morning run completed - 5km"

# Log a run entry for tracking
streakup run "Day 15 streak - meditation"

# View recent activity across all commands
streakup recent

# Search for all meditation-related entries
streakup search "meditation"

# Get summary statistics
streakup stats

# Export all habit data to JSON
streakup export json

# Export to CSV for spreadsheet analysis
streakup export csv

# Generate a report entry
streakup report "Week 4: 6/7 days completed"
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
streakup stats > progress.txt
streakup export json  # writes to ~/.local/share/streakup/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
