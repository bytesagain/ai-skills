---
version: "2.0.0"
name: doc-summarize-pro
description: "Enhanced document summarizer. Smart summary, bullet extraction, executive summary, chapter breakdown, multi-doc comparison, translate+summarize, action item extraction, timeline extraction. Use when summarizing documents, extracting key points, generating executive summaries, or pulling action items from meeting notes. Triggers on: doc summarize pro."
author: BytesAgain
---

# 📝 Summarize Pro — Enhanced Document Summarizer

> One tool for every summarization need — from bullet points to timelines.

## ❓ FAQ

### What summary modes are available?
Eight modes covering all scenarios: `summarize` (default), `bullet` (key points), `executive` (decision-maker brief), `chapter` (section breakdown), `compare` (multi-doc), `translate-summary` (translate + summarize), `action` (action items), `timeline` (chronological events).

### How do I use it?
Run `bash scripts/summarize.sh <command> [text]` or let the Agent pick the right command for your need.

### What's the difference between executive and summarize?
`summarize` outputs a full summary with details. `executive` targets decision-makers — highlights conclusions, impact, and recommendations in a shorter format.

### How does compare mode work?
Provide multiple text blocks separated by `---`. The tool extracts core points from each and generates a comparative analysis.

### What languages are supported?
Works with any language input. `translate-summary` can translate while summarizing in one step.

## 🔧 Commands

| Command | Purpose | Input |
|---------|---------|-------|
| `summarize` | General summary | Text |
| `bullet` | Key points list | Text |
| `executive` | Executive brief | Text |
| `chapter` | Section breakdown | Long text |
| `compare` | Multi-doc comparison | Multiple texts |
| `translate-summary` | Translate + summarize | Text + target lang |
| `action` | Action item extraction | Meeting notes / text |
| `timeline` | Timeline extraction | Text with dates |

## 📂 Scripts

- `scripts/summarize.sh` — Main script, bash + python3 heredoc
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Quick start
doc-summarize-pro help

# Run main function
doc-summarize-pro run
```

## Commands

Run `doc-summarize-pro help` to see all available commands.
