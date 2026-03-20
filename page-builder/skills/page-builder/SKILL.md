---
version: "1.0.0"
name: Grapesjs
description: "Free and Open source Web Builder Framework. Next generation tool for building templates without codi page-builder, typescript, drag-and-drop, framework."
---

# Page Builder

Gaming toolkit v2.0.0 — record, track, and manage gaming activities from the command line.

## Commands

All commands follow the pattern: `page-builder <command> [input]`

When called without input, each command displays its recent entries. When called with input, it records a new timestamped entry.

| Command        | Description                                      |
|----------------|--------------------------------------------------|
| `roll`         | Record or view dice roll entries                 |
| `score`        | Record or view score entries                     |
| `rank`         | Record or view rank/ranking entries              |
| `history`      | Record or view history entries                   |
| `stats`        | Record or view stats entries                     |
| `challenge`    | Record or view challenge entries                 |
| `create`       | Record or view create entries                    |
| `join`         | Record or view join entries                      |
| `track`        | Record or view tracking entries                  |
| `leaderboard`  | Record or view leaderboard entries               |
| `reward`       | Record or view reward entries                    |
| `reset`        | Record or view reset entries                     |
| `export <fmt>` | Export all data (json, csv, or txt)              |
| `search <term>`| Search across all log entries                    |
| `recent`       | Show the 20 most recent activity log entries     |
| `status`       | Health check — version, entry count, disk usage  |
| `help`         | Show help with all available commands            |
| `version`      | Print version string                             |

## How It Works

Each domain command (`roll`, `score`, `rank`, etc.) works in two modes:

- **Read mode** (no arguments): displays the last 20 entries from its log file
- **Write mode** (with arguments): appends a timestamped `YYYY-MM-DD HH:MM|<input>` line to its log file and logs the action to `history.log`

The built-in utility commands (`stats`, `export`, `search`, `recent`, `status`) aggregate data across all log files for reporting and analysis.

## Data Storage

All data is stored locally in `~/.local/share/page-builder/`:

- Each command writes to its own log file (e.g., `roll.log`, `score.log`, `rank.log`)
- `history.log` records all write operations with timestamps
- Export files are saved as `export.json`, `export.csv`, or `export.txt`
- No external network calls — everything stays on disk

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies or package installations needed

## When to Use

1. **Tracking game sessions** — log dice rolls, scores, and rankings during tabletop or video game sessions
2. **Running challenges** — create and track challenge progress with timestamped entries
3. **Managing leaderboards** — record player rankings and reward achievements over time
4. **Exporting game data** — generate JSON, CSV, or TXT exports for spreadsheets or external analysis
5. **Reviewing activity history** — search and browse past entries to see trends and patterns

## Examples

```bash
# Record a dice roll
page-builder roll "d20: natural 20, critical hit"

# Log a score
page-builder score "Round 3: 2450 points"

# Track a challenge
page-builder challenge "Speed run attempt #5 — completed in 12:34"

# Update the leaderboard
page-builder leaderboard "Player1: 9800pts, Player2: 8200pts"

# Search for all entries mentioning "critical"
page-builder search critical

# Export everything to JSON
page-builder export json

# Check system status
page-builder status

# View recent activity
page-builder recent
```

## Output

All commands return results to stdout. Redirect to a file if needed:

```bash
page-builder stats > game-summary.txt
page-builder export csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
