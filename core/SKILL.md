---
version: "2.0.0"
name: Core
description: "AdonisJS is a TypeScript-first web framework for building web apps and API servers. It comes with su core, typescript, core, framework, mvc-framework."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Core

Multi-purpose utility tool for managing data entries, searching, exporting, and running general-purpose tasks from the command line.

## Commands

| Command   | Description                        |
|-----------|------------------------------------|
| `run`     | Execute the main function with given arguments |
| `config`  | View or edit configuration (stored in `config.json`) |
| `status`  | Show current status (ready / not ready) |
| `init`    | Initialize the data directory and setup |
| `list`    | List all entries from the data log |
| `add`     | Add a new timestamped entry to the data log |
| `remove`  | Remove an entry by identifier     |
| `search`  | Search entries by keyword (case-insensitive) |
| `export`  | Export all data log contents to stdout |
| `info`    | Show version and data directory info |
| `help`    | Show help and list all commands    |
| `version` | Print current version              |

## Usage

```bash
core <command> [args]
```

All actions are logged to `$DATA_DIR/history.log` for auditing.

## Data Storage

- **Default directory:** `~/.local/share/core/`
- **Override:** Set the `CORE_DIR` environment variable to change the data directory.
- **Files:**
  - `history.log` — timestamped log of every command executed
  - `data.log` — persistent data store for `add`, `list`, `search`, and `export` commands
  - `config.json` — configuration file (created by `config`)

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- `grep` (for the `search` command)
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **Tracking items or tasks** — Use `core add "buy groceries"` to log timestamped entries, then `core list` to review them all.
2. **Quick data lookups** — Run `core search "keyword"` to find entries matching a keyword across your data log.
3. **Exporting data for other tools** — Use `core export > data.csv` to pipe all stored data into a file for processing with other scripts.
4. **Running ad-hoc tasks** — Execute `core run "task-name"` for general-purpose task execution with automatic logging.
5. **Checking system readiness** — Run `core status` to verify the tool is initialized and ready, or `core info` to see version and directory details.

## Examples

```bash
# Initialize core in the default data directory
core init

# Add a new entry
core add "Deploy v2.1 to production"

# List all entries
core list

# Search for entries containing "deploy"
core search deploy

# Export all data
core export > backup.txt
```

```bash
# Run a task
core run "nightly-backup"

# Check status
core status

# View configuration
core config

# Show version and data directory info
core info

# Remove an entry
core remove "old-entry"
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
core list > entries.txt
core export > full-export.txt
```

## Configuration

Set `CORE_DIR` to customize where data is stored:

```bash
export CORE_DIR=/path/to/custom/dir
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
