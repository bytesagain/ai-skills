---
name: parser
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [parser, tool, utility]
description: "Parser - command-line tool for everyday use"
---

# Parser

Text and data parser — parse JSON, CSV, XML, logs, and custom formats into structured output.

## Commands

| Command | Description |
|---------|-------------|
| `parser help` | Show usage info |
| `parser run` | Run main task |
| `parser status` | Check current state |
| `parser list` | List items |
| `parser add <item>` | Add new item |
| `parser export <fmt>` | Export data |

## Usage

```bash
parser help
parser run
parser status
```

## Examples

```bash
# Get started
parser help

# Run default task
parser run

# Export as JSON
parser export json
```

## Output

Results go to stdout. Save with `parser run > output.txt`.

## Configuration

Set `PARSER_DIR` to change data directory. Default: `~/.local/share/parser/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
