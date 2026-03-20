---
version: "2.0.0"
name: Config
description: "Manage app configuration files with init, list, and add operations. Use when initializing configs, listing settings, switching environments."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Config

Multi-purpose configuration and data utility tool. Initialize settings, add entries, search records, and export data — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `config run <input>` | Execute the main function with the given input |
| `config config` | Show the configuration file path (`$DATA_DIR/config.json`) |
| `config status` | Display current system status (shows "ready" when operational) |
| `config init` | Initialize the data directory and prepare for first use |
| `config list` | List all entries stored in the data log |
| `config add <item>` | Add a new timestamped entry to the data log |
| `config remove <item>` | Remove a specified entry |
| `config search <term>` | Search entries by keyword (case-insensitive) |
| `config export` | Export all stored data to stdout |
| `config info` | Show version number and data directory path |
| `config help` | Show help with all available commands |
| `config version` | Show current version |

## Data Storage

- Default data directory: `~/.local/share/config/`
- Data log: `$DATA_DIR/data.log` — stores all added entries with timestamps
- History log: `$DATA_DIR/history.log` — timestamped record of every command executed
- Override the storage location by setting the `CONFIG_DIR` environment variable

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies, API keys, or network access required
- Fully offline and local — data never leaves your machine

## When to Use

1. **Bootstrapping a new project** — Run `init` to create the data directory and get a clean starting point for configuration tracking
2. **Logging configuration changes** — Use `add` to record timestamped configuration decisions, environment changes, or deployment notes
3. **Searching through config history** — Find specific entries with `search` to trace when a setting was last changed
4. **Exporting settings for backup** — Dump all stored entries with `export` and redirect to a file for version control or sharing
5. **Quick status checks in scripts** — Use `status` and `info` in automation pipelines to verify the tool is ready before proceeding

## Examples

```bash
# Initialize the config data directory
config init

# Record a configuration change
config add "Set DATABASE_URL to production endpoint"

# Record another entry
config add "Enabled rate limiting: 100 req/min"

# List all recorded entries
config list

# Search for entries related to a keyword
config search "database"

# Export all data to a backup file
config export > config-backup.txt

# Check system status
config status

# View version and storage location
config info
```

## How It Works

The tool maintains a simple date-stamped text log (`data.log`). Each `add` command appends a new line with the current date and your input. Every command execution is also logged to `history.log` for audit trails. The `search` command performs a case-insensitive grep, and `export` outputs the full data log to stdout.

## Tips

- Use `config config` to find where the config JSON file is stored — handy for automated backup
- Pipe `export` into other tools: `config export | wc -l` to count entries
- Combine with cron or CI/CD: log config drifts automatically with `config add "$(diff old new)"`
- Run `config help` at any time to see the complete command reference

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
