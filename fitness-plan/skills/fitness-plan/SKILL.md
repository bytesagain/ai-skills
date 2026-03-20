---
version: "2.0.0"
name: Fitness Plan
description: "Generate workout plans for muscle gain, fat loss, or shaping with diet tips. Use when creating schedules, planning cycles, or designing routines."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Fitness Plan — Productivity & Task Management Tool

Fitness Plan is a command-line productivity and task management tool. It lets you add items, list tasks, mark them done, set priorities, view today's and weekly overviews, set reminders, check statistics, clear completed items, and export data — all with timestamped history logging.

## Commands

| Command | Description |
|---------|-------------|
| `fitness-plan add <item>` | Add a new item to the task list (date-stamped) |
| `fitness-plan list` | List all items in the data file |
| `fitness-plan done <item>` | Mark an item as completed |
| `fitness-plan priority <item> [level]` | Set priority for an item (default: medium) |
| `fitness-plan today` | Show items scheduled for today |
| `fitness-plan week` | Show a weekly overview of tasks |
| `fitness-plan remind <item> [when]` | Set a reminder for an item (default: tomorrow) |
| `fitness-plan stats` | Show total number of items in the database |
| `fitness-plan clear` | Clear all completed items |
| `fitness-plan export` | Export all data (prints contents of the data file) |
| `fitness-plan help` | Show all available commands |
| `fitness-plan version` | Print version string (`fitness-plan v2.0.0`) |

## Data Storage

All data is stored in the data directory (default `~/.local/share/fitness-plan/`):

- **Data file**: `data.log` — the main task list, one item per line prefixed with the date (`YYYY-MM-DD <item>`)
- **History log**: `history.log` — timestamped record of every command invocation

You can override the data directory by setting the `FITNESS_PLAN_DIR` environment variable or `XDG_DATA_HOME`.

## Requirements

- Bash 4+
- No external dependencies or API keys required
- Standard POSIX utilities (`date`, `wc`, `cat`, `grep`)

## When to Use

1. **Quick task capture** — Use `fitness-plan add "buy groceries"` to instantly log a task from the terminal without leaving your workflow
2. **Daily planning** — Use `fitness-plan today` each morning to review what's scheduled, then `fitness-plan priority` to reorder by importance
3. **Weekly reviews** — Use `fitness-plan week` to get a high-level view of the week, then `fitness-plan stats` to see your total backlog size
4. **Setting reminders** — Use `fitness-plan remind "submit report" "friday"` to attach time-based reminders to important tasks
5. **Cleaning up** — Use `fitness-plan done` to mark items complete, then `fitness-plan clear` to remove all finished items and keep your list tidy

## Examples

```bash
# Add a new task
fitness-plan add "review pull request #42"
# Output: Added: review pull request #42

# List all tasks
fitness-plan list
# Output: 2026-03-18 review pull request #42

# Mark a task done
fitness-plan done "review pull request #42"
# Output: Completed: review pull request #42

# Set high priority
fitness-plan priority "deploy v2.0" high
# Output: deploy v2.0 -> priority: high

# View today's items
fitness-plan today
# Output: Today 2026-03-18: (matching items or "Nothing scheduled")

# Set a reminder
fitness-plan remind "team sync" "monday"
# Output: Reminder: team sync at monday

# Check statistics
fitness-plan stats
# Output: Total: 5

# Export all data
fitness-plan export

# Clear completed items
fitness-plan clear
# Output: Cleared completed items
```

## Configuration

Set the `FITNESS_PLAN_DIR` environment variable to change the data storage location:

```bash
export FITNESS_PLAN_DIR="$HOME/my-custom-dir/fitness-plan"
```

Default location: `~/.local/share/fitness-plan/`

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
