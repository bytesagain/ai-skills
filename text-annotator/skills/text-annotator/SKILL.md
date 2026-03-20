---
version: "1.0.0"
name: Doccano
description: "Open source annotation tool for machine learning practitioners. text-annotator, python, annotation-tool, data-labeling, dataset, datasets."
---

# Text Annotator

A versatile utility toolkit for recording, categorizing, and managing annotation data from the command line. Each command logs timestamped entries to its own dedicated log file, with built-in statistics, search, export, and health-check capabilities.

## Why Text Annotator?

- Works entirely offline — your data stays on your machine
- Each command type maintains its own log file for clean separation
- Built-in multi-format export (JSON, CSV, plain text)
- Full activity history with timestamped audit trail
- Search across all log files instantly
- Summary statistics with entry counts and disk usage

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `text-annotator run <input>` | Record a run entry (no args: show recent entries) |
| `text-annotator check <input>` | Record a check entry (no args: show recent entries) |
| `text-annotator convert <input>` | Record a convert entry (no args: show recent entries) |
| `text-annotator analyze <input>` | Record an analyze entry (no args: show recent entries) |
| `text-annotator generate <input>` | Record a generate entry (no args: show recent entries) |
| `text-annotator preview <input>` | Record a preview entry (no args: show recent entries) |
| `text-annotator batch <input>` | Record a batch entry (no args: show recent entries) |
| `text-annotator compare <input>` | Record a compare entry (no args: show recent entries) |
| `text-annotator export <input>` | Record an export entry (no args: show recent entries) |
| `text-annotator config <input>` | Record a config entry (no args: show recent entries) |
| `text-annotator status <input>` | Record a status entry (no args: show recent entries) |
| `text-annotator report <input>` | Record a report entry (no args: show recent entries) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `text-annotator stats` | Show summary statistics (entry counts per type, total, disk usage) |
| `text-annotator export <fmt>` | Export all data in json, csv, or txt format |
| `text-annotator search <term>` | Search across all log files (case-insensitive) |
| `text-annotator recent` | Show the 20 most recent activity log entries |
| `text-annotator status` | Health check (version, entries, disk, last activity) |
| `text-annotator help` | Display all available commands |
| `text-annotator version` | Print version string |

Each core command works in two modes:
- **With arguments**: Saves a timestamped entry to `<command>.log` and logs to `history.log`
- **Without arguments**: Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/text-annotator/` (override with `TEXT_ANNOTATOR_DIR`). The directory contains:

- **`run.log`**, **`check.log`**, **`convert.log`**, etc. — One log file per command type, storing `YYYY-MM-DD HH:MM|input` entries
- **`history.log`** — Unified activity log with timestamped records of every command executed
- **`export.json`** / **`export.csv`** / **`export.txt`** — Generated export files

## Requirements

- **Bash** 4.0+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `grep`, `cat`, `tail`, `wc`, `du`, `date`, `sed`
- No external dependencies or network access required

## When to Use

1. **Annotating text samples** — Use `text-annotator run "sample: positive sentiment"` to log annotation decisions with timestamps
2. **Batch processing annotations** — Record bulk operations with `text-annotator batch "processed 500 samples from dataset-v3"`
3. **Comparing annotation results** — Track comparison notes with `text-annotator compare "model-A vs model-B: 94% agreement"`
4. **Generating annotation reports** — Use `text-annotator report` to log report milestones, then `text-annotator stats` for summary data
5. **Exporting labeled data** — Run `text-annotator export json` to export all logged entries across all command types in structured JSON

## Examples

```bash
# Record annotation activities
text-annotator run "labeled 50 sentences for NER"
text-annotator analyze "sentiment distribution: 60% pos, 25% neg, 15% neutral"
text-annotator check "inter-annotator agreement: 0.87 kappa"

# Batch processing log
text-annotator batch "imported dataset-v2: 10,000 samples"
text-annotator convert "exported NER tags to CoNLL format"

# Search and review
text-annotator search "sentiment"
text-annotator recent

# Export all data
text-annotator export json
text-annotator export csv

# View statistics and health
text-annotator stats
text-annotator status
```

## Configuration

Set the `TEXT_ANNOTATOR_DIR` environment variable to change the data directory:

```bash
export TEXT_ANNOTATOR_DIR="$HOME/my-annotations"
```

Default location: `~/.local/share/text-annotator/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
