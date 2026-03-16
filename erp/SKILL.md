---
name: erp
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [erp, tool, utility]
description: "Erp - command-line tool for everyday use"
---

# ERP

Enterprise resource planning toolkit — manage business processes, track resources, inventory planning, department coordination, and reporting.

## Commands

| Command | Description |
|---------|-------------|
| `erp run` | Execute main function |
| `erp list` | List all items |
| `erp add <item>` | Add new item |
| `erp status` | Show current status |
| `erp export <format>` | Export data |
| `erp help` | Show help |

## Usage

```bash
# Show help
erp help

# Quick start
erp run
```

## Examples

```bash
# Run with defaults
erp run

# Check status
erp status

# Export results
erp export json
```

- Run `erp help` for all commands
- Data stored in `~/.local/share/erp/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `erp help` for all commands

## Output

Results go to stdout. Save with `erp run > output.txt`.

## Output

Results go to stdout. Save with `erp run > output.txt`.

## Configuration

Set `ERP_DIR` to change data directory. Default: `~/.local/share/erp/`
