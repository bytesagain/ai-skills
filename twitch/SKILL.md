---
name: "Twitch"
description: "Manage Twitch data right from your terminal. Built for people who want get things done faster without complex setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["twitch", "tool", "terminal", "cli", "utility"]
---

# Twitch

Manage Twitch data right from your terminal. Built for people who want get things done faster without complex setup.

## Why Twitch?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
twitch help

# Check current status
twitch status

# View your statistics
twitch stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `twitch roll` | Roll |
| `twitch score` | Score |
| `twitch rank` | Rank |
| `twitch history` | History |
| `twitch stats` | Stats |
| `twitch challenge` | Challenge |
| `twitch create` | Create |
| `twitch join` | Join |
| `twitch track` | Track |
| `twitch leaderboard` | Leaderboard |
| `twitch reward` | Reward |
| `twitch reset` | Reset |
| `twitch stats` | Summary statistics |
| `twitch export` | <fmt>       Export (json|csv|txt) |
| `twitch search` | <term>      Search entries |
| `twitch recent` | Recent activity |
| `twitch status` | Health check |
| `twitch help` | Show this help |
| `twitch version` | Show version |
| `twitch $name:` | $c entries |
| `twitch Total:` | $total entries |
| `twitch Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `twitch Version:` | v2.0.0 |
| `twitch Data` | dir: $DATA_DIR |
| `twitch Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `twitch Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `twitch Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `twitch Status:` | OK |
| `twitch [Twitch]` | roll: $input |
| `twitch Saved.` | Total roll entries: $total |
| `twitch [Twitch]` | score: $input |
| `twitch Saved.` | Total score entries: $total |
| `twitch [Twitch]` | rank: $input |
| `twitch Saved.` | Total rank entries: $total |
| `twitch [Twitch]` | history: $input |
| `twitch Saved.` | Total history entries: $total |
| `twitch [Twitch]` | stats: $input |
| `twitch Saved.` | Total stats entries: $total |
| `twitch [Twitch]` | challenge: $input |
| `twitch Saved.` | Total challenge entries: $total |
| `twitch [Twitch]` | create: $input |
| `twitch Saved.` | Total create entries: $total |
| `twitch [Twitch]` | join: $input |
| `twitch Saved.` | Total join entries: $total |
| `twitch [Twitch]` | track: $input |
| `twitch Saved.` | Total track entries: $total |
| `twitch [Twitch]` | leaderboard: $input |
| `twitch Saved.` | Total leaderboard entries: $total |
| `twitch [Twitch]` | reward: $input |
| `twitch Saved.` | Total reward entries: $total |
| `twitch [Twitch]` | reset: $input |
| `twitch Saved.` | Total reset entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/twitch/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
