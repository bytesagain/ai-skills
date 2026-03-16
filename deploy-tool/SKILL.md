---
version: "2.0.0"
name: Deployer
description: "The PHP deployment tool with support for popular frameworks out of the box deploy-tool, php, deploy, deployment, php, provision, tool. Use when you need deploy-tool capabilities. Triggers on: deploy-tool."
---

# Deployer

The PHP deployment tool with support for popular frameworks out of the box ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from deployphp/deploy-tool

## Usage

Run any command: `deploy-tool <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
deploy-tool help
deploy-tool run
```

## When to Use

- when you need quick deploy tool from the command line
- to automate deploy tasks in your workflow

## Output

Returns reports to stdout. Redirect to a file with `deploy-tool run > output.txt`.


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
deploy-tool status

# View help
deploy-tool help

# View statistics
deploy-tool stats

# Export data
deploy-tool export json
```

## How It Works

Deploy Tool stores all data locally in `~/.local/share/deploy-tool/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
