---
name: "Compile"
description: "Validate, lint, and format source code across multiple languages. Use when checking syntax, formatting files, running lint passes, validating builds."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["programming", "tools", "cli", "compile", "engineering"]
---

# Compile

Your personal Compile assistant. Track, analyze, and manage all your developer tools needs from the command line.

## Why Compile?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
compile help

# Check current status
compile status

# View your statistics
compile stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `compile check` | Check |
| `compile validate` | Validate |
| `compile generate` | Generate |
| `compile format` | Format |
| `compile lint` | Lint |
| `compile explain` | Explain |
| `compile convert` | Convert |
| `compile template` | Template |
| `compile diff` | Diff |
| `compile preview` | Preview |
| `compile fix` | Fix |
| `compile report` | Report |
| `compile stats` | Summary statistics |
| `compile export` | <fmt>       Export (json|csv|txt) |
| `compile search` | <term>      Search entries |
| `compile recent` | Recent activity |
| `compile status` | Health check |
| `compile help` | Show this help |
| `compile version` | Show version |
| `compile $name:` | $c entries |
| `compile Total:` | $total entries |
| `compile Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compile Version:` | v2.0.0 |
| `compile Data` | dir: $DATA_DIR |
| `compile Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `compile Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compile Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `compile Status:` | OK |
| `compile [Compile]` | check: $input |
| `compile Saved.` | Total check entries: $total |
| `compile [Compile]` | validate: $input |
| `compile Saved.` | Total validate entries: $total |
| `compile [Compile]` | generate: $input |
| `compile Saved.` | Total generate entries: $total |
| `compile [Compile]` | format: $input |
| `compile Saved.` | Total format entries: $total |
| `compile [Compile]` | lint: $input |
| `compile Saved.` | Total lint entries: $total |
| `compile [Compile]` | explain: $input |
| `compile Saved.` | Total explain entries: $total |
| `compile [Compile]` | convert: $input |
| `compile Saved.` | Total convert entries: $total |
| `compile [Compile]` | template: $input |
| `compile Saved.` | Total template entries: $total |
| `compile [Compile]` | diff: $input |
| `compile Saved.` | Total diff entries: $total |
| `compile [Compile]` | preview: $input |
| `compile Saved.` | Total preview entries: $total |
| `compile [Compile]` | fix: $input |
| `compile Saved.` | Total fix entries: $total |
| `compile [Compile]` | report: $input |
| `compile Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/compile/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
