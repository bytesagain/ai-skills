---
version: "1.0.0"
name: regex-builder
description: "Construct and test regex patterns with visual reference. Use when building expressions, scoring efficiency, ranking match results, reviewing history."
---

# Regex Builder

Gaming-inspired CLI toolkit for tracking scores, ranks, challenges, and leaderboards. Roll dice, score events, rank players, track history, manage challenges, create games, join sessions, monitor leaderboards, issue rewards, and reset state — all with persistent local logging and full export capabilities.

## Commands

Run `regex-builder <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `roll` | Roll dice or generate random values |
| `score` | Record and track scores |
| `rank` | Manage player/item rankings |
| `history` | View or log history entries |
| `stats` | Track statistics and metrics |
| `challenge` | Create and manage challenges |
| `create` | Create new game sessions or items |
| `join` | Join an existing game or session |
| `track` | Track progress and milestones |
| `leaderboard` | View and manage leaderboards |
| `reward` | Issue and track rewards |
| `reset` | Reset game state or entries |
| `stats` | Show summary statistics across all categories |
| `export <fmt>` | Export data in json, csv, or txt format |
| `search <term>` | Search across all logged entries |
| `recent` | Show recent activity from history log |
| `status` | Health check — version, data dir, disk usage |
| `help` | Show help and available commands |
| `version` | Show version (v2.0.0) |

Each domain command (roll, score, rank, etc.) works in two modes:
- **Without arguments**: displays the most recent 20 entries from that category
- **With arguments**: logs the input with a timestamp and saves to the category log file

## Data Storage

All data is stored locally in `~/.local/share/regex-builder/`:

- Each command creates its own log file (e.g., `roll.log`, `score.log`, `leaderboard.log`)
- A unified `history.log` tracks all activity across commands
- Entries are stored in `timestamp|value` pipe-delimited format
- Export supports JSON, CSV, and plain text formats

## Requirements

- Bash 4+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Running tabletop or dice-based games** — use `roll` to generate random values and `score` to track player points during game sessions
2. **Managing competitive leaderboards** — track rankings with `rank`, view standings via `leaderboard`, and issue `reward` entries for achievements
3. **Organizing challenges and tournaments** — create challenges, let players join sessions, and track progress through milestones
4. **Logging game history for review** — maintain a persistent history of all game events, search past entries, and export data for analysis
5. **Resetting and starting fresh** — use `reset` to clear state for a new season or tournament, while keeping exported archives of previous data

## Examples

```bash
# Roll dice for a game session
regex-builder roll "2d6 result: 7"

# Record a player score
regex-builder score "player=Alice points=1500 round=3"

# Update rankings
regex-builder rank "1st=Alice 2nd=Bob 3rd=Charlie"

# Create a new challenge
regex-builder challenge "speed-run: complete level 5 in under 2 minutes"

# Join a game session
regex-builder join "session=tournament-42 player=Dave"

# View the leaderboard
regex-builder leaderboard "top 10 by total score"

# Issue a reward
regex-builder reward "Alice: achievement unlocked — first place 3 rounds straight"

# Track a milestone
regex-builder track "Bob reached level 10, 2500 total XP"

# View summary statistics
regex-builder stats

# Export all data as CSV
regex-builder export csv

# Search for a specific player
regex-builder search "Alice"

# Check recent activity
regex-builder recent
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
regex-builder history > game-log.txt
regex-builder export json  # saves to ~/.local/share/regex-builder/export.json
```

## Configuration

Set `DATA_DIR` by modifying the script, or use the default: `~/.local/share/regex-builder/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
