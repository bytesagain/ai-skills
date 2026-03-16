---
name: meditation
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [meditation, tool, utility]
description: "Meditation - command-line tool for everyday use"
---

# Meditation

Meditation and mindfulness toolkit — guided session timer, breathing exercises, mood logging, streak tracking, ambient sounds, and session history.

## Commands

| Command | Description |
|---------|-------------|
| `meditation start` | [minutes] |
| `meditation breathe` | [pattern] |
| `meditation mood` | <1-10> |
| `meditation streak` | Streak |
| `meditation history` | History |
| `meditation sounds` | Sounds |

## Usage

```bash
# Show help
meditation help

# Quick start
meditation start [minutes]
```

## Examples

```bash
# Example 1
meditation start [minutes]

# Example 2
meditation breathe [pattern]
```

- Run `meditation help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick meditation tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `meditation run > output.txt`.

## When to Use

- Quick meditation tasks from terminal
- Automation pipelines
