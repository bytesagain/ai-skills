---
name: roadmap
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [roadmap, tool, utility]
description: "Roadmap - command-line tool for everyday use"
---

# Roadmap

Product roadmap planner — create timelines, milestones, feature tracking, priority scoring, dependency mapping, and progress visualization.

## Commands

| Command | Description |
|---------|-------------|
| `roadmap run` | Execute main function |
| `roadmap list` | List all items |
| `roadmap add <item>` | Add new item |
| `roadmap status` | Show current status |
| `roadmap export <format>` | Export data |
| `roadmap help` | Show help |

## Usage

```bash
# Show help
roadmap help

# Quick start
roadmap run
```

## Examples

```bash
# Run with defaults
roadmap run

# Check status
roadmap status

# Export results
roadmap export json
```

- Run `roadmap help` for all commands
- Data stored in `~/.local/share/roadmap/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Configuration

Set `ROADMAP_DIR` to change data directory. Default: `~/.local/share/roadmap/`

## When to Use

- Quick roadmap tasks from terminal
- Automation pipelines
