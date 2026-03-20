---
version: "2.0.0"
name: Love Lines
description: "Generate witty romantic lines for any occasion. Use when drafting confessions, writing humorous openers, composing anniversary notes, crafting farewells."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Love Lines

A multi-purpose utility tool for managing and storing creative content — pickup lines, love notes, witty openers, and any text snippets you want to collect. Pickup Lines provides 10 commands for adding, listing, searching, removing, and exporting entries, all backed by a simple date-stamped log file.

## Commands

| Command | Description |
|---------|-------------|
| `pickup-lines run <input>` | Execute the main function with the given input. General-purpose entry point for quick operations. |
| `pickup-lines config` | Show the current configuration file path (`$DATA_DIR/config.json`). |
| `pickup-lines status` | Display the current tool status (ready/not ready). |
| `pickup-lines init` | Initialize the data directory. Creates `$DATA_DIR` if it doesn't exist. Safe to run multiple times. |
| `pickup-lines list` | List all saved entries from the data log. Shows full contents of the data file. |
| `pickup-lines add <text>` | Add a new entry to the data log with today's date stamp. E.g. `add "Are you a magician?"` |
| `pickup-lines remove <item>` | Remove a specific entry from the collection. |
| `pickup-lines search <term>` | Search saved entries for a keyword (case-insensitive). Returns matching lines from the data log. |
| `pickup-lines export` | Export all saved data to stdout. Pipe to a file for backup or sharing. |
| `pickup-lines info` | Show version and data directory information. |
| `pickup-lines help` | Display the full help message with all available commands. |
| `pickup-lines version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored as plain-text files in `~/.local/share/pickup-lines/` (or override with `PICKUP_LINES_DIR` env var):

- **`data.log`** — Main data file. Each entry is one line: `YYYY-MM-DD <text>`
- **`history.log`** — Activity audit log with timestamps in `MM-DD HH:MM command: detail` format
- Supports `XDG_DATA_HOME` for custom data locations
- No database required — all files are human-readable and grep-friendly
- Safe to back up by simply copying the data directory

## Requirements

- **Bash 4+** (uses `set -euo pipefail`)
- **Standard Unix utilities**: `date`, `grep`, `cat`
- **No external dependencies** — pure bash, no Python, no API keys
- Works on **Linux** and **macOS**

## When to Use

1. **Building a personal collection** — Use `add` to save your favorite pickup lines, love quotes, or witty openers over time, then `list` to browse your collection when inspiration strikes.
2. **Preparing for a date or special occasion** — `search` for lines matching a theme (e.g. "coffee", "stars", "nerdy") to find the perfect opener or anniversary message.
3. **Writing creative content** — Export your collection as raw material for social media posts, greeting cards, or creative writing projects.
4. **Sharing with friends** — Run `export` to dump your curated list and share it, or `search` for specific categories to send targeted suggestions.
5. **Daily inspiration** — Keep a growing collection and use `list` to randomly browse entries for a smile or a creative spark each morning.

## Examples

```bash
# Initialize the data directory
pickup-lines init

# Add a classic pickup line
pickup-lines add "Are you a parking ticket? Because you've got 'fine' written all over you."

# Add a sweet confession
pickup-lines add "I didn't believe in love at first sight until I met you."

# Search for lines about stars
pickup-lines search "stars"

# List your entire collection
pickup-lines list

# Export everything for backup
pickup-lines export > ~/my-lines-backup.txt
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
