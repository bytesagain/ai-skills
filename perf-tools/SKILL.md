---
name: Perf Tools
description: "Performance analysis tools based on Linux perf_events (aka perf) and ftrace Based on brendangregg/perf-tools (10,390+ GitHub stars). perf tools, shell"
version: "2.0.0"
license: GPL-2.0
runtime: python3
---

# Perf Tools

Performance analysis tools based on Linux perf_events (aka perf) and ftrace

Inspired by [brendangregg/perf-tools]([configured-endpoint]) (10,390+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from brendangregg/perf-tools

## Usage

Run any command: `perf-tools <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
perf-tools help
perf-tools run
```

## When to Use

- to automate perf tasks in your workflow
- for batch processing tools operations

## Output

Returns summaries to stdout. Redirect to a file with `perf-tools run > output.txt`.

## Configuration

Set `PERF_TOOLS_DIR` environment variable to change the data directory. Default: `~/.local/share/perf-tools/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
