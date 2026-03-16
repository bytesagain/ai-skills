---
name: "Dice"
description: "A focused gaming & entertainment tool built for Dice. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["dice", "scores", "tabletop", "gaming", "fun"]
---

# Dice

A focused gaming & entertainment tool built for Dice. Log entries, review trends, and export reports — all locally.

## Why Dice?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
dice help

# Check current status
dice status

# View your statistics
dice stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `dice roll` | Roll |
| `dice score` | Score |
| `dice rank` | Rank |
| `dice history` | History |
| `dice stats` | Stats |
| `dice challenge` | Challenge |
| `dice create` | Create |
| `dice join` | Join |
| `dice track` | Track |
| `dice leaderboard` | Leaderboard |
| `dice reward` | Reward |
| `dice reset` | Reset |
| `dice stats` | Summary statistics |
| `dice export` | <fmt>       Export (json|csv|txt) |
| `dice search` | <term>      Search entries |
| `dice recent` | Recent activity |
| `dice status` | Health check |
| `dice help` | Show this help |
| `dice version` | Show version |
| `dice $name:` | $c entries |
| `dice Total:` | $total entries |
| `dice Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `dice Version:` | v2.0.0 |
| `dice Data` | dir: $DATA_DIR |
| `dice Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `dice Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `dice Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `dice Status:` | OK |
| `dice [Dice]` | roll: $input |
| `dice Saved.` | Total roll entries: $total |
| `dice [Dice]` | score: $input |
| `dice Saved.` | Total score entries: $total |
| `dice [Dice]` | rank: $input |
| `dice Saved.` | Total rank entries: $total |
| `dice [Dice]` | history: $input |
| `dice Saved.` | Total history entries: $total |
| `dice [Dice]` | stats: $input |
| `dice Saved.` | Total stats entries: $total |
| `dice [Dice]` | challenge: $input |
| `dice Saved.` | Total challenge entries: $total |
| `dice [Dice]` | create: $input |
| `dice Saved.` | Total create entries: $total |
| `dice [Dice]` | join: $input |
| `dice Saved.` | Total join entries: $total |
| `dice [Dice]` | track: $input |
| `dice Saved.` | Total track entries: $total |
| `dice [Dice]` | leaderboard: $input |
| `dice Saved.` | Total leaderboard entries: $total |
| `dice [Dice]` | reward: $input |
| `dice Saved.` | Total reward entries: $total |
| `dice [Dice]` | reset: $input |
| `dice Saved.` | Total reset entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/dice/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
