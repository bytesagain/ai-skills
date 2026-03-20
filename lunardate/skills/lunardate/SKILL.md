---
version: "1.0.0"
name: Chinese Calendar
description: "Look up Chinese lunar dates, zodiac signs, festivals, and daily auspiciousness. Use when converting dates, checking festivals, looking up zodiac years."
---

# Lunardate

Lunardate v2.0.0 — a utility toolkit for managing date-related data including conversions, analysis, generation, and batch processing. Track and record various date operations with timestamped entries stored locally.

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
| `version` | Show version string (`lunardate v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/lunardate/`:

- Each command type writes to its own `.log` file (e.g., `run.log`, `convert.log`, `analyze.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|<value>` format
- A unified `history.log` tracks all actions across command types
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies — works out of the box on Linux and macOS

## When to Use

1. **Date conversion tracking** — record date conversion operations (e.g., Gregorian to lunar calendar) with `convert` and review them later
2. **Batch date processing** — log batch operations when processing multiple dates at once for festivals, holidays, or scheduling
3. **Date analysis and comparison** — use `analyze` and `compare` to record analysis results and track date-related comparisons over time
4. **Report generation** — record report entries and export accumulated data to JSON, CSV, or TXT for sharing or archival
5. **Configuration management** — use `config` to track configuration changes and `status` to monitor the health of your date data store

## Examples

```bash
# Record a date conversion
lunardate convert "2025-01-29 -> Lunar: Year of Snake, Month 1, Day 1"

# Log a batch operation
lunardate batch "Processed 365 dates for 2025 festival calendar"

# Analyze a date range
lunardate analyze "Q1 2025: 3 major festivals, 12 auspicious dates"

# Search for entries related to a specific term
lunardate search "festival"

# View summary statistics across all categories
lunardate stats

# Show recent activity
lunardate recent
```

## Output

All commands print results to stdout. Each recording command confirms the save and shows the total entry count for that category. Redirect output to a file with:

```bash
lunardate stats > summary.txt
```

## Configuration

Set the `DATA_DIR` inside the script or modify the default path `~/.local/share/lunardate/` to change where data is stored.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
