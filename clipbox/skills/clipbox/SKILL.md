---
name: ClipBox
description: "Save and organize reusable text snippets for quick retrieval. Use when storing code fragments, saving command templates, or building snippet libraries."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["clipboard","snippets","text","paste","templates","productivity","developer"]
categories: ["Productivity", "Developer Tools", "Utility"]
---

# ClipBox

Developer toolkit for logging, tracking, and exporting entries across multiple categories. Each command records timestamped entries to its own log file. Call without arguments to view recent entries; call with arguments to record a new entry.

## Commands

| Command | What it does |
|---------|-------------|
| `clipbox check <input>` | Record a check entry (no args = show recent) |
| `clipbox validate <input>` | Record a validate entry (no args = show recent) |
| `clipbox generate <input>` | Record a generate entry (no args = show recent) |
| `clipbox format <input>` | Record a format entry (no args = show recent) |
| `clipbox lint <input>` | Record a lint entry (no args = show recent) |
| `clipbox explain <input>` | Record an explain entry (no args = show recent) |
| `clipbox convert <input>` | Record a convert entry (no args = show recent) |
| `clipbox template <input>` | Record a template entry (no args = show recent) |
| `clipbox diff <input>` | Record a diff entry (no args = show recent) |
| `clipbox preview <input>` | Record a preview entry (no args = show recent) |
| `clipbox fix <input>` | Record a fix entry (no args = show recent) |
| `clipbox report <input>` | Record a report entry (no args = show recent) |
| `clipbox stats` | Show summary statistics across all log files |
| `clipbox export <fmt>` | Export all data to json, csv, or txt format |
| `clipbox search <term>` | Search all log entries for a keyword |
| `clipbox recent` | Show the 20 most recent history entries |
| `clipbox status` | Health check — version, entry count, disk usage, last activity |
| `clipbox help` | Show help message |
| `clipbox version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/clipbox/`. Each command writes to its own `.log` file (e.g., `check.log`, `lint.log`). A unified `history.log` tracks all activity with timestamps.

## Requirements

- Bash 4+
- Standard Unix utilities (`wc`, `du`, `tail`, `grep`, `date`, `sed`)

## When to Use

- Logging code checks, lint results, or validation outcomes with timestamps
- Tracking format conversions, diffs, and template usage over time
- Searching historical entries by keyword across all categories
- Exporting accumulated data to JSON, CSV, or plain text for review
- Getting a quick status overview of entry counts and disk usage

## Examples

```bash
# Record a lint finding
clipbox lint "unused variable 'count' in main.py line 42"

# Record a template usage
clipbox template "created new React component from base template"

# Search all logs for "main.py"
clipbox search main.py

# Export everything to JSON
clipbox export json

# View overall stats
clipbox stats

# Check health status
clipbox status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
