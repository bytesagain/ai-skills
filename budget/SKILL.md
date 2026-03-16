---
name: "Budget"
description: "A focused personal finance tool built for Budget. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["planning", "budget", "tracking", "finance", "accounting"]
---

# Budget

A focused personal finance tool built for Budget. Log entries, review trends, and export reports — all locally.

## Why Budget?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
budget help

# Check current status
budget status

# View your statistics
budget stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `budget Running:` | $1 |
| `budget Config:` | $DATA_DIR/config.json |
| `budget Status:` | ready |
| `budget Initialized` | in $DATA_DIR |
| `budget Removed:` | $1 |
| `budget Version:` | $VERSION | Data: $DATA_DIR |

## Data Storage

All data is stored locally at `~/.local/share/budget/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
