---
version: "1.0.0"
name: Win10 Initial Setup Script
description: "PowerShell script for automation of routine tasks done after fresh installations of Windows 10 / Ser win10 initial setup script, powershell, powershell."
---

# Windows Setup

A utility toolkit for tracking and managing Windows setup, configuration, and post-installation tasks. Log setup runs, check configurations, analyze system state, generate reports, and export data — all from the command line.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from their log.

| Command | Description |
|---------|-------------|
| `windows-setup run <input>` | Run a setup task and log the result |
| `windows-setup check <input>` | Check a system configuration or prerequisite |
| `windows-setup convert <input>` | Convert setup scripts or configuration formats |
| `windows-setup analyze <input>` | Analyze system state, installed components, or logs |
| `windows-setup generate <input>` | Generate setup scripts, checklists, or templates |
| `windows-setup preview <input>` | Preview a setup operation before executing |
| `windows-setup batch <input>` | Batch process multiple setup tasks at once |
| `windows-setup compare <input>` | Compare two system configurations or setup states |
| `windows-setup export <input>` | Log an export operation |
| `windows-setup config <input>` | Log or update configuration entries |
| `windows-setup status <input>` | Log a status check result |
| `windows-setup report <input>` | Generate or log a report entry |
| `windows-setup stats` | Show summary statistics across all log files |
| `windows-setup export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `windows-setup search <term>` | Search across all log entries for a keyword |
| `windows-setup recent` | Show the 20 most recent activity entries |
| `windows-setup help` | Show all available commands |
| `windows-setup version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/windows-setup/`. Each command maintains its own `.log` file with timestamped entries in `YYYY-MM-DD HH:MM|value` format. A unified `history.log` tracks all operations across commands.

**Export formats supported:**
- **JSON** — Array of objects with `type`, `time`, and `value` fields
- **CSV** — Standard comma-separated with `type,time,value` header
- **TXT** — Human-readable grouped by command type

## Requirements

- Bash 4.0+ with `set -euo pipefail` (strict mode)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies — runs on any POSIX-compliant system
- Works on WSL, Git Bash, or any Bash environment on Windows

## When to Use

1. **Post-installation task tracking** — Log all setup steps after a fresh Windows install for reproducibility
2. **Configuration auditing** — Record and compare system configurations before and after changes
3. **Batch setup automation** — Queue up multiple setup tasks and track their completion status
4. **Generating setup reports** — Export task history to JSON/CSV for documentation or compliance
5. **Comparing system states** — Use `compare` to record differences between baseline and current configurations

## Examples

```bash
# Log a setup task
windows-setup run "Disable telemetry via Group Policy"

# Check a system prerequisite
windows-setup check ".NET Framework 4.8 installed"

# Analyze current system state
windows-setup analyze "Startup apps: 12 enabled, 3 high-impact"

# Compare before and after setup
windows-setup compare "Default vs hardened: 23 registry changes"

# Batch process multiple tasks
windows-setup batch "Privacy settings: 8 toggles disabled"

# Export all setup history to JSON
windows-setup export json

# Search for specific setup entries
windows-setup search "registry"

# View summary statistics
windows-setup stats
```

## How It Works

Windows Setup stores all data locally in `~/.local/share/windows-setup/`. Each command creates a dedicated log file (e.g., `run.log`, `check.log`, `config.log`). Every entry is timestamped and appended, providing a full audit trail of all setup operations. The `history.log` file aggregates activity across all commands for unified tracking.

When called without arguments, each command displays its most recent 20 entries, making it easy to review past setup work without manually inspecting log files.

## Output

All output goes to stdout. Redirect to a file with:

```bash
windows-setup stats > report.txt
windows-setup export json  # writes to ~/.local/share/windows-setup/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
