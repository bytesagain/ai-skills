---
name: Dive
description: "A tool for exploring each layer in a docker image Based on wagoodman/dive (53,570+ GitHub stars). dive, go, cli, docker, docker-image, explorer, inspector"
version: "2.0.0"
license: MIT
runtime: python3
---

# Dive

A tool for exploring each layer in a docker image

Inspired by [wagoodman/dive]([configured-endpoint]) (53,570+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from wagoodman/dive

## Usage

Run any command: `dive <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
dive help
dive run
```

## When to Use

- to automate dive tasks in your workflow
- for batch processing dive operations

## Output

Returns reports to stdout. Redirect to a file with `dive run > output.txt`.

## Configuration

Set `DIVE_DIR` environment variable to change the data directory. Default: `~/.local/share/dive/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
