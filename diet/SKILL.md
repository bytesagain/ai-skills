---
name: diet
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [diet, tool, utility]
description: "Diet - command-line tool for everyday use"
---

# Diet

Diet and nutrition tracker — log meals, calorie counting, macro tracking, meal planning, grocery lists, and nutritional analysis.

## Commands

| Command | Description |
|---------|-------------|
| `diet log` | <food> [qty] |
| `diet today` | Today |
| `diet macros` | Macros |
| `diet plan` | [days] |
| `diet grocery` | Grocery |
| `diet analyze` | [period] |

## Usage

```bash
# Show help
diet help

# Quick start
diet log <food> [qty]
```

## Examples

```bash
# Example 1
diet log <food> [qty]

# Example 2
diet today
```

- Run `diet help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Output

Results go to stdout. Save with `diet run > output.txt`.

## Configuration

Set `DIET_DIR` to change data directory. Default: `~/.local/share/diet/`

## When to Use

- Quick diet tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `diet run > output.txt`.
