---
name: llm
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [llm, tool, utility]
description: "Llm - command-line tool for everyday use"
---

# LLM

Local LLM toolkit — manage, compare, and benchmark language models. List installed models, check compatibility, estimate VRAM, run inference tests, compare outputs side-by-side.

## Commands

| Command | Description |
|---------|-------------|
| `llm list` | List |
| `llm info` | <model> |
| `llm bench` | <model> |
| `llm compare` | <m1> <m2> |
| `llm vram` | <model> |
| `llm download` | <model> |

## Usage

```bash
# Show help
llm help

# Quick start
llm list
```

## Examples

```bash
# Example 1
llm list

# Example 2
llm info <model>
```

- Run `llm help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Configuration

Set `LLM_DIR` to change data directory. Default: `~/.local/share/llm/`

## When to Use

- Quick llm tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `llm run > output.txt`.

## Configuration

Set `LLM_DIR` to change data directory. Default: `~/.local/share/llm/`
