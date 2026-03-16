---
name: "Leaderboard"
description: "Leaderboard makes gaming & entertainment simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["scores", "tabletop", "gaming", "fun", "leaderboard"]
---

# Leaderboard

Leaderboard makes gaming & entertainment simple. Record, search, and analyze your data with clear terminal output.

## Why Leaderboard?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
leaderboard help

# Check current status
leaderboard status

# View your statistics
leaderboard stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `leaderboard roll` | Roll |
| `leaderboard score` | Score |
| `leaderboard rank` | Rank |
| `leaderboard history` | History |
| `leaderboard stats` | Stats |
| `leaderboard challenge` | Challenge |
| `leaderboard create` | Create |
| `leaderboard join` | Join |
| `leaderboard track` | Track |
| `leaderboard leaderboard` | Leaderboard |
| `leaderboard reward` | Reward |
| `leaderboard reset` | Reset |
| `leaderboard stats` | Summary statistics |
| `leaderboard export` | <fmt>       Export (json|csv|txt) |
| `leaderboard search` | <term>      Search entries |
| `leaderboard recent` | Recent activity |
| `leaderboard status` | Health check |
| `leaderboard help` | Show this help |
| `leaderboard version` | Show version |
| `leaderboard $name:` | $c entries |
| `leaderboard Total:` | $total entries |
| `leaderboard Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `leaderboard Version:` | v2.0.0 |
| `leaderboard Data` | dir: $DATA_DIR |
| `leaderboard Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `leaderboard Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `leaderboard Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `leaderboard Status:` | OK |
| `leaderboard [Leaderboard]` | roll: $input |
| `leaderboard Saved.` | Total roll entries: $total |
| `leaderboard [Leaderboard]` | score: $input |
| `leaderboard Saved.` | Total score entries: $total |
| `leaderboard [Leaderboard]` | rank: $input |
| `leaderboard Saved.` | Total rank entries: $total |
| `leaderboard [Leaderboard]` | history: $input |
| `leaderboard Saved.` | Total history entries: $total |
| `leaderboard [Leaderboard]` | stats: $input |
| `leaderboard Saved.` | Total stats entries: $total |
| `leaderboard [Leaderboard]` | challenge: $input |
| `leaderboard Saved.` | Total challenge entries: $total |
| `leaderboard [Leaderboard]` | create: $input |
| `leaderboard Saved.` | Total create entries: $total |
| `leaderboard [Leaderboard]` | join: $input |
| `leaderboard Saved.` | Total join entries: $total |
| `leaderboard [Leaderboard]` | track: $input |
| `leaderboard Saved.` | Total track entries: $total |
| `leaderboard [Leaderboard]` | leaderboard: $input |
| `leaderboard Saved.` | Total leaderboard entries: $total |
| `leaderboard [Leaderboard]` | reward: $input |
| `leaderboard Saved.` | Total reward entries: $total |
| `leaderboard [Leaderboard]` | reset: $input |
| `leaderboard Saved.` | Total reset entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/leaderboard/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
