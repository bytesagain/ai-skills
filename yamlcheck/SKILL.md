---
name: YAMLCheck
description: "YAML validator and formatter. Validate YAML syntax, pretty-print with proper indentation, convert between YAML and JSON, and lint YAML files for common issues."
version: "2.0.0"
author: "BytesAgain"
tags: ["yaml","validator","lint","formatter","json","developer"]
categories: ["Developer Tools", "Utility"]
---
# YAMLCheck

YAML validator and formatter. Validate YAML syntax, pretty-print with proper indentation, convert between YAML and JSON, and lint YAML files for common issues.

## Quick Start

Run `yamlcheck help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
 in `~/.yamlcheck/`
- Works on Linux and macOS

## Usage

```bash
yamlcheck help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `yamlcheck help` for all commands

## When to Use

- to automate yamlcheck tasks in your workflow
- for batch processing yamlcheck operations

## Output

Returns logs to stdout. Redirect to a file with `yamlcheck run > output.txt`.

## Configuration

Set `YAMLCHECK_DIR` environment variable to change the data directory. Default: `~/.local/share/yamlcheck/`
