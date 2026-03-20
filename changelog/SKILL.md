---
name: changelog
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [changelog, tool, utility]
description: "Parse commits and generate versioned changelogs in Markdown format. Use when preparing releases, formatting commit history, or detecting breaking changes."
---

# Changelog

Changelog generator — commit parsing, version grouping, markdown output, conventional commits, breaking change detection, and templates.

## Commands

| Command | Description |
|---------|-------------|
| `changelog run` | Execute main function |
| `changelog list` | List all items |
| `changelog add <item>` | Add new item |
| `changelog status` | Show current status |
| `changelog export <format>` | Export data |
| `changelog help` | Show help |

## Usage

```bash
# Show help
changelog help

# Quick start
changelog run
```

## Examples

```bash
# Run with defaults
changelog run

# Check status
changelog status

# Export results
changelog export json
```

- Run `changelog help` for all commands
- Data stored in `~/.local/share/changelog/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## When to Use

- Quick changelog tasks from terminal
- Automation pipelines
