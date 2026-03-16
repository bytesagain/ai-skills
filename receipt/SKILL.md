---
name: receipt
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [receipt, tool, utility]
description: "Receipt - command-line tool for everyday use"
---

# Receipt

Receipt manager — scan, organize, categorize, total, and export receipts.

## Commands

| Command | Description |
|---------|-------------|
| `receipt help` | Show usage info |
| `receipt run` | Run main task |
| `receipt status` | Check state |
| `receipt list` | List items |
| `receipt add <item>` | Add item |
| `receipt export <fmt>` | Export data |

## Usage

```bash
receipt help
receipt run
receipt status
```

## Examples

```bash
receipt help
receipt run
receipt export json
```

## Output

Results go to stdout. Save with `receipt run > output.txt`.

## Configuration

Set `RECEIPT_DIR` to change data directory. Default: `~/.local/share/receipt/`

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
receipt status

# View help and available commands
receipt help

# View statistics
receipt stats

# Export your data
receipt export json
```

## How It Works

Receipt stores all data locally in `~/.local/share/receipt/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary, or `export` to back up your data in JSON, CSV, or plain text format.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com
- Email: hello@bytesagain.com

Powered by BytesAgain | bytesagain.com
