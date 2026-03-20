---
version: "2.0.0"
name: Gift Finder
description: "Recommend gifts by person, budget, and occasion with creative card ideas. Use when picking birthday gifts, finding presents, or writing greetings."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Gift Finder

Multi-purpose utility tool for running tasks, managing configuration, tracking entries, searching data, and exporting results. All operations are logged with timestamps and stored locally for full traceability.

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `gift-finder run <input>` | Execute main function with given input |
| `config` | `gift-finder config` | Show configuration file location |
| `status` | `gift-finder status` | Show current status (ready/not ready) |
| `init` | `gift-finder init` | Initialize the data directory |
| `list` | `gift-finder list` | List all entries from the data log |
| `add` | `gift-finder add <entry>` | Add a new entry with today's date |
| `remove` | `gift-finder remove <entry>` | Remove an entry |
| `search` | `gift-finder search <term>` | Search entries for a keyword (case-insensitive) |
| `export` | `gift-finder export` | Export all data from the log |
| `info` | `gift-finder info` | Show version and data directory path |
| `help` | `gift-finder help` | Show help with all available commands |
| `version` | `gift-finder version` | Print version string |

## Data Storage

All data is stored locally at `~/.local/share/gift-finder/` (override with `GIFT_FINDER_DIR` env var):

- `data.log` — Main data log for entries added via `add`, listed via `list`, searched via `search`
- `history.log` — Unified activity log across all commands with timestamps
- `config.json` — Configuration file (referenced by `config` command)
- Follows XDG Base Directory spec (`XDG_DATA_HOME` supported)

No cloud services, no network calls, no external API calls needed. Fully offline.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `grep`, `cat`)
- No external dependencies

## When to Use

1. **Maintaining a gift idea list** — Use `gift-finder add "Wireless headphones for Dad's birthday"` to build a running list of gift ideas, then `gift-finder list` to review them all when shopping time comes.
2. **Searching past entries** — Use `gift-finder search "birthday"` to find all birthday-related entries across your data log when you need inspiration from previous ideas.
3. **Initializing a fresh workspace** — Use `gift-finder init` when setting up on a new machine to create the data directory structure, then `gift-finder status` to verify everything is ready.
4. **Exporting data for sharing** — Use `gift-finder export` to dump all entries to stdout, which can be redirected to a file or piped to another tool for further processing.
5. **Quick system info check** — Use `gift-finder info` to see the current version and data directory path, useful for debugging or verifying which instance is active.

## Examples

```bash
# Initialize the data directory
gift-finder init

# Add a gift idea
gift-finder add "Kindle Paperwhite for Mom"

# Add another entry
gift-finder add "Board game collection for family game night"

# List all entries
gift-finder list

# Search for entries containing "Mom"
gift-finder search "Mom"

# Check current status
gift-finder status

# View configuration location
gift-finder config

# Show version and data path
gift-finder info

# Export all data
gift-finder export

# Run main function
gift-finder run "process holiday list"

# Remove an entry
gift-finder remove "Kindle Paperwhite for Mom"
```

## How It Works

Gift Finder stores all data locally in `~/.local/share/gift-finder/`. The `add` command appends entries to `data.log` with the current date prefix (`YYYY-MM-DD`). Every command logs its activity to `history.log` with timestamps in `MM-DD HH:MM` format. The `list` command displays the full data log, while `search` performs case-insensitive grep across entries.

## Notes

- Entries are stored as plain text for easy inspection and portability
- The `remove` command logs the removal but actual deletion depends on implementation
- All operations are purely local — no network access, no external APIs
- Redirect output to files with `gift-finder export > my_list.txt`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
