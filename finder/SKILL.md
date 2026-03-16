---
name: finder
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [finder, tool, utility]
description: "Finder - command-line tool for everyday use"
---

# Finder

File finder — locate files by name, content, size, date, type, duplicates detection, and bulk operations.

## Commands

| Command | Description |
|---------|-------------|
| `finder run` | Execute main function |
| `finder list` | List all items |
| `finder add <item>` | Add new item |
| `finder status` | Show current status |
| `finder export <format>` | Export data |
| `finder help` | Show help |

## Usage

```bash
# Show help
finder help

# Quick start
finder run
```

## Examples

```bash
# Run with defaults
finder run

# Check status
finder status

# Export results
finder export json
```

- Run `finder help` for all commands
finder/`

## When to Use

- for batch processing finder operations
- as part of a larger automation pipeline

## Output

Returns structured data to stdout. Redirect to a file with `finder run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
