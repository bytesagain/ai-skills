---
name: SQLFormat
description: "SQL query formatter and linter. Pretty-print SQL queries with proper indentation, validate basic SQL syntax, convert between SQL dialects, and minify queries."
version: "2.0.0"
author: "BytesAgain"
tags: ["sql","format","lint","query","database","developer"]
categories: ["Developer Tools", "Utility"]
---
# SQLFormat

SQL query formatter and linter. Pretty-print SQL queries with proper indentation, validate basic SQL syntax, convert between SQL dialects, and minify queries.

## Quick Start

Run `sqlformat help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
- Works on Linux and macOS

## Usage

```bash
sqlformat help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## When to Use

- to automate sqlformat tasks in your workflow
- for batch processing sqlformat operations

## Output

Returns structured data to stdout. Redirect to a file with `sqlformat run > output.txt`.

## Configuration

Set `SQLFORMAT_DIR` environment variable to change the data directory. Default: `~/.local/share/sqlformat/`
