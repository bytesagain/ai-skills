---
version: "2.0.0"
name: Cc Switch
description: "A cross-platform desktop All-in-One assistant tool for Claude Code, Codex, OpenCode, openclaw & Gemi cc switch, rust, ai-tools, claude-code, codex."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# CC Switch

CC Switch is a multi-purpose utility tool for managing entries, configuration, and data from the terminal. It provides a log-based system for adding, listing, searching, and exporting data with full command history tracking.

## Commands

| Command | Description |
|---------|-------------|
| `cc-switch run <args>` | Execute the main function with given arguments |
| `cc-switch config` | Show configuration file location (`config.json`) |
| `cc-switch status` | Show current status (ready/not ready) |
| `cc-switch init` | Initialize the data directory |
| `cc-switch list` | List all entries in the data log |
| `cc-switch add <entry>` | Add a new dated entry to the data log |
| `cc-switch remove <entry>` | Remove an entry |
| `cc-switch search <term>` | Search entries with case-insensitive matching |
| `cc-switch export` | Export all data to stdout |
| `cc-switch info` | Show version and data directory path |
| `cc-switch help` | Show all available commands |
| `cc-switch version` | Show version number |

## How It Works

CC Switch uses a flat-file data model. Entries are stored in `data.log` as dated lines (`YYYY-MM-DD <content>`). Every command also appends a timestamped record to `history.log` for auditing purposes.

- `add` appends a new line prefixed with today's date
- `list` prints the full data log contents
- `search` performs case-insensitive matching via `grep`
- `export` dumps the raw data log to stdout for piping or redirection
- `init` ensures the data directory exists and is ready
- `config` points you to the `config.json` file location

## Data Storage

All data is stored locally in `~/.local/share/cc-switch/` by default:

- `data.log` — Main data file with all entries (one per line, date-prefixed)
- `history.log` — Timestamped audit trail of every command executed
- `config.json` — Configuration file (referenced by `cc-switch config`)

Override the storage location by setting the `CC_SWITCH_DIR` environment variable:

```bash
export CC_SWITCH_DIR="$HOME/my-data/cc-switch"
```

Alternatively, `XDG_DATA_HOME` is respected if `CC_SWITCH_DIR` is not set.

## Requirements

- **bash 4+** (uses `set -euo pipefail` for strict mode)
- Standard Unix tools (`grep`, `date`, `cat`)
- No API keys needed
- No external dependencies

## When to Use

1. **Tracking tool configurations** — Use `cc-switch add` to log configuration changes, tool switches, or environment notes with automatic date stamps
2. **Managing a quick data log** — Run `cc-switch list` to review entries, or `cc-switch search` to find specific items
3. **Exporting records** — Use `cc-switch export > data.txt` to dump all entries for backup or import into other systems
4. **Setting up on a new machine** — Run `cc-switch init` to prepare the data directory, then `cc-switch config` to check configuration
5. **Auditing tool usage** — Check `cc-switch status` and `cc-switch info` to verify readiness, then review `history.log` for a full activity audit trail

## Examples

```bash
# Initialize the data directory
cc-switch init

# Add entries to track tool switches
cc-switch add "Switched to Claude Code for refactoring task"
cc-switch add "Using Codex for documentation generation"
cc-switch add "OpenCode for quick prototyping session"

# List all entries
cc-switch list
```

```bash
# Search for specific entries
cc-switch search claude
cc-switch search codex

# Export everything for backup
cc-switch export > tool-log-backup.txt

# Check status and info
cc-switch status
cc-switch info
```

```bash
# Run a custom operation
cc-switch run sync-preferences

# View configuration location
cc-switch config

# Remove an old entry
cc-switch remove "outdated entry"

# Show version
cc-switch version
```

## Output

All command output goes to stdout. The history log is always written to `$DATA_DIR/history.log`. Redirect output as needed:

```bash
cc-switch list > all-entries.txt
cc-switch export | grep "claude" > claude-sessions.txt
```

## Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `CC_SWITCH_DIR` | Override data/config directory | `~/.local/share/cc-switch/` |
| `XDG_DATA_HOME` | Fallback base directory | `~/.local/share/` |

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
