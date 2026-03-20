---
version: "1.0.0"
name: Iperf
description: "Measure TCP, UDP, and SCTP bandwidth between hosts with throughput benchmarks. Use when testing speed, benchmarking links, comparing protocol performance."
---

# Network Speed

Network Speed v2.0.0 — a sysops toolkit for measuring, monitoring, benchmarking, and comparing network speed and bandwidth from the command line. All data is stored locally with full history tracking, search, and multi-format export.

## Commands

Run `network-speed <command> [args]` to use. Each data command accepts optional input — with no arguments it shows recent entries; with arguments it records a new entry.

| Command | Description |
|---------|-------------|
| `scan [input]` | Scan and record network speed measurements |
| `monitor [input]` | Monitor bandwidth and log observations over time |
| `report [input]` | Generate or record speed test reports |
| `alert [input]` | Create and review speed/bandwidth alerts |
| `top [input]` | Track top-level speed metrics |
| `usage [input]` | Record and review bandwidth usage data |
| `check [input]` | Run and log speed health checks |
| `fix [input]` | Document speed-related fixes applied |
| `cleanup [input]` | Log cleanup operations on speed data |
| `backup [input]` | Record speed data backups |
| `restore [input]` | Log speed data restorations |
| `log [input]` | General-purpose speed logging |
| `benchmark [input]` | Record network benchmark results (throughput, latency) |
| `compare [input]` | Log speed comparisons across links or time periods |
| `stats` | Show summary statistics across all entry types |
| `export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `search <term>` | Full-text search across all log entries |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show built-in help message |
| `version` | Print version string (`network-speed v2.0.0`) |

## Features

- **20+ subcommands** covering the full network speed testing lifecycle
- **Local-first storage** — all data in `~/.local/share/network-speed/` as plain-text logs
- **Timestamped entries** — every record includes `YYYY-MM-DD HH:MM` timestamps
- **Unified history log** — `history.log` tracks every action for auditability
- **Multi-format export** — JSON, CSV, and plain-text export built in
- **Full-text search** — grep-based search across all log files
- **Zero external dependencies** — pure Bash, runs anywhere
- **Automatic data directory creation** — no setup required

## Data Storage

All data is stored in `~/.local/share/network-speed/`:

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

1. **Recording speed test results** — run `network-speed benchmark "iperf3 TCP: 940 Mbps download, 890 Mbps upload"` after running a throughput test
2. **Monitoring bandwidth over time** — use `network-speed monitor "WAN throughput: 450 Mbps at 14:00"` to build a historical speed log
3. **Alerting on speed degradation** — log alerts with `network-speed alert "Download speed dropped below 100 Mbps threshold"` for incident tracking
4. **Comparing link performance** — use `network-speed compare "Office vs DC: 200ms RTT difference"` to document comparisons across links
5. **Generating speed reports** — record periodic reports with `network-speed report "Weekly avg: 850 Mbps down / 420 Mbps up"` for trend analysis

## Examples

```bash
# Show all available commands
network-speed help

# Record a speed scan result
network-speed scan "Speedtest: 520 Mbps down / 310 Mbps up via Cloudflare"

# Log a monitoring observation
network-speed monitor "Peak hour bandwidth: 380 Mbps avg"

# Record a benchmark
network-speed benchmark "iperf3 UDP 1Gbps target: 0.02% loss, 0.4ms jitter"

# Compare two links
network-speed compare "Fiber vs LTE: 940 Mbps vs 85 Mbps download"

# View summary statistics
network-speed stats

# Search all logs for a term
network-speed search "UDP"

# Export everything to CSV
network-speed export csv

# Check tool health
network-speed status

# View recent activity
network-speed recent
```

## How It Works

Network Speed stores all data locally in `~/.local/share/network-speed/`. Each command logs activity with timestamps for full traceability. When called without arguments, data commands display their most recent 20 entries. When called with arguments, they append a new timestamped entry and update the unified history log.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
