---
version: "1.0.0"
name: Dbeaver
description: "Browse database tables and run SQL queries across multiple engines. Use when exploring schemas, running queries, comparing databases."
---

# Db Explorer

Db Explorer v2.0.0 — a gaming/gamification toolkit for tracking scores, ranks, challenges, leaderboards, rewards, and more from the command line.

## Commands

Run via: `bash scripts/script.sh <command> [args]`

| Command | Description |
|---------|-------------|
| `roll <input>` | Roll dice or log a random outcome. Without args, shows recent rolls. |
| `score <input>` | Record a score entry — points, grades, or performance metrics. |
| `rank <input>` | Log rank changes or current standing in a leaderboard. |
| `history <input>` | Add or view historical entries for past events and milestones. |
| `stats <input>` | Log stats data points (game stats, player stats, etc.). |
| `challenge <input>` | Create or record a challenge — goals to achieve or compete on. |
| `create <input>` | Create a new entity — game, character, team, or project. |
| `join <input>` | Log a join event — joining a team, session, or group. |
| `track <input>` | Track progress on a challenge, quest, or ongoing goal. |
| `leaderboard <input>` | Record or view leaderboard entries and rankings. |
| `reward <input>` | Log rewards earned — badges, achievements, prizes. |
| `reset <input>` | Record a reset event — starting fresh on a score, rank, or challenge. |
| `stats` | Show summary statistics across all entry types. |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search across all log files for a keyword. |
| `recent` | Show the 20 most recent activity entries from the history log. |
| `status` | Health check — version, data directory, entry count, disk usage. |
| `help` | Show the built-in help message with all available commands. |
| `version` | Print the current version (`db-explorer v2.0.0`). |

Each data command works in two modes:
- **With arguments**: saves the input with a timestamp to its dedicated log file.
- **Without arguments**: displays the 20 most recent entries from that log.

## Data Storage

All data is stored locally in `~/.local/share/db-explorer/`:

- Each command has its own log file (e.g., `roll.log`, `score.log`, `rank.log`)
- Entries are saved in `timestamp|value` format
- A unified `history.log` records all activity across commands
- Export files are written to the same directory

## Requirements

- Bash (standard system shell)
- No external dependencies — uses only coreutils (`date`, `wc`, `du`, `grep`, `tail`, `cat`)

## When to Use

- When you want to track scores and rankings from the terminal
- To manage challenges and record progress on gamified goals
- For maintaining leaderboards and tracking competitive standings
- To log rewards, achievements, and milestones
- When building a simple gamification layer for productivity
- To export game/challenge data for analysis or sharing
- For lightweight, file-based score and progress tracking

## Examples

```bash
# Roll the dice
db-explorer roll "D20 — got 17, critical success"

# Record a score
db-explorer score "Level 5 completed: 2450 points"

# Update rank
db-explorer rank "Moved up to #3 on weekly leaderboard"

# Log history
db-explorer history "First time clearing the boss in under 2 minutes"

# Create a challenge
db-explorer challenge "30-day coding streak — no skipped days"

# Join a team
db-explorer join "Joined Team Alpha for the hackathon"

# Track progress
db-explorer track "Day 12/30 of coding streak — still going"

# Record a reward
db-explorer reward "Earned 'Consistency King' badge"

# Update leaderboard
db-explorer leaderboard "Week 12: Alice 980, Bob 875, Charlie 720"

# Reset scores
db-explorer reset "New season — all scores zeroed"

# View all statistics
db-explorer stats

# Export everything as JSON
db-explorer export json

# Search for entries mentioning "streak"
db-explorer search streak

# Check recent activity
db-explorer recent

# Health check
db-explorer status
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
