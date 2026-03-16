---
version: "2.0.0"
name: bookmark-keeper
description: "Bookmark manager with tags, dead link checking, and multi-format export. Use when you need to save bookmarks, organize with tags, search saved links, check for dead URLs, or export bookmarks as HTML/Markdown. Triggers on: bookmark, link, URL, save link, favorites, reading later."
author: BytesAgain
---

# Linkwarden

Bookmark Manager — save & organize links

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
 — your data stays on your machine
- Original implementation by BytesAgain

## Commands

Run `scripts/linkwarden.sh <command>` to use.

- `add` — <url> [title] [tags]   Save bookmark
- `list` — [n]                   List recent (default 20)
- `search` — <query>             Search bookmarks
- `tag` — <tag>                  Filter by tag
- `tags` —                       Show all tags
- `check` —                      Check dead links
- `export` — [format]            Export (md/html/json)
- `import` — <file>              Import from file
- `delete` — <url>               Remove bookmark
- `stats` —                      Statistics
- `info` —                       Version info

## Quick Start

```bash
linkwarden.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
