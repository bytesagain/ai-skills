---
version: "1.0.0"
name: Mac Cli
description: " macOS command line tool for developers – The ultimate tool to manage your Mac. It provides a huge mac cli, shell, bash, cli, command-line-tool, linux."
---

# macOS Toolkit

Macos Toolkit v2.0.0 — a utility toolkit for managing, analyzing, converting, and processing data from the command line. Supports run, check, convert, analyze, generate, preview, batch, compare, export, config, status, and report operations — all tracked with timestamped entries stored locally.

## Commands

Run `scripts/script.sh <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `run <input>` | Record a run entry. Without args, shows the 20 most recent run entries. |
| `check <input>` | Record a check entry. Without args, shows recent check entries. |
| `convert <input>` | Record a conversion entry. Without args, shows recent convert entries. |
| `analyze <input>` | Record an analysis entry. Without args, shows recent analyze entries. |
| `generate <input>` | Record a generation entry. Without args, shows recent generate entries. |
| `preview <input>` | Record a preview entry. Without args, shows recent preview entries. |
| `batch <input>` | Record a batch processing entry. Without args, shows recent batch entries. |
| `compare <input>` | Record a comparison entry. Without args, shows recent compare entries. |
| `export <input>` | Record an export entry. Without args, shows recent export entries. |
| `config <input>` | Record a configuration entry. Without args, shows recent config entries. |
| `status <input>` | Record a status entry. Without args, shows recent status entries. |
| `report <input>` | Record a report entry. Without args, shows recent report entries. |
| `stats` | Show summary statistics across all entry types (counts, data size). |
| `search <term>` | Search all log files for a term (case-insensitive). |
| `recent` | Show the 20 most recent entries from the activity history. |
| `help` | Show help message with all available commands. |
| `version` | Show version string (`macos-toolkit v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/macos-toolkit/`:

- Each command type writes to its own `.log` file (e.g., `run.log`, `check.log`, `convert.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|<value>` format
- A unified `history.log` tracks all actions across command types
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies — works out of the box on Linux and macOS

## When to Use

1. **System checks and diagnostics** — use `check` and `analyze` to record system health checks, diagnostic results, and analysis findings on your Mac
2. **File conversion tracking** — log `convert` operations when batch-converting file formats, encoding, or data transformations
3. **Configuration management** — use `config` to track system configuration changes and `status` to record current system states for auditing
4. **Batch processing workflows** — record `batch` and `generate` entries to document automated processing pipelines and their outputs
5. **Reporting and export** — use `report` to log generated reports and export accumulated data to JSON, CSV, or TXT for sharing or archival

## Examples

```bash
# Record a system check
macos-toolkit check "Homebrew packages up to date, 142 installed"

# Log a file conversion operation
macos-toolkit convert "Converted 50 HEIC photos to JPEG format"

# Analyze disk usage
macos-toolkit analyze "SSD: 234GB used / 500GB total, 47% capacity"

# Record a batch operation
macos-toolkit batch "Resized 200 images to 1080p for web deployment"

# Search across all entries
macos-toolkit search "disk"

# Export all data as JSON
macos-toolkit export json

# View summary statistics
macos-toolkit stats
```

## Output

All commands print results to stdout. Each recording command confirms the save and shows the total entry count for that category. Redirect output to a file with:

```bash
macos-toolkit stats > report.txt
```

## Configuration

Set the `DATA_DIR` inside the script or modify the default path `~/.local/share/macos-toolkit/` to change where data is stored.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
