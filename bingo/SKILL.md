---
name: bingo
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [bingo, tool, utility]
description: "Bingo - command-line tool for everyday use"
---

# Bingo

Bingo toolkit — card generator, number caller, pattern checking, and game management.

## Commands

| Command | Description |
|---------|-------------|
| `bingo help` | Show usage info |
| `bingo run` | Run main task |
| `bingo status` | Check state |
| `bingo list` | List items |
| `bingo add <item>` | Add item |
| `bingo export <fmt>` | Export data |

## Usage

```bash
bingo help
bingo run
bingo status
```

## Examples

```bash
bingo help
bingo run
bingo export json
```

## Output

Results go to stdout. Save with `bingo run > output.txt`.

## Configuration

Set `BINGO_DIR` to change data directory. Default: `~/.local/share/bingo/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries

## Quick Start

```bash
# Check status
bingo status

# View help
bingo help

# Export data
bingo export json
```

## How It Works

Bingo stores all data locally in `~/.local/share/bingo/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
