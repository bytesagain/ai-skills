---
version: "2.0.0"
name: Bcc
description: "BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more bcc, c. Use when you need bcc capabilities. Triggers on: bcc."
author: BytesAgain
---

# Bcc

BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from iovisor/bcc

## Usage

Run any command: `bcc <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
bcc help

# Run
bcc run
```

- Run `bcc help` for all commands

- Run `bcc help` for all commands

## When to Use

- when you need quick bcc from the command line
- to automate bcc tasks in your workflow

## Output

Returns formatted output to stdout. Redirect to a file with `bcc run > output.txt`.

## Configuration

Set `BCC_DIR` to change data directory. Default: `~/.local/share/bcc/`

## Configuration

Set `BCC_DIR` to change data directory. Default: `~/.local/share/bcc/`
