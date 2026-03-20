---
version: "2.0.0"
name: Autohotkey
description: "AutoHotkey - macro-creation and automation-oriented scripting utility for Windows. autohotkey, c++, autohotkey, automation, c-plus-plus, hotkeys."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Autohotkey

A multi-purpose utility tool for managing data entries, tracking records, and organizing information. Autohotkey provides a lightweight CLI interface with persistent local storage for adding, searching, listing, and exporting structured data.

## Commands

| Command   | Description                                      |
|-----------|--------------------------------------------------|
| `run`     | Execute the main function with provided arguments |
| `config`  | Show or manage configuration settings             |
| `status`  | Display current system status                     |
| `init`    | Initialize the data directory and config files    |
| `list`    | List all stored entries from the data log         |
| `add`     | Add a new dated entry to the data log             |
| `remove`  | Remove a specified entry                          |
| `search`  | Search entries by keyword (case-insensitive)      |
| `export`  | Export all data from the data log to stdout       |
| `info`    | Show version and data directory information       |
| `help`    | Show the help message with all available commands |
| `version` | Print the current version number                  |

## Data Storage

- **Data directory:** `~/.local/share/autohotkey/` (override with `AUTOHOTKEY_DIR` env variable)
- **Data log:** `$DATA_DIR/data.log` — stores all entries added via `add`
- **History log:** `$DATA_DIR/history.log` — tracks all command executions with timestamps
- **Config:** `$DATA_DIR/config.json` — configuration file managed via `config`

## Requirements

- Bash 4.0+
- Standard Unix utilities (`grep`, `cat`, `date`)
- No API keys or external services needed
- Works on Linux and macOS

## When to Use

1. **Quick data logging** — When you need a simple way to record timestamped entries without setting up a database
2. **Record searching** — When you want to find specific entries in your data log using case-insensitive keyword search
3. **Data export** — When you need to dump all stored records to stdout or pipe them to another tool for processing
4. **System initialization** — When setting up a new workspace and need to create the local data directory structure
5. **Entry management** — When you need to add or remove individual records from your persistent data store

## Examples

```bash
# Initialize the data directory
autohotkey init

# Add a new entry to the data log
autohotkey add "Keyboard shortcut Ctrl+Shift+A mapped to screenshot"

# Add another entry
autohotkey add "Macro for auto-fill form fields configured"

# List all stored entries
autohotkey list

# Search for entries containing "macro"
autohotkey search macro

# Export all data to a file
autohotkey export > backup.txt

# Check current status
autohotkey status

# Show version and data path
autohotkey info

# View or update configuration
autohotkey config

# Remove an entry
autohotkey remove "old-entry"

# Execute a function
autohotkey run "task-name"
```

## Output

All command results are printed to stdout. You can redirect output with standard shell operators:

```bash
autohotkey list > all-entries.txt
autohotkey export | grep "2025"
autohotkey search shortcut > results.txt
```

## Configuration

Set the `AUTOHOTKEY_DIR` environment variable to change the data directory:

```bash
export AUTOHOTKEY_DIR="/custom/path/to/autohotkey"
```

Default location: `~/.local/share/autohotkey/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
