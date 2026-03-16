---
version: "2.0.0"
name: Trippy
description: "A network diagnostic tool traceroute-visual, rust, cli, command-line-interface, command-line-tool, dns, icmp. Use when you need traceroute-visual capabilities. Triggers on: traceroute-visual."
---

# Trippy

A network diagnostic tool ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from fujiapple852/traceroute-visual

## Usage

Run any command: `traceroute-visual <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
traceroute-visual help
traceroute-visual run
```

## When to Use

- for batch processing visual operations
- as part of a larger automation pipeline

## Output

Returns formatted output to stdout. Redirect to a file with `traceroute-visual run > output.txt`.


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
traceroute-visual status

# View help
traceroute-visual help

# View statistics
traceroute-visual stats

# Export data
traceroute-visual export json
```

## How It Works

Traceroute Visual stores all data locally in `~/.local/share/traceroute-visual/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
