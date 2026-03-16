---
version: "2.0.0"
name: Task
description: "A fast, cross-platform build tool inspired by Make, designed for modern workflows. task, go, build-tool, devops, go, make, makefile. Use when you need task capabilities. Triggers on: task."
---

# Task

A fast, cross-platform build tool inspired by Make, designed for modern workflows. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from go-task/task

## Usage

Run any command: `task <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
task help
task run
```

## When to Use

- when you need quick task from the command line
- to automate task tasks in your workflow

## Output

Returns formatted output to stdout. Redirect to a file with `task run > output.txt`.


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
task status

# View help
task help

# View statistics
task stats

# Export data
task export json
```

## How It Works

Task stores all data locally in `~/.local/share/task/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
