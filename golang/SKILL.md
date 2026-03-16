---
name: golang
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [golang, tool, utility]
description: "Golang - command-line tool for everyday use"
---

# Golang

Go development toolkit — build, test, lint, format, and manage Go projects.

## Commands

| Command | Description |
|---------|-------------|
| `golang help` | Show usage info |
| `golang run` | Run main task |
| `golang status` | Check current state |
| `golang list` | List items |
| `golang add <item>` | Add new item |
| `golang export <fmt>` | Export data |

## Usage

```bash
golang help
golang run
golang status
```

## Examples

```bash
# Get started
golang help

# Run default task
golang run

# Export as JSON
golang export json
```

## Output

Results go to stdout. Save with `golang run > output.txt`.

## Configuration

Set `GOLANG_DIR` to change data directory. Default: `~/.local/share/golang/`

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
golang status

# View help
golang help

# Export data
golang export json
```

## How It Works

Golang stores all data locally in `~/.local/share/golang/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
