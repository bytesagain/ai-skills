---
name: "Allergy"
description: "Take control of Allergy with this health & wellness toolkit. Clean interface, local storage, zero configuration."
version: "2.0.0"
author: "BytesAgain"
tags: ["wellness", "fitness", "self-care", "allergy", "personal"]
---

# Allergy

Take control of Allergy with this health & wellness toolkit. Clean interface, local storage, zero configuration.

## Why Allergy?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
allergy help

# Check current status
allergy status

# View your statistics
allergy stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `allergy log` | Log |
| `allergy track` | Track |
| `allergy chart` | Chart |
| `allergy goal` | Goal |
| `allergy remind` | Remind |
| `allergy weekly` | Weekly |
| `allergy monthly` | Monthly |
| `allergy compare` | Compare |
| `allergy export` | Export |
| `allergy streak` | Streak |
| `allergy milestone` | Milestone |
| `allergy trend` | Trend |
| `allergy stats` | Summary statistics |
| `allergy export` | <fmt>       Export (json|csv|txt) |
| `allergy search` | <term>      Search entries |
| `allergy recent` | Recent activity |
| `allergy status` | Health check |
| `allergy help` | Show this help |
| `allergy version` | Show version |
| `allergy $name:` | $c entries |
| `allergy Total:` | $total entries |
| `allergy Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `allergy Version:` | v2.0.0 |
| `allergy Data` | dir: $DATA_DIR |
| `allergy Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `allergy Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `allergy Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `allergy Status:` | OK |
| `allergy [Allergy]` | log: $input |
| `allergy Saved.` | Total log entries: $total |
| `allergy [Allergy]` | track: $input |
| `allergy Saved.` | Total track entries: $total |
| `allergy [Allergy]` | chart: $input |
| `allergy Saved.` | Total chart entries: $total |
| `allergy [Allergy]` | goal: $input |
| `allergy Saved.` | Total goal entries: $total |
| `allergy [Allergy]` | remind: $input |
| `allergy Saved.` | Total remind entries: $total |
| `allergy [Allergy]` | weekly: $input |
| `allergy Saved.` | Total weekly entries: $total |
| `allergy [Allergy]` | monthly: $input |
| `allergy Saved.` | Total monthly entries: $total |
| `allergy [Allergy]` | compare: $input |
| `allergy Saved.` | Total compare entries: $total |
| `allergy [Allergy]` | export: $input |
| `allergy Saved.` | Total export entries: $total |
| `allergy [Allergy]` | streak: $input |
| `allergy Saved.` | Total streak entries: $total |
| `allergy [Allergy]` | milestone: $input |
| `allergy Saved.` | Total milestone entries: $total |
| `allergy [Allergy]` | trend: $input |
| `allergy Saved.` | Total trend entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/allergy/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
