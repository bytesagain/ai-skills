---
name: "Bmi"
description: "A focused health & wellness tool built for Bmi. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["fitness", "bmi", "tracking", "daily", "monitor"]
---

# Bmi

A focused health & wellness tool built for Bmi. Log entries, review trends, and export reports — all locally.

## Why Bmi?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
bmi help

# Check current status
bmi status

# View your statistics
bmi stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `bmi log` | Log |
| `bmi track` | Track |
| `bmi chart` | Chart |
| `bmi goal` | Goal |
| `bmi remind` | Remind |
| `bmi weekly` | Weekly |
| `bmi monthly` | Monthly |
| `bmi compare` | Compare |
| `bmi export` | Export |
| `bmi streak` | Streak |
| `bmi milestone` | Milestone |
| `bmi trend` | Trend |
| `bmi stats` | Summary statistics |
| `bmi export` | <fmt>       Export (json|csv|txt) |
| `bmi search` | <term>      Search entries |
| `bmi recent` | Recent activity |
| `bmi status` | Health check |
| `bmi help` | Show this help |
| `bmi version` | Show version |
| `bmi $name:` | $c entries |
| `bmi Total:` | $total entries |
| `bmi Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `bmi Version:` | v2.0.0 |
| `bmi Data` | dir: $DATA_DIR |
| `bmi Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `bmi Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `bmi Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `bmi Status:` | OK |
| `bmi [Bmi]` | log: $input |
| `bmi Saved.` | Total log entries: $total |
| `bmi [Bmi]` | track: $input |
| `bmi Saved.` | Total track entries: $total |
| `bmi [Bmi]` | chart: $input |
| `bmi Saved.` | Total chart entries: $total |
| `bmi [Bmi]` | goal: $input |
| `bmi Saved.` | Total goal entries: $total |
| `bmi [Bmi]` | remind: $input |
| `bmi Saved.` | Total remind entries: $total |
| `bmi [Bmi]` | weekly: $input |
| `bmi Saved.` | Total weekly entries: $total |
| `bmi [Bmi]` | monthly: $input |
| `bmi Saved.` | Total monthly entries: $total |
| `bmi [Bmi]` | compare: $input |
| `bmi Saved.` | Total compare entries: $total |
| `bmi [Bmi]` | export: $input |
| `bmi Saved.` | Total export entries: $total |
| `bmi [Bmi]` | streak: $input |
| `bmi Saved.` | Total streak entries: $total |
| `bmi [Bmi]` | milestone: $input |
| `bmi Saved.` | Total milestone entries: $total |
| `bmi [Bmi]` | trend: $input |
| `bmi Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/bmi/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
