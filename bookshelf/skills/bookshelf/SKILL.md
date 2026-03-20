---
name: Bookshelf
description: "Track reading progress, rate finished books, and manage your library. Use when logging books, reviewing reading stats, or planning reading goals."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["books","reading","library","list","tracker","literature","personal","knowledge"]
categories: ["Personal Management", "Productivity", "Education"]
---

# Bookshelf

A personal productivity toolkit for managing books, reading plans, progress tracking, reviews, and reading habits — all from the command line with timestamped local logging, tagging, archiving, and weekly review workflows.

## Commands

| Command | Description |
|---------|-------------|
| `bookshelf add <input>` | Add a book or item to your shelf. Without args, shows recent add entries |
| `bookshelf plan <input>` | Record a reading plan or goal. Without args, shows recent plans |
| `bookshelf track <input>` | Track reading progress. Without args, shows recent tracking entries |
| `bookshelf review <input>` | Log a book review or assessment. Without args, shows recent reviews |
| `bookshelf streak <input>` | Record a reading streak or consistency milestone. Without args, shows recent streaks |
| `bookshelf remind <input>` | Set a reading reminder note. Without args, shows recent reminders |
| `bookshelf prioritize <input>` | Record a prioritization decision. Without args, shows recent priorities |
| `bookshelf archive <input>` | Archive a finished or dropped book. Without args, shows recent archives |
| `bookshelf tag <input>` | Tag or categorize a book. Without args, shows recent tag entries |
| `bookshelf timeline <input>` | Record a reading timeline entry or milestone. Without args, shows recent timeline entries |
| `bookshelf report <input>` | Generate and log a reading report. Without args, shows recent reports |
| `bookshelf weekly-review <input>` | Record a weekly reading review summary. Without args, shows recent weekly reviews |
| `bookshelf stats` | Show summary statistics across all entry types |
| `bookshelf search <term>` | Search across all log entries for a keyword |
| `bookshelf recent` | Show the 20 most recent activity entries |
| `bookshelf status` | Health check — version, data dir, entry count, disk usage, last activity |
| `bookshelf export <fmt>` | Export all data in json, csv, or txt format |
| `bookshelf help` | Show all available commands |
| `bookshelf version` | Print version (v2.0.0) |

Each command (add, plan, track, etc.) works the same way:
- **With arguments**: saves the entry with a timestamp to its dedicated `.log` file and records it in activity history
- **Without arguments**: displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/bookshelf/
├── add.log             # Added books and items
├── plan.log            # Reading plans and goals
├── track.log           # Progress tracking entries
├── review.log          # Book reviews and assessments
├── streak.log          # Reading streak records
├── remind.log          # Reminder notes
├── prioritize.log      # Prioritization decisions
├── archive.log         # Archived / finished books
├── tag.log             # Tag and genre categorization
├── timeline.log        # Reading timeline milestones
├── report.log          # Reading reports and summaries
├── weekly-review.log   # Weekly reading review summaries
└── history.log         # Unified activity log with timestamps
```

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` for easy parsing and export.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities: `date`, `wc`, `du`, `grep`, `head`, `tail`, `cat`
- No external dependencies or API keys required
- Runs without internet — all data stays on your machine

## When to Use

1. **Reading list management** — Use `add` to build your to-read list, `prioritize` what to pick up next, and `archive` books once finished or dropped
2. **Reading habit tracking** — Track daily pages or chapters with `track`, maintain reading streaks with `streak`, and review progress in `weekly-review`
3. **Book review journaling** — After finishing a book, use `review` to log your thoughts, ratings, and key takeaways for future reference
4. **Annual reading goals** — Set yearly targets with `plan`, track progress with `stats`, and generate periodic reports with `report` to stay on pace
5. **Genre and tag organization** — Use `tag` to categorize books by genre, topic, or mood, then `search` to find the right book for any occasion

## Examples

### Add books and start reading

```bash
# Add books to your shelf
bookshelf add "Atomic Habits by James Clear — recommended by Kelly"
bookshelf add "Deep Work by Cal Newport — productivity classic"
bookshelf add "Project Hail Mary by Andy Weir — sci-fi for fun"

# Tag them by genre
bookshelf tag "Atomic Habits: #self-help #habits #productivity"
bookshelf tag "Deep Work: #productivity #focus #career"
bookshelf tag "Project Hail Mary: #sci-fi #fiction #adventure"

# Prioritize what to read next
bookshelf prioritize "Atomic Habits — start this week, short chapters"
```

### Track reading progress

```bash
# Track daily reading
bookshelf track "Atomic Habits — finished chapters 1-3, 45 pages"
bookshelf track "Atomic Habits — chapters 4-6, identity-based habits section"

# Record streaks
bookshelf streak "day 7 of reading at least 20 pages daily"
bookshelf streak "day 30 — one month streak! 🎉"

# Set a reminder
bookshelf remind "return library copy of Deep Work by April 20"

# Record a timeline milestone
bookshelf timeline "2024-04-01: started Atomic Habits reading challenge"
```

### Review, report, and archive

```bash
# Write a book review
bookshelf review "Atomic Habits — 5/5. Best takeaway: habit stacking. Changed my morning routine."

# Weekly reading review
bookshelf weekly-review "Week 15: finished Atomic Habits (5/5), started Deep Work. Read 180 pages total."

# Generate a monthly report
bookshelf report "April: 2 books finished, 1 in progress. 620 pages read. On track for 24-book goal."

# Set reading plans
bookshelf plan "Q2 goal: finish 6 books — 2 non-fiction, 2 sci-fi, 2 technical"

# Archive finished books
bookshelf archive "Atomic Habits — completed 2024-04-10, review saved"

# Check overall stats
bookshelf stats
bookshelf recent
```

### Search and export

```bash
# Search for a book or topic
bookshelf search "productivity"

# Export entire library as JSON
bookshelf export json

# Export as CSV for spreadsheet tracking
bookshelf export csv

# Health check
bookshelf status
```

## Output

All commands print confirmation to stdout. Data is persisted in `~/.local/share/bookshelf/`. Use `bookshelf stats` for an overview, `bookshelf search <term>` to find specific entries, or `bookshelf export <fmt>` to extract all data as JSON, CSV, or plain text.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
