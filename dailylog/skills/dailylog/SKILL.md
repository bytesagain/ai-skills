---
name: DailyLog
description: "Record daily wins, challenges, and learnings with streak tracking. Use when logging reflections, tracking streaks, reviewing weekly progress."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["daily","log","journal","reflection","productivity","wins","challenges"]
categories: ["Personal Management", "Productivity"]
---
# DailyLog

Productivity toolkit for structured daily logging, planning, habit tracking, reviews, reminders, and weekly reports. Every entry is timestamped and stored locally. Build streaks, tag entries, create timelines, and generate periodic reports to stay on top of your goals.

## Commands

### Core Productivity Commands

| Command | Description |
|---------|-------------|
| `dailylog add <input>` | Add a general log entry (thought, note, observation). Without arguments, shows recent entries. |
| `dailylog plan <input>` | Log a plan or intention for the day/week. Without arguments, shows recent plans. |
| `dailylog track <input>` | Track a habit, metric, or progress item. Without arguments, shows recent tracked items. |
| `dailylog review <input>` | Record a review or reflection on completed work. Without arguments, shows recent reviews. |
| `dailylog streak <input>` | Log a streak milestone or streak-related note (e.g., "Day 30 of running"). Without arguments, shows recent streak entries. |
| `dailylog remind <input>` | Set a reminder or log something to follow up on. Without arguments, shows recent reminders. |
| `dailylog prioritize <input>` | Log priority rankings or mark high-priority items. Without arguments, shows recent priority entries. |
| `dailylog archive <input>` | Archive a completed item or old entry. Without arguments, shows recent archived items. |
| `dailylog tag <input>` | Tag an entry with a label or category for organization. Without arguments, shows recent tags. |
| `dailylog timeline <input>` | Add an event or milestone to your personal timeline. Without arguments, shows recent timeline entries. |
| `dailylog report <input>` | Log a report or summary for a period. Without arguments, shows recent reports. |
| `dailylog weekly-review <input>` | Record a structured weekly review. Without arguments, shows recent weekly reviews. |

### Utility Commands

| Command | Description |
|---------|-------------|
| `dailylog stats` | Show summary statistics across all log categories (entry counts, data size, first entry date). |
| `dailylog export <format>` | Export all data in `json`, `csv`, or `txt` format. Output saved to the data directory. |
| `dailylog search <term>` | Search across all log files for a keyword or phrase (case-insensitive). |
| `dailylog recent` | Show the 20 most recent entries from the activity history log. |
| `dailylog status` | Health check — shows version, data directory, total entries, disk usage, and last activity. |
| `dailylog help` | Display all available commands and usage information. |
| `dailylog version` | Show the current version (v2.0.0). |

## Data Storage

All data is stored in `~/.local/share/dailylog/` as plain-text log files:

- Each command category has its own `.log` file (e.g., `add.log`, `plan.log`, `streak.log`, `weekly-review.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|value` format
- A central `history.log` tracks all activity across commands
- Export files are saved as `export.json`, `export.csv`, or `export.txt` in the same directory

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `cut`
- No external API keys or network access required
- No additional dependencies to install

## When to Use

1. **Morning planning sessions** — Use `plan` and `prioritize` to set your daily intentions and rank tasks by importance before starting work.
2. **Habit tracking and streaks** — Use `track` and `streak` to log daily habits (exercise, reading, coding) and celebrate milestone streaks.
3. **End-of-day reflections** — Use `add` and `review` to capture what went well, what didn't, and lessons learned each evening.
4. **Weekly retrospectives** — Use `weekly-review` and `report` to summarize accomplishments, blockers, and goals for the next week.
5. **Organizing and archiving work** — Use `tag`, `archive`, and `timeline` to label entries, retire completed items, and build a chronological record of milestones.

## Examples

### Morning planning workflow
```bash
dailylog plan "Focus on API refactor and code review today"
dailylog prioritize "1. API refactor 2. Code review 3. Update docs"
dailylog remind "Follow up with design team on mockups by 3 PM"
```

### Track habits and streaks
```bash
dailylog track "Ran 5km in 28 minutes"
dailylog streak "Day 15 of daily running — new personal best"
dailylog tag "running, fitness, personal-best"
```

### End-of-day reflection
```bash
dailylog add "Shipped the API refactor ahead of schedule"
dailylog review "Code review went smoothly, found 2 edge cases to fix tomorrow"
dailylog timeline "API v2 refactor completed"
```

### Weekly review and export
```bash
dailylog weekly-review "Completed 8/10 planned tasks. Blockers: waiting on design approval."
dailylog report "Week 12: shipped API v2, started onboarding docs, 5-day running streak"
dailylog export json
dailylog stats
```

### Search and status
```bash
dailylog search "API"
dailylog recent
dailylog status
dailylog archive "Q1 planning notes — no longer active"
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
