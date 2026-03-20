---
name: DupFinder
description: "Scan directories for duplicate files by hash to reclaim disk space. Use when finding duplicates, reclaiming space, comparing checksums."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["duplicate","finder","files","cleanup","storage","hash","disk","dedup"]
categories: ["System Tools", "Utility"]
---
# DupFinder

Utility toolkit for running checks, converting data, analyzing content, generating reports, previewing results, and batch-processing entries. A general-purpose CLI for logging structured operations and exporting collected data.

## Commands

| Command | Description |
|---------|-------------|
| `dupfinder run <input>` | Execute the main function and log the input |
| `dupfinder check <input>` | Run a check and record the result |
| `dupfinder convert <input>` | Log a data conversion operation |
| `dupfinder analyze <input>` | Record an analysis result |
| `dupfinder generate <input>` | Log a generated output or asset |
| `dupfinder preview <input>` | Record a preview observation |
| `dupfinder batch <input>` | Log a batch processing operation |
| `dupfinder compare <input>` | Record a comparison between items |
| `dupfinder export <input>` | Log an export operation |
| `dupfinder config <input>` | Record a configuration change |
| `dupfinder status <input>` | Log a status observation |
| `dupfinder report <input>` | Record a report entry |
| `dupfinder stats` | Show summary statistics across all logs |
| `dupfinder export <fmt>` | Export all data (json, csv, or txt) |
| `dupfinder search <term>` | Search across all log files for a term |
| `dupfinder recent` | Show the 20 most recent activity entries |
| `dupfinder status` | Health check — version, disk usage, last activity (no args) |
| `dupfinder help` | Show all available commands |
| `dupfinder version` | Show current version |

Each command without arguments displays the most recent 20 entries from its log file.

## Data Storage

All data is stored in `~/.local/share/dupfinder/`:

- **Per-command logs** — `run.log`, `check.log`, `convert.log`, `analyze.log`, `generate.log`, `preview.log`, `batch.log`, `compare.log`, `export.log`, `config.log`, `status.log`, `report.log`
- **Activity history** — `history.log` (unified timeline of all actions)
- **Exports** — `export.json`, `export.csv`, or `export.txt` (generated on demand)

Data format: each entry is stored as `YYYY-MM-DD HH:MM|<value>`, pipe-delimited for easy parsing.

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard POSIX utilities (`date`, `wc`, `du`, `head`, `tail`, `grep`, `cut`, `basename`)
- No external dependencies or API keys required

## When to Use

1. **Tracking file operations** — log every check, conversion, and analysis with timestamps for a complete audit trail
2. **Batch processing workflows** — record batch operations and compare results across multiple runs
3. **Data analysis journaling** — use `analyze` and `report` to document findings as you work through a dataset
4. **Configuration change tracking** — log config changes with `config` so you can trace what changed and when
5. **Exporting operational data** — export the full history as JSON, CSV, or plain text for reporting or integration with other tools

## Examples

```bash
# Run the main function with an input
dupfinder run "scan /home/user/documents"

# Record a check result
dupfinder check "file-integrity OK for /var/data"

# Log an analysis
dupfinder analyze "Found 342 entries matching pattern *.tmp"

# Compare two datasets
dupfinder compare "dataset-A vs dataset-B: 97% overlap"

# Batch process a directory listing
dupfinder batch "processed 1500 files in /mnt/archive"

# Record a configuration change
dupfinder config "max_depth=5, hash_algo=sha256"

# Export all data as JSON
dupfinder export json

# Search logs for a specific term
dupfinder search "integrity"

# Show summary statistics
dupfinder stats

# View recent activity
dupfinder recent

# Check overall health
dupfinder status
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
dupfinder stats > summary.txt
dupfinder export csv
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
