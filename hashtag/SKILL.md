---
name: hashtag
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [hashtag, tool, utility]
description: "Hashtag - command-line tool for everyday use"
---

# Hashtag

Hashtag toolkit — hashtag research, trending detection, relevance scoring, set generation, competition analysis, and performance tracking.

## Commands

| Command | Description |
|---------|-------------|
| `hashtag run` | Execute main function |
| `hashtag list` | List all items |
| `hashtag add <item>` | Add new item |
| `hashtag status` | Show current status |
| `hashtag export <format>` | Export data |
| `hashtag help` | Show help |

## Usage

```bash
# Show help
hashtag help

# Quick start
hashtag run
```

## Examples

```bash
# Run with defaults
hashtag run

# Check status
hashtag status

# Export results
hashtag export json
```

- Run `hashtag help` for all commands
- Data stored in `~/.local/share/hashtag/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Configuration

Set `HASHTAG_DIR` to change data directory. Default: `~/.local/share/hashtag/`

## When to Use

- Quick hashtag tasks from terminal
- Automation pipelines
