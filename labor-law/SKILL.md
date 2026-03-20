---
version: "2.0.0"
name: labor-law
description: "Query Chinese labor law on overtime, leave, contracts, and severance rules. Use when checking overtime rules, calculating severance, reviewing contracts."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Labor Law

A multi-purpose utility tool for managing data entries from the command line. Run tasks, manage configurations, track items, search entries, and export data — with full activity logging and history.

## Commands

| Command | Description |
|---------|-------------|
| `labor-law run <args>` | Execute the main function with given arguments |
| `labor-law config` | Show the configuration file path (`$DATA_DIR/config.json`) |
| `labor-law status` | Display current status (ready/not ready) |
| `labor-law init` | Initialize the data directory |
| `labor-law list` | List all entries in the data log |
| `labor-law add <entry>` | Add a new timestamped entry to the data log |
| `labor-law remove <entry>` | Remove a specified entry |
| `labor-law search <term>` | Search entries in the data log (case-insensitive) |
| `labor-law export` | Export all data from the data log to stdout |
| `labor-law info` | Show version number and data directory path |
| `labor-law help` | Show the built-in help message |
| `labor-law version` | Print the current version |

## Data Storage

All data is stored in `$DATA_DIR/data.log` as plain text with date-prefixed entries. Activity history is logged to `$DATA_DIR/history.log` with timestamps. The default data directory is `~/.local/share/labor-law/`. Override it by setting the `LABOR_LAW_DIR` environment variable, or it will respect `XDG_DATA_HOME` if set.

## Requirements

- Bash 4+ with standard Unix utilities (`date`, `grep`, `cat`)
- No external dependencies or API keys required
- Works on any Linux/macOS terminal

## When to Use

1. **Quick data tracking** — Use `labor-law add <entry>` to log items with automatic timestamps, then `labor-law list` to review everything you've recorded.
2. **Searching past entries** — Run `labor-law search <term>` to find specific entries in your data log using case-insensitive matching.
3. **Initializing a new workspace** — Use `labor-law init` to set up the data directory, then `labor-law config` to verify the configuration path.
4. **Checking system readiness** — Run `labor-law status` for a quick confirmation that the tool is ready and operational.
5. **Exporting data for external use** — Use `labor-law export` to dump all logged data to stdout, which you can redirect to a file or pipe to another tool.

## Examples

```bash
# Initialize the data directory
labor-law init

# Add entries to the data log
labor-law add "Review employment contract for new hire"
labor-law add "Check overtime policy compliance"
labor-law add "Prepare severance calculation"

# List all entries
labor-law list

# Search for specific entries
labor-law search "overtime"

# Check status
labor-law status

# View configuration path
labor-law config

# Show version and data directory
labor-law info

# Export all data
labor-law export > backup.txt

# Run a task
labor-law run "quarterly review"

# Remove an entry
labor-law remove "old item"
```

## How It Works

Labor Law stores all entries locally in `~/.local/share/labor-law/data.log`. Each `add` command prepends the current date to the entry. Every command invocation is logged to `history.log` with a timestamp for full audit traceability. No data leaves your machine — everything is stored locally in plain text files.

## Configuration

Set `LABOR_LAW_DIR` to change the data directory:

```bash
export LABOR_LAW_DIR=/custom/path
```

Default: `~/.local/share/labor-law/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
