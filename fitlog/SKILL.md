---
name: FitLog
description: "Track workouts, log sets and reps, and build exercise streaks over time. Use when logging sessions, tracking progress, or reviewing weekly volume."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["fitness","workout","exercise","health","gym","running","tracker","sports"]
categories: ["Health & Wellness", "Personal Management"]
---

# FitLog — Productivity Toolkit

FitLog is a command-line productivity toolkit for adding tasks, planning activities, tracking progress, reviewing work, maintaining streaks, setting reminders, prioritizing items, archiving entries, tagging content, viewing timelines, generating reports, and conducting weekly reviews — all with full timestamped history.

## Commands

| Command | Description |
|---------|-------------|
| `fitlog add <input>` | Add a new entry to the add log |
| `fitlog plan <input>` | Record a planning entry |
| `fitlog track <input>` | Log a tracking entry |
| `fitlog review <input>` | Record a review note |
| `fitlog streak <input>` | Log a streak milestone or check |
| `fitlog remind <input>` | Set or record a reminder |
| `fitlog prioritize <input>` | Log a prioritization decision |
| `fitlog archive <input>` | Archive an entry |
| `fitlog tag <input>` | Tag an entry with a label |
| `fitlog timeline <input>` | Record a timeline event |
| `fitlog report <input>` | Log a report entry |
| `fitlog weekly-review <input>` | Record a weekly review summary |
| `fitlog stats` | Show summary statistics across all log files |
| `fitlog search <term>` | Search all logs for a keyword |
| `fitlog recent` | Show the 20 most recent history entries |
| `fitlog export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `fitlog status` | Health check — version, disk usage, entry count, last activity |
| `fitlog help` | Show available commands |
| `fitlog version` | Print version string (`fitlog v2.0.0`) |

Each primary command (add, plan, track, review, etc.) works in two modes:

- **With arguments**: Saves the input with a timestamp to its dedicated `.log` file and prints a confirmation with the running total
- **Without arguments**: Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored in `~/.local/share/fitlog/`:

- **Per-command logs**: `add.log`, `plan.log`, `track.log`, `review.log`, `streak.log`, `remind.log`, `prioritize.log`, `archive.log`, `tag.log`, `timeline.log`, `report.log`, `weekly-review.log`
- **History log**: `history.log` — unified activity log across all commands
- **Export files**: `export.json`, `export.csv`, or `export.txt` when using the bulk export feature

Each log entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

## Requirements

- Bash 4+
- No external dependencies or API keys required
- Standard POSIX utilities (`wc`, `du`, `grep`, `tail`, `head`, `date`)

## When to Use

1. **Daily task tracking** — Use `fitlog add` and `fitlog track` to log tasks and activities throughout the day, building a timestamped record of everything you accomplish
2. **Planning and prioritization** — Use `fitlog plan` and `fitlog prioritize` to record plans and priority decisions, keeping a clear audit trail of what was planned vs. what was done
3. **Building consistency streaks** — Use `fitlog streak` to log daily check-ins and milestone completions, helping you maintain productive habits over time
4. **Weekly reviews** — Use `fitlog weekly-review` to summarize each week's progress, then `fitlog stats` to see aggregate numbers across all commands
5. **Archiving and organizing** — Use `fitlog tag` and `fitlog archive` to categorize and archive entries, keeping your active logs clean while preserving historical data

## Examples

```bash
# Add a new task
fitlog add "finish quarterly report draft"

# Plan tomorrow's priorities
fitlog plan "morning: code review, afternoon: deploy v2.1, evening: docs"

# Track a completed item
fitlog track "deployed staging build #247 — all tests passing"

# Log a streak milestone
fitlog streak "day 30 of daily journaling"

# Set a reminder
fitlog remind "team standup at 10am tomorrow"

# Tag an entry
fitlog tag "project-alpha milestone-3 completed"

# Generate a weekly review
fitlog weekly-review "shipped 3 features, closed 12 bugs, 2 PRs pending"

# View recent activity
fitlog recent

# Export all data as JSON
fitlog export json

# Search for a keyword
fitlog search "deploy"

# Check system status
fitlog status
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
