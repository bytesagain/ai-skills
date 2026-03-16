---
name: "Step"
description: "Terminal-first Step manager. Keep your health & wellness data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["health", "wellness", "tracking", "self-care", "step"]
---

# Step

Terminal-first Step manager. Keep your health & wellness data organized with simple commands.

## Why Step?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
step help

# Check current status
step status

# View your statistics
step stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `step log` | Log |
| `step track` | Track |
| `step chart` | Chart |
| `step goal` | Goal |
| `step remind` | Remind |
| `step weekly` | Weekly |
| `step monthly` | Monthly |
| `step compare` | Compare |
| `step export` | Export |
| `step streak` | Streak |
| `step milestone` | Milestone |
| `step trend` | Trend |
| `step stats` | Summary statistics |
| `step export` | <fmt>       Export (json|csv|txt) |
| `step search` | <term>      Search entries |
| `step recent` | Recent activity |
| `step status` | Health check |
| `step help` | Show this help |
| `step version` | Show version |
| `step $name:` | $c entries |
| `step Total:` | $total entries |
| `step Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `step Version:` | v2.0.0 |
| `step Data` | dir: $DATA_DIR |
| `step Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `step Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `step Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `step Status:` | OK |
| `step [Step]` | log: $input |
| `step Saved.` | Total log entries: $total |
| `step [Step]` | track: $input |
| `step Saved.` | Total track entries: $total |
| `step [Step]` | chart: $input |
| `step Saved.` | Total chart entries: $total |
| `step [Step]` | goal: $input |
| `step Saved.` | Total goal entries: $total |
| `step [Step]` | remind: $input |
| `step Saved.` | Total remind entries: $total |
| `step [Step]` | weekly: $input |
| `step Saved.` | Total weekly entries: $total |
| `step [Step]` | monthly: $input |
| `step Saved.` | Total monthly entries: $total |
| `step [Step]` | compare: $input |
| `step Saved.` | Total compare entries: $total |
| `step [Step]` | export: $input |
| `step Saved.` | Total export entries: $total |
| `step [Step]` | streak: $input |
| `step Saved.` | Total streak entries: $total |
| `step [Step]` | milestone: $input |
| `step Saved.` | Total milestone entries: $total |
| `step [Step]` | trend: $input |
| `step Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/step/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
