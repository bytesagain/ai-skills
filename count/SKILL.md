---
name: count
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [count, tool, utility]
description: "Count - command-line tool for everyday use"
---

# Count

Count toolkit — word count, line count, character frequency, and file statistics.

## Commands

| Command | Description |
|---------|-------------|
| `count help` | Show usage info |
| `count run` | Run main task |
| `count status` | Check state |
| `count list` | List items |
| `count add <item>` | Add item |
| `count export <fmt>` | Export data |

## Usage

```bash
count help
count run
count status
```

## Examples

```bash
count help
count run
count export json
```

## Output

Results go to stdout. Save with `count run > output.txt`.

## Configuration

Set `COUNT_DIR` to change data directory. Default: `~/.local/share/count/`

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
count status

# View help and available commands
count help

# View statistics
count stats

# Export your data
count export json
```

## How It Works

Count stores all data locally in `~/.local/share/count/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary, or `export` to back up your data in JSON, CSV, or plain text format.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com
- Email: hello@bytesagain.com

Powered by BytesAgain | bytesagain.com
