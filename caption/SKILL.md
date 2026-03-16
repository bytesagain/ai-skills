---
name: caption
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [caption, tool, utility]
description: "Caption - command-line tool for everyday use"
---

# Caption

Caption generator — create captions for images, videos, social media posts, alt text, subtitle formatting, and batch processing.

## Commands

| Command | Description |
|---------|-------------|
| `caption run` | Execute main function |
| `caption list` | List all items |
| `caption add <item>` | Add new item |
| `caption status` | Show current status |
| `caption export <format>` | Export data |
| `caption help` | Show help |

## Usage

```bash
# Show help
caption help

# Quick start
caption run
```

## Examples

```bash
# Run with defaults
caption run

# Check status
caption status

# Export results
caption export json
```

## How It Works


## Tips

- Run `caption help` for all commands
- Data stored in `~/.local/share/caption/`


## When to Use

- to automate caption tasks in your workflow
- for batch processing caption operations

## Output

Returns results to stdout. Redirect to a file with `caption run > output.txt`.

## Configuration

Set `CAPTION_DIR` environment variable to change the data directory. Default: `~/.local/share/caption/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
