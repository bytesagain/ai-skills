---
version: "1.0.0"
name: Penpot
description: "Penpot: The open-source design tool for design and code collaboration design-tool, clojure, clojure, clojurescript, design, prototyping."
---

# Design Tool

Design Tool v2.0.0 — a utility toolkit for logging, tracking, and managing design-related entries from the command line.

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

All data is stored locally in `~/.local/share/design-tool/`:

- **Per-command logs** — Each command (run, check, convert, etc.) writes to its own `.log` file with pipe-delimited `timestamp|value` format.
- **history.log** — A unified activity log recording every write operation with timestamps.
- **Export formats** — The `export` utility function supports JSON, CSV, and TXT output, written to `~/.local/share/design-tool/export.<fmt>`.

No external services, databases, or API keys are required. Everything is flat-file and human-readable.

## Requirements

- **Bash** (v4+ recommended)
- No external dependencies — uses only standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`)

## When to Use

- When you need to log and track design-related activities from the command line
- To maintain a searchable history of design decisions and iterations
- For batch recording of design tasks with timestamps
- When you want to export design logs in JSON, CSV, or TXT format
- As part of a larger design workflow automation pipeline
- To get quick statistics and summaries of past design activities

## Examples

```bash
# Record a new run entry
design-tool run "updated homepage wireframe v3"

# View recent run entries (no args = show history)
design-tool run

# Check something and log it
design-tool check "color contrast passes WCAG AA"

# Analyze and record
design-tool analyze "user flow has 5 steps, target is 3"

# Preview and record
design-tool preview "mobile layout at 375px"

# Compare designs
design-tool compare "v2 vs v3 header layout"

# Search across all logs
design-tool search "wireframe"

# View summary statistics
design-tool stats

# Show recent activity across all commands
design-tool recent

# Show tool version
design-tool version

# Show full help
design-tool help
```

## How It Works

Each command follows the same pattern:
1. **With arguments** — Timestamps the input, appends it to the command-specific log file, prints confirmation, and logs to `history.log`.
2. **Without arguments** — Shows the last 20 entries from that command's log file.

The `stats` command iterates all `.log` files, counts entries per file, and reports totals plus disk usage. The `search` command performs case-insensitive grep across all log files. The `recent` command tails the last 20 lines of `history.log`.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
