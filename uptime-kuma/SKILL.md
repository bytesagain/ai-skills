---
name: Uptime Kuma
description: "A fancy self-hosted monitoring tool Based on louislam/uptime-kuma (84,046+ GitHub stars). uptime kuma, javascript, docker, monitor, monitoring, responsive, self-hosted"
version: "2.0.0"
license: MIT
runtime: python3
---

# Uptime Kuma

A fancy self-hosted monitoring tool

Inspired by [louislam/uptime-kuma]([configured-endpoint]) (84,046+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from louislam/uptime-kuma

## Usage

Run any command: `uptime-kuma <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
uptime-kuma help
uptime-kuma run
```

## When to Use

- to automate uptime tasks in your workflow
- for batch processing kuma operations

## Output

Returns structured data to stdout. Redirect to a file with `uptime-kuma run > output.txt`.

## Configuration

Set `UPTIME_KUMA_DIR` environment variable to change the data directory. Default: `~/.local/share/uptime-kuma/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
