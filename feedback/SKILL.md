---
name: feedback
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [feedback, tool, utility]
description: "Feedback - command-line tool for everyday use"
---

# Feedback

Feedback collector — gather user feedback, categorize, prioritize, and track resolution.

## Commands

| Command | Description |
|---------|-------------|
| `feedback help` | Show usage info |
| `feedback run` | Run main task |
| `feedback status` | Check current state |
| `feedback list` | List items |
| `feedback add <item>` | Add new item |
| `feedback export <fmt>` | Export data |

## Usage

```bash
feedback help
feedback run
feedback status
```

## Examples

```bash
# Get started
feedback help

# Run default task
feedback run

# Export as JSON
feedback export json
```

## Output

Results go to stdout. Save with `feedback run > output.txt`.

## Configuration

Set `FEEDBACK_DIR` to change data directory. Default: `~/.local/share/feedback/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
