---
name: etl
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [etl, tool, utility]
description: "Etl - command-line tool for everyday use"
---

# ETL

Extract-Transform-Load pipeline toolkit — data extraction, format conversion, cleaning, validation, loading, and pipeline scheduling.

## Commands

| Command | Description |
|---------|-------------|
| `etl run` | Execute main function |
| `etl list` | List all items |
| `etl add <item>` | Add new item |
| `etl status` | Show current status |
| `etl export <format>` | Export data |
| `etl help` | Show help |

## Usage

```bash
# Show help
etl help

# Quick start
etl run
```

## Examples

```bash
# Run with defaults
etl run

# Check status
etl status

# Export results
etl export json
```

- Run `etl help` for all commands
- Data stored in `~/.local/share/etl/`

## When to Use

- as part of a larger automation pipeline
- when you need quick etl from the command line

## Output

Returns structured data to stdout. Redirect to a file with `etl run > output.txt`.

## Configuration

Set `ETL_DIR` environment variable to change the data directory. Default: `~/.local/share/etl/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
