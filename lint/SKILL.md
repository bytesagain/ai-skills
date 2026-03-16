---
name: lint
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [lint, tool, utility]
description: "Lint - command-line tool for everyday use"
---

# Lint

Code linter — syntax checking, style enforcement, error detection, auto-fix suggestions, config management, and CI integration.

## Commands

| Command | Description |
|---------|-------------|
| `lint run` | Execute main function |
| `lint list` | List all items |
| `lint add <item>` | Add new item |
| `lint status` | Show current status |
| `lint export <format>` | Export data |
| `lint help` | Show help |

## Usage

```bash
# Show help
lint help

# Quick start
lint run
```

## Examples

```bash
# Run with defaults
lint run

# Check status
lint status

# Export results
lint export json
```

- Run `lint help` for all commands
- Data stored in `~/.local/share/lint/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick lint tasks from terminal
- Automation pipelines

## When to Use

- Quick lint tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `lint run > output.txt`.
