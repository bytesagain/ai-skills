---
name: builder
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [builder, tool, utility]
description: "Builder - command-line tool for everyday use"
---

# Builder

Project builder — scaffold new projects, generate boilerplate, configure build systems.

## Commands

| Command | Description |
|---------|-------------|
| `builder help` | Show usage info |
| `builder run` | Run main task |
| `builder status` | Check current state |
| `builder list` | List items |
| `builder add <item>` | Add new item |
| `builder export <fmt>` | Export data |

## Usage

```bash
builder help
builder run
builder status
```

## Examples

```bash
# Get started
builder help

# Run default task
builder run

# Export as JSON
builder export json
```

## Output

Results go to stdout. Save with `builder run > output.txt`.

## Configuration

Set `BUILDER_DIR` to change data directory. Default: `~/.local/share/builder/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
