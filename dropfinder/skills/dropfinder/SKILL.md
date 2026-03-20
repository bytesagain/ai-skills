---
version: "1.0.0"
name: Airdrop Hunter
description: "Aggregate and track crypto airdrops — find eligible drops, set reminders, and generate participation checklists across EVM and Solana systems. Use when you n."
---

# Dropfinder

Utility toolkit for logging and tracking operations — run, check, convert, analyze, generate, preview, batch, compare, export, config, status, and report. All entries are recorded locally with timestamps for full audit trails.

## Commands

| Command | Description |
|---------|-------------|
| `dropfinder run <input>` | Run a task or record a run entry |
| `dropfinder check <input>` | Check something or record a check entry |
| `dropfinder convert <input>` | Convert data or record a conversion entry |
| `dropfinder analyze <input>` | Analyze data or record an analysis entry |
| `dropfinder generate <input>` | Generate output or record a generation entry |
| `dropfinder preview <input>` | Preview results or record a preview entry |
| `dropfinder batch <input>` | Batch process or record a batch entry |
| `dropfinder compare <input>` | Compare items or record a comparison entry |
| `dropfinder export <input>` | Export data or record an export entry |
| `dropfinder config <input>` | Configure settings or record a config entry |
| `dropfinder status <input>` | Check status or record a status entry |
| `dropfinder report <input>` | Generate a report or record a report entry |
| `dropfinder stats` | Show summary statistics across all entry types |
| `dropfinder search <term>` | Search across all log entries by keyword |
| `dropfinder recent` | Show the 20 most recent activity entries |
| `dropfinder help` | Show help with all available commands |
| `dropfinder version` | Show current version (v2.0.0) |

Each command (run, check, convert, analyze, generate, preview, batch, compare, export, config, status, report) works in two modes:
- **No arguments**: displays the 20 most recent entries from that command's log
- **With arguments**: records the input with a timestamp and appends to the command's log file

## Data Storage

All data is stored locally at `~/.local/share/dropfinder/`. Each action is logged to its own file (e.g., `run.log`, `check.log`, `analyze.log`). A unified `history.log` tracks all operations. The built-in export function supports JSON, CSV, and plain text formats for backup and portability.

## Requirements

- bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)

## When to Use

- Logging and tracking recurring utility operations
- Recording analysis results and comparison data over time
- Batch processing entries with timestamped audit trails
- Exporting operation history for reporting or review
- Searching past entries by keyword across all log categories

## Examples

```bash
# Record a run entry
dropfinder run "processed 150 items from input queue"

# Record an analysis
dropfinder analyze "dataset has 3 outliers above 2σ threshold"

# Record a comparison
dropfinder compare "v1.2 vs v1.3 — 15% improvement in throughput"

# View recent check entries
dropfinder check

# Batch process an entry
dropfinder batch "queue-20240315 — 42 items processed"

# Search entries mentioning "error"
dropfinder search error

# View summary statistics
dropfinder stats

# Show recent activity
dropfinder recent

# Show overall status
dropfinder status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
