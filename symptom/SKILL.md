---
name: "Symptom"
description: "Symptom — a fast health & wellness tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["fitness", "tracking", "daily", "self-care", "symptom"]
---

# Symptom

Symptom — a fast health & wellness tool. Log anything, find it later, export when needed.

## Why Symptom?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
symptom help

# Check current status
symptom status

# View your statistics
symptom stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `symptom log` | Log |
| `symptom track` | Track |
| `symptom chart` | Chart |
| `symptom goal` | Goal |
| `symptom remind` | Remind |
| `symptom weekly` | Weekly |
| `symptom monthly` | Monthly |
| `symptom compare` | Compare |
| `symptom export` | Export |
| `symptom streak` | Streak |
| `symptom milestone` | Milestone |
| `symptom trend` | Trend |
| `symptom stats` | Summary statistics |
| `symptom export` | <fmt>       Export (json|csv|txt) |
| `symptom search` | <term>      Search entries |
| `symptom recent` | Recent activity |
| `symptom status` | Health check |
| `symptom help` | Show this help |
| `symptom version` | Show version |
| `symptom $name:` | $c entries |
| `symptom Total:` | $total entries |
| `symptom Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `symptom Version:` | v2.0.0 |
| `symptom Data` | dir: $DATA_DIR |
| `symptom Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `symptom Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `symptom Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `symptom Status:` | OK |
| `symptom [Symptom]` | log: $input |
| `symptom Saved.` | Total log entries: $total |
| `symptom [Symptom]` | track: $input |
| `symptom Saved.` | Total track entries: $total |
| `symptom [Symptom]` | chart: $input |
| `symptom Saved.` | Total chart entries: $total |
| `symptom [Symptom]` | goal: $input |
| `symptom Saved.` | Total goal entries: $total |
| `symptom [Symptom]` | remind: $input |
| `symptom Saved.` | Total remind entries: $total |
| `symptom [Symptom]` | weekly: $input |
| `symptom Saved.` | Total weekly entries: $total |
| `symptom [Symptom]` | monthly: $input |
| `symptom Saved.` | Total monthly entries: $total |
| `symptom [Symptom]` | compare: $input |
| `symptom Saved.` | Total compare entries: $total |
| `symptom [Symptom]` | export: $input |
| `symptom Saved.` | Total export entries: $total |
| `symptom [Symptom]` | streak: $input |
| `symptom Saved.` | Total streak entries: $total |
| `symptom [Symptom]` | milestone: $input |
| `symptom Saved.` | Total milestone entries: $total |
| `symptom [Symptom]` | trend: $input |
| `symptom Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/symptom/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
