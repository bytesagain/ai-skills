---
name: validator
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [validator, tool, utility]
description: "Validator - command-line tool for everyday use"
---

# Validator

Input validator — check emails, URLs, phone numbers, dates, and custom patterns.

## Commands

| Command | Description |
|---------|-------------|
| `validator help` | Show usage info |
| `validator run` | Run main task |
| `validator status` | Check current state |
| `validator list` | List items |
| `validator add <item>` | Add new item |
| `validator export <fmt>` | Export data |

## Usage

```bash
validator help
validator run
validator status
```

## Examples

```bash
# Get started
validator help

# Run default task
validator run

# Export as JSON
validator export json
```

## Output

Results go to stdout. Save with `validator run > output.txt`.

## Configuration

Set `VALIDATOR_DIR` to change data directory. Default: `~/.local/share/validator/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
