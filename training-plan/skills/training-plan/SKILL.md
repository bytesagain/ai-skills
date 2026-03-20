---
version: "2.0.0"
name: training-plan
description: "Design training plans with curriculum, evaluation, and scheduling. Use when adding modules, prioritizing gaps, planning sessions, reviewing progress."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# training-plan

Productivity and task management tool. Add tasks, set priorities, view daily and weekly plans, set reminders, track completion stats, and export your data. All data is stored locally in plain-text log files.

## Commands

| Command | Description |
|---------|-------------|
| `training-plan add <text>` | Add a new item with today's date |
| `training-plan list` | List all items in the data log |
| `training-plan done <item>` | Mark an item as completed |
| `training-plan priority <item> [level]` | Set priority for an item (default: medium) |
| `training-plan today` | Show items scheduled for today |
| `training-plan week` | Show this week's overview |
| `training-plan remind <item> [when]` | Set a reminder (default: tomorrow) |
| `training-plan stats` | Show total item count and statistics |
| `training-plan clear` | Clear all completed items |
| `training-plan export` | Export all data to stdout |
| `training-plan help` | Show help message |
| `training-plan version` | Show version number |

## Data Storage

All data is stored locally at `$TRAINING_PLAN_DIR` or `~/.local/share/training-plan/` by default:

- `data.log` — Main data file with all items (date + description per line)
- `history.log` — Activity history with timestamps for every command run

Set the `TRAINING_PLAN_DIR` environment variable to use a custom data directory.

## Requirements

- bash 4+
- Standard UNIX utilities (`date`, `grep`, `wc`)
- No external dependencies or API keys required

## When to Use

1. **Daily planning** — Use `add` to capture tasks, then `today` to see what's on your plate
2. **Weekly reviews** — Run `week` to get an overview of everything scheduled this week
3. **Priority management** — Use `priority` to flag urgent items so you focus on what matters
4. **Progress tracking** — Check `stats` to see how many items you've logged and use `done` to mark completions
5. **Data portability** — Use `export` to dump all data to stdout for backup, piping, or integration with other tools

## Examples

```bash
# Add a new task
training-plan add "Review project proposal by Friday"

# Add another task
training-plan add "Prepare slides for Monday meeting"

# List all current items
training-plan list

# See what's on today's schedule
training-plan today

# Mark a task as completed
training-plan done "Review project proposal"

# Set a task to high priority
training-plan priority "Prepare slides" high

# Set a reminder for tomorrow
training-plan remind "Submit expense report" tomorrow

# View weekly overview
training-plan week

# Check stats
training-plan stats

# Clear completed items
training-plan clear

# Export all data
training-plan export > backup.txt

# Show help
training-plan help

# Check version
training-plan version
```

## Tips

- Items are stored with the date they were added, making `today` filtering automatic
- Use `stats` regularly to track your productivity over time
- Pipe `export` output to other tools for custom reports: `training-plan export | grep "2026-03"`
- The `history.log` keeps a timestamped record of every action you take

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
