---
name: "Mileage"
description: "A focused home management tool built for Mileage. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["maintenance", "home", "domestic", "smart-home", "mileage"]
---

# Mileage

A focused home management tool built for Mileage. Log entries, review trends, and export reports — all locally.

## Why Mileage?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
mileage help

# Check current status
mileage status

# View your statistics
mileage stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `mileage add` | Add |
| `mileage inventory` | Inventory |
| `mileage schedule` | Schedule |
| `mileage remind` | Remind |
| `mileage checklist` | Checklist |
| `mileage usage` | Usage |
| `mileage cost` | Cost |
| `mileage maintain` | Maintain |
| `mileage log` | Log |
| `mileage report` | Report |
| `mileage seasonal` | Seasonal |
| `mileage tips` | Tips |
| `mileage stats` | Summary statistics |
| `mileage export` | <fmt>       Export (json|csv|txt) |
| `mileage search` | <term>      Search entries |
| `mileage recent` | Recent activity |
| `mileage status` | Health check |
| `mileage help` | Show this help |
| `mileage version` | Show version |
| `mileage $name:` | $c entries |
| `mileage Total:` | $total entries |
| `mileage Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `mileage Version:` | v2.0.0 |
| `mileage Data` | dir: $DATA_DIR |
| `mileage Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `mileage Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `mileage Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `mileage Status:` | OK |
| `mileage [Mileage]` | add: $input |
| `mileage Saved.` | Total add entries: $total |
| `mileage [Mileage]` | inventory: $input |
| `mileage Saved.` | Total inventory entries: $total |
| `mileage [Mileage]` | schedule: $input |
| `mileage Saved.` | Total schedule entries: $total |
| `mileage [Mileage]` | remind: $input |
| `mileage Saved.` | Total remind entries: $total |
| `mileage [Mileage]` | checklist: $input |
| `mileage Saved.` | Total checklist entries: $total |
| `mileage [Mileage]` | usage: $input |
| `mileage Saved.` | Total usage entries: $total |
| `mileage [Mileage]` | cost: $input |
| `mileage Saved.` | Total cost entries: $total |
| `mileage [Mileage]` | maintain: $input |
| `mileage Saved.` | Total maintain entries: $total |
| `mileage [Mileage]` | log: $input |
| `mileage Saved.` | Total log entries: $total |
| `mileage [Mileage]` | report: $input |
| `mileage Saved.` | Total report entries: $total |
| `mileage [Mileage]` | seasonal: $input |
| `mileage Saved.` | Total seasonal entries: $total |
| `mileage [Mileage]` | tips: $input |
| `mileage Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/mileage/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
