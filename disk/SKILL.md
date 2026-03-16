---
name: disk
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [disk, tool, utility]
description: "Disk - command-line tool for everyday use"
---

# Disk

Disk monitor — usage stats, cleanup suggestions, partition info, and space alerts.

## Commands

| Command | Description |
|---------|-------------|
| `disk help` | Show usage info |
| `disk run` | Run main task |
| `disk status` | Check state |
| `disk list` | List items |
| `disk add <item>` | Add item |
| `disk export <fmt>` | Export data |

## Usage

```bash
disk help
disk run
disk status
```

## Examples

```bash
disk help
disk run
disk export json
```

## Output

Results go to stdout. Save with `disk run > output.txt`.

## Configuration

Set `DISK_DIR` to change data directory. Default: `~/.local/share/disk/`

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
disk status

# View help and available commands
disk help

# View statistics
disk stats

# Export your data
disk export json
```

## How It Works

Disk stores all data locally in `~/.local/share/disk/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary, or `export` to back up your data in JSON, CSV, or plain text format.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com
- Email: hello@bytesagain.com

Powered by BytesAgain | bytesagain.com
