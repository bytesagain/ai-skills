---
name: sketch
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [sketch, tool, utility]
description: "Sketch - command-line tool for everyday use"
---

# Sketch

ASCII sketch tool — text-based diagrams, flowcharts, wireframes, box drawing, arrow connections, and export to image.

## Commands

| Command | Description |
|---------|-------------|
| `sketch run` | Execute main function |
| `sketch list` | List all items |
| `sketch add <item>` | Add new item |
| `sketch status` | Show current status |
| `sketch export <format>` | Export data |
| `sketch help` | Show help |

## Usage

```bash
# Show help
sketch help

# Quick start
sketch run
```

## Examples

```bash
# Run with defaults
sketch run

# Check status
sketch status

# Export results
sketch export json
```

- Run `sketch help` for all commands
- Data stored in `~/.local/share/sketch/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `sketch help` for all commands

## Output

Results go to stdout. Save with `sketch run > output.txt`.

## Configuration

Set `SKETCH_DIR` to change data directory. Default: `~/.local/share/sketch/`
