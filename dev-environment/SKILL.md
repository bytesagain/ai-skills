---
version: "2.0.0"
name: Dev Setup
description: "macOS development environment setup: Easy-to-understand instructions with automated setup scripts f dev setup, python, android-development, aws, bash, cli, cloud. Use when you need dev setup capabilities. Triggers on: dev setup."
---

# Dev Setup

macOS development environment setup: Easy-to-understand instructions with automated setup scripts for developer tools like Vim, Sublime Text, Bash, iTerm, Python data analysis, Spark, Hadoop MapReduce, AWS, Heroku, JavaScript web development, Android development, common data stores, and dev-based OS X defaults. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from donnemartin/dev-environment

## Usage

Run any command: `dev-environment <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
dev-environment help
dev-environment run
```

## When to Use

- to automate dev tasks in your workflow
- for batch processing environment operations

## Output

Returns results to stdout. Redirect to a file with `dev-environment run > output.txt`.

## Configuration

Set `DEV_ENVIRONMENT_DIR` environment variable to change the data directory. Default: `~/.local/share/dev-environment/`
