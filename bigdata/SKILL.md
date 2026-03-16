---
name: bigdata
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [bigdata, tool, utility]
description: "Bigdata - command-line tool for everyday use"
---

# BigData

Big data processing toolkit — large file splitting, parallel processing, data sampling, streaming analysis, and batch operations.

## Commands

| Command | Description |
|---------|-------------|
| `bigdata run` | Execute main function |
| `bigdata list` | List all items |
| `bigdata add <item>` | Add new item |
| `bigdata status` | Show current status |
| `bigdata export <format>` | Export data |
| `bigdata help` | Show help |

## Usage

```bash
# Show help
bigdata help

# Quick start
bigdata run
```

## Examples

```bash
# Run with defaults
bigdata run

# Check status
bigdata status

# Export results
bigdata export json
```

- Run `bigdata help` for all commands
bigdata/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `bigdata help` for all commands

## When to Use

- Quick bigdata tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `bigdata run > output.txt`.
