---
name: survey
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [survey, tool, utility]
description: "Survey - command-line tool for everyday use"
---

# Survey

Survey builder — create questionnaires, collect responses, analyze results, export data.

## Commands

| Command | Description |
|---------|-------------|
| `survey help` | Show usage info |
| `survey run` | Run main task |
| `survey status` | Check current state |
| `survey list` | List items |
| `survey add <item>` | Add new item |
| `survey export <fmt>` | Export data |

## Usage

```bash
survey help
survey run
survey status
```

## Examples

```bash
# Get started
survey help

# Run default task
survey run

# Export as JSON
survey export json
```

## Output

Results go to stdout. Save with `survey run > output.txt`.

## Configuration

Set `SURVEY_DIR` to change data directory. Default: `~/.local/share/survey/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
