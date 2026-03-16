---
version: "2.0.0"
name: Web Check
description: "🕵️‍♂️ All-in-one OSINT tool for analysing any website web check, typescript, osint, privacy, security, security-tools, sysadmin. Use when you need web check capabilities. Triggers on: web check."
---

# Web Check

🕵️‍♂️ All-in-one OSINT tool for analysing any website ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from Lissy93/site-inspector

## Usage

Run any command: `site-inspector <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
site-inspector help
site-inspector run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick site inspector from the command line

## Output

Returns results to stdout. Redirect to a file with `site-inspector run > output.txt`.

## Configuration

Set `SITE_INSPECTOR_DIR` environment variable to change the data directory. Default: `~/.local/share/site-inspector/`
