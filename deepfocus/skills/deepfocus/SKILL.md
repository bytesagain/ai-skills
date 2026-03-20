---
version: "1.0.0"
name: deepfocus
description: "Run Pomodoro sessions with break timers and productivity tracking. Use when starting focus sessions, tracking streaks, reviewing productivity."
---

# Deepfocus

Deepfocus v2.0.0 — a productivity toolkit for managing tasks, plans, reviews, streaks, reminders, and more from the command line.

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
| `version` | Print the current version (`deepfocus v2.0.0`). |

Each data command (add, plan, track, etc.) works in two modes:
- **With arguments**: saves the input with a timestamp to its dedicated log file.
- **Without arguments**: displays the 20 most recent entries from that log.

## Data Storage

All data is stored locally in `~/.local/share/deepfocus/`:

- Each command has its own log file (e.g., `add.log`, `plan.log`, `track.log`)
- Entries are saved in `timestamp|value` format
- A unified `history.log` records all activity across commands
- Export files are written to the same directory

## Requirements

- Bash (standard system shell)
- No external dependencies — uses only coreutils (`date`, `wc`, `du`, `grep`, `tail`, `cat`)

## When to Use

- When you need to quickly add tasks, plans, or notes from the terminal
- To track daily habits and maintain productivity streaks
- For end-of-day or weekly reviews and reflections
- To set reminders and prioritize tasks without leaving the command line
- To search through past entries by keyword
- To export your productivity data for analysis or backup
- When you want a lightweight, file-based focus and task management system

## Examples

```bash
# Add a task
deepfocus add "Write unit tests for the auth module"

# Create a plan for the day
deepfocus plan "Morning: deep work on API refactor. Afternoon: PR reviews."

# Track a habit
deepfocus track "Completed 45-minute focus session on documentation"

# Log a review
deepfocus review "Good progress on backend. Need to speed up frontend work."

# Record a streak
deepfocus streak "Day 15 of daily coding — still going strong"

# Set a reminder
deepfocus remind "Submit expense report by end of week"

# Prioritize a task
deepfocus prioritize "P0: Fix production memory leak"

# Archive an old entry
deepfocus archive "Q3 planning notes — no longer relevant"

# Tag an entry
deepfocus tag "meeting-notes: Sprint retrospective takeaways"

# Add to timeline
deepfocus timeline "Shipped v2.0 release to production"

# Generate a report
deepfocus report "Weekly output: 12 tasks completed, 3 carried over"

# Log a weekly review
deepfocus weekly-review "Best week this month — cleared the entire backlog"

# View all statistics
deepfocus stats

# Export everything as JSON
deepfocus export json

# Search for entries mentioning "focus"
deepfocus search focus

# Check recent activity
deepfocus recent

# Health check
deepfocus status
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
