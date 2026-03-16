---
version: "2.0.0"
name: diskview
description: "Duf — duf — Disk Usage/Free analyzer. Automated tool for duf tasks. Use when you need Duf capabilities. Triggers on: diskview."
---

# Duf

duf — Disk Usage/Free analyzer

## Why This Skill?

- No installation required — works with standard system tools
- Real functionality — runs actual commands, produces real output

## Commands

Run `scripts/duf.sh <command>` to use.

- `overview` — Disk usage overview (all mounts)
- `usage` — [path] Directory usage breakdown
- `top` — [n] [path] Top n largest files
- `find-big` — [size] Find files larger than size (e.g. 100M)
- `duplicates` — [path] Find duplicate files
- `clean` — [path] Suggest cleanup targets
- `watch` — [path] Monitor disk usage changes
- `export` — [format] Export report (md/json)
- `info` — Version info

## Quick Start

```bash
duf.sh help
```

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
