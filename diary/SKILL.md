---
name: diary
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [diary, tool, utility]
description: "Diary - command-line tool for everyday use"
---

# Diary

Digital diary — daily entries, mood tracking, tag system, search, photo attachments, export, and monthly summaries.

## Commands

| Command | Description |
|---------|-------------|
| `diary run` | Execute main function |
| `diary list` | List all items |
| `diary add <item>` | Add new item |
| `diary status` | Show current status |
| `diary export <format>` | Export data |
| `diary help` | Show help |

## Usage

```bash
# Show help
diary help

# Quick start
diary run
```

## Examples

```bash
# Run with defaults
diary run

# Check status
diary status

# Export results
diary export json
```

## How It Works


## Tips

- Run `diary help` for all commands
- Data stored in `~/.local/share/diary/`


## When to Use

- to automate diary tasks in your workflow
- for batch processing diary operations

## Output

Returns formatted output to stdout. Redirect to a file with `diary run > output.txt`.

## Configuration

Set `DIARY_DIR` environment variable to change the data directory. Default: `~/.local/share/diary/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
