---
version: "2.0.0"
name: Docker Analyzer
description: "A tool for exploring each layer in a docker image docker analyzer, go, cli, docker, docker-image, explorer, inspector. Use when you need docker analyzer capabilities. Triggers on: docker analyzer."
---

# Docker Analyzer

A tool for exploring each layer in a docker image ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from wagoodman/dive

## Usage

Run any command: `docker-analyzer <command> [args]`

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
container-analyzer help
container-analyzer run
```

## When to Use

- to automate container tasks in your workflow
- for batch processing analyzer operations

## Output

Returns reports to stdout. Redirect to a file with `container-analyzer run > output.txt`.

## Configuration

Set `CONTAINER_ANALYZER_DIR` environment variable to change the data directory. Default: `~/.local/share/container-analyzer/`
