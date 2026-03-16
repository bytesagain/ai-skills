---
version: "2.0.0"
name: Iperf
description: "network-speed3: A TCP, UDP, and SCTP network bandwidth measurement tool network-speed, c, network-speed3. Use when you need network-speed capabilities. Triggers on: network-speed."
---

# Iperf

network-speed3: A TCP, UDP, and SCTP network bandwidth measurement tool ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from esnet/network-speed

## Usage

Run any command: `network-speed <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
network-speed help
network-speed run
```

## When to Use

- for batch processing speed operations
- as part of a larger automation pipeline

## Output

Returns summaries to stdout. Redirect to a file with `network-speed run > output.txt`.


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
network-speed status

# View help
network-speed help

# View statistics
network-speed stats

# Export data
network-speed export json
```

## How It Works

Network Speed stores all data locally in `~/.local/share/network-speed/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
