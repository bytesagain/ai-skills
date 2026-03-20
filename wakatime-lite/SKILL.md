---
name: WakaTime Lite
description: "Track coding time and review productivity stats. Use when logging dev hours, analyzing time per project, setting focus goals, or reviewing summaries."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["time","tracker","coding","productivity","project","wakatime","developer","stats"]
categories: ["Developer Tools", "Productivity"]
---

# WakaTime Lite

A lightweight productivity and task management tool. Add tasks, mark them done, set priorities, view daily and weekly summaries, set reminders, track statistics, and export your data — all from the command line with persistent logging.

## Why WakaTime Lite?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Persistent task log with date-stamped entries
- Built-in daily and weekly views for quick overviews
- Priority management and reminder support
- Export your full task history anytime

## Commands

| Command | Description |
|---------|-------------|
| `wakatime-lite add <text>` | Add a new task or item. Saves with today's date to the data log |
| `wakatime-lite list` | List all items in the data log |
| `wakatime-lite done <item>` | Mark an item as completed |
| `wakatime-lite priority <item> [level]` | Set priority for an item (default: medium) |
| `wakatime-lite today` | Show items scheduled for today |
| `wakatime-lite week` | Show this week's overview |
| `wakatime-lite remind <item> [when]` | Set a reminder for an item (default: tomorrow) |
| `wakatime-lite stats` | Show total item count and statistics |
| `wakatime-lite clear` | Clear completed items from the log |
| `wakatime-lite export` | Export all data to stdout |
| `wakatime-lite help` | Show help with all available commands |
| `wakatime-lite version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally at `~/.local/share/wakatime-lite/` (or the path specified by `WAKATIME_LITE_DIR` or `XDG_DATA_HOME`). The main task log is `data.log`, containing date-stamped entries. A separate `history.log` tracks all command activity with timestamps. Each command is logged automatically for full activity tracking.

## Requirements

- Bash 4.0+ with `set -euo pipefail` support
- Standard Unix utilities: `date`, `wc`, `tail`, `grep`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Daily task management** — Add items, mark them done, and review what's on your plate for today with the `today` command
2. **Weekly planning and review** — Use `week` to get an overview of your tasks and plan ahead for the coming days
3. **Setting priorities and reminders** — Assign priority levels to tasks and set reminders so nothing slips through the cracks
4. **Tracking productivity over time** — Use `stats` to see how many tasks you've logged, and `export` to analyze your history externally
5. **Lightweight project tracking** — When a full project management tool is overkill, use WakaTime Lite to keep a simple running log of work items

## Examples

```bash
# Add a new task
wakatime-lite add "Fix login page bug"

# List all current items
wakatime-lite list

# Mark a task as done
wakatime-lite done "Fix login page bug"

# Set high priority on a task
wakatime-lite priority "Deploy v2.0" high

# View today's tasks
wakatime-lite today

# Set a reminder
wakatime-lite remind "Code review" Friday

# Show stats
wakatime-lite stats

# Export all data
wakatime-lite export
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
