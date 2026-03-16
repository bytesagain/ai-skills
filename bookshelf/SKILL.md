---
name: Bookshelf
description: "Personal reading list manager. Add books to your reading list, track reading status (to-read, reading, finished), rate books with stars, view filtered lists by status, and get reading statistics. Build and maintain your personal library."
version: "2.0.0"
author: "BytesAgain"
tags: ["books","reading","library","list","tracker","literature","personal","knowledge"]
categories: ["Personal Management", "Productivity", "Education"]
---

# Bookshelf

Your personal reading tracker. Add books, track progress, rate what you read.

## Commands

- `add <title> [author]` — Add a book to your shelf
- `reading <title>` — Mark as currently reading
- `finished <title>` — Mark as finished
- `rate <title> <1-5>` — Rate a book
- `list [status]` — List books (to-read/reading/finished/all)
- `stats` — Reading statistics
- `help` — Show commands

## Usage Examples

```bash
bookshelf add "Atomic Habits" James Clear
bookshelf reading "Atomic Habits"
bookshelf finished "Atomic Habits"
bookshelf rate "Atomic Habits" 5
bookshelf list reading
bookshelf stats
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `bookshelf help` for all commands
