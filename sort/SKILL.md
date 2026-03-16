---
name: sort
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [sort, tool, utility]
description: "Sort - command-line tool for everyday use"
---

# Sort

Sort toolkit — sort files, lines, columns, custom ordering, and deduplication.

## Commands

| Command | Description |
|---------|-------------|
| `sort help` | Show usage info |
| `sort run` | Run main task |
| `sort status` | Check state |
| `sort list` | List items |
| `sort add <item>` | Add item |
| `sort export <fmt>` | Export data |

## Usage

```bash
sort help
sort run
sort status
```

## Examples

```bash
sort help
sort run
sort export json
```

## Output

Results go to stdout. Save with `sort run > output.txt`.

## Configuration

Set `SORT_DIR` to change data directory. Default: `~/.local/share/sort/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- Status monitoring and health checks
- No external dependencies required

## Quick Start

```bash
# Check status
sort status

# View help and available commands
sort help

# View statistics
sort stats

# Export your data
sort export json
```

## How It Works

Sort stores all data locally in `~/.local/share/sort/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary, or `export` to back up your data in JSON, CSV, or plain text format.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com
- Email: hello@bytesagain.com

Powered by BytesAgain | bytesagain.com
