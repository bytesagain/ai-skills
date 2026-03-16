---
name: gpt
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [gpt, tool, utility]
description: "Gpt - command-line tool for everyday use"
---

# GPT

GPT interaction toolkit — manage prompts, token counting, cost estimation, conversation history, and API usage tracking for OpenAI-compatible endpoints.

## Commands

| Command | Description |
|---------|-------------|
| `gpt ask` | <prompt> |
| `gpt tokens` | <text> |
| `gpt cost` | <tokens> |
| `gpt history` | History |
| `gpt models` | Models |
| `gpt usage` | Usage |

## Usage

```bash
# Show help
gpt help

# Quick start
gpt ask <prompt>
```

## Examples

```bash
# Example 1
gpt ask <prompt>

# Example 2
gpt tokens <text>
```

- Run `gpt help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `gpt help` for all commands

## When to Use

- Quick gpt tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `gpt run > output.txt`.

## Configuration

Set `GPT_DIR` to change data directory. Default: `~/.local/share/gpt/`

## When to Use

- Quick gpt tasks from terminal
- Automation pipelines
