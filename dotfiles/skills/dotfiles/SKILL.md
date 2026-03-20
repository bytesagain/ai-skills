---
name: Dotfiles
description: "Backup, sync, and version-track dotfiles across multiple machines. Use when syncing configs, backing up settings, restoring on new machines."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["dotfiles","config","backup","sync","bashrc","vimrc","setup","developer"]
categories: ["Developer Tools", "System Tools", "Productivity"]
---
# Dotfiles

Sysops toolkit for scanning, monitoring, reporting, and maintaining system configurations. Track changes, create backups, run benchmarks, and keep your environment healthy — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `dotfiles scan <input>` | Scan and log a system configuration entry |
| `dotfiles monitor <input>` | Record a monitoring observation |
| `dotfiles report <input>` | Log a report entry for review |
| `dotfiles alert <input>` | Create an alert record |
| `dotfiles top <input>` | Record top-level metrics or priorities |
| `dotfiles usage <input>` | Log resource usage data |
| `dotfiles check <input>` | Run a check and record results |
| `dotfiles fix <input>` | Log a fix or remediation action |
| `dotfiles cleanup <input>` | Record a cleanup operation |
| `dotfiles backup <input>` | Log a backup event |
| `dotfiles restore <input>` | Log a restore operation |
| `dotfiles log <input>` | Add a general log entry |
| `dotfiles benchmark <input>` | Record benchmark results |
| `dotfiles compare <input>` | Log a comparison between configurations |
| `dotfiles stats` | Show summary statistics across all logs |
| `dotfiles export <fmt>` | Export all data (json, csv, or txt) |
| `dotfiles search <term>` | Search across all log files for a term |
| `dotfiles recent` | Show the 20 most recent activity entries |
| `dotfiles status` | Health check — version, disk usage, last activity |
| `dotfiles help` | Show all available commands |
| `dotfiles version` | Show current version |

Each command without arguments displays the most recent 20 entries from its log file.

## Data Storage

All data is stored in `~/.local/share/dotfiles/`:

- **Per-command logs** — `scan.log`, `monitor.log`, `report.log`, `alert.log`, `top.log`, `usage.log`, `check.log`, `fix.log`, `cleanup.log`, `backup.log`, `restore.log`, `log.log`, `benchmark.log`, `compare.log`
- **Activity history** — `history.log` (unified timeline of all actions)
- **Exports** — `export.json`, `export.csv`, or `export.txt` (generated on demand)

Data format: each entry is stored as `YYYY-MM-DD HH:MM|<value>`, pipe-delimited for easy parsing.

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard POSIX utilities (`date`, `wc`, `du`, `head`, `tail`, `grep`, `cut`, `basename`)
- No external dependencies or API keys required

## When to Use

1. **System configuration auditing** — scan and record the state of config files across machines, track drift over time
2. **Incident response logging** — use `alert`, `fix`, and `log` to maintain a structured timeline during outages or issues
3. **Backup and restore tracking** — log every backup and restore event to maintain an audit trail for compliance
4. **Performance benchmarking** — record benchmark results over time and compare configurations side by side
5. **Daily ops monitoring** — capture usage metrics, run health checks, and clean up stale resources on a regular schedule

## Examples

```bash
# Scan a configuration and log the result
dotfiles scan "nginx.conf updated to v1.25"

# Record a monitoring observation
dotfiles monitor "CPU at 78% during peak hours"

# Create an alert for high memory usage
dotfiles alert "Memory usage exceeded 90% threshold"

# Log a fix action after resolving an issue
dotfiles fix "Rotated /var/log/syslog, freed 2.3GB"

# Export all collected data as JSON for analysis
dotfiles export json

# Search all logs for entries related to nginx
dotfiles search nginx

# View recent activity across all commands
dotfiles recent

# Check overall health and disk usage
dotfiles status

# Show summary statistics
dotfiles stats
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
dotfiles stats > report.txt
dotfiles export json
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
