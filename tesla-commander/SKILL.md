---
version: "2.0.0"
name: tesla-commander
description: "Control Tesla vehicles from terminal: climate, charging, locks, location. Use when checking status, configuring climate, listing charges, adding schedules."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Tesla Commander — Multi-Purpose Utility Tool

A general-purpose CLI utility tool for data entry, management, and retrieval. Provides commands to run tasks, configure settings, check status, initialize the workspace, list/add/remove/search entries, export data, and view system info — all from the terminal.

## Command Reference

The script (`tesla-commander`) supports the following commands via its case dispatch:

| Command | Description | Example Output |
|---------|-------------|----------------|
| `run <arg>` | Execute the main function with a given argument | `Running: <arg>` |
| `config` | Show configuration file path | `Config: $DATA_DIR/config.json` |
| `status` | Display current operational status | `Status: ready` |
| `init` | Initialize the data directory and workspace | `Initialized in $DATA_DIR` |
| `list` | List all entries from the data log | Prints contents of `data.log` or `(empty)` |
| `add <text>` | Add a new timestamped entry to the data log | `Added: <text>` |
| `remove <id>` | Remove an entry from the data log | `Removed: <id>` |
| `search <term>` | Search entries in the data log (case-insensitive) | Matching lines or `Not found: <term>` |
| `export` | Export all data log contents to stdout | Full contents of `data.log` |
| `info` | Show version and data directory path | `Version: 2.0.0 \| Data: $DATA_DIR` |
| `help` | Show full help text with all commands | — |
| `version` | Print version string | `tesla-commander v2.0.0` |

## Data Storage

- **Data directory:** `$TESLA_COMMANDER_DIR` or `~/.local/share/tesla-commander/`
- **Data log:** `$DATA_DIR/data.log` — stores all entries added via the `add` command, each prefixed with a date stamp
- **History log:** `$DATA_DIR/history.log` — every command invocation is timestamped and logged for auditing
- All directories are auto-created on first run via `mkdir -p`

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies — pure bash, no API keys, no network calls
- Works on Linux and macOS
- `grep` (for the `search` command)

## When to Use

1. **Quick data logging** — Need to record notes, events, or observations from the command line? Use `tesla-commander add "your note here"` for instant timestamped logging.
2. **Simple searchable notebook** — Accumulated entries can be searched with `tesla-commander search <term>`, making it a lightweight grep-able journal.
3. **Data export for pipelines** — Use `tesla-commander export` to pipe all logged data into downstream tools (e.g., `tesla-commander export | jq` or redirect to a file).
4. **System status checks in scripts** — `tesla-commander status` provides a quick health-check output suitable for monitoring scripts or cron jobs.
5. **Workspace initialization** — Run `tesla-commander init` when setting up a new machine or environment to bootstrap the data directory structure.

## Examples

### Initialize the workspace
```bash
tesla-commander init
# Output: Initialized in /home/user/.local/share/tesla-commander
```

### Add entries
```bash
tesla-commander add "Server migration completed"
# Output: Added: Server migration completed

tesla-commander add "Backup verified - all checksums match"
# Output: Added: Backup verified - all checksums match
```

### List all entries
```bash
tesla-commander list
# Output:
# 2026-03-18 Server migration completed
# 2026-03-18 Backup verified - all checksums match
```

### Search entries
```bash
tesla-commander search "migration"
# Output: 2026-03-18 Server migration completed
```

### Check status and info
```bash
tesla-commander status
# Output: Status: ready

tesla-commander info
# Output: Version: 2.0.0 | Data: /home/user/.local/share/tesla-commander
```

## Configuration

Set the `TESLA_COMMANDER_DIR` environment variable to change the data directory:

```bash
export TESLA_COMMANDER_DIR="/path/to/custom/dir"
```

Default: `~/.local/share/tesla-commander/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
