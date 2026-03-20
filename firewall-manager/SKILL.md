---
version: "1.0.0"
name: Simplewall
description: "Simple tool to configure Windows Filtering Platform (WFP) which can configure network activity on yo firewall-manager, c, arm64, firewall, foss, network."
---
# Firewall Manager

A sysops toolkit for logging, tracking, and managing firewall and network operations. Each command records timestamped entries to its own log file for auditing and review.

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `scan <input>` | Log a scan entry (view recent entries if no input given) |
| `monitor <input>` | Log a monitor entry for monitoring tasks |
| `report <input>` | Log a report entry for reporting tasks |
| `alert <input>` | Log an alert entry for alert tracking |
| `top <input>` | Log a top entry for top-level summaries |
| `usage <input>` | Log a usage entry for usage monitoring |
| `check <input>` | Log a check entry for verification tasks |
| `fix <input>` | Log a fix entry for remediation tasks |
| `cleanup <input>` | Log a cleanup entry for cleanup operations |
| `backup <input>` | Log a backup entry for backup operations |
| `restore <input>` | Log a restore entry for restore operations |
| `log <input>` | Log a log entry for general logging |
| `benchmark <input>` | Log a benchmark entry for performance testing |
| `compare <input>` | Log a compare entry for comparison tasks |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Search all log entries for a term (case-insensitive) |
| `recent` | Show the 20 most recent entries from history |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show available commands |
| `version` | Show version (v2.0.0) |

## Data Storage

All data is stored in `~/.local/share/firewall-manager/`:

- Each command writes to its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`)
- All actions are also recorded in `history.log` with timestamps
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`
- Log format: `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)

## Requirements

- Bash (no external dependencies)
- Works on Linux and macOS

## When to Use

- When you need to track firewall scan and monitoring activities
- To maintain an audit trail of alerts, fixes, and cleanup operations
- When managing backup and restore records for firewall configurations
- For benchmarking and comparing firewall performance across environments
- To search or export historical firewall operation logs
- When tracking usage patterns and generating reports

## Examples

```bash
# Log sysops operations
firewall-manager scan "port scan on 192.168.1.0/24"
firewall-manager monitor "watch inbound traffic on eth0"
firewall-manager alert "blocked 15 connections from 10.0.0.5"
firewall-manager check "verify iptables rules"
firewall-manager fix "patch rule for port 443"
firewall-manager cleanup "remove expired temp rules"
firewall-manager backup "full ruleset backup 2025-03-18"
firewall-manager restore "rollback to last known good config"
firewall-manager log "manual override applied by admin"
firewall-manager benchmark "throughput test with 10k connections"
firewall-manager compare "iptables vs nftables performance"
firewall-manager report "weekly security summary"

# View recent entries for a command (no args)
firewall-manager scan
firewall-manager alert

# Search and export
firewall-manager search "port 443"
firewall-manager export json
firewall-manager stats
firewall-manager recent
firewall-manager status
```

## Output

All commands output to stdout. Redirect with `firewall-manager report > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
