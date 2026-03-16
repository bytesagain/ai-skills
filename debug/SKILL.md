---
name: debug
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [debug, tool, utility]
description: "Debug - command-line tool for everyday use"
---

# Debug

Debugging toolkit — log analysis, error tracing, memory profiling, network inspection, performance bottleneck detection, and crash report parsing.

## Commands

| Command | Description |
|---------|-------------|
| `debug logs` | <file> |
| `debug trace` | <error> |
| `debug memory` | Memory |
| `debug network` | <pid> |
| `debug profile` | <command> |
| `debug crash` | <report> |

## Usage

```bash
# Show help
debug help

# Quick start
debug logs <file>
```

## Examples

```bash
# Example 1
debug logs <file>

# Example 2
debug trace <error>
```

- Run `debug help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick debug tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `debug run > output.txt`.

## Configuration

Set `DEBUG_DIR` to change data directory. Default: `~/.local/share/debug/`

## When to Use

- Quick debug tasks from terminal
- Automation pipelines
