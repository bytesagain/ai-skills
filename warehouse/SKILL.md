---
name: warehouse
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [warehouse, tool, utility]
description: "Warehouse - command-line tool for everyday use"
---

# Warehouse

Data warehouse toolkit — schema design, query optimization, data partitioning, aggregation pipelines, and storage management.

## Commands

| Command | Description |
|---------|-------------|
| `warehouse run` | Execute main function |
| `warehouse list` | List all items |
| `warehouse add <item>` | Add new item |
| `warehouse status` | Show current status |
| `warehouse export <format>` | Export data |
| `warehouse help` | Show help |

## Usage

```bash
# Show help
warehouse help

# Quick start
warehouse run
```

## Examples

```bash
# Run with defaults
warehouse run

# Check status
warehouse status

# Export results
warehouse export json
```

- Run `warehouse help` for all commands
- Data stored in `~/.local/share/warehouse/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Output

Results go to stdout. Save with `warehouse run > output.txt`.

## Configuration

Set `WAREHOUSE_DIR` to change data directory. Default: `~/.local/share/warehouse/`
