---
name: "Habit"
description: "Build daily habits with streak tracking, reminders, and progress charts. Use when starting habits, maintaining streaks, or analyzing completion rates."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["planning", "productivity", "habit", "organization", "workflow"]
---

# Habit

Take control of Habit with this productivity toolkit. Clean interface, local storage, zero configuration.

## Why Habit?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
habit help

# Check current status
habit status

# View your statistics
habit stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `habit ingest` | Ingest |
| `habit transform` | Transform |
| `habit query` | Query |
| `habit filter` | Filter |
| `habit aggregate` | Aggregate |
| `habit visualize` | Visualize |
| `habit export` | Export |
| `habit sample` | Sample |
| `habit schema` | Schema |
| `habit validate` | Validate |
| `habit pipeline` | Pipeline |
| `habit profile` | Profile |
| `habit stats` | Summary statistics |
| `habit export` | <fmt>       Export (json|csv|txt) |
| `habit search` | <term>      Search entries |
| `habit recent` | Recent activity |
| `habit status` | Health check |
| `habit help` | Show this help |
| `habit version` | Show version |
| `habit $name:` | $c entries |
| `habit Total:` | $total entries |
| `habit Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `habit Version:` | v2.0.0 |
| `habit Data` | dir: $DATA_DIR |
| `habit Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `habit Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `habit Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `habit Status:` | OK |
| `habit [Habit]` | ingest: $input |
| `habit Saved.` | Total ingest entries: $total |
| `habit [Habit]` | transform: $input |
| `habit Saved.` | Total transform entries: $total |
| `habit [Habit]` | query: $input |
| `habit Saved.` | Total query entries: $total |
| `habit [Habit]` | filter: $input |
| `habit Saved.` | Total filter entries: $total |
| `habit [Habit]` | aggregate: $input |
| `habit Saved.` | Total aggregate entries: $total |
| `habit [Habit]` | visualize: $input |
| `habit Saved.` | Total visualize entries: $total |
| `habit [Habit]` | export: $input |
| `habit Saved.` | Total export entries: $total |
| `habit [Habit]` | sample: $input |
| `habit Saved.` | Total sample entries: $total |
| `habit [Habit]` | schema: $input |
| `habit Saved.` | Total schema entries: $total |
| `habit [Habit]` | validate: $input |
| `habit Saved.` | Total validate entries: $total |
| `habit [Habit]` | pipeline: $input |
| `habit Saved.` | Total pipeline entries: $total |
| `habit [Habit]` | profile: $input |
| `habit Saved.` | Total profile entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/habit/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
