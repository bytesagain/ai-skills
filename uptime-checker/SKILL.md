---
version: "2.0.0"
name: Uptime Kuma
description: "A fancy self-hosted monitoring tool uptime kuma, javascript, docker, monitor, monitoring, responsive, self-hosted. Use when you need uptime kuma capabilities. Triggers on: uptime kuma."
---

# Uptime Kuma

A fancy self-hosted monitoring tool ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from louislam/uptime-checker

## Usage

Run any command: `uptime-checker <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
uptime-checker help
uptime-checker run
```

## When to Use

- to automate uptime tasks in your workflow
- for batch processing checker operations

## Output

Returns structured data to stdout. Redirect to a file with `uptime-checker run > output.txt`.

## Configuration

Set `UPTIME_CHECKER_DIR` environment variable to change the data directory. Default: `~/.local/share/uptime-checker/`
