---
version: "1.0.0"
name: Nebula
description: "Configure encrypted overlay mesh networks focused on performance and simplicity. Use when setting up VPN meshes, connecting nodes, managing tunnels."
---
# Mesh Network

Sysops toolkit for scanning, monitoring, reporting, alerting, and managing network infrastructure. Mesh Network provides a complete operations workflow — scan nodes, monitor services, generate reports, set alerts, track usage, run benchmarks, manage backups, and compare configurations. All entries are timestamped and stored locally for full traceability.

## Commands

### Monitoring & Scanning
| Command | Description |
|---------|-------------|
| `mesh-network scan <input>` | Scan network nodes or services. Run without args to view recent scan entries |
| `mesh-network monitor <input>` | Log monitoring observations. Run without args to view recent monitor entries |
| `mesh-network top <input>` | Record top resource consumers or metrics. Run without args to view recent top entries |
| `mesh-network usage <input>` | Track resource usage data. Run without args to view recent usage entries |
| `mesh-network check <input>` | Run health or connectivity checks. Run without args to view recent check entries |

### Alerting & Reporting
| Command | Description |
|---------|-------------|
| `mesh-network alert <input>` | Create or log alert events. Run without args to view recent alert entries |
| `mesh-network report <input>` | Generate operational reports. Run without args to view recent report entries |
| `mesh-network log <input>` | Record custom log entries. Run without args to view recent log entries |
| `mesh-network benchmark <input>` | Run or record benchmark results. Run without args to view recent benchmark entries |
| `mesh-network compare <input>` | Compare configurations or metrics. Run without args to view recent compare entries |

### Maintenance & Recovery
| Command | Description |
|---------|-------------|
| `mesh-network fix <input>` | Log fix actions or remediation steps. Run without args to view recent fix entries |
| `mesh-network cleanup <input>` | Record cleanup operations. Run without args to view recent cleanup entries |
| `mesh-network backup <input>` | Log backup operations. Run without args to view recent backup entries |
| `mesh-network restore <input>` | Log restore operations. Run without args to view recent restore entries |

### Utility Commands
| Command | Description |
|---------|-------------|
| `mesh-network stats` | Show summary statistics across all entry types |
| `mesh-network export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `mesh-network search <term>` | Search across all entries by keyword |
| `mesh-network recent` | Show the 20 most recent activity log entries |
| `mesh-network status` | Health check — version, data dir, entry count, disk usage |
| `mesh-network help` | Show usage information and available commands |
| `mesh-network version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/mesh-network/`:

- Each command type has its own log file (e.g., `scan.log`, `monitor.log`, `alert.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|value` format
- A unified `history.log` tracks all activity across commands
- Export supports JSON, CSV, and plain text formats
- No external services or API keys required

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)
- No external dependencies — works on any POSIX-compatible system

## When to Use

1. **Network monitoring** — Use `scan`, `monitor`, and `check` to track node health, service availability, and connectivity across your mesh network
2. **Incident response** — Use `alert`, `fix`, and `log` to document incidents, remediation steps, and resolution timelines
3. **Capacity planning** — Use `usage`, `top`, and `benchmark` to track resource consumption and performance baselines over time
4. **Backup & disaster recovery** — Use `backup`, `restore`, and `cleanup` to log all maintenance operations with timestamped audit trails
5. **Infrastructure auditing** — Use `stats`, `search`, `compare`, and `export` to review operational history, compare configurations, and generate compliance reports

## Examples

```bash
# Scan network nodes
mesh-network scan "192.168.1.0/24 — checking all nodes for availability"

# Log a monitoring observation
mesh-network monitor "Node-7 latency spike: 250ms avg over last 15 min"

# Create an alert
mesh-network alert "Disk usage on gateway-01 exceeded 90% threshold"

# Record a fix action
mesh-network fix "Restarted nginx on node-3, cleared stale connections"

# Log a backup operation
mesh-network backup "Full backup of mesh config completed — 2.4GB to /mnt/backup"

# Search for all entries about a specific node
mesh-network search gateway-01

# Export all data as JSON
mesh-network export json

# View overall statistics
mesh-network stats
```

## How It Works

Each operations command (scan, monitor, alert, etc.) works the same way:
- **With arguments**: Saves the input as a new timestamped entry and logs it to history
- **Without arguments**: Displays the 20 most recent entries for that command type

This makes Mesh Network both an operations tool and a searchable ops journal.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
