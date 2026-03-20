---
version: "2.0.0"
name: bookworm
description: "Log books, track reading habits, and review reading streaks over time. Use when recording reads, maintaining goals, or analyzing genre preferences."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Bookworm

Bookworm v2.0.0 — a productivity toolkit for logging, planning, tracking, reviewing, and organizing your work and reading habits from the command line.

## Why Bookworm?

- Designed for everyday personal productivity use
- No external dependencies, accounts, or API keys needed — your privacy, your data
- Simple commands with powerful results
- All data saved on your machine in plain-text log files
- Export to JSON, CSV, or TXT at any time

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `add` | `bookworm add <input>` | Add a new entry (book, task, note) to your log |
| `plan` | `bookworm plan <input>` | Record a plan or goal for future action |
| `track` | `bookworm track <input>` | Track progress on an ongoing activity |
| `review` | `bookworm review <input>` | Log a review or reflection on completed work |
| `streak` | `bookworm streak <input>` | Record streak data for daily habit tracking |
| `remind` | `bookworm remind <input>` | Set a reminder note for follow-up |
| `prioritize` | `bookworm prioritize <input>` | Mark or log priority items |
| `archive` | `bookworm archive <input>` | Move completed items to the archive |
| `tag` | `bookworm tag <input>` | Add tags or labels to organize entries |
| `timeline` | `bookworm timeline <input>` | Log timeline milestones or events |
| `report` | `bookworm report <input>` | Generate or log a report entry |
| `weekly-review` | `bookworm weekly-review <input>` | Perform a weekly review and log insights |
| `stats` | `bookworm stats` | Show summary statistics across all log files |
| `export` | `bookworm export <fmt>` | Export all data (json, csv, or txt) |
| `search` | `bookworm search <term>` | Search across all log files for a keyword |
| `recent` | `bookworm recent` | Show the 20 most recent history entries |
| `status` | `bookworm status` | Health check — version, entry count, disk usage |
| `help` | `bookworm help` | Show the help message with all commands |
| `version` | `bookworm version` | Print the current version |

All entry commands (add, plan, track, review, streak, remind, prioritize, archive, tag, timeline, report, weekly-review) work the same way:
- **With arguments**: saves a timestamped entry to `<command>.log` and logs to `history.log`
- **Without arguments**: displays the 20 most recent entries from that command's log

## Data Storage

All data is stored in `~/.local/share/bookworm/`:

- `add.log`, `plan.log`, `track.log`, etc. — one log file per command
- `history.log` — unified activity log across all commands
- `export.json` / `export.csv` / `export.txt` — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited timestamp and content).

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `head`, `tail`, `cat`
- No external dependencies, no Python, no API keys

## When to Use

1. **Daily reading log** — Use `bookworm add "Finished Chapter 5 of Sapiens"` to maintain a running log of your reading progress day by day.
2. **Habit streak tracking** — Use `bookworm streak "Day 15 of reading 30min/day"` to record consecutive-day habits and review your consistency over time.
3. **Weekly reflection** — Use `bookworm weekly-review "Read 3 books, favorite was Project Hail Mary"` at the end of each week to capture insights and progress.
4. **Priority management** — Use `bookworm prioritize "Must finish Design Patterns by Friday"` to flag high-priority items and review them with `bookworm prioritize`.
5. **Data export for analysis** — Use `bookworm export json` to export all your logged data into a structured format for further analysis in spreadsheets or scripts.

## Examples

```bash
# Add a book to your reading list
bookworm add "The Pragmatic Programmer - Hunt & Thomas"

# Plan your reading goals for the month
bookworm plan "Read 4 books in March: 2 fiction, 2 non-fiction"

# Track reading progress
bookworm track "Sapiens - Chapter 8/21 complete"

# Log a book review
bookworm review "Clean Code: Excellent guide to writing maintainable software. 5/5"

# Record a reading streak
bookworm streak "Day 30 - read every day this month!"

# Set a reminder
bookworm remind "Return library books by March 25"

# Tag entries for organization
bookworm tag "Sapiens #non-fiction #history #favorite"

# View summary statistics
bookworm stats

# Search for a specific book or keyword
bookworm search "Sapiens"

# Export everything to CSV
bookworm export csv

# Check system status
bookworm status
```

## Configuration

Data directory: `~/.local/share/bookworm/` (hardcoded, no environment variable override).

## Output

All commands print results to stdout. Redirect output to a file if needed:

```bash
bookworm stats > my-stats.txt
bookworm export json
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
