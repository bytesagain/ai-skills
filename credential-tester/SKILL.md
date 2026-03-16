---
version: "2.0.0"
name: Mimikatz
description: "A little tool to play with Windows security credential-tester, c. Use when you need credential-tester capabilities. Triggers on: credential-tester."
author: BytesAgain
---

# Mimikatz

A little tool to play with Windows security ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from gentilkiwi/credential-tester

## Usage

Run any command: `credential-tester <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
credential-tester help

# Run
credential-tester run
```

- Run `credential-tester help` for commands
- No API keys needed

- Run `credential-tester help` for all commands

- Run `credential-tester help` for all commands

## Configuration

Set `CREDENTIAL_TESTER_DIR` to change data directory. Default: `~/.local/share/credential-tester/`

## When to Use

- Quick credential tasks from terminal
- Automation pipelines
