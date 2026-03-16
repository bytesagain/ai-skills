---
name: "Room"
description: "Terminal-first Room manager. Keep your home management data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["organize", "domestic", "room", "inventory", "home"]
---

# Room

Terminal-first Room manager. Keep your home management data organized with simple commands.

## Why Room?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
room help

# Check current status
room status

# View your statistics
room stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `room add` | Add |
| `room inventory` | Inventory |
| `room schedule` | Schedule |
| `room remind` | Remind |
| `room checklist` | Checklist |
| `room usage` | Usage |
| `room cost` | Cost |
| `room maintain` | Maintain |
| `room log` | Log |
| `room report` | Report |
| `room seasonal` | Seasonal |
| `room tips` | Tips |
| `room stats` | Summary statistics |
| `room export` | <fmt>       Export (json|csv|txt) |
| `room search` | <term>      Search entries |
| `room recent` | Recent activity |
| `room status` | Health check |
| `room help` | Show this help |
| `room version` | Show version |
| `room $name:` | $c entries |
| `room Total:` | $total entries |
| `room Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `room Version:` | v2.0.0 |
| `room Data` | dir: $DATA_DIR |
| `room Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `room Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `room Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `room Status:` | OK |
| `room [Room]` | add: $input |
| `room Saved.` | Total add entries: $total |
| `room [Room]` | inventory: $input |
| `room Saved.` | Total inventory entries: $total |
| `room [Room]` | schedule: $input |
| `room Saved.` | Total schedule entries: $total |
| `room [Room]` | remind: $input |
| `room Saved.` | Total remind entries: $total |
| `room [Room]` | checklist: $input |
| `room Saved.` | Total checklist entries: $total |
| `room [Room]` | usage: $input |
| `room Saved.` | Total usage entries: $total |
| `room [Room]` | cost: $input |
| `room Saved.` | Total cost entries: $total |
| `room [Room]` | maintain: $input |
| `room Saved.` | Total maintain entries: $total |
| `room [Room]` | log: $input |
| `room Saved.` | Total log entries: $total |
| `room [Room]` | report: $input |
| `room Saved.` | Total report entries: $total |
| `room [Room]` | seasonal: $input |
| `room Saved.` | Total seasonal entries: $total |
| `room [Room]` | tips: $input |
| `room Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/room/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
