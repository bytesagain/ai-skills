---
version: "1.0.0"
name: quick-memo
description: "Capture and search short notes from the terminal. Use when scanning memos, monitoring note updates, reporting tagged entries, viewing recent notes."
---

# Memos

Memos — quick notes manager

## Why This Skill?

- No installation required — works with standard system tools
- Real functionality — runs actual commands, produces real output

## Commands

Run `scripts/memos.sh <command>` to use.

- `add` — <text> Add a memo
- `list` — [n] List recent memos (default 10)
- `search` — <query> Search memos
- `tag` — <tag> List memos by tag (#tag)
- `tags` — Show all tags
- `edit` — <id> Edit a memo
- `delete` — <id> Delete a memo
- `export` — [format] Export all (md/json)
- `stats` — Memo statistics
- `info` — Version info

## Quick Start

```bash
memos.sh help
```

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
