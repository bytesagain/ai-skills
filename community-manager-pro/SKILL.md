---
version: "2.0.0"
name: Community Manager
description: "Build community strategies with engagement metrics and crisis playbooks. Use when scaling communities, tracking KPIs, handling crises."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Community Manager Pro

Multi-purpose utility tool for managing data entries, searching records, and exporting information — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `community-manager-pro run <input>` | Execute the main function with the given input |
| `community-manager-pro config` | Show configuration file path (`$DATA_DIR/config.json`) |
| `community-manager-pro status` | Display current system status |
| `community-manager-pro init` | Initialize the data directory and prepare for first use |
| `community-manager-pro list` | List all entries stored in the data log |
| `community-manager-pro add <item>` | Add a new timestamped entry to the data log |
| `community-manager-pro remove <item>` | Remove a specified entry |
| `community-manager-pro search <term>` | Search entries by keyword (case-insensitive) |
| `community-manager-pro export` | Export all stored data to stdout |
| `community-manager-pro info` | Show version number and data directory path |
| `community-manager-pro help` | Show help with all available commands |
| `community-manager-pro version` | Show current version |

## Data Storage

- Default data directory: `~/.local/share/community-manager-pro/`
- Data log: `$DATA_DIR/data.log` — stores all added entries with dates
- History log: `$DATA_DIR/history.log` — timestamped record of every command executed
- Override the storage location by setting the `COMMUNITY_MANAGER_PRO_DIR` environment variable

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies, API keys, or network access needed
- Fully offline and local — your data stays on your machine

## When to Use

1. **Quick data logging** — Capture notes, ideas, or action items from the terminal with timestamped entries using `add`
2. **Searching through records** — Find specific entries across your log with case-insensitive keyword search via `search`
3. **Exporting data for reports** — Dump all stored entries to stdout with `export` for piping to other tools or files
4. **Initializing a new project workspace** — Run `init` to set up the data directory and configuration for a fresh start
5. **Checking system readiness** — Use `status` and `info` to verify the tool is properly configured before scripting

## Examples

```bash
# Initialize the tool
community-manager-pro init

# Add a new entry
community-manager-pro add "Weekly community sync meeting notes"

# Add another entry
community-manager-pro add "New member onboarding checklist updated"

# List all stored entries
community-manager-pro list

# Search for entries containing a keyword
community-manager-pro search "meeting"

# Export all data
community-manager-pro export > backup.txt

# Check current status
community-manager-pro status

# View version and data location
community-manager-pro info
```

## How It Works

The tool maintains a simple date-stamped text log (`data.log`) where each `add` command appends a new line. Every command execution is also recorded in `history.log` for audit purposes. The `search` command performs case-insensitive grep across the data log, and `export` outputs the entire log contents.

## Tips

- Use `list` to review what you've logged before exporting
- Pipe `export` output to files or other tools: `community-manager-pro export | grep "keyword"`
- The `config` command shows where your config file lives — useful for backup scripts
- Run `community-manager-pro help` at any time to see all commands

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
