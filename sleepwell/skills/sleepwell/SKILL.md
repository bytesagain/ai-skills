---
name: SleepWell
description: "Track sleep habits and analyze rest patterns over time. Use when logging bedtimes, planning schedules, tracking streaks, reviewing weekly patterns."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["sleep","health","wellness","tracker","rest","habits","quality","bedtime"]
categories: ["Health & Wellness", "Personal Management", "Productivity"]
---

# SleepWell

Productivity toolkit for managing tasks, plans, reviews, streaks, reminders, priorities, archives, tags, timelines, reports, and weekly reviews. Each command logs timestamped entries and lets you review past entries, search history, view statistics, and export data in multiple formats.

## Commands

| Command | Description |
|---------|-------------|
| `sleepwell add <input>` | Add a new entry (or view recent add entries with no args) |
| `sleepwell plan <input>` | Log a plan entry (or view recent plans with no args) |
| `sleepwell track <input>` | Log a tracking entry (or view recent entries with no args) |
| `sleepwell review <input>` | Log a review entry (or view recent reviews with no args) |
| `sleepwell streak <input>` | Log a streak entry (or view recent streaks with no args) |
| `sleepwell remind <input>` | Log a reminder (or view recent reminders with no args) |
| `sleepwell prioritize <input>` | Log a priority entry (or view recent priorities with no args) |
| `sleepwell archive <input>` | Archive an entry (or view recent archives with no args) |
| `sleepwell tag <input>` | Tag an entry (or view recent tags with no args) |
| `sleepwell timeline <input>` | Log a timeline entry (or view recent timeline with no args) |
| `sleepwell report <input>` | Log a report entry (or view recent reports with no args) |
| `sleepwell weekly-review <input>` | Log a weekly review (or view recent weekly reviews with no args) |
| `sleepwell stats` | Show summary statistics across all log categories |
| `sleepwell export <fmt>` | Export all data to json, csv, or txt format |
| `sleepwell search <term>` | Search across all log files for a term |
| `sleepwell recent` | Show the 20 most recent history entries |
| `sleepwell status` | Health check: version, data dir, entry count, disk usage, last activity |
| `sleepwell help` | Show help with all available commands |
| `sleepwell version` | Show version number |

## How It Works

Each productivity command (add, plan, track, review, etc.) works in two modes:

- **With arguments**: Saves the input with a timestamp to a dedicated `.log` file and displays the total entry count
- **Without arguments**: Shows the 20 most recent entries from that category's log file

All actions are also recorded in a central `history.log` for unified tracking.

### Typical Workflow

1. **Plan your day**: `sleepwell plan "Focus on Q2 report, finish by 3pm"`
2. **Track tasks**: `sleepwell track "Started Q2 report — gathering data"`
3. **Set reminders**: `sleepwell remind "Send draft to team by 4pm"`
4. **Prioritize**: `sleepwell prioritize "Q2 report > email cleanup > meeting prep"`
5. **Review progress**: `sleepwell review "Completed 3/5 tasks, good day"`
6. **Weekly roundup**: `sleepwell weekly-review "Productive week, hit all deadlines"`

## Data Storage

All data is stored in `~/.local/share/sleepwell/`. The directory contains:

- `add.log`, `plan.log`, `track.log`, `review.log`, etc. — one log file per command category
- `history.log` — central log of all actions with timestamps
- `export.json`, `export.csv`, `export.txt` — generated export files

The tool automatically creates the data directory on first run.

## Requirements

- **Shell**: Bash 4+
- **No external dependencies** — uses only standard Unix utilities (`date`, `wc`, `du`, `grep`, `tail`, `head`)
- **Works on**: Linux, macOS, any POSIX-compatible system

## When to Use

1. **Daily task management** — Use `sleepwell add "fix login bug"` and `sleepwell track "started debugging"` to log and track tasks throughout the day
2. **Sprint planning** — Run `sleepwell plan "Sprint 14: auth refactor, API docs, deploy"` to record sprint plans and reference them later
3. **Building accountability streaks** — Log daily wins with `sleepwell streak "Day 15: shipped feature"` and review your consistency over time
4. **Weekly retrospectives** — Use `sleepwell weekly-review "Good velocity, need to reduce meeting time"` for structured reflection
5. **Searching past decisions** — Run `sleepwell search "deploy"` to find all entries across every category mentioning deployments

## Examples

```bash
# Add a new task
sleepwell add "Refactor authentication module"

# Plan tomorrow's work
sleepwell plan "Morning: code review. Afternoon: API integration"

# Track progress on current task
sleepwell track "Auth module 60% complete, tests passing"

# Set a reminder
sleepwell remind "Team standup at 10:00 AM"

# Prioritize tasks
sleepwell prioritize "1. Deploy hotfix 2. Review PR #42 3. Update docs"

# Tag an entry for easy retrieval
sleepwell tag "urgent: production database migration"

# Log a timeline milestone
sleepwell timeline "v2.0 beta released to internal testers"

# Generate a report
sleepwell report "March metrics: 23 features, 8 bugs fixed, 99.5% uptime"

# Archive completed items
sleepwell archive "Q1 OKR tracking — completed and filed"

# Weekly review
sleepwell weekly-review "Shipped 3 features, resolved 2 blockers"

# View statistics across all categories
sleepwell stats

# Export all data as CSV
sleepwell export csv

# Search for deployment-related entries
sleepwell search "deploy"

# View recent activity
sleepwell recent

# Health check
sleepwell status
```

## Export Formats

The `export` command supports three formats:

- **json** — Array of objects with `type`, `time`, and `value` fields
- **csv** — Comma-separated with `type,time,value` header
- **txt** — Plain text grouped by category

Export files are saved to the data directory and the output shows the file path and size in bytes.

## Output

All command output goes to stdout in plain text. Use shell redirection for saving:

```bash
sleepwell stats > weekly-report.txt
sleepwell export json
sleepwell recent | head -5
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
