---
version: "2.0.0"
name: notelane
description: "Personal note-taking and knowledge base manager. Use when you need to create notes, organize into notebooks, full-text search, tag notes, or export your knowledge base. Triggers on: note, memo, knowledge base, notebook, quick note, jot down."
---

# Note Organizer

Note Manager — personal knowledge base

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/joplin.sh <command>` to use.

- `new` — [title]         Create new note
- `list` — [n]            List recent notes (default 10)
- `search` — <query>      Full-text search
- `view` — <id>           View a note
- `edit` — <id> <text>    Append to note
- `tag` — <tag>           List notes by tag
- `tags` —                Show all tags
- `notebook` — <name>     List notes in notebook
- `notebooks` —           List all notebooks
- `export` — [format]     Export all (md/json/html)
- `trash` — <id>          Move to trash
- `stats` —               Note statistics

## Quick Start

```bash
joplin.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
