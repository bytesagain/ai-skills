---
name: lyrics
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [lyrics, tool, utility]
description: "Lyrics - command-line tool for everyday use"
---

# Lyrics

Lyrics toolkit — songwriting assistant, rhyme finder, syllable counter, verse structure, chorus patterns, and format export.

## Commands

| Command | Description |
|---------|-------------|
| `lyrics run` | Execute main function |
| `lyrics list` | List all items |
| `lyrics add <item>` | Add new item |
| `lyrics status` | Show current status |
| `lyrics export <format>` | Export data |
| `lyrics help` | Show help |

## Usage

```bash
# Show help
lyrics help

# Quick start
lyrics run
```

## Examples

```bash
# Run with defaults
lyrics run

# Check status
lyrics status

# Export results
lyrics export json
```

- Run `lyrics help` for all commands
- Data stored in `~/.local/share/lyrics/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Output

Results go to stdout. Save with `lyrics run > output.txt`.

## Output

Results go to stdout. Save with `lyrics run > output.txt`.

## Configuration

Set `LYRICS_DIR` to change data directory. Default: `~/.local/share/lyrics/`
