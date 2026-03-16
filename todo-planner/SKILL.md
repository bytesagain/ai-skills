---
version: "2.0.0"
name: todo-planner
description: "Task management with priorities, due dates, and tags. Use when you need to add tasks, set priorities (high/medium/low), track deadlines, filter by tags, or manage a todo list. Triggers on: todo, task, checklist, priority, deadline, due date, to-do list."
---

# Todo Planner

Todo Planner — manage tasks with priorities

## Why This Skill?

- Designed for everyday personal use
- No external dependencies or accounts needed
- Simple commands, powerful results

## Commands

- `add` — <task> [priority]   Add task (priority: 1-high 2-med 3-low)
- `done` — <id>               Mark task complete
- `list` — [filter]           List tasks (all/today/overdue/done)
- `edit` — <id> <text>        Edit task text
- `priority` — <id> <1-3>     Change priority
- `due` — <id> <date>         Set due date (YYYY-MM-DD)
- `tag` — <id> <tag>          Add tag
- `filter` — <tag>            Filter by tag
- `clear-done` —              Remove completed tasks
- `stats` —                   Task statistics
- `export` — [format]         Export (md/csv/json)
- `info` —                    Version info

## Quick Start

```bash
todo_planner.sh help
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
