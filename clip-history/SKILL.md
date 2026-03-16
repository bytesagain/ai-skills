---
version: "2.0.0"
name: clip-history
description: "Clipboard history manager with pinning and search. Use when you need to save clipboard entries, search clipboard history, pin important items, or retrieve previously copied text. Triggers on: clipboard, copy, paste, clipboard history, clip."
author: BytesAgain
---

# Copyq

Clipboard Manager — clipboard history & tools

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
 — your data stays on your machine
- Original implementation by BytesAgain

## Commands

Run `scripts/copyq.sh <command>` to use.

- `copy` — <text>       Save to clipboard history
- `paste` —             Show last copied
- `list` — [n]          Show recent history (default 10)
- `search` — <query>    Search clipboard history
- `pin` — <id>          Pin item (permanent)
- `pins` —              Show pinned items
- `clear` —             Clear history
- `stats` —             Usage statistics
- `info` —              Version info

## Quick Start

```bash
copyq.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
