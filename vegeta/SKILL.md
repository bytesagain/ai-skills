---
name: Vegeta
description: "HTTP load testing tool and library. It's over 9000! Based on tsenart/vegeta (24,958+ GitHub stars). vegeta, go, benchmarking, go, http, load-testing"
version: "2.0.0"
license: MIT
runtime: python3
---

# Vegeta

HTTP load testing tool and library. It's over 9000!

Inspired by [tsenart/vegeta]([configured-endpoint]) (24,958+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from tsenart/vegeta

## Usage

Run any command: `vegeta <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
vegeta help
vegeta run
```

## When to Use

- when you need quick vegeta from the command line
- to automate vegeta tasks in your workflow

## Output

Returns reports to stdout. Redirect to a file with `vegeta run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
vegeta status

# View help
vegeta help

# View statistics
vegeta stats

# Export data
vegeta export json
```

## How It Works

Vegeta stores all data locally in `~/.local/share/vegeta/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
