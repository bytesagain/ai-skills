---
name: "Course"
description: "Take control of Course with this education toolkit. Clean interface, local storage, zero configuration."
version: "2.0.0"
author: "BytesAgain"
tags: ["teaching", "learning", "skills", "study", "course"]
---

# Course

Take control of Course with this education toolkit. Clean interface, local storage, zero configuration.

## Why Course?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
course help

# Check current status
course status

# View your statistics
course stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `course Topic:` | $1 |
| `course Q1:` | What is $1? |
| `course Front:` | $1 |
| `course Review:` | spaced repetition (1d, 3d, 7d, 14d, 30d) |
| `course Sessions:` | $(wc -l < "$DB" 2>/dev/null || echo 0) |
| `course 1.` | Basics (week 1-2) |
| `course Books` | | Videos | Courses | Practice sites |
| `course Summary` | of: $1 |
| `course Testing` | knowledge of: $1 |

## Data Storage

All data is stored locally at `~/.local/share/course/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
