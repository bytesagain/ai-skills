---
name: FlowDo
description: "Task and workflow manager with kanban-style status tracking. Add tasks, move them through workflow states (todo, doing, done, blocked), set priority levels, filter by status, and track completion percentage. Simple project management in your terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["task","todo","workflow","productivity","project","kanban","gtd","management"]
categories: ["Productivity", "Project Management"]
---

# FlowDo

FlowDo brings kanban-style task management to your terminal. Track tasks through workflow states, set priorities, and monitor your completion rate.

## Why FlowDo?

- **Workflow states**: Move tasks through todo → doing → done
- **Priority system**: Mark urgent tasks as high priority
- **Visual status**: Icons show task state at a glance
- **Completion tracking**: See your progress percentage
- **Filter views**: Show only tasks in a specific state
## Commands

- `add <text>` — Add a new task
- `list [status]` — List tasks filtered by status (todo/doing/done/all)
- `done <id>` — Mark a task as complete
- `doing <id>` — Mark a task as in progress
- `priority <id> <level>` — Set priority (high/normal/low)
- `stats` — View completion statistics
- `info` — Version information
- `help` — Show available commands

## Usage Examples

```bash
flowdo add Write project proposal
flowdo add Review pull requests
flowdo doing 1710000001
flowdo priority 1710000001 high
flowdo done 1710000001
flowdo list todo
flowdo stats
```

## Status Icons

- ⬜ Todo — Not started
- 🔄 Doing — In progress
- ✅ Done — Completed
- 🚫 Blocked — Blocked by dependency
- ❗ High priority indicator

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
