---
name: sms
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [sms, tool, utility]
description: "Sms - command-line tool for everyday use"
---

# SMS

SMS toolkit — send messages, manage contacts, template management, delivery tracking, bulk sending, and conversation history.

## Commands

| Command | Description |
|---------|-------------|
| `sms run` | Execute main function |
| `sms list` | List all items |
| `sms add <item>` | Add new item |
| `sms status` | Show current status |
| `sms export <format>` | Export data |
| `sms help` | Show help |

## Usage

```bash
# Show help
sms help

# Quick start
sms run
```

## Examples

```bash
# Run with defaults
sms run

# Check status
sms status

# Export results
sms export json
```

- Run `sms help` for all commands
- Data stored in `~/.local/share/sms/`

## When to Use

- for batch processing sms operations
- as part of a larger automation pipeline

## Output

Returns formatted output to stdout. Redirect to a file with `sms run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
