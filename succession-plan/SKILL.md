---
version: "2.0.0"
name: Succession Plan
description: "Design succession plans with role mapping and transition roadmaps. Use when adding positions, listing candidates, prioritizing paths, planning transfers."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Succession Plan

A lightweight, terminal-based productivity and task management tool for planning and tracking succession-related tasks. Add items, set priorities, view daily and weekly overviews, set reminders, and export your data — all from the command line with zero dependencies.

## Commands

| Command | Description |
|---------|-------------|
| `succession-plan add <text>` | Add a new item to your task list (timestamped with today's date) |
| `succession-plan list` | List all items currently in the data log |
| `succession-plan done <item>` | Mark an item as completed |
| `succession-plan priority <item> [level]` | Set priority for an item (default: medium) |
| `succession-plan today` | Show items scheduled for today |
| `succession-plan week` | Show a weekly overview of tasks |
| `succession-plan remind <item> [when]` | Set a reminder for an item (default: tomorrow) |
| `succession-plan stats` | Show total number of items tracked |
| `succession-plan clear` | Clear all completed items |
| `succession-plan export` | Export all data to stdout |
| `succession-plan help` | Show help message with all available commands |
| `succession-plan version` | Show current version (v2.0.0) |

## Data Storage

- **Default location:** `~/.local/share/succession-plan/`
- **Override:** Set the `SUCCESSION_PLAN_DIR` environment variable, or `XDG_DATA_HOME` to customize the base path
- **Data file:** `data.log` — plain text, one item per line, prefixed with date
- **History file:** `history.log` — timestamped log of every command executed
- All data is stored locally on your machine. No cloud sync, no network calls.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `grep`, `wc`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Succession planning projects** — Track key positions, candidate assessments, and transition milestones as simple task items
2. **Daily planning** — Use `today` to see what's on your plate and `add` to capture new items as they arise throughout the day
3. **Priority management** — Set priority levels on tasks to keep focus on what matters most during busy transition periods
4. **Team handoff tracking** — Log knowledge transfer items, training sessions, and handoff checkpoints with reminders
5. **Quick task capture in automation** — Pipe items into `succession-plan add` from scripts or cron jobs to build a log of automated events

## Examples

```bash
# Add a new succession planning item
succession-plan add "Interview candidate for VP Engineering role"

# Add multiple items for a transition roadmap
succession-plan add "Document current processes for Q2 handoff"
succession-plan add "Schedule shadowing sessions with successor"
succession-plan add "Review knowledge base completeness"

# Set priority on a critical item
succession-plan priority "VP Engineering role" high

# Check what's due today
succession-plan today

# View the weekly overview
succession-plan week

# Set a reminder for a follow-up
succession-plan remind "Final candidate review" "next Monday"

# List all tracked items
succession-plan list

# Check statistics
succession-plan stats

# Export data for reporting
succession-plan export > succession-report.txt

# Clear completed items when done
succession-plan clear
```

## How It Works

Succession Plan uses a simple append-only log file (`data.log`) to store items. Each entry is prefixed with the date it was added. Every command you run is also logged to `history.log` with a timestamp, giving you full traceability of your planning activities.

The tool follows Unix philosophy: it does one thing well, outputs plain text to stdout, and plays nicely with pipes and redirection.

## Tips

- Combine with `grep` to filter items: `succession-plan list | grep "VP"`
- Redirect export for backup: `succession-plan export > backup-$(date +%F).txt`
- Use in CI/CD or cron to auto-log events: `echo "Deploy completed" | xargs succession-plan add`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
