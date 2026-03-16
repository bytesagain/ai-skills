---
name: Sampler
description: "Tool for shell commands execution, visualization and alerting. Configured with a simple YAML file. Based on sqshq/sampler (14,511+ GitHub stars). sampler, go, alerting, charts, cmd, command-line, command-line-tool"
version: "2.0.0"
license: GPL-3.0
runtime: python3
---

# Sampler

Tool for shell commands execution, visualization and alerting. Configured with a simple YAML file.

Inspired by [sqshq/sampler]([configured-endpoint]) (14,511+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from sqshq/sampler

## Usage

Run any command: `sampler <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
sampler help
sampler run
```

## When to Use

- to automate sampler tasks in your workflow
- for batch processing sampler operations

## Output

Returns formatted output to stdout. Redirect to a file with `sampler run > output.txt`.

## Configuration

Set `SAMPLER_DIR` environment variable to change the data directory. Default: `~/.local/share/sampler/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
