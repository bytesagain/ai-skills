---
version: "2.0.0"
name: calendar-planner-pro
description: "日程规划工具。周计划、月计划、时间块、会议安排、截止日期管理、工作生活平衡。Calendar planner with weekly, monthly, time-blocking, meeting scheduling, deadline management."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Calendar Planner Pro

Productivity and task management tool — add tasks, set priorities, track daily and weekly schedules, set reminders, view statistics, and export data. A lightweight CLI-based task manager with persistent local storage.

## Commands

| Command | Description |
|---------|-------------|
| `calendar-planner-pro add <item>` | Add a new task/item (appends to data log with date) |
| `calendar-planner-pro list` | List all items in the data log |
| `calendar-planner-pro done <item>` | Mark an item as completed |
| `calendar-planner-pro priority <item> [level]` | Set priority for an item (default: medium) |
| `calendar-planner-pro today` | Show today's scheduled items |
| `calendar-planner-pro week` | Show this week's overview |
| `calendar-planner-pro remind <item> [time]` | Set a reminder for an item (default: tomorrow) |
| `calendar-planner-pro stats` | Show total item count statistics |
| `calendar-planner-pro clear` | Clear all completed items |
| `calendar-planner-pro export` | Export all data from the log |
| `calendar-planner-pro help` | Show usage info |
| `calendar-planner-pro version` | Show version string |

## Data Storage

All data is stored locally in `~/.local/share/calendar-planner-pro/`:

- `data.log` — Main data file storing all tasks (format: `YYYY-MM-DD <item text>`)
- `history.log` — Unified activity log recording every command with timestamps

**Log format:** `MM-DD HH:MM <command>: <value>`

You can customize the data directory by setting the `CALENDAR_PLANNER_PRO_DIR` or `XDG_DATA_HOME` environment variable.

## Requirements

- **bash** (version 4+ recommended)
- Standard POSIX utilities: `date`, `wc`, `cat`, `grep`, `echo`
- No external dependencies, no network access needed
- Works on Linux, macOS, and WSL

## When to Use

1. **Daily task management** — Use `add` to capture tasks throughout the day, `today` to review what's on your plate, and `done` to mark items complete
2. **Weekly planning and review** — Use `week` for a weekly overview, `priority` to rank tasks by importance, and `stats` to see how much you've accumulated
3. **Deadline and reminder tracking** — Use `remind` to set time-based reminders so nothing falls through the cracks
4. **Lightweight project tracking** — Add project milestones as tasks, set priorities, and use `list` to maintain a running backlog without heavyweight tools
5. **Data export and backup** — Use `export` to dump all task data for archival, migration, or integration with other tools; use `clear` to clean up completed items

## Examples

```bash
# Add a new task
calendar-planner-pro add "Review Q1 report draft"

# Add a high-priority item
calendar-planner-pro add "Submit tax documents before deadline"

# Set priority
calendar-planner-pro priority "Submit tax documents" high

# View today's tasks
calendar-planner-pro today

# View the week overview
calendar-planner-pro week

# Mark a task as done
calendar-planner-pro done "Review Q1 report draft"

# Set a reminder
calendar-planner-pro remind "Team standup prep" "9am tomorrow"

# View task statistics
calendar-planner-pro stats

# List all items
calendar-planner-pro list

# Export all data
calendar-planner-pro export

# Clear completed items
calendar-planner-pro clear
```

## How It Works

Calendar Planner Pro is a lightweight CLI task manager. Tasks are appended to `data.log` with the current date when you use `add`. The `today` command filters entries by today's date. Every command logs activity to `history.log` with timestamps for full traceability. The tool is designed to be simple, fast, and dependency-free — perfect for terminal-centric workflows where you want task management without leaving the command line.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
