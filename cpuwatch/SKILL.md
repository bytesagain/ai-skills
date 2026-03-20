---
name: CPUWatch
description: "Watch real-time CPU utilization with per-core breakdown and alerts. Use when monitoring spikes, identifying runaway processes, tracking cores."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["cpu","monitor","process","performance","system","admin","devops"]
categories: ["Developer Tools", "Utility"]
---

# CPUWatch

Sysops toolkit for CPU monitoring and system operations. Log scan results, monitor entries, alerts, benchmarks, and more — all with timestamped entries, export, and search.

## Commands

| Command | What it does |
|---------|-------------|
| `cpuwatch scan <input>` | Log a scan entry. Without args, shows recent entries. |
| `cpuwatch monitor <input>` | Log a monitor entry. Without args, shows recent entries. |
| `cpuwatch report <input>` | Log a report entry. Without args, shows recent entries. |
| `cpuwatch alert <input>` | Log an alert entry. Without args, shows recent entries. |
| `cpuwatch top <input>` | Log a top-processes entry. Without args, shows recent entries. |
| `cpuwatch usage <input>` | Log a usage entry. Without args, shows recent entries. |
| `cpuwatch check <input>` | Log a check entry. Without args, shows recent entries. |
| `cpuwatch fix <input>` | Log a fix entry. Without args, shows recent entries. |
| `cpuwatch cleanup <input>` | Log a cleanup entry. Without args, shows recent entries. |
| `cpuwatch backup <input>` | Log a backup entry. Without args, shows recent entries. |
| `cpuwatch restore <input>` | Log a restore entry. Without args, shows recent entries. |
| `cpuwatch log <input>` | Log a general log entry. Without args, shows recent entries. |
| `cpuwatch benchmark <input>` | Log a benchmark entry. Without args, shows recent entries. |
| `cpuwatch compare <input>` | Log a comparison entry. Without args, shows recent entries. |
| `cpuwatch stats` | Show summary statistics across all log files. |
| `cpuwatch export <fmt>` | Export all data to json, csv, or txt format. |
| `cpuwatch search <term>` | Search all entries for a keyword. |
| `cpuwatch recent` | Show last 20 history entries. |
| `cpuwatch status` | Health check — version, data dir, entry count, disk usage. |
| `cpuwatch help` | Show help message. |
| `cpuwatch version` | Show version (v2.0.0). |

## Requirements

- Bash 4+

## When to Use

- Logging CPU scan results after a performance investigation
- Recording alerts when CPU spikes above thresholds
- Tracking system fixes and cleanup actions over time
- Benchmarking CPU performance before and after configuration changes
- Exporting monitoring data for external dashboards or reports

## Examples

```bash
# Log a CPU scan result
cpuwatch scan "web-server-01 avg 78% across 8 cores"

# Record an alert
cpuwatch alert "CPU spike 95% on pid 3421 (java) at 14:30"

# Export all monitoring data as JSON
cpuwatch export json

# Search for entries about a specific server
cpuwatch search web-server
```

## Data Storage

Data stored in `~/.local/share/cpuwatch/`. Each command writes to its own `.log` file with timestamped entries. All actions are also recorded in `history.log`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
