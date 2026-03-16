---
name: paycheck
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [paycheck, tool, utility]
description: "Paycheck - command-line tool for everyday use"
---

# Paycheck

Paycheck calculator — salary breakdown, tax estimates, deductions, and net pay.

## Commands

| Command | Description |
|---------|-------------|
| `paycheck help` | Show usage info |
| `paycheck run` | Run main task |
| `paycheck status` | Check state |
| `paycheck list` | List items |
| `paycheck add <item>` | Add item |
| `paycheck export <fmt>` | Export data |

## Usage

```bash
paycheck help
paycheck run
paycheck status
```

## Examples

```bash
paycheck help
paycheck run
paycheck export json
```

## Output

Results go to stdout. Save with `paycheck run > output.txt`.

## Configuration

Set `PAYCHECK_DIR` to change data directory. Default: `~/.local/share/paycheck/`

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
paycheck status

# View help
paycheck help

# Export data
paycheck export json
```

## How It Works

Paycheck stores all data locally in `~/.local/share/paycheck/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
