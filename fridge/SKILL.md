---
name: "Fridge"
description: "Manage Fridge data right from your terminal. Built for people who want organize your household without complex setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["maintenance", "inventory", "household", "fridge", "home"]
---

# Fridge

Manage Fridge data right from your terminal. Built for people who want organize your household without complex setup.

## Why Fridge?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
fridge help

# Check current status
fridge status

# View your statistics
fridge stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `fridge add` | Add |
| `fridge inventory` | Inventory |
| `fridge schedule` | Schedule |
| `fridge remind` | Remind |
| `fridge checklist` | Checklist |
| `fridge usage` | Usage |
| `fridge cost` | Cost |
| `fridge maintain` | Maintain |
| `fridge log` | Log |
| `fridge report` | Report |
| `fridge seasonal` | Seasonal |
| `fridge tips` | Tips |
| `fridge stats` | Summary statistics |
| `fridge export` | <fmt>       Export (json|csv|txt) |
| `fridge search` | <term>      Search entries |
| `fridge recent` | Recent activity |
| `fridge status` | Health check |
| `fridge help` | Show this help |
| `fridge version` | Show version |
| `fridge $name:` | $c entries |
| `fridge Total:` | $total entries |
| `fridge Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `fridge Version:` | v2.0.0 |
| `fridge Data` | dir: $DATA_DIR |
| `fridge Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `fridge Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `fridge Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `fridge Status:` | OK |
| `fridge [Fridge]` | add: $input |
| `fridge Saved.` | Total add entries: $total |
| `fridge [Fridge]` | inventory: $input |
| `fridge Saved.` | Total inventory entries: $total |
| `fridge [Fridge]` | schedule: $input |
| `fridge Saved.` | Total schedule entries: $total |
| `fridge [Fridge]` | remind: $input |
| `fridge Saved.` | Total remind entries: $total |
| `fridge [Fridge]` | checklist: $input |
| `fridge Saved.` | Total checklist entries: $total |
| `fridge [Fridge]` | usage: $input |
| `fridge Saved.` | Total usage entries: $total |
| `fridge [Fridge]` | cost: $input |
| `fridge Saved.` | Total cost entries: $total |
| `fridge [Fridge]` | maintain: $input |
| `fridge Saved.` | Total maintain entries: $total |
| `fridge [Fridge]` | log: $input |
| `fridge Saved.` | Total log entries: $total |
| `fridge [Fridge]` | report: $input |
| `fridge Saved.` | Total report entries: $total |
| `fridge [Fridge]` | seasonal: $input |
| `fridge Saved.` | Total seasonal entries: $total |
| `fridge [Fridge]` | tips: $input |
| `fridge Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/fridge/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
