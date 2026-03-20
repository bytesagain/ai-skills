---
version: "1.0.0"
name: Prisma1
description: "💾 Database Tools incl. ORM, Migrations and Admin UI (Postgres, MySQL & MongoDB) [deprecated] orm-builder, scala, dao, database, datamapper, graphql."
---

# Orm Builder

Terminal-based gaming toolkit for dice rolls, scoring, rankings, challenges, leaderboards, and player tracking. Orm Builder provides 12 core gaming commands plus built-in statistics, data export, search, and health-check capabilities — all backed by local log-based storage.

## Commands

All commands follow the pattern: `orm-builder <command> [input]`

When called **without arguments**, each command displays its most recent 20 log entries.
When called **with arguments**, it records the input with a timestamp.

### Core Gaming Commands

| Command | Description |
|---------|-------------|
| `roll <input>` | Record a dice roll or random result |
| `score <input>` | Record a score entry |
| `rank <input>` | Record a ranking or position |
| `history <input>` | Record a history event |
| `stats <input>` | Record a stats observation |
| `challenge <input>` | Record a challenge entry |
| `create <input>` | Record a creation event (new game, session, etc.) |
| `join <input>` | Record a join action (player joining a game/session) |
| `track <input>` | Record a tracking entry (progress, milestones) |
| `leaderboard <input>` | Record a leaderboard entry |
| `reward <input>` | Record a reward or achievement |
| `reset <input>` | Record a reset action |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files (entry counts, disk usage) |
| `export <fmt>` | Export all data to a file — supported formats: `json`, `csv`, `txt` |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Show the 20 most recent entries from the activity history |
| `status` | Health check — version, data directory, total entries, disk usage, last activity |
| `help` | Display the full help message with all available commands |
| `version` | Print the current version (`orm-builder v2.0.0`) |

## Data Storage

All data is stored locally in plain-text log files:

- **Location:** `~/.local/share/orm-builder/`
- **Format:** Each entry is a line of `YYYY-MM-DD HH:MM|<input>` in the corresponding `<command>.log` file
- **History:** Every action is also appended to `history.log` with a timestamp and command label
- **Export formats:** JSON (array of objects), CSV (with headers), plain text (grouped by command)
- **No external dependencies** — pure bash, runs anywhere

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **Core utilities:** `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No network access required — fully offline
- No configuration needed — works out of the box

## When to Use

1. **Tabletop gaming sessions** — use `orm-builder roll` to log dice rolls, `orm-builder score` to track scores, and `orm-builder leaderboard` to record standings
2. **Game challenge tracking** — record challenges with `orm-builder challenge`, track progress with `orm-builder track`, and reward achievements with `orm-builder reward`
3. **Player management** — use `orm-builder create` for new games/sessions, `orm-builder join` for player registration, and `orm-builder rank` for rankings
4. **Session history and analytics** — review past activity with `orm-builder history`, get aggregate stats with `orm-builder stats`, and export data with `orm-builder export csv`
5. **Tournament administration** — combine `orm-builder leaderboard`, `orm-builder score`, and `orm-builder rank` to manage multi-round competitions, then `orm-builder export json` for archival

## Examples

### Record dice rolls and scores

```bash
# Log a dice roll
orm-builder roll "d20 = 17, critical hit"

# Record a player score
orm-builder score "Player1: 2450 points"

# View recent rolls
orm-builder roll
```

### Challenge and reward tracking

```bash
# Create a new challenge
orm-builder challenge "defeat the dragon - difficulty: legendary"

# Track progress
orm-builder track "dragon HP reduced to 50%"

# Award a reward
orm-builder reward "Player2 earned Dragon Slayer badge"
```

### Leaderboard management

```bash
# Update leaderboard
orm-builder leaderboard "1st: Player1 (2450), 2nd: Player3 (2100), 3rd: Player2 (1800)"

# Record rankings
orm-builder rank "Player1 moved from #3 to #1"

# Export full leaderboard data
orm-builder export json
```

### Session lifecycle

```bash
# Start a new session
orm-builder create "Campaign: The Lost Mines - Session 5"

# Players join
orm-builder join "Player1 joined as Fighter"
orm-builder join "Player2 joined as Mage"

# Review session history
orm-builder recent
```

### Statistics and data export

```bash
# View overall statistics
orm-builder stats

# Search for specific entries
orm-builder search "critical"

# Health check
orm-builder status

# Export to CSV for spreadsheet analysis
orm-builder export csv
```

## Output

All commands output to stdout. Redirect to a file with:

```bash
orm-builder stats > report.txt
orm-builder export json   # writes to ~/.local/share/orm-builder/export.json
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
