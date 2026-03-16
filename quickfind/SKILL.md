---
version: "2.0.0"
name: File Finder
description: "A simple, fast and user-friendly alternative to 'find' file finder, rust, cli, command-line, filesystem, hacktoberfest, regex. Use when you need quickfind capabilities. Triggers on: quickfind."
---

# File Finder

A simple, fast and user-friendly alternative to 'find' ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from sharkdp/fd

## Usage

Run any command: `file-finder <command> [args]`

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
quickfind help
quickfind run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick quickfind from the command line

## Output

Returns structured data to stdout. Redirect to a file with `quickfind run > output.txt`.

## Configuration

Set `QUICKFIND_DIR` environment variable to change the data directory. Default: `~/.local/share/quickfind/`
