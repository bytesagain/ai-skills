---
version: "2.0.0"
name: gitbuddy
description: "Git Extras — Git Extras — extended git utilities. Automated tool for git-extras tasks. Use when you need Git Extras capabilities. Triggers on: gitbuddy."
---

# Git Extras

Git Extras — extended git utilities

## Why This Skill?

- No installation required — works with standard system tools
- Real functionality — runs actual commands, produces real output

## Commands

Run `scripts/git_extras.sh <command>` to use.

- `summary` — Repo summary (commits, authors, files)
- `authors` — List all authors by commits
- `changelog` — [since] Generate changelog
- `effort` — [n] Files with most commits
- `fresh-branch` — <n> Create branch from clean state
- `ignore` — <pattern> Add to.gitignore
- `undo` — [n] Undo last n commits (soft)
- `standup` — [days] What did I do (default: 1 day)
- `stats` — Detailed repo statistics
- `info` — Version info

## Quick Start

```bash
git_extras.sh help
```

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
