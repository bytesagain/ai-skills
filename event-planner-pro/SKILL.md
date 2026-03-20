---
version: "2.0.0"
name: Event Planner
description: "Plan weddings, birthdays, and corporate events with budgets and checklists. Use when drafting budgets, building checklists, or coordinating vendors."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Event Planner Pro

Productivity and task management tool for event planning (v2.0.0). Add items to your event task list, mark tasks as done, set priorities, view today's or this week's schedule, set reminders, track statistics, clear completed items, and export your data. All entries are timestamped and stored in a simple log file.

## Commands

| Command | Description |
|---------|-------------|
| `event-planner-pro add <item>` | Add a new item to the task list. Records the current date and the item text. |
| `event-planner-pro list` | List all items in the data log. Shows the full task list with dates. |
| `event-planner-pro done <item>` | Mark a task or item as completed. |
| `event-planner-pro priority <item> [level]` | Set the priority level for an item. Default level is `medium`. |
| `event-planner-pro today` | Show tasks and events scheduled for today (filters by current date). |
| `event-planner-pro week` | Show this week's overview of planned tasks and events. |
| `event-planner-pro remind <item> [when]` | Set a reminder for an item. Default time is `tomorrow`. |
| `event-planner-pro stats` | Show statistics: total number of items in the task list. |
| `event-planner-pro clear` | Clear all completed items from the list. |
| `event-planner-pro export` | Export all data from the task list to stdout. |
| `event-planner-pro help` | Show the built-in help with all available commands. |
| `event-planner-pro version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored in `~/.local/share/event-planner-pro/` (or the path set by `EVENT_PLANNER_PRO_DIR` or `XDG_DATA_HOME`):

- **data.log** — The main task list. Each line contains a date and the item text.
- **history.log** — An audit trail of every command executed, with timestamps.

You can customize the data directory by setting the `EVENT_PLANNER_PRO_DIR` environment variable:

```bash
export EVENT_PLANNER_PRO_DIR="$HOME/my-events"
```

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **coreutils** — `date`, `wc`, `grep`, `cat`
- No external dependencies, API keys, or network access required
- Works fully offline on any POSIX-compatible system

## When to Use

1. **Wedding planning** — Add all wedding tasks (venue booking, caterer selection, invitation mailing), set priorities, view today's checklist, and mark items done as you go.
2. **Corporate event coordination** — Track conference logistics (speaker confirmations, AV setup, catering orders), use `today` to see what needs attention right now, and `week` for the upcoming schedule.
3. **Birthday party preparation** — Add decorations, cake order, guest list items; use `remind` to set follow-ups for RSVPs and vendor confirmations.
4. **Daily task triage** — Start each morning with `event-planner-pro today` to see what's due, use `priority` to rank items, and `done` to clear them as you complete tasks.
5. **Post-event cleanup and review** — After the event, run `stats` to see how many items were tracked, `export` the full log for archiving, and `clear` completed items to start fresh for the next event.

## Examples

```bash
# Add a wedding task
event-planner-pro add "Book photographer — call Studio Lux by Friday"

# Add a catering task
event-planner-pro add "Confirm vegetarian menu options with caterer"

# Set priority on a task
event-planner-pro priority "Book photographer" high

# View today's tasks
event-planner-pro today

# View the week ahead
event-planner-pro week

# Set a reminder
event-planner-pro remind "Send invitations" "next Monday"

# Mark a task as done
event-planner-pro done "Book photographer"

# View statistics
event-planner-pro stats

# Export all tasks for archiving
event-planner-pro export > event-backup.txt

# Clear completed items
event-planner-pro clear

# List everything
event-planner-pro list
```

## Tips

- Use `event-planner-pro list` to get a full dump of all tasks, then pipe to `grep` for filtering: `event-planner-pro list | grep "caterer"`
- Redirect `export` output to a file for backups: `event-planner-pro export > archive-2024.txt`
- The `today` command filters by the current date, so add items with the correct date context for best results.
- Combine with cron for daily reminders: `0 9 * * * event-planner-pro today | mail -s "Today's events" you@example.com`

---
*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
