---
name: "Blood"
description: "Blood — a fast health & wellness tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["health", "wellness", "fitness", "blood", "personal"]
---

# Blood

Blood — a fast health & wellness tool. Log anything, find it later, export when needed.

## Why Blood?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
blood help

# Check current status
blood status

# View your statistics
blood stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `blood log` | Log |
| `blood track` | Track |
| `blood chart` | Chart |
| `blood goal` | Goal |
| `blood remind` | Remind |
| `blood weekly` | Weekly |
| `blood monthly` | Monthly |
| `blood compare` | Compare |
| `blood export` | Export |
| `blood streak` | Streak |
| `blood milestone` | Milestone |
| `blood trend` | Trend |
| `blood stats` | Summary statistics |
| `blood export` | <fmt>       Export (json|csv|txt) |
| `blood search` | <term>      Search entries |
| `blood recent` | Recent activity |
| `blood status` | Health check |
| `blood help` | Show this help |
| `blood version` | Show version |
| `blood $name:` | $c entries |
| `blood Total:` | $total entries |
| `blood Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `blood Version:` | v2.0.0 |
| `blood Data` | dir: $DATA_DIR |
| `blood Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `blood Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `blood Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `blood Status:` | OK |
| `blood [Blood]` | log: $input |
| `blood Saved.` | Total log entries: $total |
| `blood [Blood]` | track: $input |
| `blood Saved.` | Total track entries: $total |
| `blood [Blood]` | chart: $input |
| `blood Saved.` | Total chart entries: $total |
| `blood [Blood]` | goal: $input |
| `blood Saved.` | Total goal entries: $total |
| `blood [Blood]` | remind: $input |
| `blood Saved.` | Total remind entries: $total |
| `blood [Blood]` | weekly: $input |
| `blood Saved.` | Total weekly entries: $total |
| `blood [Blood]` | monthly: $input |
| `blood Saved.` | Total monthly entries: $total |
| `blood [Blood]` | compare: $input |
| `blood Saved.` | Total compare entries: $total |
| `blood [Blood]` | export: $input |
| `blood Saved.` | Total export entries: $total |
| `blood [Blood]` | streak: $input |
| `blood Saved.` | Total streak entries: $total |
| `blood [Blood]` | milestone: $input |
| `blood Saved.` | Total milestone entries: $total |
| `blood [Blood]` | trend: $input |
| `blood Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/blood/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
