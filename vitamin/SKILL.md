---
name: "Vitamin"
description: "Terminal-first Vitamin manager. Keep your health & wellness data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["vitamin", "tracking", "daily", "self-care", "monitor"]
---

# Vitamin

Terminal-first Vitamin manager. Keep your health & wellness data organized with simple commands.

## Why Vitamin?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
vitamin help

# Check current status
vitamin status

# View your statistics
vitamin stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `vitamin log` | Log |
| `vitamin track` | Track |
| `vitamin chart` | Chart |
| `vitamin goal` | Goal |
| `vitamin remind` | Remind |
| `vitamin weekly` | Weekly |
| `vitamin monthly` | Monthly |
| `vitamin compare` | Compare |
| `vitamin export` | Export |
| `vitamin streak` | Streak |
| `vitamin milestone` | Milestone |
| `vitamin trend` | Trend |
| `vitamin stats` | Summary statistics |
| `vitamin export` | <fmt>       Export (json|csv|txt) |
| `vitamin search` | <term>      Search entries |
| `vitamin recent` | Recent activity |
| `vitamin status` | Health check |
| `vitamin help` | Show this help |
| `vitamin version` | Show version |
| `vitamin $name:` | $c entries |
| `vitamin Total:` | $total entries |
| `vitamin Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `vitamin Version:` | v2.0.0 |
| `vitamin Data` | dir: $DATA_DIR |
| `vitamin Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `vitamin Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `vitamin Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `vitamin Status:` | OK |
| `vitamin [Vitamin]` | log: $input |
| `vitamin Saved.` | Total log entries: $total |
| `vitamin [Vitamin]` | track: $input |
| `vitamin Saved.` | Total track entries: $total |
| `vitamin [Vitamin]` | chart: $input |
| `vitamin Saved.` | Total chart entries: $total |
| `vitamin [Vitamin]` | goal: $input |
| `vitamin Saved.` | Total goal entries: $total |
| `vitamin [Vitamin]` | remind: $input |
| `vitamin Saved.` | Total remind entries: $total |
| `vitamin [Vitamin]` | weekly: $input |
| `vitamin Saved.` | Total weekly entries: $total |
| `vitamin [Vitamin]` | monthly: $input |
| `vitamin Saved.` | Total monthly entries: $total |
| `vitamin [Vitamin]` | compare: $input |
| `vitamin Saved.` | Total compare entries: $total |
| `vitamin [Vitamin]` | export: $input |
| `vitamin Saved.` | Total export entries: $total |
| `vitamin [Vitamin]` | streak: $input |
| `vitamin Saved.` | Total streak entries: $total |
| `vitamin [Vitamin]` | milestone: $input |
| `vitamin Saved.` | Total milestone entries: $total |
| `vitamin [Vitamin]` | trend: $input |
| `vitamin Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/vitamin/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
