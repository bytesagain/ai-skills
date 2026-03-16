---
name: cms
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [cms, tool, utility]
description: "Cms - command-line tool for everyday use"
---

# CMS

Content management toolkit — page creation, media library, template management, content versioning, publishing workflow, and search.

## Commands

| Command | Description |
|---------|-------------|
| `cms run` | Execute main function |
| `cms list` | List all items |
| `cms add <item>` | Add new item |
| `cms status` | Show current status |
| `cms export <format>` | Export data |
| `cms help` | Show help |

## Usage

```bash
# Show help
cms help

# Quick start
cms run
```

## Examples

```bash
# Run with defaults
cms run

# Check status
cms status

# Export results
cms export json
```

## How It Works


## Tips

- Run `cms help` for all commands
- Data stored in `~/.local/share/cms/`


## When to Use

- when you need quick cms from the command line
- to automate cms tasks in your workflow

## Output

Returns formatted output to stdout. Redirect to a file with `cms run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
