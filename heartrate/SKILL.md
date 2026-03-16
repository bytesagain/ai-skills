---
name: "Heartrate"
description: "A focused health & wellness tool built for Heartrate. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["health", "tracking", "daily", "heartrate", "personal"]
---

# Heartrate

A focused health & wellness tool built for Heartrate. Log entries, review trends, and export reports — all locally.

## Why Heartrate?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
heartrate help

# Check current status
heartrate status

# View your statistics
heartrate stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `heartrate log` | Log |
| `heartrate track` | Track |
| `heartrate chart` | Chart |
| `heartrate goal` | Goal |
| `heartrate remind` | Remind |
| `heartrate weekly` | Weekly |
| `heartrate monthly` | Monthly |
| `heartrate compare` | Compare |
| `heartrate export` | Export |
| `heartrate streak` | Streak |
| `heartrate milestone` | Milestone |
| `heartrate trend` | Trend |
| `heartrate stats` | Summary statistics |
| `heartrate export` | <fmt>       Export (json|csv|txt) |
| `heartrate search` | <term>      Search entries |
| `heartrate recent` | Recent activity |
| `heartrate status` | Health check |
| `heartrate help` | Show this help |
| `heartrate version` | Show version |
| `heartrate $name:` | $c entries |
| `heartrate Total:` | $total entries |
| `heartrate Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `heartrate Version:` | v2.0.0 |
| `heartrate Data` | dir: $DATA_DIR |
| `heartrate Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `heartrate Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `heartrate Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `heartrate Status:` | OK |
| `heartrate [Heartrate]` | log: $input |
| `heartrate Saved.` | Total log entries: $total |
| `heartrate [Heartrate]` | track: $input |
| `heartrate Saved.` | Total track entries: $total |
| `heartrate [Heartrate]` | chart: $input |
| `heartrate Saved.` | Total chart entries: $total |
| `heartrate [Heartrate]` | goal: $input |
| `heartrate Saved.` | Total goal entries: $total |
| `heartrate [Heartrate]` | remind: $input |
| `heartrate Saved.` | Total remind entries: $total |
| `heartrate [Heartrate]` | weekly: $input |
| `heartrate Saved.` | Total weekly entries: $total |
| `heartrate [Heartrate]` | monthly: $input |
| `heartrate Saved.` | Total monthly entries: $total |
| `heartrate [Heartrate]` | compare: $input |
| `heartrate Saved.` | Total compare entries: $total |
| `heartrate [Heartrate]` | export: $input |
| `heartrate Saved.` | Total export entries: $total |
| `heartrate [Heartrate]` | streak: $input |
| `heartrate Saved.` | Total streak entries: $total |
| `heartrate [Heartrate]` | milestone: $input |
| `heartrate Saved.` | Total milestone entries: $total |
| `heartrate [Heartrate]` | trend: $input |
| `heartrate Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/heartrate/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
