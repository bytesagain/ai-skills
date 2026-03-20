---
version: "1.0.0"
name: Networkmanager
description: "A powerful open-source tool for managing networks and troubleshooting network problems! network-config, c#, aws-ssm, dns, dns-lookup, icmp."
---

# Network Config

Network Config v2.0.0 — a sysops toolkit for scanning, monitoring, alerting, benchmarking, and managing network configurations from the command line. All data is stored locally with full history tracking, search, and multi-format export.

## Commands

Run `network-config <command> [args]` to use. Each data command accepts optional input — with no arguments it shows recent entries; with arguments it records a new entry.

| Command | Description |
|---------|-------------|
| `scan [input]` | Scan network configurations and record findings |
| `monitor [input]` | Monitor network state and log observations |
| `report [input]` | Generate or record network reports |
| `alert [input]` | Create and review network alerts |
| `top [input]` | Track top-level network metrics |
| `usage [input]` | Record and review network usage data |
| `check [input]` | Run and log network health checks |
| `fix [input]` | Document network fixes applied |
| `cleanup [input]` | Log network cleanup operations |
| `backup [input]` | Record network config backups |
| `restore [input]` | Log network config restorations |
| `log [input]` | General-purpose network logging |
| `benchmark [input]` | Record network benchmark results |
| `compare [input]` | Log network comparison data |
| `stats` | Show summary statistics across all entry types |
| `export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `search <term>` | Full-text search across all log entries |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show built-in help message |
| `version` | Print version string (`network-config v2.0.0`) |

## Features

- **20+ subcommands** covering the full network config lifecycle
- **Local-first storage** — all data in `~/.local/share/network-config/` as plain-text logs
- **Timestamped entries** — every record includes `YYYY-MM-DD HH:MM` timestamps
- **Unified history log** — `history.log` tracks every action for auditability
- **Multi-format export** — JSON, CSV, and plain-text export built in
- **Full-text search** — grep-based search across all log files
- **Zero external dependencies** — pure Bash, runs anywhere
- **Automatic data directory creation** — no setup required

## Data Storage

All data is stored in `~/.local/share/network-config/`:

- `scan.log`, `monitor.log`, `report.log`, `alert.log`, `top.log`, `usage.log`, `check.log`, `fix.log`, `cleanup.log`, `backup.log`, `restore.log`, `log.log`, `benchmark.log`, `compare.log` — per-command entry logs
- `history.log` — unified audit trail of all operations
- `export.json`, `export.csv`, `export.txt` — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

Override the data directory by setting `NETWORK_CONFIG_DIR` (not yet wired — default is `~/.local/share/network-config/`).

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No root privileges required
- No internet connection required

## When to Use

1. **Recording network scan results** — run `network-config scan "192.168.1.0/24 — 14 hosts found"` after scanning your subnet
2. **Monitoring network state over time** — use `network-config monitor "latency 12ms to gateway"` to build a time-series log
3. **Tracking alerts and incidents** — log alerts with `network-config alert "DNS resolution failing for api.example.com"` for later review
4. **Benchmarking and comparing configs** — record benchmark results and compare configurations across environments
5. **Backing up and restoring configurations** — document backup/restore operations with `network-config backup` and `network-config restore`

## Examples

```bash
# Show all available commands
network-config help

# Record a network scan result
network-config scan "Found 23 active hosts on 10.0.0.0/24"

# Log a monitoring observation
network-config monitor "WAN latency spike: 85ms avg over last hour"

# Create an alert entry
network-config alert "Interface eth0 dropped 12 packets in 5 min"

# Record a benchmark
network-config benchmark "iperf3 TCP throughput: 940 Mbps"

# View summary statistics
network-config stats

# Search all logs for a term
network-config search "eth0"

# Export everything to JSON
network-config export json

# Check tool health
network-config status

# View recent activity
network-config recent
```

## How It Works

Network Config stores all data locally in `~/.local/share/network-config/`. Each command logs activity with timestamps for full traceability. When called without arguments, data commands display their most recent 20 entries. When called with arguments, they append a new timestamped entry and update the unified history log.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
