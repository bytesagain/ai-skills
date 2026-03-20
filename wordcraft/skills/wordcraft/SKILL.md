---
name: WordCraft
description: "Analyze text, build outlines, and craft polished writing. Use when outlining articles, scoring readability, counting words, ranking keywords, or editing."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["writing","text","analysis","readability","wordcount","content","blog","author"]
categories: ["Writing", "Productivity", "Content Creation"]
---

# WordCraft

A gaming-inspired toolkit for word challenges, scoring, tracking, and creative play. Roll dice, score words, rank players, manage challenges, track progress, and view leaderboards — all from the command line.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from their log.

| Command | Description |
|---------|-------------|
| `wordcraft roll <input>` | Roll dice or generate a random word challenge |
| `wordcraft score <input>` | Log a score for a word game or challenge |
| `wordcraft rank <input>` | Record or update player rankings |
| `wordcraft history <input>` | Log a history entry or view recent history |
| `wordcraft stats <input>` | Log stats or view summary statistics |
| `wordcraft challenge <input>` | Create or log a new word challenge |
| `wordcraft create <input>` | Create a new game, puzzle, or word set |
| `wordcraft join <input>` | Join an existing game or challenge session |
| `wordcraft track <input>` | Track progress on an ongoing challenge |
| `wordcraft leaderboard <input>` | View or update the leaderboard |
| `wordcraft reward <input>` | Log a reward or achievement earned |
| `wordcraft reset <input>` | Reset a game, score, or challenge |
| `wordcraft stats` | Show summary statistics across all log files |
| `wordcraft export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `wordcraft search <term>` | Search across all log entries for a keyword |
| `wordcraft recent` | Show the 20 most recent activity entries |
| `wordcraft status` | Health check — version, data dir, entry count, disk usage |
| `wordcraft help` | Show all available commands |
| `wordcraft version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/wordcraft/`. Each command maintains its own `.log` file with timestamped entries in `YYYY-MM-DD HH:MM|value` format. A unified `history.log` tracks all operations across commands.

**Export formats supported:**
- **JSON** — Array of objects with `type`, `time`, and `value` fields
- **CSV** — Standard comma-separated with `type,time,value` header
- **TXT** — Human-readable grouped by command type

## Requirements

- Bash 4.0+ with `set -euo pipefail` (strict mode)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies — runs on any POSIX-compliant system

## When to Use

1. **Running word game challenges** — Use `roll`, `challenge`, and `create` to set up and play word games
2. **Tracking scores and rankings** — Log scores with `score`, update ranks with `rank`, and view `leaderboard`
3. **Monitoring progress over time** — Use `track` and `history` to follow player progress across sessions
4. **Exporting game data** — Export scores, rankings, and history to JSON/CSV for sharing or analysis
5. **Managing multiplayer sessions** — Use `join`, `create`, and `reset` to coordinate multi-player word challenges

## Examples

```bash
# Roll a new word challenge
wordcraft roll "7-letter scramble: ABCDEFG"

# Log a player's score
wordcraft score "Alice: 42 points — round 3"

# Create a new challenge
wordcraft challenge "Anagram race: 5 words in 60 seconds"

# Track progress
wordcraft track "Bob: 3/5 challenges completed"

# View the leaderboard
wordcraft leaderboard "Weekly top 5"

# Export all game data to JSON
wordcraft export json

# Search for a player's entries
wordcraft search "Alice"

# View summary statistics
wordcraft stats
```

## How It Works

WordCraft stores all data locally in `~/.local/share/wordcraft/`. Each command creates a dedicated log file (e.g., `roll.log`, `score.log`, `challenge.log`). Every entry is timestamped and appended, providing a full record of all game activity. The `history.log` file aggregates activity across all commands for unified tracking.

When called without arguments, each command displays its most recent 20 entries, making it easy to review past games and scores without manually inspecting log files.

## Output

All output goes to stdout. Redirect to a file with:

```bash
wordcraft stats > report.txt
wordcraft export json  # writes to ~/.local/share/wordcraft/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
