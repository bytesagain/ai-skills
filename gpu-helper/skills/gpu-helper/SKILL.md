---
version: "1.0.0"
name: G Helper
description: "Lightweight, open-source control tool for ASUS laptops and ROG Ally. Manage performance modes, fans, g helper, c#, ally, amd, armoury, armoury-crate."
---

# Gpu Helper

Gpu Helper v2.0.0 — a utility toolkit for logging and tracking GPU-related operations from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `gpu-helper run <input>` | Log a run entry (no args = show recent) |
| `gpu-helper check <input>` | Log a check entry (no args = show recent) |
| `gpu-helper convert <input>` | Log a convert entry (no args = show recent) |
| `gpu-helper analyze <input>` | Log an analyze entry (no args = show recent) |
| `gpu-helper generate <input>` | Log a generate entry (no args = show recent) |
| `gpu-helper preview <input>` | Log a preview entry (no args = show recent) |
| `gpu-helper batch <input>` | Log a batch entry (no args = show recent) |
| `gpu-helper compare <input>` | Log a compare entry (no args = show recent) |
| `gpu-helper export <input>` | Log an export entry (no args = show recent) |
| `gpu-helper config <input>` | Log a config entry (no args = show recent) |
| `gpu-helper status <input>` | Log a status entry (no args = show recent) |
| `gpu-helper report <input>` | Log a report entry (no args = show recent) |
| `gpu-helper stats` | Show summary statistics across all log files |
| `gpu-helper export <fmt>` | Export all data (json, csv, or txt) |
| `gpu-helper search <term>` | Search across all log entries |
| `gpu-helper recent` | Show last 20 history entries |
| `gpu-helper status` | Health check (version, data dir, entry count, disk usage) |
| `gpu-helper help` | Show usage information |
| `gpu-helper version` | Show version string |

## Data Storage

All data is stored locally in `~/.local/share/gpu-helper/`. Each command writes timestamped entries to its own `.log` file (e.g., `run.log`, `check.log`, `analyze.log`). A unified `history.log` tracks all operations for the `recent` command.

Log format per entry: `YYYY-MM-DD HH:MM|<input>`

## Requirements

- Bash (with `set -euo pipefail`)
- No external dependencies — uses only standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `cat`, `sed`)

## When to Use

- To log and track GPU utility operations over time
- To maintain a searchable history of run/check/analyze/convert tasks
- To export accumulated data in JSON, CSV, or plain text for reporting
- To get a quick health check on your gpu-helper data directory
- For batch-tracking operations with timestamped entries

## Examples

```bash
# Log a run entry
gpu-helper run "benchmark RTX 4090 at 1440p"

# Log an analyze entry
gpu-helper analyze "power consumption under load"

# View recent check entries
gpu-helper check

# Search all logs for a term
gpu-helper search "RTX"

# Export everything as JSON
gpu-helper export json

# View aggregate statistics
gpu-helper stats

# Health check
gpu-helper status

# Show last 20 history entries
gpu-helper recent
```

## Configuration

Set the `GPU_HELPER_DIR` environment variable to override the default data directory. Default: `~/.local/share/gpu-helper/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
