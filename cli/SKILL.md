---
version: "2.0.0"
name: Cli
description: "GitHub’s official command line tool cli, go, cli, git, github-api-v4, golang. Use when you need cli capabilities. Triggers on: cli."
---

# Cli

GitHub’s official command line tool ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from cli/cli

## Usage

Run any command: `cli <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
cli help
cli run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick cli from the command line

## Output

Returns summaries to stdout. Redirect to a file with `cli run > output.txt`.

## Configuration

Set `CLI_DIR` environment variable to change the data directory. Default: `~/.local/share/cli/`


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
cli status

# View help
cli help

# View statistics
cli stats

# Export data
cli export json
```

## How It Works

Cli stores all data locally in `~/.local/share/cli/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
