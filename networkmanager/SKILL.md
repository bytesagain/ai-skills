---
name: Networkmanager
description: "Manage Wi-Fi, VPN, and network connections on Linux with troubleshooting tools. Use when configuring Wi-Fi, managing VPNs, troubleshooting connectivity."
version: "1.0.0"
license: GPL-3.0
runtime: python3
---

# Networkmanager

Networkmanager v2.0.0 — a sysops toolkit for scanning, monitoring, alerting, benchmarking, and managing network connections from the command line. All data is stored locally with full history tracking, search, and multi-format export.

## Commands

Run `networkmanager <command> [args]` to use. Each data command accepts optional input — with no arguments it shows recent entries; with arguments it records a new entry.

| Command | Description |
|---------|-------------|
| `scan [input]` | Scan networks and record findings |
| `monitor [input]` | Monitor network connections and log observations |
| `report [input]` | Generate or record network reports |
| `alert [input]` | Create and review network connection alerts |
| `top [input]` | Track top-level network metrics |
| `usage [input]` | Record and review connection usage data |
| `check [input]` | Run and log network health checks |
| `fix [input]` | Document network fixes applied |
| `cleanup [input]` | Log network cleanup operations |
| `backup [input]` | Record network config backups |
| `restore [input]` | Log network config restorations |
| `log [input]` | General-purpose network connection logging |
| `benchmark [input]` | Record network benchmark results |
| `compare [input]` | Log network comparison data |
| `stats` | Show summary statistics across all entry types |
| `export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `search <term>` | Full-text search across all log entries |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show built-in help message |
| `version` | Print version string (`networkmanager v2.0.0`) |

## Features

- **20+ subcommands** covering the full network management lifecycle
- **Local-first storage** — all data in `~/.local/share/networkmanager/` as plain-text logs
- **Timestamped entries** — every record includes `YYYY-MM-DD HH:MM` timestamps
- **Unified history log** — `history.log` tracks every action for auditability
- **Multi-format export** — JSON, CSV, and plain-text export built in
- **Full-text search** — grep-based search across all log files
- **Zero external dependencies** — pure Bash, runs anywhere
- **Automatic data directory creation** — no setup required

## Data Storage

All data is stored in `~/.local/share/networkmanager/`:

- `scan.log`, `monitor.log`, `report.log`, `alert.log`, `top.log`, `usage.log`, `check.log`, `fix.log`, `cleanup.log`, `backup.log`, `restore.log`, `log.log`, `benchmark.log`, `compare.log` — per-command entry logs
- `history.log` — unified audit trail of all operations
- `export.json`, `export.csv`, `export.txt` — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No root privileges required
- No internet connection required

## When to Use

1. **Scanning Wi-Fi and network connections** — run `networkmanager scan "Found 8 SSIDs on 2.4GHz band"` to record wireless scan results
2. **Monitoring connection stability** — use `networkmanager monitor "VPN tunnel uptime: 99.7% over 24h"` to track connection health over time
3. **Alerting on connectivity issues** — log alerts with `networkmanager alert "Wi-Fi disconnected 3 times in last hour"` for incident tracking
4. **Benchmarking connection performance** — record results with `networkmanager benchmark "VPN throughput: 280 Mbps via WireGuard"` to compare configurations
5. **Backing up and restoring network configs** — document backup operations with `networkmanager backup "Saved /etc/NetworkManager/system-connections/"` before making changes

## Examples

```bash
# Show all available commands
networkmanager help

# Record a network scan
networkmanager scan "Office Wi-Fi: 5 APs detected, signal -45 to -72 dBm"

# Log a monitoring observation
networkmanager monitor "eth0 link speed: 1000 Mbps full-duplex"

# Create an alert
networkmanager alert "DNS resolution timeout for internal domain"

# Record a benchmark
networkmanager benchmark "WireGuard vs OpenVPN: 280 Mbps vs 150 Mbps"

# View summary statistics
networkmanager stats

# Search all logs for a term
networkmanager search "VPN"

# Export everything to JSON
networkmanager export json

# Check tool health
networkmanager status

# View recent activity
networkmanager recent
```

## How It Works

Networkmanager stores all data locally in `~/.local/share/networkmanager/`. Each command logs activity with timestamps for full traceability. When called without arguments, data commands display their most recent 20 entries. When called with arguments, they append a new timestamped entry and update the unified history log.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
