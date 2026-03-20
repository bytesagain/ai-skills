---
version: "1.0.0"
name: time-logger
description: "Log time entries and see where your hours go each day. Use when scanning hours, monitoring totals, reporting summaries, ranking categories."
---

# Time Logger

Time Logger v2.0.0 — a sysops toolkit for logging, monitoring, and managing system operations from the command line. All data is stored locally in flat log files with timestamps, making it easy to review history, export records, and search across entries.

## Commands

Run `scripts/script.sh <command> [args]` to use.

### Core Operations

| Command | Description |
|---------|-------------|
| `scan <input>` | Log a scan entry (e.g. system scans, resource discovery) |
| `monitor <input>` | Log a monitor entry (e.g. uptime monitoring, service checks) |
| `report <input>` | Log a report entry (e.g. daily/weekly summaries, incident reports) |
| `alert <input>` | Log an alert entry (e.g. threshold alerts, anomaly warnings) |
| `top <input>` | Log a top entry (e.g. top resource consumers, peak usage) |
| `usage <input>` | Log a usage entry (e.g. CPU/memory/disk usage snapshots) |
| `check <input>` | Log a check entry (e.g. health checks, verification results) |
| `fix <input>` | Log a fix entry (e.g. applied patches, resolved issues) |
| `cleanup <input>` | Log a cleanup entry (e.g. temp file removal, log rotation) |
| `backup <input>` | Log a backup entry (e.g. backup runs, snapshot records) |
| `restore <input>` | Log a restore entry (e.g. recovery operations, data restores) |
| `log <input>` | Log a generic log entry (e.g. free-form notes, misc events) |
| `benchmark <input>` | Log a benchmark entry (e.g. performance baselines, load tests) |
| `compare <input>` | Log a compare entry (e.g. before/after comparisons, diff results) |

Each command without arguments shows the 20 most recent entries for that category.

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Summary statistics across all log categories with entry counts and disk usage |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Show the 20 most recent entries from the global activity history |
| `status` | Health check — version, data directory, total entries, disk usage, last activity |
| `help` | Show full usage information |
| `version` | Show version string (`time-logger v2.0.0`) |

## Data Storage

All data is persisted locally under `~/.local/share/time-logger/`:

- **`<command>.log`** — One log file per command (e.g. `scan.log`, `monitor.log`, `backup.log`)
- **`history.log`** — Global activity log with timestamps for every operation
- **`export.<fmt>`** — Generated export files (json/csv/txt)

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). No external services, no API keys, no network calls — everything stays on your machine.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or packages required
- No API keys or accounts needed

## When to Use

1. **Tracking system operations** — Log scans, monitors, and health checks to build a searchable history of your sysops activities
2. **Recording incident response** — Use `alert`, `fix`, and `restore` to document the lifecycle of an incident from detection through resolution
3. **Auditing maintenance tasks** — Track `cleanup`, `backup`, and `restore` operations so you can prove compliance and trace back when actions occurred
4. **Benchmarking and comparing** — Use `benchmark` and `compare` to record performance baselines and before/after results across system changes
5. **Generating ops reports** — Use `report` to log periodic summaries, then `export json` to pull structured data for dashboards or handoffs

## Examples

```bash
# Log a system scan
time-logger scan "Full port scan on 192.168.1.0/24 — 12 hosts found"

# Record a monitoring event
time-logger monitor "nginx upstream response time spiked to 2.3s"

# Log an alert
time-logger alert "Disk usage on /var exceeded 90% threshold"

# Record a fix applied
time-logger fix "Rotated nginx logs and freed 4.2GB on /var"

# Search for all entries mentioning 'nginx'
time-logger search nginx

# Export everything to JSON
time-logger export json

# View summary statistics
time-logger stats

# Check recent activity
time-logger recent
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
