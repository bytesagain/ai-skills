---
name: trivia
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [trivia, tool, utility]
description: "Trivia - command-line tool for everyday use"
---

# Trivia

Trivia toolkit — question banks, quiz rounds, scoring, and category management.

## Commands

| Command | Description |
|---------|-------------|
| `trivia help` | Show usage info |
| `trivia run` | Run main task |
| `trivia status` | Check state |
| `trivia list` | List items |
| `trivia add <item>` | Add item |
| `trivia export <fmt>` | Export data |

## Usage

```bash
trivia help
trivia run
trivia status
```

## Examples

```bash
trivia help
trivia run
trivia export json
```

## Output

Results go to stdout. Save with `trivia run > output.txt`.

## Configuration

Set `TRIVIA_DIR` to change data directory. Default: `~/.local/share/trivia/`

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
trivia status

# View help
trivia help

# Export data
trivia export json
```

## How It Works

Trivia stores all data locally in `~/.local/share/trivia/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
