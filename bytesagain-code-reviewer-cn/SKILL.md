---
description: "Review code files for bugs, security issues, and style problems. Use when auditing Python, JavaScript, Go, or Bash code, checking for injection risks, measuring complexity, or generating review checklists."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-code-reviewer-cn

Automated code review assistant with pattern-based issue detection, language-specific checklists, security scanning, and complexity metrics. Supports Python, JavaScript, Go, Java, and Bash.

## Usage

```
bytesagain-code-reviewer-cn review <file>
bytesagain-code-reviewer-cn checklist <lang>
bytesagain-code-reviewer-cn security <file>
bytesagain-code-reviewer-cn complexity <file>
bytesagain-code-reviewer-cn diff <file1> <file2>
```

## Commands

- `review` — Auto-detect language, check for common issues, warnings, and style suggestions
- `checklist` — Print language-specific review checklist (python/js/go/generic)
- `security` — Scan for hardcoded secrets, injection risks, weak crypto, unsafe patterns
- `complexity` — Calculate lines, branching, nesting depth, and complexity score
- `diff` — Side-by-side unified diff of two code files

## Examples

```bash
bytesagain-code-reviewer-cn review app.py
bytesagain-code-reviewer-cn review server.js
bytesagain-code-reviewer-cn checklist python
bytesagain-code-reviewer-cn checklist go
bytesagain-code-reviewer-cn security config.py
bytesagain-code-reviewer-cn complexity main.go
bytesagain-code-reviewer-cn diff old.py new.py
```

## Requirements

- bash
- python3

## When to Use

Use before committing code, during PR review, when onboarding new team members to coding standards, or when auditing a codebase for security issues and complexity hotspots.
