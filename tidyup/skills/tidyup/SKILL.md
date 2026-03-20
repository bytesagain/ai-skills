---
name: TidyUp
description: "Find duplicates, reclaim disk space, and clean storage. Use when scanning dupes, checking usage, running cleanup, analyzing age, generating reports."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["files","organize","cleanup","disk","duplicates","sort","storage","utility"]
categories: ["Utility", "System Tools", "Productivity"]
---

# TidyUp

A versatile utility toolkit for recording, tracking, and managing cleanup and disk maintenance tasks from the command line. Each command logs timestamped entries to its own dedicated log file, with built-in statistics, multi-format export, search, and health-check capabilities.

## Why TidyUp?

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
| `tidyup run <input>` | Record a run entry (no args: show recent entries) |
| `tidyup check <input>` | Record a check entry (no args: show recent entries) |
| `tidyup convert <input>` | Record a convert entry (no args: show recent entries) |
| `tidyup analyze <input>` | Record an analyze entry (no args: show recent entries) |
| `tidyup generate <input>` | Record a generate entry (no args: show recent entries) |
| `tidyup preview <input>` | Record a preview entry (no args: show recent entries) |
| `tidyup batch <input>` | Record a batch entry (no args: show recent entries) |
| `tidyup compare <input>` | Record a compare entry (no args: show recent entries) |
| `tidyup export <input>` | Record an export entry (no args: show recent entries) |
| `tidyup config <input>` | Record a config entry (no args: show recent entries) |
| `tidyup status <input>` | Record a status entry (no args: show recent entries) |
| `tidyup report <input>` | Record a report entry (no args: show recent entries) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `tidyup stats` | Show summary statistics (entry counts per type, total, disk usage) |
| `tidyup export <fmt>` | Export all data in json, csv, or txt format |
| `tidyup search <term>` | Search across all log files (case-insensitive) |
| `tidyup recent` | Show the 20 most recent activity log entries |
| `tidyup status` | Health check (version, entries, disk, last activity) |
| `tidyup help` | Display all available commands |
| `tidyup version` | Print version string |

Each core command works in two modes:
- **With arguments**: Saves a timestamped entry to `<command>.log` and logs to `history.log`
- **Without arguments**: Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/tidyup/`. The directory contains:

- **`run.log`**, **`check.log`**, **`convert.log`**, **`analyze.log`**, etc. — One log file per command type, storing `YYYY-MM-DD HH:MM|input` entries
- **`history.log`** — Unified activity log with timestamped records of every command executed
- **`export.json`** / **`export.csv`** / **`export.txt`** — Generated export files

## Requirements

- **Bash** 4.0+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `grep`, `cat`, `tail`, `wc`, `du`, `date`, `sed`
- No external dependencies or network access required

## When to Use

1. **Tracking disk cleanup runs** — Use `tidyup run "cleaned ~/Downloads: removed 2.1GB temp files"` to log cleanup activities with timestamps
2. **Checking for duplicates** — Record duplicate scan results with `tidyup check "scanned Documents: found 34 duplicate files (890MB)"`
3. **Analyzing storage usage** — Log analysis with `tidyup analyze "home dir: 120GB used, largest: node_modules 15GB"` and review with `tidyup search "node_modules"`
4. **Batch cleanup operations** — Track batch processing with `tidyup batch "purged .DS_Store and Thumbs.db from all project dirs"` and review past batches
5. **Generating cleanup reports** — Use `tidyup report "weekly cleanup: freed 8.5GB across 3 drives"` then `tidyup export csv` for tracking trends

## Examples

```bash
# Record cleanup activities
tidyup run "removed stale Docker images: freed 4.2GB"
tidyup check "verified backup integrity before cleanup"
tidyup analyze "disk usage breakdown: 40% media, 30% code, 30% docs"

# Track conversions and batch operations
tidyup convert "compressed 500 PNGs to WebP: saved 2.1GB"
tidyup batch "deleted all .log files older than 90 days"
tidyup generate "created cleanup script for CI artifacts"

# Preview and compare
tidyup preview "dry-run: 150 files to archive, 2.3GB to free"
tidyup compare "before/after: 120GB → 95GB (25GB freed)"

# Search, review, and export
tidyup search "Docker"
tidyup recent
tidyup stats
tidyup export json
tidyup export csv

# Configuration and reporting
tidyup config "retention policy: 90 days"
tidyup report "monthly summary: 45GB reclaimed this month"
tidyup status
```

## Configuration

The data directory defaults to `~/.local/share/tidyup/`. All log files are plain text with pipe-delimited fields (`timestamp|value`), making them easy to parse with standard Unix tools or import into spreadsheets.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
