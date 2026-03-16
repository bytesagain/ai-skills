---
name: "Furniture"
description: "Furniture — a fast home management tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["furniture", "smart-home", "inventory", "household", "home"]
---

# Furniture

Furniture — a fast home management tool. Log anything, find it later, export when needed.

## Why Furniture?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
furniture help

# Check current status
furniture status

# View your statistics
furniture stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `furniture add` | Add |
| `furniture inventory` | Inventory |
| `furniture schedule` | Schedule |
| `furniture remind` | Remind |
| `furniture checklist` | Checklist |
| `furniture usage` | Usage |
| `furniture cost` | Cost |
| `furniture maintain` | Maintain |
| `furniture log` | Log |
| `furniture report` | Report |
| `furniture seasonal` | Seasonal |
| `furniture tips` | Tips |
| `furniture stats` | Summary statistics |
| `furniture export` | <fmt>       Export (json|csv|txt) |
| `furniture search` | <term>      Search entries |
| `furniture recent` | Recent activity |
| `furniture status` | Health check |
| `furniture help` | Show this help |
| `furniture version` | Show version |
| `furniture $name:` | $c entries |
| `furniture Total:` | $total entries |
| `furniture Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `furniture Version:` | v2.0.0 |
| `furniture Data` | dir: $DATA_DIR |
| `furniture Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `furniture Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `furniture Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `furniture Status:` | OK |
| `furniture [Furniture]` | add: $input |
| `furniture Saved.` | Total add entries: $total |
| `furniture [Furniture]` | inventory: $input |
| `furniture Saved.` | Total inventory entries: $total |
| `furniture [Furniture]` | schedule: $input |
| `furniture Saved.` | Total schedule entries: $total |
| `furniture [Furniture]` | remind: $input |
| `furniture Saved.` | Total remind entries: $total |
| `furniture [Furniture]` | checklist: $input |
| `furniture Saved.` | Total checklist entries: $total |
| `furniture [Furniture]` | usage: $input |
| `furniture Saved.` | Total usage entries: $total |
| `furniture [Furniture]` | cost: $input |
| `furniture Saved.` | Total cost entries: $total |
| `furniture [Furniture]` | maintain: $input |
| `furniture Saved.` | Total maintain entries: $total |
| `furniture [Furniture]` | log: $input |
| `furniture Saved.` | Total log entries: $total |
| `furniture [Furniture]` | report: $input |
| `furniture Saved.` | Total report entries: $total |
| `furniture [Furniture]` | seasonal: $input |
| `furniture Saved.` | Total seasonal entries: $total |
| `furniture [Furniture]` | tips: $input |
| `furniture Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/furniture/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
