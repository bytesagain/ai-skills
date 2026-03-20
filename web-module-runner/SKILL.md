---
version: "1.0.0"
name: Wmr
description: "👩‍🚀 The tiny all-in-one development tool for modern web apps. web-module-runner, javascript, build-tool, esmodules, preact."
---

# Web Module Runner

👩‍🚀 The tiny all-in-one development tool for modern web apps — a versatile utility toolkit for running, checking, converting, analyzing, and managing web module tasks from your terminal.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from their log.

| Command | Description |
|---------|-------------|
| `web-module-runner run <input>` | Run a web module task and log the result |
| `web-module-runner check <input>` | Check a module, dependency, or configuration |
| `web-module-runner convert <input>` | Convert between module formats or configurations |
| `web-module-runner analyze <input>` | Analyze a module, bundle, or dependency tree |
| `web-module-runner generate <input>` | Generate boilerplate, configs, or module scaffolds |
| `web-module-runner preview <input>` | Preview output or rendered results |
| `web-module-runner batch <input>` | Batch process multiple items at once |
| `web-module-runner compare <input>` | Compare two modules, builds, or configurations |
| `web-module-runner export <input>` | Log an export operation |
| `web-module-runner config <input>` | Log or update configuration entries |
| `web-module-runner status <input>` | Log status check results |
| `web-module-runner report <input>` | Generate or log a report entry |
| `web-module-runner stats` | Show summary statistics across all log files |
| `web-module-runner export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `web-module-runner search <term>` | Search across all log entries for a keyword |
| `web-module-runner recent` | Show the 20 most recent activity entries |
| `web-module-runner help` | Show all available commands |
| `web-module-runner version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/web-module-runner/`. Each command maintains its own `.log` file with timestamped entries in `YYYY-MM-DD HH:MM|value` format. A unified `history.log` tracks all operations across commands.

**Export formats supported:**
- **JSON** — Array of objects with `type`, `time`, and `value` fields
- **CSV** — Standard comma-separated with `type,time,value` header
- **TXT** — Human-readable grouped by command type

## Requirements

- Bash 4.0+ with `set -euo pipefail` (strict mode)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies — runs on any POSIX-compliant system

## When to Use

1. **Tracking web module build tasks** — Log and review module runs, builds, and conversions over time
2. **Comparing module configurations** — Use `compare` and `analyze` to record side-by-side evaluations
3. **Batch processing workflows** — Record batch operations and review history for repeatability
4. **Generating reports from logged data** — Export accumulated logs to JSON/CSV for downstream analysis
5. **Quick health checks** — Use `status` and `stats` to verify the toolkit state and entry counts at a glance

## Examples

```bash
# Run a module task and log it
web-module-runner run "build main.js --target es2020"

# Analyze a dependency
web-module-runner analyze "preact@10.x bundle size"

# Batch process multiple modules
web-module-runner batch "convert all legacy modules to ESM"

# Search for previous entries containing a keyword
web-module-runner search "preact"

# Export everything to JSON for external tooling
web-module-runner export json

# View summary statistics
web-module-runner stats

# Show recent activity log
web-module-runner recent
```

## How It Works

Web Module Runner stores all data locally in `~/.local/share/web-module-runner/`. Each command creates a dedicated log file (e.g., `run.log`, `check.log`, `analyze.log`). Every entry is timestamped and appended, providing a full audit trail of all operations. The `history.log` file aggregates activity across all commands for unified tracking.

When called without arguments, each command displays its most recent 20 entries, making it easy to review past work without needing to manually inspect log files.

## Output

All output goes to stdout. Redirect to a file with:

```bash
web-module-runner stats > report.txt
web-module-runner export json  # writes to ~/.local/share/web-module-runner/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
