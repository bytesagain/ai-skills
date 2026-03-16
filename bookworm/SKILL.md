---
version: "2.0.0"
name: bookworm
description: "Reading list and book tracker with progress, ratings, and recommendations. Use when you need to track books (reading/done/todo), update reading progress, rate finished books, get book recommendations, or export reading lists. Triggers on: book, reading, library, book list, book recommendation, reading progress."
author: BytesAgain
---

# Reading Log

Reading Log — track books & reading habits

## Why This Skill?

- Designed for everyday personal use
- No external dependencies or accounts needed
 — your privacy, your data
- Simple commands, powerful results

## Commands

- `add` — <title> [author]    Add book to reading list
- `start` — <title>           Start reading a book
- `progress` — <title> <pct>  Update progress (0-100%)
- `finish` — <title> [rating] Mark book finished (1-5 stars)
- `list` — [filter]           List books (all/reading/done/todo)
- `search` — <query>          Search books
- `stats` —                   Reading statistics
- `streak` —                  Reading streak
- `recommend` — [genre]       Book recommendations
- `shelf` —                   Visual bookshelf
- `export` — [format]         Export (md/csv/json)
- `info` —                    Version info

## Quick Start

```bash
reading_log.sh help
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
