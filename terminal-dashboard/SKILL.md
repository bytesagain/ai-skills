---
version: "2.0.0"
name: Sampler
description: "Tool for shell commands execution, visualization and alerting. Configured with a simple YAML file. terminal-dashboard, go, alerting, charts, cmd, command-line, command-line-tool. Use when you need terminal-dashboard capabilities. Triggers on: terminal-dashboard."
---

# Sampler

Tool for shell commands execution, visualization and alerting. Configured with a simple YAML file. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from sqshq/terminal-dashboard

## Usage

Run any command: `terminal-dashboard <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
terminal-dashboard help
terminal-dashboard run
```

## When to Use

- when you need quick terminal dashboard from the command line
- to automate terminal tasks in your workflow

## Output

Returns logs to stdout. Redirect to a file with `terminal-dashboard run > output.txt`.
