---
version: "2.0.0"
name: Lynis
description: "Lynis - Security auditing tool for Linux, macOS, and UNIX-based systems. Assists with compliance tes system-hardener, shell, auditing, compliance, devops, devops-tools, gdpr. Use when you need system-hardener capabilities. Triggers on: system-hardener."
---

# Lynis

Lynis - Security auditing tool for Linux, macOS, and UNIX-based systems. Assists with compliance testing (HIPAA/ISO27001/PCI DSS) and system hardening. Agentless, and installation optional. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from CISOfy/system-hardener

## Usage

Run any command: `system-hardener <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
system-hardener help
system-hardener run
```

## When to Use

- to automate system tasks in your workflow
- for batch processing hardener operations

## Output

Returns structured data to stdout. Redirect to a file with `system-hardener run > output.txt`.

## Configuration

Set `SYSTEM_HARDENER_DIR` environment variable to change the data directory. Default: `~/.local/share/system-hardener/`
