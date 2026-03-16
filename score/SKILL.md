---
name: score
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [score, tool, utility]
description: "Score - command-line tool for everyday use"
---

# Score

Score tracker — game scores, tournament brackets, standings, and statistics.

## Commands

| Command | Description |
|---------|-------------|
| `score help` | Show usage info |
| `score run` | Run main task |
| `score status` | Check state |
| `score list` | List items |
| `score add <item>` | Add item |
| `score export <fmt>` | Export data |

## Usage

```bash
score help
score run
score status
```

## Examples

```bash
score help
score run
score export json
```

## Output

Results go to stdout. Save with `score run > output.txt`.

## Configuration

Set `SCORE_DIR` to change data directory. Default: `~/.local/share/score/`

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
score status

# View help
score help

# Export data
score export json
```

## How It Works

Score stores all data locally in `~/.local/share/score/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
