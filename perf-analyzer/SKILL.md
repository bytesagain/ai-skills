---
version: "2.0.0"
name: Perf Tools
description: "Performance analysis tools based on Linux perf_events (aka perf) and ftrace perf tools, shell. Use when you need perf tools capabilities. Triggers on: perf tools."
---

# Perf Tools

Performance analysis tools based on Linux perf_events (aka perf) and ftrace ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from brendangregg/perf-analyzer

## Usage

Run any command: `perf-analyzer <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
perf-analyzer help
perf-analyzer run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick perf analyzer from the command line

## Output

Returns results to stdout. Redirect to a file with `perf-analyzer run > output.txt`.

## Configuration

Set `PERF_ANALYZER_DIR` environment variable to change the data directory. Default: `~/.local/share/perf-analyzer/`
