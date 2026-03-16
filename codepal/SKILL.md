---
name: CodePal
description: "Developer's coding companion. Analyze source files to see function counts, imports, and comment ratios. Scan projects for TODO/FIXME/HACK markers. Count lines of code by language. Extract dependency lists from imports. Quick code intelligence without an IDE."
version: "2.0.0"
author: "BytesAgain"
tags: ["code","developer","analysis","todo","loc","dependencies","programming","devtools"]
categories: ["Developer Tools", "Productivity"]
---

# CodePal

Quick code intelligence from your terminal. Understand any codebase faster.

## Why CodePal?

- **File analysis**: Functions, imports, comments at a glance
- **TODO scanner**: Find all TODOs, FIXMEs, HACKs across projects
- **Line counter**: LOC stats by language
- **Dependency extraction**: See what a file imports
- **Multi-language**: Python, JS, Go, Rust, Java, C, and more

## Commands

- `explain <file>` — Analyze a source file (language, functions, imports, comments)
- `todos [directory]` — Scan for TODO/FIXME/HACK/XXX/BUG markers
- `lines [directory]` — Count lines of code by file extension
- `deps <file>` — Extract dependencies/imports from a file
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
codepal explain main.py
codepal todos ~/projects/myapp
codepal lines .
codepal deps server.js
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
