---
name: Todo
description: "Minimal todo list manager. Add tasks, mark complete, set priorities, filter by status, and clean up done items. The simplest way to track tasks from your terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["task","todo","list","productivity","simple"]
categories: ["Developer Tools", "Utility"]
---
# Todo

Minimal todo list manager. Add tasks, mark complete, set priorities, filter by status, and clean up done items. The simplest way to track tasks from your terminal.

## Quick Start

Run `todo help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
- Works on Linux and macOS

## Usage

```bash
todo help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick todo from the command line

## Output

Returns logs to stdout. Redirect to a file with `todo run > output.txt`.

## Configuration

Set `TODO_DIR` environment variable to change the data directory. Default: `~/.local/share/todo/`
