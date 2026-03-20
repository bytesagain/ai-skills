---
version: "2.0.0"
name: Bcc
description: "Trace Linux kernel events with BPF for I/O, networking, and CPU analysis. Use when profiling syscalls, diagnosing latency, or monitoring I/O."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Bcc

A multi-purpose command-line utility tool for logging, searching, and managing data entries. All data remains on disk in plain-text log files — no cloud, no external dependencies.

## Commands

| Command | Description |
|---------|-------------|
| `run <arg>` | Execute the main function — prints the argument and logs the action. |
| `config` | Show the config file path (`$DATA_DIR/config.json`) and log the action. |
| `status` | Print current status ("ready") and log the check. |
| `init` | Initialize the data directory — confirms creation at `$DATA_DIR`. |
| `list` | Print all entries from the main data log (`data.log`). Shows "(empty)" if no entries exist. |
| `add <text>` | Append a timestamped entry to the log. Format: `YYYY-MM-DD <text>`. |
| `remove <text>` | Mark an entry as removed and log the removal action. |
| `search <term>` | Case-insensitive search through all logged entries. Shows "Not found" if no matches. |
| `export` | Output the full data log to stdout. Pipe to a file for backups: `bcc export > backup.txt`. |
| `info` | Show version number and data directory path. |
| `help` | Show full usage information with all available commands. |
| `version` | Print version number (`v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/bcc/` by default:

- `data.log` — Main log file (one entry per line, date-prefixed via `add`)
- `history.log` — Command history with timestamps (auto-maintained by every command)
- `config.json` — Configuration file path (shown by `bcc config`)

Set the `BCC_DIR` environment variable to change the storage location. Alternatively, `XDG_DATA_HOME` is respected if `BCC_DIR` is not set.

## Requirements

- Bash 4+ (uses `local` variables, `set -euo pipefail`)
- Standard Unix utilities (`grep`, `date`, `wc`, `cat`)
- No external dependencies or API keys required

## When to Use

1. **Quick data logging from the terminal** — Use `bcc add` to record events, observations, or notes without leaving the shell.
2. **Maintaining a chronological activity log** — Every `add` creates a dated entry, building a time-ordered record of actions.
3. **Searching logged data by keyword** — Use `bcc search <term>` for case-insensitive matching across all stored entries.
4. **Exporting data for backup or analysis** — Use `bcc export > output.txt` to dump all entries for archival, sharing, or processing with other tools.
5. **Scripted workflow automation** — Use `run`, `init`, `config`, and `status` as building blocks in shell scripts and CI/CD pipelines.

## Examples

```bash
# Initialize the data directory
bcc init

# Add a log entry
bcc add "Deployed v2.3.1 to staging"

# Add another entry
bcc add "Fixed memory leak in worker process"

# List all entries
bcc list

# Search for entries about deployments
bcc search "deploy"

# Export all data to a backup file
bcc export > ~/bcc-backup.txt

# Check current status
bcc status

# View version and data directory
bcc info

# Show config file path
bcc config
```

## Output

All commands print results to stdout and log actions to `history.log`. The `add` command confirms each save with the added text. The `list` and `export` commands output raw log content suitable for piping and redirection.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
