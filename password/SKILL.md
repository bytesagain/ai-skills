---
name: password
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [password, tool, utility]
description: "Password - command-line tool for everyday use"
---

# Password

Password manager — generate strong passwords, check strength, store credentials locally, breach checking, and secure export.

## Commands

| Command | Description |
|---------|-------------|
| `password run` | Execute main function |
| `password list` | List all items |
| `password add <item>` | Add new item |
| `password status` | Show current status |
| `password export <format>` | Export data |
| `password help` | Show help |

## Usage

```bash
# Show help
password help

# Quick start
password run
```

## Examples

```bash
# Run with defaults
password run

# Check status
password status

# Export results
password export json
```

- Run `password help` for all commands
password/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `password help` for all commands

## Output

Results go to stdout. Save with `password run > output.txt`.

## Configuration

Set `PASSWORD_DIR` to change data directory. Default: `~/.local/share/password/`
