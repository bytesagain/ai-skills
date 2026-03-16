---
version: "2.0.0"
name: Web Profiler Bundle
description: "Provides a development tool that gives detailed information about the execution of any request web profiler bundle, twig, component, dev, php, symfony, symfony-component. Use when you need web profiler bundle capabilities. Triggers on: web profiler bundle."
---

# Web Profiler Bundle

Provides a development tool that gives detailed information about the execution of any request ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from symfony/web-profiler

## Usage

Run any command: `web-profiler <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
web-profiler help
web-profiler run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick web profiler from the command line

## Output

Returns results to stdout. Redirect to a file with `web-profiler run > output.txt`.

## Configuration

Set `WEB_PROFILER_DIR` environment variable to change the data directory. Default: `~/.local/share/web-profiler/`
