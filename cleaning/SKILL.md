---
name: "Cleaning"
description: "Cleaning makes home management simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["cleaning", "maintenance", "domestic", "inventory", "home"]
---

# Cleaning

Cleaning makes home management simple. Record, search, and analyze your data with clear terminal output.

## Why Cleaning?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
cleaning help

# Check current status
cleaning status

# View your statistics
cleaning stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `cleaning add` | Add |
| `cleaning inventory` | Inventory |
| `cleaning schedule` | Schedule |
| `cleaning remind` | Remind |
| `cleaning checklist` | Checklist |
| `cleaning usage` | Usage |
| `cleaning cost` | Cost |
| `cleaning maintain` | Maintain |
| `cleaning log` | Log |
| `cleaning report` | Report |
| `cleaning seasonal` | Seasonal |
| `cleaning tips` | Tips |
| `cleaning stats` | Summary statistics |
| `cleaning export` | <fmt>       Export (json|csv|txt) |
| `cleaning search` | <term>      Search entries |
| `cleaning recent` | Recent activity |
| `cleaning status` | Health check |
| `cleaning help` | Show this help |
| `cleaning version` | Show version |
| `cleaning $name:` | $c entries |
| `cleaning Total:` | $total entries |
| `cleaning Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `cleaning Version:` | v2.0.0 |
| `cleaning Data` | dir: $DATA_DIR |
| `cleaning Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `cleaning Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `cleaning Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `cleaning Status:` | OK |
| `cleaning [Cleaning]` | add: $input |
| `cleaning Saved.` | Total add entries: $total |
| `cleaning [Cleaning]` | inventory: $input |
| `cleaning Saved.` | Total inventory entries: $total |
| `cleaning [Cleaning]` | schedule: $input |
| `cleaning Saved.` | Total schedule entries: $total |
| `cleaning [Cleaning]` | remind: $input |
| `cleaning Saved.` | Total remind entries: $total |
| `cleaning [Cleaning]` | checklist: $input |
| `cleaning Saved.` | Total checklist entries: $total |
| `cleaning [Cleaning]` | usage: $input |
| `cleaning Saved.` | Total usage entries: $total |
| `cleaning [Cleaning]` | cost: $input |
| `cleaning Saved.` | Total cost entries: $total |
| `cleaning [Cleaning]` | maintain: $input |
| `cleaning Saved.` | Total maintain entries: $total |
| `cleaning [Cleaning]` | log: $input |
| `cleaning Saved.` | Total log entries: $total |
| `cleaning [Cleaning]` | report: $input |
| `cleaning Saved.` | Total report entries: $total |
| `cleaning [Cleaning]` | seasonal: $input |
| `cleaning Saved.` | Total seasonal entries: $total |
| `cleaning [Cleaning]` | tips: $input |
| `cleaning Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/cleaning/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
