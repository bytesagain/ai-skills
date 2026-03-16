---
name: "Plant"
description: "Manage Plant data right from your terminal. Built for people who want organize your household without complex setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["organize", "domestic", "plant", "inventory", "household"]
---

# Plant

Manage Plant data right from your terminal. Built for people who want organize your household without complex setup.

## Why Plant?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
plant help

# Check current status
plant status

# View your statistics
plant stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `plant add` | Add |
| `plant inventory` | Inventory |
| `plant schedule` | Schedule |
| `plant remind` | Remind |
| `plant checklist` | Checklist |
| `plant usage` | Usage |
| `plant cost` | Cost |
| `plant maintain` | Maintain |
| `plant log` | Log |
| `plant report` | Report |
| `plant seasonal` | Seasonal |
| `plant tips` | Tips |
| `plant stats` | Summary statistics |
| `plant export` | <fmt>       Export (json|csv|txt) |
| `plant search` | <term>      Search entries |
| `plant recent` | Recent activity |
| `plant status` | Health check |
| `plant help` | Show this help |
| `plant version` | Show version |
| `plant $name:` | $c entries |
| `plant Total:` | $total entries |
| `plant Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `plant Version:` | v2.0.0 |
| `plant Data` | dir: $DATA_DIR |
| `plant Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `plant Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `plant Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `plant Status:` | OK |
| `plant [Plant]` | add: $input |
| `plant Saved.` | Total add entries: $total |
| `plant [Plant]` | inventory: $input |
| `plant Saved.` | Total inventory entries: $total |
| `plant [Plant]` | schedule: $input |
| `plant Saved.` | Total schedule entries: $total |
| `plant [Plant]` | remind: $input |
| `plant Saved.` | Total remind entries: $total |
| `plant [Plant]` | checklist: $input |
| `plant Saved.` | Total checklist entries: $total |
| `plant [Plant]` | usage: $input |
| `plant Saved.` | Total usage entries: $total |
| `plant [Plant]` | cost: $input |
| `plant Saved.` | Total cost entries: $total |
| `plant [Plant]` | maintain: $input |
| `plant Saved.` | Total maintain entries: $total |
| `plant [Plant]` | log: $input |
| `plant Saved.` | Total log entries: $total |
| `plant [Plant]` | report: $input |
| `plant Saved.` | Total report entries: $total |
| `plant [Plant]` | seasonal: $input |
| `plant Saved.` | Total seasonal entries: $total |
| `plant [Plant]` | tips: $input |
| `plant Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/plant/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
