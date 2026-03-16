---
name: education
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [education, tool, utility]
description: "Education - command-line tool for everyday use"
---

# Education

Education toolkit — create lesson plans, generate quizzes, track student progress, manage curriculum, build study schedules, and export course materials.

## Commands

| Command | Description |
|---------|-------------|
| `education lesson` | <topic> |
| `education quiz` | <topic> [n] |
| `education progress` | <student> |
| `education curriculum` | Curriculum |
| `education schedule` | Schedule |
| `education export` | <format> |

## Usage

```bash
# Show help
education help

# Quick start
education lesson <topic>
```

## Examples

```bash
# Example 1
education lesson <topic>

# Example 2
education quiz <topic> [n]
```

- Run `education help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Output

Results go to stdout. Save with `education run > output.txt`.

## Configuration

Set `EDUCATION_DIR` to change data directory. Default: `~/.local/share/education/`
