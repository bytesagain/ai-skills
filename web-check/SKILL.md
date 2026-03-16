---
name: Web Check
description: "🕵️‍♂️ All-in-one OSINT tool for analysing any website Based on Lissy93/web-check (32,278+ GitHub stars). web check, typescript, osint, privacy, security, security-tools, sysadmin"
version: "2.0.0"
license: MIT
runtime: python3
---

# Web Check

🕵️‍♂️ All-in-one OSINT tool for analysing any website

Inspired by [Lissy93/web-check]([configured-endpoint]) (32,278+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from Lissy93/web-check

## Usage

Run any command: `web-check <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
web-check help
web-check run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick web check from the command line

## Output

Returns formatted output to stdout. Redirect to a file with `web-check run > output.txt`.

## Configuration

Set `WEB_CHECK_DIR` environment variable to change the data directory. Default: `~/.local/share/web-check/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
