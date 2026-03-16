---
name: decode
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [decode, tool, utility]
description: "Decode - command-line tool for everyday use"
---

# Decode

Decoder toolkit — base64 decode, URL decode, JWT decode, and format parsing.

## Commands

| Command | Description |
|---------|-------------|
| `decode help` | Show usage info |
| `decode run` | Run main task |
| `decode status` | Check state |
| `decode list` | List items |
| `decode add <item>` | Add item |
| `decode export <fmt>` | Export data |

## Usage

```bash
decode help
decode run
decode status
```

## Examples

```bash
decode help
decode run
decode export json
```

## Output

Results go to stdout. Save with `decode run > output.txt`.

## Configuration

Set `DECODE_DIR` to change data directory. Default: `~/.local/share/decode/`

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
decode status

# View help and available commands
decode help

# View statistics
decode stats

# Export your data
decode export json
```

## How It Works

Decode stores all data locally in `~/.local/share/decode/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary, or `export` to back up your data in JSON, CSV, or plain text format.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com
- Email: hello@bytesagain.com

Powered by BytesAgain | bytesagain.com
