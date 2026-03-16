---
name: "Fuel"
description: "Terminal-first Fuel manager. Keep your home management data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["organize", "maintenance", "smart-home", "fuel", "home"]
---

# Fuel

Terminal-first Fuel manager. Keep your home management data organized with simple commands.

## Why Fuel?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
fuel help

# Check current status
fuel status

# View your statistics
fuel stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `fuel add` | Add |
| `fuel inventory` | Inventory |
| `fuel schedule` | Schedule |
| `fuel remind` | Remind |
| `fuel checklist` | Checklist |
| `fuel usage` | Usage |
| `fuel cost` | Cost |
| `fuel maintain` | Maintain |
| `fuel log` | Log |
| `fuel report` | Report |
| `fuel seasonal` | Seasonal |
| `fuel tips` | Tips |
| `fuel stats` | Summary statistics |
| `fuel export` | <fmt>       Export (json|csv|txt) |
| `fuel search` | <term>      Search entries |
| `fuel recent` | Recent activity |
| `fuel status` | Health check |
| `fuel help` | Show this help |
| `fuel version` | Show version |
| `fuel $name:` | $c entries |
| `fuel Total:` | $total entries |
| `fuel Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `fuel Version:` | v2.0.0 |
| `fuel Data` | dir: $DATA_DIR |
| `fuel Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `fuel Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `fuel Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `fuel Status:` | OK |
| `fuel [Fuel]` | add: $input |
| `fuel Saved.` | Total add entries: $total |
| `fuel [Fuel]` | inventory: $input |
| `fuel Saved.` | Total inventory entries: $total |
| `fuel [Fuel]` | schedule: $input |
| `fuel Saved.` | Total schedule entries: $total |
| `fuel [Fuel]` | remind: $input |
| `fuel Saved.` | Total remind entries: $total |
| `fuel [Fuel]` | checklist: $input |
| `fuel Saved.` | Total checklist entries: $total |
| `fuel [Fuel]` | usage: $input |
| `fuel Saved.` | Total usage entries: $total |
| `fuel [Fuel]` | cost: $input |
| `fuel Saved.` | Total cost entries: $total |
| `fuel [Fuel]` | maintain: $input |
| `fuel Saved.` | Total maintain entries: $total |
| `fuel [Fuel]` | log: $input |
| `fuel Saved.` | Total log entries: $total |
| `fuel [Fuel]` | report: $input |
| `fuel Saved.` | Total report entries: $total |
| `fuel [Fuel]` | seasonal: $input |
| `fuel Saved.` | Total seasonal entries: $total |
| `fuel [Fuel]` | tips: $input |
| `fuel Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/fuel/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
