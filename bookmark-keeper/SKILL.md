---
version: "2.0.0"
name: bookmark-keeper
description: "Save, organize, and search web bookmarks with tags and categories. Use when collecting research links, organizing lists, or reviewing resources."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Bookmark Keeper

A productivity toolkit for managing bookmarks, plans, tasks, and reviews — all from the command line with timestamped local logging, tagging, archiving, and weekly review workflows.

## Commands

| Command | Description |
|---------|-------------|
| `bookmark-keeper add <input>` | Add a new bookmark or item. Without args, shows recent add entries |
| `bookmark-keeper plan <input>` | Record a plan or goal. Without args, shows recent plans |
| `bookmark-keeper track <input>` | Track progress on an item. Without args, shows recent tracking entries |
| `bookmark-keeper review <input>` | Log a review or assessment. Without args, shows recent reviews |
| `bookmark-keeper streak <input>` | Record a streak or consistency milestone. Without args, shows recent streaks |
| `bookmark-keeper remind <input>` | Set a reminder note. Without args, shows recent reminders |
| `bookmark-keeper prioritize <input>` | Record a prioritization decision. Without args, shows recent priorities |
| `bookmark-keeper archive <input>` | Archive a completed or inactive item. Without args, shows recent archives |
| `bookmark-keeper tag <input>` | Add tags or categorize an item. Without args, shows recent tag entries |
| `bookmark-keeper timeline <input>` | Record a timeline entry or milestone. Without args, shows recent timeline entries |
| `bookmark-keeper report <input>` | Generate and log a report. Without args, shows recent reports |
| `bookmark-keeper weekly-review <input>` | Record a weekly review summary. Without args, shows recent weekly reviews |
| `bookmark-keeper stats` | Show summary statistics across all entry types |
| `bookmark-keeper search <term>` | Search across all log entries for a keyword |
| `bookmark-keeper recent` | Show the 20 most recent activity entries |
| `bookmark-keeper status` | Health check — version, data dir, entry count, disk usage, last activity |
| `bookmark-keeper export <fmt>` | Export all data in json, csv, or txt format |
| `bookmark-keeper help` | Show all available commands |
| `bookmark-keeper version` | Print version (v2.0.0) |

Each command (add, plan, track, etc.) works the same way:
- **With arguments**: saves the entry with a timestamp to its dedicated `.log` file and records it in activity history
- **Without arguments**: displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/bookmark-keeper/
├── add.log             # Added bookmarks and items
├── plan.log            # Plans and goals
├── track.log           # Progress tracking entries
├── review.log          # Reviews and assessments
├── streak.log          # Streak / consistency records
├── remind.log          # Reminder notes
├── prioritize.log      # Prioritization decisions
├── archive.log         # Archived items
├── tag.log             # Tag and categorization entries
├── timeline.log        # Timeline milestones
├── report.log          # Generated reports
├── weekly-review.log   # Weekly review summaries
└── history.log         # Unified activity log with timestamps
```

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` for easy parsing and export.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities: `date`, `wc`, `du`, `grep`, `head`, `tail`, `cat`
- No external dependencies or API keys required
- Runs without internet — all data stays on your machine

## When to Use

1. **Research link collection** — Use `add` to save URLs with notes as you research a topic, then `tag` to categorize them and `search` to find them later
2. **Weekly productivity reviews** — Run `weekly-review` every Sunday to summarize what you accomplished, what's pending, and what to focus on next week
3. **Goal tracking with streaks** — Set goals with `plan`, track daily progress with `track`, and celebrate consistency milestones with `streak`
4. **Reading list management** — Add articles and resources with `add`, `prioritize` what to read next, and `archive` items once consumed
5. **Project milestone tracking** — Use `timeline` to record key milestones, `report` to generate progress summaries, and `remind` to set follow-up notes

## Examples

### Build a bookmark collection

```bash
# Add bookmarks with notes
bookmark-keeper add "https://example.com/rust-guide — thorough Rust tutorial"
bookmark-keeper add "https://arxiv.org/abs/2401.12345 — attention mechanisms survey paper"

# Tag them for organization
bookmark-keeper tag "rust-guide: #programming #rust #tutorial"
bookmark-keeper tag "attention-paper: #ml #research #papers"

# Search later
bookmark-keeper search "rust"

# Prioritize what to read first
bookmark-keeper prioritize "rust-guide — high priority, needed for current project"
```

### Weekly review workflow

```bash
# Track daily progress
bookmark-keeper track "completed 3 chapters of Rust book, built first CLI tool"
bookmark-keeper track "reviewed 5 research papers, summarized key findings"

# Record streaks
bookmark-keeper streak "day 14 of daily coding practice"

# Do your weekly review
bookmark-keeper weekly-review "Week 12: finished Rust basics, started async chapter. Read 5 papers. Next week: build REST API in Rust."

# Generate a report
bookmark-keeper report "March progress: 20 bookmarks added, 12 reviewed, 8 archived"
```

### Plan, remind, and archive

```bash
# Set a plan
bookmark-keeper plan "Q2 reading goal: 15 technical articles, 3 books"

# Set reminders
bookmark-keeper remind "follow up on ML paper discussion — Friday"

# Record a timeline milestone
bookmark-keeper timeline "2024-04-01: started Rust learning path"

# Archive completed items
bookmark-keeper archive "rust-guide — completed, notes saved to wiki"

# View stats and recent activity
bookmark-keeper stats
bookmark-keeper recent
```

### Export and status

```bash
# Export everything as JSON
bookmark-keeper export json

# Export as CSV for spreadsheet analysis
bookmark-keeper export csv

# Health check
bookmark-keeper status
```

## Output

All commands print confirmation to stdout. Data is persisted in `~/.local/share/bookmark-keeper/`. Use `bookmark-keeper stats` for an overview, `bookmark-keeper search <term>` to find specific entries, or `bookmark-keeper export <fmt>` to extract all data as JSON, CSV, or plain text.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
