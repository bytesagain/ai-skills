---
name: "Focus"
description: "Focus — a fast productivity tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["planning", "focus", "time-management", "organization", "workflow"]
---

# Focus

Focus — a fast productivity tool. Log anything, find it later, export when needed.

## Why Focus?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
focus help

# Check current status
focus status

# View your statistics
focus stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `focus add` | Add |
| `focus plan` | Plan |
| `focus track` | Track |
| `focus review` | Review |
| `focus streak` | Streak |
| `focus remind` | Remind |
| `focus prioritize` | Prioritize |
| `focus archive` | Archive |
| `focus tag` | Tag |
| `focus timeline` | Timeline |
| `focus report` | Report |
| `focus weekly-review` | Weekly Review |
| `focus stats` | Summary statistics |
| `focus export` | <fmt>       Export (json|csv|txt) |
| `focus search` | <term>      Search entries |
| `focus recent` | Recent activity |
| `focus status` | Health check |
| `focus help` | Show this help |
| `focus version` | Show version |
| `focus $name:` | $c entries |
| `focus Total:` | $total entries |
| `focus Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `focus Version:` | v2.0.0 |
| `focus Data` | dir: $DATA_DIR |
| `focus Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `focus Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `focus Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `focus Status:` | OK |
| `focus [Focus]` | add: $input |
| `focus Saved.` | Total add entries: $total |
| `focus [Focus]` | plan: $input |
| `focus Saved.` | Total plan entries: $total |
| `focus [Focus]` | track: $input |
| `focus Saved.` | Total track entries: $total |
| `focus [Focus]` | review: $input |
| `focus Saved.` | Total review entries: $total |
| `focus [Focus]` | streak: $input |
| `focus Saved.` | Total streak entries: $total |
| `focus [Focus]` | remind: $input |
| `focus Saved.` | Total remind entries: $total |
| `focus [Focus]` | prioritize: $input |
| `focus Saved.` | Total prioritize entries: $total |
| `focus [Focus]` | archive: $input |
| `focus Saved.` | Total archive entries: $total |
| `focus [Focus]` | tag: $input |
| `focus Saved.` | Total tag entries: $total |
| `focus [Focus]` | timeline: $input |
| `focus Saved.` | Total timeline entries: $total |
| `focus [Focus]` | report: $input |
| `focus Saved.` | Total report entries: $total |
| `focus [Focus]` | weekly-review: $input |
| `focus Saved.` | Total weekly-review entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/focus/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
