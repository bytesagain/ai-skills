---
name: Dev Setup
description: "Set up macOS dev environments with automated install scripts for tools. Use when provisioning Macs, installing dev tools, configuring shells."
version: "1.0.0"
license: NOASSERTION
runtime: python3
---

# Dev Setup

Dev Setup v2.0.0 — a utility toolkit for logging, tracking, and managing development setup entries from the command line.

## Commands

All commands accept optional input arguments. Without arguments, they display recent entries from the corresponding log. With arguments, they record a new timestamped entry.

| Command | Description |
|---------|-------------|
| `run <input>` | Record or view run entries |
| `check <input>` | Record or view check entries |
| `convert <input>` | Record or view convert entries |
| `analyze <input>` | Record or view analyze entries |
| `generate <input>` | Record or view generate entries |
| `preview <input>` | Record or view preview entries |
| `batch <input>` | Record or view batch entries |
| `compare <input>` | Record or view compare entries |
| `export <input>` | Record or view export entries |
| `config <input>` | Record or view config entries |
| `status <input>` | Record or view status entries |
| `report <input>` | Record or view report entries |
| `stats` | Show summary statistics across all log files |
| `search <term>` | Search all log entries for a keyword (case-insensitive) |
| `recent` | Display the 20 most recent history log entries |
| `help` | Show usage information |
| `version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/dev-setup/`:

- **Per-command logs** — Each command (run, check, convert, etc.) writes to its own `.log` file with pipe-delimited `timestamp|value` format.
- **history.log** — A unified activity log recording every write operation with timestamps.
- **Export formats** — The `export` utility function supports JSON, CSV, and TXT output, written to `~/.local/share/dev-setup/export.<fmt>`.

No external services, databases, or API keys are required. Everything is flat-file and human-readable.

## Requirements

- **Bash** (v4+ recommended)
- No external dependencies — uses only standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`)

## When to Use

- When you need to log and track development setup activities on macOS
- To maintain a searchable history of tool installations and configurations
- For batch recording of setup tasks with timestamps
- When you want to export setup logs in JSON, CSV, or TXT format
- As part of a larger provisioning or onboarding automation pipeline
- To get quick statistics and summaries of past setup activities

## Examples

```bash
# Record a new run entry
dev-setup run "installed Homebrew and Xcode CLI tools"

# View recent run entries (no args = show history)
dev-setup run

# Check something and log it
dev-setup check "Vim plugins installed via vim-plug"

# Analyze and record
dev-setup analyze "iTerm2 config imported from dotfiles"

# Configure and record
dev-setup config "set default shell to zsh"

# Generate a record
dev-setup generate "shell profile backup"

# Search across all logs
dev-setup search "homebrew"

# View summary statistics
dev-setup stats

# Show recent activity across all commands
dev-setup recent

# Show tool version
dev-setup version

# Show full help
dev-setup help
```

## How It Works

Each command follows the same pattern:
1. **With arguments** — Timestamps the input, appends it to the command-specific log file, prints confirmation, and logs to `history.log`.
2. **Without arguments** — Shows the last 20 entries from that command's log file.

The `stats` command iterates all `.log` files, counts entries per file, and reports totals plus disk usage. The `search` command performs case-insensitive grep across all log files. The `recent` command tails the last 20 lines of `history.log`.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
