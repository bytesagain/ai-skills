---
version: "2.0.0"
name: Vegeta
description: "HTTP load testing tool and library. It's over 9000! load-tester, go, benchmarking, go, http, load-testing. Use when you need load-tester capabilities. Triggers on: load-tester."
---

# Vegeta

HTTP load testing tool and library. It's over 9000! ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from tsenart/load-tester

## Usage

Run any command: `load-tester <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
load-tester help
load-tester run
```

## When to Use

- to automate load tasks in your workflow
- for batch processing tester operations

## Output

Returns reports to stdout. Redirect to a file with `load-tester run > output.txt`.

## Configuration

Set `LOAD_TESTER_DIR` environment variable to change the data directory. Default: `~/.local/share/load-tester/`


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
load-tester status

# View help
load-tester help

# View statistics
load-tester stats

# Export data
load-tester export json
```

## How It Works

Load Tester stores all data locally in `~/.local/share/load-tester/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
