---
version: "1.0.0"
name: Docker Analyzer
description: "Inspect Docker image layers and find size optimization opportunities. Use when auditing image sizes, comparing layers, benchmarking builds."
---

# Container Analyzer

AI toolkit for container analysis — configure, benchmark, compare, and optimize container workflows. Log-based data tracking with timestamped entries, export, and search.

## Commands

| Command | What it does |
|---------|-------------|
| `container-analyzer configure <input>` | Log a configuration entry. Without args, shows recent entries. |
| `container-analyzer benchmark <input>` | Log a benchmark result. Without args, shows recent entries. |
| `container-analyzer compare <input>` | Log a comparison entry. Without args, shows recent entries. |
| `container-analyzer prompt <input>` | Log a prompt entry. Without args, shows recent entries. |
| `container-analyzer evaluate <input>` | Log an evaluation entry. Without args, shows recent entries. |
| `container-analyzer fine-tune <input>` | Log a fine-tune entry. Without args, shows recent entries. |
| `container-analyzer analyze <input>` | Log an analysis entry. Without args, shows recent entries. |
| `container-analyzer cost <input>` | Log a cost entry. Without args, shows recent entries. |
| `container-analyzer usage <input>` | Log a usage entry. Without args, shows recent entries. |
| `container-analyzer optimize <input>` | Log an optimization entry. Without args, shows recent entries. |
| `container-analyzer test <input>` | Log a test entry. Without args, shows recent entries. |
| `container-analyzer report <input>` | Log a report entry. Without args, shows recent entries. |
| `container-analyzer stats` | Show summary statistics across all log files. |
| `container-analyzer export <fmt>` | Export all data to json, csv, or txt format. |
| `container-analyzer search <term>` | Search all entries for a keyword. |
| `container-analyzer recent` | Show last 20 history entries. |
| `container-analyzer status` | Health check — version, data dir, entry count, disk usage. |
| `container-analyzer help` | Show help message. |
| `container-analyzer version` | Show version (v2.0.0). |

## Requirements

- Bash 4+

## When to Use

- Tracking container image benchmark results over time
- Comparing container configurations and logging the differences
- Recording cost analysis entries for container infrastructure
- Exporting accumulated container data for external reporting
- Searching historical container optimization notes

## Examples

```bash
# Log a benchmark result
container-analyzer benchmark "nginx:alpine build time 12s, size 23MB"

# Export all data as CSV
container-analyzer export csv

# Search for entries mentioning nginx
container-analyzer search nginx

# View overall statistics
container-analyzer stats
```

## Data Storage

Data stored in `~/.local/share/container-analyzer/`. Each command writes to its own `.log` file with timestamped entries. All actions are also recorded in `history.log`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
