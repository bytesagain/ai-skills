---
version: "2.0.0"
name: Sniffnet
description: "Comfortably monitor your Internet traffic 🕵️‍♂️ traffic-monitor, rust, application, gui, iced, linux, macos. Use when you need traffic-monitor capabilities. Triggers on: traffic-monitor."
---

# Sniffnet

Comfortably monitor your Internet traffic 🕵️‍♂️ ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from GyulyVGC/traffic-monitor

## Usage

Run any command: `traffic-monitor <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
traffic-monitor help
traffic-monitor run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick traffic monitor from the command line

## Output

Returns summaries to stdout. Redirect to a file with `traffic-monitor run > output.txt`.

## Configuration

Set `TRAFFIC_MONITOR_DIR` environment variable to change the data directory. Default: `~/.local/share/traffic-monitor/`
