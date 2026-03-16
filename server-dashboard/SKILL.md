---
version: "2.0.0"
name: Komodo
description: "🦎 a tool to build and deploy software on many servers 🦎 server-dashboard, rust. Use when you need server-dashboard capabilities. Triggers on: server-dashboard."
---

# Komodo

🦎 a tool to build and deploy software on many servers 🦎 ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from moghtech/server-dashboard

## Usage

Run any command: `server-dashboard <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
server-dashboard help
server-dashboard run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick server dashboard from the command line

## Output

Returns logs to stdout. Redirect to a file with `server-dashboard run > output.txt`.

## Configuration

Set `SERVER_DASHBOARD_DIR` environment variable to change the data directory. Default: `~/.local/share/server-dashboard/`
