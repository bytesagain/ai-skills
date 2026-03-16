---
name: "Pantry"
description: "Pantry — a fast home management tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["organize", "maintenance", "domestic", "pantry", "inventory"]
---

# Pantry

Pantry — a fast home management tool. Log anything, find it later, export when needed.

## Why Pantry?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
pantry help

# Check current status
pantry status

# View your statistics
pantry stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `pantry add` | Add |
| `pantry inventory` | Inventory |
| `pantry schedule` | Schedule |
| `pantry remind` | Remind |
| `pantry checklist` | Checklist |
| `pantry usage` | Usage |
| `pantry cost` | Cost |
| `pantry maintain` | Maintain |
| `pantry log` | Log |
| `pantry report` | Report |
| `pantry seasonal` | Seasonal |
| `pantry tips` | Tips |
| `pantry stats` | Summary statistics |
| `pantry export` | <fmt>       Export (json|csv|txt) |
| `pantry search` | <term>      Search entries |
| `pantry recent` | Recent activity |
| `pantry status` | Health check |
| `pantry help` | Show this help |
| `pantry version` | Show version |
| `pantry $name:` | $c entries |
| `pantry Total:` | $total entries |
| `pantry Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `pantry Version:` | v2.0.0 |
| `pantry Data` | dir: $DATA_DIR |
| `pantry Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `pantry Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `pantry Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `pantry Status:` | OK |
| `pantry [Pantry]` | add: $input |
| `pantry Saved.` | Total add entries: $total |
| `pantry [Pantry]` | inventory: $input |
| `pantry Saved.` | Total inventory entries: $total |
| `pantry [Pantry]` | schedule: $input |
| `pantry Saved.` | Total schedule entries: $total |
| `pantry [Pantry]` | remind: $input |
| `pantry Saved.` | Total remind entries: $total |
| `pantry [Pantry]` | checklist: $input |
| `pantry Saved.` | Total checklist entries: $total |
| `pantry [Pantry]` | usage: $input |
| `pantry Saved.` | Total usage entries: $total |
| `pantry [Pantry]` | cost: $input |
| `pantry Saved.` | Total cost entries: $total |
| `pantry [Pantry]` | maintain: $input |
| `pantry Saved.` | Total maintain entries: $total |
| `pantry [Pantry]` | log: $input |
| `pantry Saved.` | Total log entries: $total |
| `pantry [Pantry]` | report: $input |
| `pantry Saved.` | Total report entries: $total |
| `pantry [Pantry]` | seasonal: $input |
| `pantry Saved.` | Total seasonal entries: $total |
| `pantry [Pantry]` | tips: $input |
| `pantry Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/pantry/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
