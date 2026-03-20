---
version: "1.0.0"
name: tidyfiles
description: "Sort and organize files into folders by type, date, or rules. Use when decluttering dirs, checking structure, running cleanup, generating reports."
---

# Tidyfiles

A versatile utility toolkit for recording, tracking, and managing file organization tasks from the command line. Each command logs timestamped entries to its own dedicated log file, with built-in statistics, multi-format export, search, and health-check capabilities.

## Why Tidyfiles?

- Works entirely offline — your data stays on your machine
- Each command type maintains its own log file for clean data separation
- Built-in multi-format export (JSON, CSV, plain text)
- Full activity history with timestamped audit trail
- Search across all log files instantly
- Summary statistics with entry counts and disk usage
- Zero external dependencies — pure bash

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `tidyfiles run <input>` | Record a run entry (no args: show recent entries) |
| `tidyfiles check <input>` | Record a check entry (no args: show recent entries) |
| `tidyfiles convert <input>` | Record a convert entry (no args: show recent entries) |
| `tidyfiles analyze <input>` | Record an analyze entry (no args: show recent entries) |
| `tidyfiles generate <input>` | Record a generate entry (no args: show recent entries) |
| `tidyfiles preview <input>` | Record a preview entry (no args: show recent entries) |
| `tidyfiles batch <input>` | Record a batch entry (no args: show recent entries) |
| `tidyfiles compare <input>` | Record a compare entry (no args: show recent entries) |
| `tidyfiles export <input>` | Record an export entry (no args: show recent entries) |
| `tidyfiles config <input>` | Record a config entry (no args: show recent entries) |
| `tidyfiles status <input>` | Record a status entry (no args: show recent entries) |
| `tidyfiles report <input>` | Record a report entry (no args: show recent entries) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `tidyfiles stats` | Show summary statistics (entry counts per type, total, disk usage) |
| `tidyfiles export <fmt>` | Export all data in json, csv, or txt format |
| `tidyfiles search <term>` | Search across all log files (case-insensitive) |
| `tidyfiles recent` | Show the 20 most recent activity log entries |
| `tidyfiles status` | Health check (version, entries, disk, last activity) |
| `tidyfiles help` | Display all available commands |
| `tidyfiles version` | Print version string |

Each core command works in two modes:
- **With arguments**: Saves a timestamped entry to `<command>.log` and logs to `history.log`
- **Without arguments**: Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/tidyfiles/`. The directory contains:

- **`run.log`**, **`check.log`**, **`convert.log`**, **`analyze.log`**, etc. — One log file per command type, storing `YYYY-MM-DD HH:MM|input` entries
- **`history.log`** — Unified activity log with timestamped records of every command executed
- **`export.json`** / **`export.csv`** / **`export.txt`** — Generated export files

## Requirements

- **Bash** 4.0+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `grep`, `cat`, `tail`, `wc`, `du`, `date`, `sed`
- No external dependencies or network access required

## When to Use

1. **Tracking file organization tasks** — Use `tidyfiles run "sorted ~/Downloads by file type"` to log cleanup activities with timestamps
2. **Checking directory structure** — Record structure checks with `tidyfiles check "~/projects: 45 dirs, 230 files, no empty dirs"`
3. **Analyzing disk usage patterns** — Log analysis results with `tidyfiles analyze "Documents folder: 12GB, 40% PDFs"` and review with `tidyfiles search "Documents"`
4. **Batch file operations** — Track batch processing with `tidyfiles batch "renamed 150 photos with date prefix"` and review past batches
5. **Generating cleanup reports** — Use `tidyfiles report "weekly cleanup: freed 3.2GB"` then `tidyfiles export csv` for spreadsheet analysis

## Examples

```bash
# Record file organization activities
tidyfiles run "organized Downloads into subfolders"
tidyfiles check "verified backup integrity: 100% match"
tidyfiles analyze "home directory: 85GB used, 15GB free"

# Track conversions and batch operations
tidyfiles convert "batch converted 200 PNGs to WebP"
tidyfiles batch "moved archived projects to cold storage"
tidyfiles generate "created folder structure for new project"

# Preview and compare
tidyfiles preview "dry-run sort of ~/Desktop: 45 files to move"
tidyfiles compare "before/after cleanup: 12GB freed"

# Search, review, and export
tidyfiles search "backup"
tidyfiles recent
tidyfiles stats
tidyfiles export json
tidyfiles export csv

# Configuration and reporting
tidyfiles config "default sort: by extension"
tidyfiles report "monthly cleanup summary: 25GB reclaimed"
tidyfiles status
```

## Configuration

The data directory defaults to `~/.local/share/tidyfiles/`. All log files are plain text with pipe-delimited fields (`timestamp|value`), making them easy to parse with standard Unix tools or import into spreadsheets.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
