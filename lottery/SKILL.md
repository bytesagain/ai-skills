---
name: lottery
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [lottery, tool, utility]
description: "Lottery - command-line tool for everyday use"
---

# Lottery

Lottery toolkit — number generator, odds calculator, result checker, and statistics.

## Commands

| Command | Description |
|---------|-------------|
| `lottery help` | Show usage info |
| `lottery run` | Run main task |
| `lottery status` | Check state |
| `lottery list` | List items |
| `lottery add <item>` | Add item |
| `lottery export <fmt>` | Export data |

## Usage

```bash
lottery help
lottery run
lottery status
```

## Examples

```bash
lottery help
lottery run
lottery export json
```

## Output

Results go to stdout. Save with `lottery run > output.txt`.

## Configuration

Set `LOTTERY_DIR` to change data directory. Default: `~/.local/share/lottery/`

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
lottery status

# View help
lottery help

# Export data
lottery export json
```

## How It Works

Lottery stores all data locally in `~/.local/share/lottery/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
