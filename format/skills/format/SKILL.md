---
name: format
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [format, tool, utility]
description: "Auto-format source code with language detection, presets, and diff preview. Use when formatting code, enforcing styles, or batch-formatting projects."
---

# Format

Developer toolkit for checking, validating, formatting, linting, converting, and managing code and text entries. All operations are logged with timestamps and stored locally for full traceability.

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `check` | `format check <input>` | Record a check entry or view recent checks |
| `validate` | `format validate <input>` | Record a validation entry or view recent validations |
| `generate` | `format generate <input>` | Record a generate entry or view recent generations |
| `format` | `format format <input>` | Record a format entry or view recent formatting operations |
| `lint` | `format lint <input>` | Record a lint entry or view recent lint results |
| `explain` | `format explain <input>` | Record an explain entry or view recent explanations |
| `convert` | `format convert <input>` | Record a convert entry or view recent conversions |
| `template` | `format template <input>` | Record a template entry or view recent templates |
| `diff` | `format diff <input>` | Record a diff entry or view recent diffs |
| `preview` | `format preview <input>` | Record a preview entry or view recent previews |
| `fix` | `format fix <input>` | Record a fix entry or view recent fixes |
| `report` | `format report <input>` | Record a report entry or view recent reports |
| `stats` | `format stats` | Show summary statistics across all entry types |
| `export <fmt>` | `format export json\|csv\|txt` | Export all entries to JSON, CSV, or plain text |
| `search <term>` | `format search <term>` | Search across all log files for a keyword |
| `recent` | `format recent` | Show the 20 most recent history entries |
| `status` | `format status` | Health check — version, entry count, disk usage, last activity |
| `help` | `format help` | Show help with all available commands |
| `version` | `format version` | Print version string |

Each command (check, validate, generate, format, lint, explain, convert, template, diff, preview, fix, report) works the same way:

- **With arguments:** Saves the input with a timestamp to `<command>.log` and logs to `history.log`.
- **Without arguments:** Displays the 20 most recent entries from `<command>.log`.

## Data Storage

All data is stored locally at `~/.local/share/format/`:

- `<command>.log` — Timestamped entries for each command (e.g., `check.log`, `lint.log`)
- `history.log` — Unified activity log across all commands
- `export.json`, `export.csv`, `export.txt` — Generated export files

No cloud, no network calls, no external API calls needed. Fully offline.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `du`, `grep`, `head`, `tail`)
- No external dependencies

## When to Use

1. **Logging code review notes** — Use `format check` or `format lint` to record issues found during code reviews, keeping a timestamped trail of findings.
2. **Tracking format and conversion tasks** — Use `format convert` and `format format` to log what was converted or reformatted, building an audit trail.
3. **Generating reports from logged data** — Use `format report` to record report items, then `format export json` to extract structured data for dashboards or further processing.
4. **Searching past operations** — Use `format search <term>` to find specific entries across all log files when you need to recall what was done previously.
5. **Monitoring toolkit health** — Use `format status` to verify the tool is operational, check disk usage, and see when the last activity occurred.

## Examples

```bash
# Record a check entry
format check "validate JSON schema for config.yaml"

# Record a lint finding
format lint "unused import in main.go line 42"

# View recent format operations (no args = list mode)
format format

# Convert and log the action
format convert "CSV to JSON for user_data.csv"

# Generate a diff note
format diff "comparison between v1.2 and v1.3 API responses"

# Search all logs for a keyword
format search "config"

# Export everything to JSON
format export json

# View summary statistics
format stats

# Health check
format status

# View recent activity
format recent
```

## How It Works

Format stores all data locally in `~/.local/share/format/`. Each command logs activity with timestamps in the format `YYYY-MM-DD HH:MM|<input>`, enabling full traceability. The unified `history.log` records every operation with `MM-DD HH:MM <command>: <input>` format for cross-command auditing.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
