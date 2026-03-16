---
version: "2.0.0"
name: tidyfiles
description: "Files — File Organizer — sort, clean, organize files. Personal productivity tool. Use when you need Files capabilities for personal organization, tracking, or management. Triggers on: tidyfiles."
---

# Files

File Organizer — sort, clean, organize files

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/files.sh <command>` to use.

- `sort` — <dir>            Auto-sort by file type
- `preview` — <dir>         Preview sort (dry run)
- `duplicates` — <dir>      Find duplicate files
- `empty` — <dir>           Find empty files/dirs
- `large` — <dir> [size]    Find large files (default >100M)
- `old` — <dir> [days]      Find old files (default >365)
- `rename` — <dir> <pat>    Batch rename files
- `flatten` — <dir>         Move all files to root
- `tree` — <dir> [depth]    Show directory tree
- `stats` — <dir>           Directory statistics
- `info` —                  Version info

## Quick Start

```bash
files.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
