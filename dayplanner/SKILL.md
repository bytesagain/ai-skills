---
version: "1.0.0"
name: dayplanner
description: "日程规划工具。周计划、月计划、时间块、会议安排、截止日期管理、工作生活平衡。Calendar planner with weekly, monthly, time-blocking, meeting scheduling, deadline management."
---

# Dayplanner

Dayplanner v2.0.0 — a productivity toolkit for managing tasks, plans, reviews, streaks, reminders, and more from the command line.

## Commands

Run via: `bash scripts/script.sh <command> [args]`

| Command | Description |
|---------|-------------|
| `add <input>` | Add a new entry (task, note, idea). Without args, shows recent entries. |
| `plan <input>` | Create or view plan entries for organizing your day/week. |
| `track <input>` | Track progress on goals, habits, or tasks. |
| `review <input>` | Log review notes — reflect on what went well or needs improvement. |
| `streak <input>` | Record streak data for habit tracking and consistency. |
| `remind <input>` | Set reminders and notes for future reference. |
| `prioritize <input>` | Mark and log priority levels for tasks. |
| `archive <input>` | Archive completed or outdated entries. |
| `tag <input>` | Tag entries with labels for easy categorization. |
| `timeline <input>` | Add timeline entries for chronological tracking. |
| `report <input>` | Generate or log report entries for summaries. |
| `weekly-review <input>` | Log weekly review notes for end-of-week reflection. |
| `stats` | Show summary statistics across all entry types. |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search across all log files for a keyword. |
| `recent` | Show the 20 most recent activity entries from the history log. |
| `status` | Health check — version, data directory, entry count, disk usage. |
| `help` | Show the built-in help message with all available commands. |
| `version` | Print the current version (`dayplanner v2.0.0`). |

Each data command (add, plan, track, etc.) works in two modes:
- **With arguments**: saves the input with a timestamp to its dedicated log file.
- **Without arguments**: displays the 20 most recent entries from that log.

## Data Storage

All data is stored locally in `~/.local/share/dayplanner/`:

- Each command has its own log file (e.g., `add.log`, `plan.log`, `track.log`)
- Entries are saved in `timestamp|value` format
- A unified `history.log` records all activity across commands
- Export files are written to the same directory

## Requirements

- Bash (standard system shell)
- No external dependencies — uses only coreutils (`date`, `wc`, `du`, `grep`, `tail`, `cat`)

## When to Use

- When you need to quickly add tasks, plans, or notes from the terminal
- To track daily habits and streaks without leaving the command line
- For end-of-day or weekly reviews and reflections
- To search through past entries by keyword
- To export your productivity data for analysis or backup
- When you want a lightweight, file-based task management system

## Examples

```bash
# Add a task
dayplanner add "Finish the quarterly report by Friday"

# Create a plan for the day
dayplanner plan "Morning: deep work on API. Afternoon: code review."

# Track a habit
dayplanner track "Meditated for 20 minutes"

# Log a weekly review
dayplanner weekly-review "Shipped 3 features, need to improve test coverage"

# Set a reminder
dayplanner remind "Call dentist tomorrow at 10am"

# Prioritize a task
dayplanner prioritize "Deploy hotfix — critical"

# View all statistics
dayplanner stats

# Export everything as JSON
dayplanner export json

# Search for entries mentioning "report"
dayplanner search report

# Check recent activity
dayplanner recent

# Health check
dayplanner status
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
