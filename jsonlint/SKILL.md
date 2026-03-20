---
name: JSONLint
description: "Validate and pretty-print JSON files from the terminal. Use when linting config files, formatting API payloads, checking syntax before deployment."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["json","validator","formatter","lint","pretty-print","minify","developer","data"]
categories: ["Developer Tools", "Utility"]
---

# JSONLint

A real JSON linter and toolkit for the terminal. Validate syntax, pretty-print, minify, compare files, list keys, and extract values by path — all powered by `python3`.

## Commands

| Command | Description |
|---------|-------------|
| `jsonlint validate <file>` | Check JSON syntax — reports type, element count, file size, and shows error context on failure |
| `jsonlint format <file>` | Pretty-print JSON with 4-space indentation |
| `jsonlint minify <file>` | Compact JSON (remove all whitespace), shows bytes saved |
| `jsonlint diff <file1> <file2>` | Deep structural comparison of two JSON files — shows added, removed, and changed values with dot-paths |
| `jsonlint keys <file>` | List all top-level keys with types and value previews |
| `jsonlint extract <file> <path>` | Extract a value by dot-path (e.g. `config.database.host`), supports array indices like `items[0]` |

## Requirements

- `python3` (uses `json` stdlib module)

## Examples

```bash
# Validate a config file
jsonlint validate config.json

# Pretty-print API response
jsonlint format response.json

# Minify for deployment
jsonlint minify package.json

# Compare two versions
jsonlint diff old.json new.json

# List what's in a JSON file
jsonlint keys data.json

# Dig into nested values
jsonlint extract config.json database.host
```
