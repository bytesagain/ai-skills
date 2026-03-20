---
name: queue
version: "2.0.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [queue, task-management, project-planning, workflow]
description: "Manage message queues with priorities and retry logic. Use when adding jobs, planning retry strategies, tracking delivery status, reviewing failed items."
---

# Queue

Task queue with priority management, timeline tracking, streaks, tagging, and weekly reviews. Logs all operations with timestamps for full traceability.

## Commands

| Command | Description |
|---------|-------------|
| `queue add <item>` | Add a new item to the queue |
| `queue plan <task>` | Plan a task with scheduling details |
| `queue track <id>` | Track progress on a queued item |
| `queue review` | Review current queue items and status |
| `queue prioritize <id> <level>` | Set priority level for an item |
| `queue remind <id>` | Set a reminder for a queued item |
| `queue streak` | Show current processing streak |
| `queue tag <id> <tag>` | Tag a queue item for categorization |
| `queue timeline` | Display timeline of all queue activity |
| `queue report` | Generate a queue status report |
| `queue archive <id>` | Move completed items to archive |
| `queue weekly-review` | Run a weekly review of queue throughput |
| `queue stats` | Show queue statistics and counts |
| `queue export <fmt>` | Export queue data in json, csv, or txt |
| `queue search <term>` | Search across all queue entries |
| `queue recent [n]` | Show last n queue operations |
| `queue status` | Show current queue health |
| `queue help` | Display help and available commands |
| `queue version` | Show version number |

## Data Storage

All data saved on your machine in `~/.local/share/queue/`:
- `add.log` — added items
- `plan.log` — planned tasks
- `track.log` — tracking events
- `history.log` — full operation history
- Exported files saved to current directory

## Requirements

- bash 4+
- Standard coreutils (grep, wc, du, sort, head, tail)

## When to Use

- Adding tasks to a processing queue with priority levels
- Tracking progress on multiple concurrent jobs
- Running weekly reviews to assess throughput and bottlenecks
- Tagging and categorizing queue items for filtering
- Archiving completed work and generating reports

## Examples

```bash
# Add a new item to the queue
queue add "Process incoming data files"

# Plan a scheduled task
queue plan "Deploy v2.0 to staging"

# Track progress on an item
queue track ITEM-001

# Set priority
queue prioritize ITEM-001 high

# Tag for categorization
queue tag ITEM-001 deployment

# Run weekly review
queue weekly-review

# Export queue data
queue export json

# Show recent activity
queue recent 15
```

## Tips

- Use `prioritize` to bubble urgent items to the top
- `weekly-review` gives a throughput summary with trends
- `tag` items to filter by category in `search`
- `archive` completed items to keep the active queue clean
- `streak` tracks how many consecutive days you processed items

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
