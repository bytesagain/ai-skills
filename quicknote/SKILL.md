---
name: QuickNote
description: "Jot down ideas, reminders, and snippets instantly. Use when adding thoughts, planning outlines, tracking daily notes, reviewing captured ideas."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["notes","quick","capture","memo","ideas","productivity","writing"]
categories: ["Productivity", "Personal Management"]
---

# QuickNote

Capture thoughts at the speed of typing. QuickNote is the fastest way to jot down ideas, reminders, and snippets from your terminal.

## Why QuickNote?

- **Instant**: Add a note in under 2 seconds
- **Pinnable**: Pin important notes to the top
- **Searchable**: Find any note by keyword
- **Exportable**: Export all notes to markdown
- **Private**: Everything stays on your machine

## Commands

- `add <text>` — Save a note (auto-timestamped)
- `list` — Show all notes (pinned first, recent last)
- `search <keyword>` — Find notes by keyword
- `pin <id>` — Toggle pin on a note
- `delete <id>` — Remove a note
- `export` — Export all notes as markdown
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
quicknote add Remember to review PR #42
quicknote add Great article about distributed systems
quicknote list
quicknote search distributed
quicknote pin 1710000001
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
