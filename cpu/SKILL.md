---
name: cpu
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [cpu, tool, utility]
description: "Cpu - command-line tool for everyday use"
---

# Cpu

CPU monitor — load tracking, process ranking, temperature, and performance history.

## Commands

| Command | Description |
|---------|-------------|
| `cpu help` | Show usage info |
| `cpu run` | Run main task |
| `cpu status` | Check state |
| `cpu list` | List items |
| `cpu add <item>` | Add item |
| `cpu export <fmt>` | Export data |

## Usage

```bash
cpu help
cpu run
cpu status
```

## Examples

```bash
cpu help
cpu run
cpu export json
```

## Output

Results go to stdout. Save with `cpu run > output.txt`.

## Configuration

Set `CPU_DIR` to change data directory. Default: `~/.local/share/cpu/`

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
cpu status

# View help and available commands
cpu help

# View statistics
cpu stats

# Export your data
cpu export json
```

## How It Works

Cpu stores all data locally in `~/.local/share/cpu/`. Each command logs activity with timestamps for full traceability. Use `stats` to see a summary, or `export` to back up your data in JSON, CSV, or plain text format.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com
- Email: hello@bytesagain.com

Powered by BytesAgain | bytesagain.com
