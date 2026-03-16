---
name: wireframe
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [wireframe, tool, utility]
description: "Wireframe - command-line tool for everyday use"
---

# Wireframe

Wireframe generator — create ASCII and text-based wireframes, page layouts, component sketches, user flow diagrams, and export to multiple formats.

## Commands

| Command | Description |
|---------|-------------|
| `wireframe page` | <type> |
| `wireframe component` | <name> |
| `wireframe flow` | <steps> |
| `wireframe export` | <format> |
| `wireframe templates` | Templates |
| `wireframe annotate` | Annotate |

## Usage

```bash
# Show help
wireframe help

# Quick start
wireframe page <type>
```

## Examples

```bash
# Example 1
wireframe page <type>

# Example 2
wireframe component <name>
```

- Run `wireframe help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick wireframe tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `wireframe run > output.txt`.

## Configuration

Set `WIREFRAME_DIR` to change data directory. Default: `~/.local/share/wireframe/`
