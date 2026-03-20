---
version: "1.0.0"
name: Network Monitor
description: "Monitor internet traffic in real time with per-process bandwidth dashboards. Use when watching bandwidth, finding traffic hogs, monitoring network activity."
---

# Netwatch

A sysops toolkit for monitoring, scanning, and managing network activity. Track bandwidth usage, set alerts, run benchmarks, manage backups, and generate reports — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `netwatch scan <input>` | Scan network hosts, ports, or services |
| `netwatch monitor <input>` | Monitor network activity or record a monitoring entry |
| `netwatch report <input>` | Generate or record a network report |
| `netwatch alert <input>` | Set or record a network alert rule |
| `netwatch top <input>` | Log top bandwidth consumers or resource usage |
| `netwatch usage <input>` | Record bandwidth or resource usage data |
| `netwatch check <input>` | Check network connectivity, DNS, or service health |
| `netwatch fix <input>` | Log a network fix or remediation action |
| `netwatch cleanup <input>` | Record a cleanup operation (stale connections, old logs) |
| `netwatch backup <input>` | Log a backup operation for network configs or data |
| `netwatch restore <input>` | Record a restore operation from backup |
| `netwatch log <input>` | Add a custom log entry for network events |
| `netwatch benchmark <input>` | Run or record a network benchmark (speed, latency) |
| `netwatch compare <input>` | Compare network metrics, configs, or benchmark results |
| `netwatch stats` | Show summary statistics across all entry types |
| `netwatch export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `netwatch search <term>` | Search across all entries by keyword |
| `netwatch recent` | Show the 20 most recent activity log entries |
| `netwatch status` | Health check — version, disk usage, last activity |
| `netwatch help` | Show the built-in help message |
| `netwatch version` | Print the current version (v2.0.0) |

Each network command (scan, monitor, alert, etc.) works in two modes:
- **Without arguments** — displays the 20 most recent entries of that type
- **With arguments** — saves the input as a new timestamped entry

## Data Storage

All data is stored as plain-text log files in `~/.local/share/netwatch/`:

- Each command type gets its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`)
- Entries are stored in `timestamp|value` format for easy parsing
- A unified `history.log` tracks all activity across command types
- Export to JSON, CSV, or TXT at any time with the `export` command

Set the `NETWATCH_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Monitoring bandwidth usage** — use `monitor`, `top`, and `usage` to track which processes or hosts are consuming the most bandwidth in real time
2. **Network security scanning** — use `scan` and `check` to audit open ports, verify DNS resolution, and ensure services are reachable
3. **Setting up alerting** — use `alert` to log threshold-based rules (e.g., notify when bandwidth exceeds 100 Mbps or a host goes unreachable)
4. **Benchmarking network performance** — use `benchmark` and `compare` to measure and compare latency, throughput, and jitter across different configurations
5. **Managing network backups and recovery** — use `backup`, `restore`, and `cleanup` to document config snapshots, disaster recovery steps, and housekeeping operations

## Examples

```bash
# Scan the local network for active hosts
netwatch scan "192.168.1.0/24 — found 23 active hosts, 3 with open SSH"

# Monitor bandwidth on the main interface
netwatch monitor "eth0 averaging 45 Mbps download, 12 Mbps upload over last hour"

# Set an alert for high usage
netwatch alert "Trigger notification when any host exceeds 500 Mbps sustained for 5 minutes"

# Run a benchmark
netwatch benchmark "Speedtest: 940 Mbps down, 880 Mbps up, 3ms latency to ISP gateway"

# Search for past scan results
netwatch search "192.168"
```

## Output

All commands print results to stdout. Redirect to a file if needed:

```bash
netwatch stats > network-report.txt
netwatch export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
