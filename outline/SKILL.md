---
name: outline
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [outline, tool, utility]
description: "Outline - command-line tool for everyday use"
---

# Outline

Document outline generator — create structured outlines, table of contents, chapter planning, hierarchy management, and export.

## Commands

| Command | Description |
|---------|-------------|
| `outline run` | Execute main function |
| `outline list` | List all items |
| `outline add <item>` | Add new item |
| `outline status` | Show current status |
| `outline export <format>` | Export data |
| `outline help` | Show help |

## Usage

```bash
# Show help
outline help

# Quick start
outline run
```

## Examples

```bash
# Run with defaults
outline run

# Check status
outline status

# Export results
outline export json
```

## How It Works


## Tips

- Run `outline help` for all commands
- Data stored in `~/.local/share/outline/`


## When to Use

- to automate outline tasks in your workflow
- for batch processing outline operations

## Output

Returns logs to stdout. Redirect to a file with `outline run > output.txt`.

## Configuration

Set `OUTLINE_DIR` environment variable to change the data directory. Default: `~/.local/share/outline/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
