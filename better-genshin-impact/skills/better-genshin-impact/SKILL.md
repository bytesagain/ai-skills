---
version: "2.0.0"
name: Better Genshin Impact
description: "📦BetterGI · 更好的原神 - 自动拾取 | 自动剧情 | 全自动钓鱼(AI) | 全自动七圣召唤 | 自动伐木 | 自动刷本 | 自动采集/挖矿/锄地 | 一条龙 | 全连音游 - UI A better genshin impact, c#, auto-play-game, automatic."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Better Genshin Impact

A command-line gaming helper and tracker for Genshin Impact players. Get tips, guides, character builds, session timers, game logs, stats, random picks, score tracking, comparisons, and wishlists — all from your terminal. Data remains on disk.

## Commands

| Command | Description |
|---------|-------------|
| `tip <topic>` | Get a strategy tip for the given topic (character, boss, domain, etc.). |
| `guide <topic>` | Show a beginner guide for the specified topic. |
| `build <character> [focus]` | Show a character or deck build. Optional focus parameter (default: "balanced"). |
| `timer` | Start a gaming session timer. Prints the start time and a reminder to take breaks. |
| `log <text>` | Log a game event or note with a full timestamp. Appended to `data.log`. |
| `stats` | Show gaming statistics — total number of logged sessions/events. |
| `random [max]` | Generate a random number from 1 to `max` (default: 100). Great for decision-making or loot rolls. |
| `score <score> [high]` | Track a score. Shows current score and optional high score. |
| `compare` | Compare two options — prompts analysis of pros and cons. |
| `wishlist <item>` | Add an item to your wishlist. Saved to `wishlist.txt` in the data directory. |
| `help` | Show full usage information with all available commands. |
| `version` | Print version number (`v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/better-genshin-impact/` by default:

- `data.log` — Main game log file (timestamped entries via `log` command)
- `history.log` — Command history with timestamps (auto-maintained by every command)
- `wishlist.txt` — Wishlist items (one per line, added via `wishlist` command)

Set the `BETTER_GENSHIN_IMPACT_DIR` environment variable to change the storage location. Alternatively, `XDG_DATA_HOME` is respected if the env var is not set.

## Requirements

- Bash 4+ (uses `local` variables, `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `echo`, `cat`)
- No external dependencies or API keys required

## When to Use

1. **Looking up character builds** — Use `build <character>` to quickly check recommended builds and focus areas for any character.
2. **Tracking gaming sessions** — Use `timer` to mark session starts and `log` to record important events, drops, or achievements during gameplay.
3. **Making random decisions** — Use `random` for artifact rolls, character selection, or any in-game coin-flip decisions.
4. **Managing a wish/pull wishlist** — Use `wishlist` to maintain a list of desired characters, weapons, or items you're saving for.
5. **Reviewing gaming history** — Use `stats` to see how many sessions you've logged, and check `data.log` directly for detailed history.

## Examples

```bash
# Get a tip for fighting a boss
better-genshin-impact tip "Abyss Floor 12"

# Look up a character build
better-genshin-impact build "Hu Tao" "DPS"

# Show a beginner guide
better-genshin-impact guide "artifact farming"

# Start a session timer
better-genshin-impact timer

# Log a game event
better-genshin-impact log "Got 5-star Amos Bow from standard banner"

# Check gaming stats
better-genshin-impact stats

# Roll a random number (1-100)
better-genshin-impact random

# Roll a random number (1-6, like a die)
better-genshin-impact random 6

# Track a score
better-genshin-impact score 36 "Spiral Abyss stars"

# Add to wishlist
better-genshin-impact wishlist "Furina C2"

# Compare options
better-genshin-impact compare "Staff of Homa vs Primordial Jade"
```

## Output

All commands print results to stdout and log actions to `history.log`. The `log` command appends timestamped entries to `data.log`. The `wishlist` command appends items to `wishlist.txt`. Use shell redirection to capture output: `better-genshin-impact stats > report.txt`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
