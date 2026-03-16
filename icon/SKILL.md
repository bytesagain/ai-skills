---
name: icon
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [icon, tool, utility]
description: "Icon - command-line tool for everyday use"
---

# Icon

Icon management toolkit — search icon libraries, generate icon sets, convert formats, create favicons, SVG optimization, and sprite sheet generation.

## Commands

| Command | Description |
|---------|-------------|
| `icon search` | <query> |
| `icon set` | <style> |
| `icon convert` | <file> <format> |
| `icon favicon` | <image> |
| `icon optimize` | <svg> |
| `icon sprite` | <dir> |

## Usage

```bash
# Show help
icon help

# Quick start
icon search <query>
```

## Examples

```bash
# Example 1
icon search <query>

# Example 2
icon set <style>
```

- Run `icon help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `icon help` for all commands

## Configuration

Set `ICON_DIR` to change data directory. Default: `~/.local/share/icon/`

## When to Use

- Quick icon tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `icon run > output.txt`.
