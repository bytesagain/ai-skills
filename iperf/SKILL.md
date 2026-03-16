---
name: Iperf
description: "iperf3:  A TCP, UDP, and SCTP network bandwidth measurement tool Based on esnet/iperf (8,319+ GitHub stars). iperf, c, iperf3"
version: "2.0.0"
license: NOASSERTION
runtime: python3
---

# Iperf

iperf3:  A TCP, UDP, and SCTP network bandwidth measurement tool

Inspired by [esnet/iperf]([configured-endpoint]) (8,319+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from esnet/iperf

## Usage

Run any command: `iperf <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
iperf help
iperf run
```

## When to Use

- when you need quick iperf from the command line
- to automate iperf tasks in your workflow

## Output

Returns summaries to stdout. Redirect to a file with `iperf run > output.txt`.

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
iperf status

# View help
iperf help

# View statistics
iperf stats

# Export data
iperf export json
```

## How It Works

Iperf stores all data locally in `~/.local/share/iperf/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
