---
name: rating
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [rating, tool, utility]
description: "Rating - command-line tool for everyday use"
---

# Rating

Rating system — star ratings, score calculations, ranking, and review management.

## Commands

| Command | Description |
|---------|-------------|
| `rating help` | Show usage info |
| `rating run` | Run main task |
| `rating status` | Check current state |
| `rating list` | List items |
| `rating add <item>` | Add new item |
| `rating export <fmt>` | Export data |

## Usage

```bash
rating help
rating run
rating status
```

## Examples

```bash
# Get started
rating help

# Run default task
rating run

# Export as JSON
rating export json
```

## Output

Results go to stdout. Save with `rating run > output.txt`.

## Configuration

Set `RATING_DIR` to change data directory. Default: `~/.local/share/rating/`

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
rating status

# View help
rating help

# Export data
rating export json
```

## How It Works

Rating stores all data locally in `~/.local/share/rating/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
