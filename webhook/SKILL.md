---
version: "2.0.0"
name: Webhook
description: "webhook is a lightweight incoming webhook server to run shell commands webhook, go, automate, automation, ci, deploy, devops. Use when you need webhook capabilities. Triggers on: webhook."
---

# Webhook

webhook is a lightweight incoming webhook server to run shell commands ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from adnanh/webhook

## Usage

Run any command: `webhook <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
webhook help
webhook run
```

## When to Use

- to automate webhook tasks in your workflow
- for batch processing webhook operations

## Output

Returns logs to stdout. Redirect to a file with `webhook run > output.txt`.

## Configuration

Set `WEBHOOK_DIR` environment variable to change the data directory. Default: `~/.local/share/webhook/`


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
webhook status

# View help
webhook help

# View statistics
webhook stats

# Export data
webhook export json
```

## How It Works

Webhook stores all data locally in `~/.local/share/webhook/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
