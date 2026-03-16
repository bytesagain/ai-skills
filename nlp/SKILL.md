---
name: nlp
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [nlp, tool, utility]
description: "Nlp - command-line tool for everyday use"
---

# NLP

Natural language processing toolkit — text analysis, sentiment detection, keyword extraction, language detection, summarization, and entity recognition.

## Commands

| Command | Description |
|---------|-------------|
| `nlp sentiment` | <text> |
| `nlp keywords` | <text> |
| `nlp language` | <text> |
| `nlp entities` | <text> |
| `nlp summarize` | <file> |
| `nlp tokenize` | <text> |

## Usage

```bash
# Show help
nlp help

# Quick start
nlp sentiment <text>
```

## Examples

```bash
# Example 1
nlp sentiment <text>

# Example 2
nlp keywords <text>
```

- Run `nlp help` for all available commands

## When to Use

- to automate nlp tasks in your workflow
- for batch processing nlp operations

## Output

Returns formatted output to stdout. Redirect to a file with `nlp run > output.txt`.

## Configuration

Set `NLP_DIR` environment variable to change the data directory. Default: `~/.local/share/nlp/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `nlp help` for all commands
