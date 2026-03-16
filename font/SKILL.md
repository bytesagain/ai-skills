---
name: font
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [font, tool, utility]
description: "Font - command-line tool for everyday use"
---

# Font

Font management toolkit — preview fonts, find pairings, check availability, generate font stacks, compare weights, and CSS snippet generation.

## Commands

| Command | Description |
|---------|-------------|
| `font preview` | <font> |
| `font pair` | <font> |
| `font stack` | <font> |
| `font compare` | <f1> <f2> |
| `font weights` | <font> |
| `font css` | <font> |

## Usage

```bash
# Show help
font help

# Quick start
font preview <font>
```

## Examples

```bash
# Example 1
font preview <font>

# Example 2
font pair <font>
```

- Run `font help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Configuration

Set `FONT_DIR` to change data directory. Default: `~/.local/share/font/`

## When to Use

- Quick font tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `font run > output.txt`.

## Configuration

Set `FONT_DIR` to change data directory. Default: `~/.local/share/font/`
