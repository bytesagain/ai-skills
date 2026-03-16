---
version: "2.0.0"
name: ctxkeeper
description: "- **name**: Context Manager. Use when you need ctxkeeper capabilities. Triggers on: ctxkeeper."
---

# Context Manager

- **name**: Context Manager
- **description**: Smart context window management for AI. Summarize, prioritize, archive, and optimize context. Commands: summarize, prioritize, archive, restore, budget, optimize, split, merge. Use for managing AI context, reducing tokens, or organizing large conversations.

## Scenarios

### Long Conversation
Context filling up after hours of chat. Use `summarize` to compress older exchanges, `prioritize` to keep relevant parts front and center.

### Multi-Project Context
Working across codebases. `split` into project-specific chunks, `archive` inactive ones, `restore` when switching back.

### Token Budget Crunch
Approaching limits. Run `budget` for usage stats, `optimize` for reduction tips, then `summarize` to compress.

### Context Merging
Multiple threads need combining. Use `merge` to unite related contexts while removing redundancy.

## Commands

| Command | Purpose |
|---------|---------|
| `summarize` | Compress context |
| `prioritize` | Rank by relevance |
| `archive` | Store old context |
| `restore` | Retrieve archived |
| `budget` | Token usage estimate |
| `optimize` | Reduction suggestions |
| `split` | Break into chunks |
| `merge` | Combine contexts |
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
ctxkeeper help
ctxkeeper run
```
