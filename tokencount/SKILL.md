---
name: TokenCount
description: "Text and token counter for AI and NLP. Count words, characters, sentences, paragraphs, and estimate GPT tokens. Analyze text complexity and readability scores."
version: "2.0.0"
author: "BytesAgain"
tags: ["token","word","count","text","nlp","ai","gpt"]
categories: ["Developer Tools", "Utility"]
---
# TokenCount

Text and token counter for AI and NLP. Count words, characters, sentences, paragraphs, and estimate GPT tokens. Analyze text complexity and readability scores.

## Quick Start

Run `tokencount help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
 in `~/.tokencount/`
- Works on Linux and macOS

## Usage

```bash
tokencount help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick tokencount from the command line

## Output

Returns reports to stdout. Redirect to a file with `tokencount run > output.txt`.

## Configuration

Set `TOKENCOUNT_DIR` environment variable to change the data directory. Default: `~/.local/share/tokencount/`
