---
name: CalcTool
description: "Perform basic, scientific, and financial calculations from the terminal. Use when computing interest, converting units, or solving quick math."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["calculator","math","arithmetic","scientific","convert","finance","utility"]
categories: ["Utility", "Productivity"]
---

# CalcTool

Utility toolkit — run, check, convert, analyze, generate, preview, batch, compare, and manage data entries. Each command logs input with timestamps for full traceability and review.

## Commands

| Command | Description |
|---------|-------------|
| `calctool run <input>` | Log a run entry (no args = view recent runs) |
| `calctool check <input>` | Log a check entry (no args = view recent checks) |
| `calctool convert <input>` | Log a convert entry (no args = view recent converts) |
| `calctool analyze <input>` | Log an analyze entry (no args = view recent analyses) |
| `calctool generate <input>` | Log a generate entry (no args = view recent generates) |
| `calctool preview <input>` | Log a preview entry (no args = view recent previews) |
| `calctool batch <input>` | Log a batch entry (no args = view recent batches) |
| `calctool compare <input>` | Log a compare entry (no args = view recent compares) |
| `calctool export <input>` | Log an export entry (no args = view recent exports) |
| `calctool config <input>` | Log a config entry (no args = view recent configs) |
| `calctool status <input>` | Log a status entry (no args = view recent statuses) |
| `calctool report <input>` | Log a report entry (no args = view recent reports) |
| `calctool stats` | Summary statistics — entry counts per category, total, data size |
| `calctool search <term>` | Search across all log entries |
| `calctool recent` | Show last 20 history entries |
| `calctool help` | Show usage info |
| `calctool version` | Show version string |

> **Note:** The `export` and `status` commands in the case dispatch also have utility variants (`_export <fmt>` and `_status`) that provide structured export (json/csv/txt) and health check output respectively. However, the primary case match routes to the logging version.

## Data Storage

All data is stored locally in `~/.local/share/calctool/`. Each command writes to its own `.log` file (e.g., `run.log`, `check.log`, `analyze.log`). A unified `history.log` records every action with timestamps. No external services or databases required.

**Log format:** `YYYY-MM-DD HH:MM|<value>`

**Export formats:** JSON, CSV, or plain text (via the `_export` helper function).

## Requirements

- **bash** (version 4+ recommended)
- Standard POSIX utilities: `date`, `wc`, `du`, `grep`, `tail`, `head`, `cat`
- No external dependencies, no network access needed
- Works on Linux, macOS, and WSL

## When to Use

1. **Logging calculation results** — Record computations, conversions, or analysis results with `run`, `convert`, or `analyze` for future reference
2. **Batch processing and comparison** — Log batch operations with `batch` and side-by-side comparisons with `compare`
3. **Generating and previewing outputs** — Use `generate` to log generated results and `preview` to log draft outputs before finalizing
4. **Configuration and status tracking** — Record configuration changes with `config` and system states with `status` for audit trails
5. **Reporting and data export** — Create `report` entries for periodic summaries and use `stats` or `search` to review all logged data

## Examples

```bash
# Log a calculation run
calctool run "2 * (3 + 4) / 5 = 2.8"

# Log a unit conversion
calctool convert "100 USD to CNY = 725.30"

# Log an analysis result
calctool analyze "Dataset A: mean=45.2, std=12.1, n=500"

# Compare two results
calctool compare "Plan A: $12,000/yr vs Plan B: $10,800/yr — B saves 10%"

# Generate a report entry
calctool report "Q1 2026 summary: 142 entries, 98% accuracy"

# Search for specific entries
calctool search "USD"

# View summary statistics
calctool stats

# View recent activity
calctool recent

# Check health status
calctool status
```

## How It Works

CalcTool stores all data locally in `~/.local/share/calctool/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary of entries per category with total counts and data size. Use `search` to find specific entries across all logs, `recent` to view the latest activity, or the built-in export helper to back up your data in JSON, CSV, or plain text format.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
