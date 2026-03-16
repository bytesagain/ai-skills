---
name: layout
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [layout, tool, utility]
description: "Layout - command-line tool for everyday use"
---

# Layout

CSS layout toolkit — generate flexbox and grid layouts, responsive breakpoints, spacing systems, component templates, and layout debugging.

## Commands

| Command | Description |
|---------|-------------|
| `layout flex` | <items> |
| `layout grid` | <cols> <rows> |
| `layout responsive` | Responsive |
| `layout spacing` | Spacing |
| `layout template` | <name> |
| `layout debug` | <url> |

## Usage

```bash
# Show help
layout help

# Quick start
layout flex <items>
```

## Examples

```bash
# Example 1
layout flex <items>

# Example 2
layout grid <cols> <rows>
```

- Run `layout help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick layout tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `layout run > output.txt`.

## Configuration

Set `LAYOUT_DIR` to change data directory. Default: `~/.local/share/layout/`
