---
version: "1.0.0"
name: File Finder
description: "Search files and directories faster than find. Use when locating nested files, planning directory cleanups, tracking recent changes, reviewing metadata."
---

# Quickfind

A productivity toolkit for managing tasks, planning goals, tracking habits, setting reminders, and running weekly reviews. Build a complete personal productivity system from the command line with persistent local storage.

## Quick Start

```bash
bash scripts/script.sh <command> [args...]
```

## Commands

**Task Management**
- `add <input>` — Add a new task or item (without args: show recent additions)
- `prioritize <input>` — Set or record a priority for a task (without args: show recent priorities)
- `archive <input>` — Archive a completed or outdated item (without args: show recent archives)
- `tag <input>` — Tag an item with a label or category (without args: show recent tags)

**Planning & Tracking**
- `plan <input>` — Record a plan or goal (without args: show recent plans)
- `track <input>` — Track progress on a task or habit (without args: show recent tracking entries)
- `streak <input>` — Log a streak or consistency record (without args: show recent streaks)
- `timeline <input>` — Add a timeline entry or milestone (without args: show recent timeline entries)

**Review & Reporting**
- `review <input>` — Record a review note or reflection (without args: show recent reviews)
- `report <input>` — Create a summary report entry (without args: show recent reports)
- `weekly-review <input>` — Log a weekly review summary (without args: show recent weekly reviews)

**Reminders**
- `remind <input>` — Set or log a reminder (without args: show recent reminders)

**Utilities**
- `stats` — Show summary statistics across all entry types
- `export <fmt>` — Export all data (formats: `json`, `csv`, `txt`)
- `search <term>` — Search across all log files for a keyword
- `recent` — Show the 20 most recent activity log entries
- `status` — Display health check: version, data dir, entry count, disk usage
- `help` — Show available commands
- `version` — Print version (v2.0.0)

Each command accepts free-text input. When called without arguments, it displays the most recent 20 entries for that category.

## Data Storage

All data is stored as plain-text log files in:

```
~/.local/share/quickfind/
├── add.log            # New tasks and items
├── prioritize.log     # Priority assignments
├── archive.log        # Archived items
├── tag.log            # Tags and labels
├── plan.log           # Plans and goals
├── track.log          # Progress tracking
├── streak.log         # Streak and consistency records
├── timeline.log       # Timeline entries and milestones
├── review.log         # Review notes
├── report.log         # Summary reports
├── weekly-review.log  # Weekly review summaries
├── remind.log         # Reminders
└── history.log        # Unified activity history
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` — one line per record. The `history.log` file tracks all commands chronologically.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies, no network access required
- Write access to `~/.local/share/quickfind/`

## When to Use

1. **Daily task capture and prioritization** — Use `add` to quickly capture tasks as they arise, then `prioritize` to rank them by importance for focused execution
2. **Habit tracking and streak building** — Use `track` and `streak` to log daily habits (exercise, reading, coding) and maintain accountability through visible consistency records
3. **Weekly planning and review cycles** — Use `plan` at the start of the week to set goals, then `weekly-review` at the end to reflect on progress and adjust next week's priorities
4. **Project timeline management** — Use `timeline` to record milestones and deadlines, `tag` to categorize items by project, and `report` to generate progress summaries
5. **Personal knowledge and reminder system** — Use `remind` to log things you need to remember, `review` for retrospective notes, and `search` to quickly find past entries across all categories

## Examples

```bash
# Add a new task
quickfind add "Write blog post about bash productivity tools"

# Plan weekly goals
quickfind plan "This week: finish API docs, review PRs, prep demo"

# Track a daily habit
quickfind track "Morning run: 5km in 28 minutes"

# Log a streak
quickfind streak "Reading streak: day 45 consecutive"

# Set a reminder
quickfind remind "Submit tax forms by April 15"

# Tag an item
quickfind tag "blog-post: category=writing, priority=high"

# Run a weekly review
quickfind weekly-review "Completed 8/10 planned tasks. Carry over: API docs, demo prep."

# View all statistics
quickfind stats

# Export everything to JSON
quickfind export json

# Search for entries about a specific topic
quickfind search "blog"
```

## Configuration

Set `QUICKFIND_DIR` environment variable to override the default data directory. Default: `~/.local/share/quickfind/`

## Output

All commands output to stdout. Redirect to a file with `quickfind <command> > output.txt`. Export formats (json, csv, txt) write to the data directory and report the output path and file size.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
