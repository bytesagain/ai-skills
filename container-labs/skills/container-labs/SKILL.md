---
version: "1.0.0"
name: Dockerlabs
description: "This is a collection of tutorials for learning how to use Docker with various tools. Contributions w docker-labs, php, containers, docker, docker-compose."
---

# Container Labs

AI toolkit for container lab experiments — configure, benchmark, compare, and track container workflows. Log-based data tracking with timestamped entries, export, and search.

## Commands

| Command | What it does |
|---------|-------------|
| `container-labs configure <input>` | Log a configuration entry. Without args, shows recent entries. |
| `container-labs benchmark <input>` | Log a benchmark result. Without args, shows recent entries. |
| `container-labs compare <input>` | Log a comparison entry. Without args, shows recent entries. |
| `container-labs prompt <input>` | Log a prompt entry. Without args, shows recent entries. |
| `container-labs evaluate <input>` | Log an evaluation entry. Without args, shows recent entries. |
| `container-labs fine-tune <input>` | Log a fine-tune entry. Without args, shows recent entries. |
| `container-labs analyze <input>` | Log an analysis entry. Without args, shows recent entries. |
| `container-labs cost <input>` | Log a cost entry. Without args, shows recent entries. |
| `container-labs usage <input>` | Log a usage entry. Without args, shows recent entries. |
| `container-labs optimize <input>` | Log an optimization entry. Without args, shows recent entries. |
| `container-labs test <input>` | Log a test entry. Without args, shows recent entries. |
| `container-labs report <input>` | Log a report entry. Without args, shows recent entries. |
| `container-labs stats` | Show summary statistics across all log files. |
| `container-labs export <fmt>` | Export all data to json, csv, or txt format. |
| `container-labs search <term>` | Search all entries for a keyword. |
| `container-labs recent` | Show last 20 history entries. |
| `container-labs status` | Health check — version, data dir, entry count, disk usage. |
| `container-labs help` | Show help message. |
| `container-labs version` | Show version (v2.0.0). |

## Requirements

- Bash 4+

## When to Use

- Logging Docker lab experiment results and configurations
- Benchmarking different container setups and recording outcomes
- Comparing container images or compose configurations over time
- Exporting lab data for sharing or external analysis
- Tracking costs and usage across container experiments

## Examples

```bash
# Log a benchmark for a Docker Compose setup
container-labs benchmark "3-node redis cluster startup 8.2s"

# Search for all entries related to postgres
container-labs search postgres

# Export everything to JSON
container-labs export json

# Check overall lab statistics
container-labs stats
```

## Data Storage

Data stored in `~/.local/share/container-labs/`. Each command writes to its own `.log` file with timestamped entries. All actions are also recorded in `history.log`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
