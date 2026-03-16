---
name: "Laundry"
description: "Lightweight Laundry tracker. Add entries, view stats, search history, and export in multiple formats."
version: "2.0.0"
author: "BytesAgain"
tags: ["organize", "smart-home", "inventory", "laundry", "home"]
---

# Laundry

Lightweight Laundry tracker. Add entries, view stats, search history, and export in multiple formats.

## Why Laundry?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
laundry help

# Check current status
laundry status

# View your statistics
laundry stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `laundry add` | Add |
| `laundry inventory` | Inventory |
| `laundry schedule` | Schedule |
| `laundry remind` | Remind |
| `laundry checklist` | Checklist |
| `laundry usage` | Usage |
| `laundry cost` | Cost |
| `laundry maintain` | Maintain |
| `laundry log` | Log |
| `laundry report` | Report |
| `laundry seasonal` | Seasonal |
| `laundry tips` | Tips |
| `laundry stats` | Summary statistics |
| `laundry export` | <fmt>       Export (json|csv|txt) |
| `laundry search` | <term>      Search entries |
| `laundry recent` | Recent activity |
| `laundry status` | Health check |
| `laundry help` | Show this help |
| `laundry version` | Show version |
| `laundry $name:` | $c entries |
| `laundry Total:` | $total entries |
| `laundry Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `laundry Version:` | v2.0.0 |
| `laundry Data` | dir: $DATA_DIR |
| `laundry Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `laundry Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `laundry Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `laundry Status:` | OK |
| `laundry [Laundry]` | add: $input |
| `laundry Saved.` | Total add entries: $total |
| `laundry [Laundry]` | inventory: $input |
| `laundry Saved.` | Total inventory entries: $total |
| `laundry [Laundry]` | schedule: $input |
| `laundry Saved.` | Total schedule entries: $total |
| `laundry [Laundry]` | remind: $input |
| `laundry Saved.` | Total remind entries: $total |
| `laundry [Laundry]` | checklist: $input |
| `laundry Saved.` | Total checklist entries: $total |
| `laundry [Laundry]` | usage: $input |
| `laundry Saved.` | Total usage entries: $total |
| `laundry [Laundry]` | cost: $input |
| `laundry Saved.` | Total cost entries: $total |
| `laundry [Laundry]` | maintain: $input |
| `laundry Saved.` | Total maintain entries: $total |
| `laundry [Laundry]` | log: $input |
| `laundry Saved.` | Total log entries: $total |
| `laundry [Laundry]` | report: $input |
| `laundry Saved.` | Total report entries: $total |
| `laundry [Laundry]` | seasonal: $input |
| `laundry Saved.` | Total seasonal entries: $total |
| `laundry [Laundry]` | tips: $input |
| `laundry Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/laundry/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
