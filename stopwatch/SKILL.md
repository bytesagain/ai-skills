---
name: Stopwatch
description: "Terminal stopwatch and timer. Start, stop, lap, countdown timer, and split time tracking. Precision timing without leaving the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["timer","stopwatch","countdown","time","lap"]
categories: ["Developer Tools", "Utility"]
---
# Stopwatch

Terminal stopwatch and timer. Start, stop, lap, countdown timer, and split time tracking. Precision timing without leaving the command line.

## Quick Start

Run `stopwatch help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
- Works on Linux and macOS

## Usage

```bash
stopwatch help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick stopwatch from the command line

## Output

Returns summaries to stdout. Redirect to a file with `stopwatch run > output.txt`.

## Configuration

Set `STOPWATCH_DIR` environment variable to change the data directory. Default: `~/.local/share/stopwatch/`
