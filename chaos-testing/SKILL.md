---
version: "2.0.0"
name: Simianarmy
description: "Tools for keeping your cloud operating in top form. Chaos Monkey is a resiliency tool that helps app chaos-testing, java. Use when you need chaos-testing capabilities. Triggers on: chaos-testing."
author: BytesAgain
---

# Simianarmy

Tools for keeping your cloud operating in top form. Chaos Monkey is a resiliency tool that helps applications tolerate random instance failures. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from Netflix/SimianArmy

## Usage

Run any command: `chaos-testing <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
chaos-testing help

# Run
chaos-testing run
```

- Run `chaos-testing help` for all commands

## When to Use

- when you need quick chaos testing from the command line
- to automate chaos tasks in your workflow

## Output

Returns logs to stdout. Redirect to a file with `chaos-testing run > output.txt`.
