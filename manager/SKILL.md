---
name: manager
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [manager, tool, utility]
description: "Manager - command-line tool for everyday use"
---

# Manager

Resource manager — track, organize, list, and maintain any collection of items.

## Commands

| Command | Description |
|---------|-------------|
| `manager help` | Show usage info |
| `manager run` | Run main task |
| `manager status` | Check current state |
| `manager list` | List items |
| `manager add <item>` | Add new item |
| `manager export <fmt>` | Export data |

## Usage

```bash
manager help
manager run
manager status
```

## Examples

```bash
# Get started
manager help

# Run default task
manager run

# Export as JSON
manager export json
```

## Output

Results go to stdout. Save with `manager run > output.txt`.

## Configuration

Set `MANAGER_DIR` to change data directory. Default: `~/.local/share/manager/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
