---
name: "Poem"
description: "Your personal Poem assistant. Track, analyze, and manage all your utility tools needs from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "cli", "utility", "poem"]
---

# Poem

Your personal Poem assistant. Track, analyze, and manage all your utility tools needs from the command line.

## Why Poem?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
poem help

# Check current status
poem status

# View your statistics
poem stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `poem run` | Run |
| `poem check` | Check |
| `poem convert` | Convert |
| `poem analyze` | Analyze |
| `poem generate` | Generate |
| `poem preview` | Preview |
| `poem batch` | Batch |
| `poem compare` | Compare |
| `poem export` | Export |
| `poem config` | Config |
| `poem status` | Status |
| `poem report` | Report |
| `poem stats` | Summary statistics |
| `poem export` | <fmt>       Export (json|csv|txt) |
| `poem search` | <term>      Search entries |
| `poem recent` | Recent activity |
| `poem status` | Health check |
| `poem help` | Show this help |
| `poem version` | Show version |
| `poem $name:` | $c entries |
| `poem Total:` | $total entries |
| `poem Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `poem Version:` | v2.0.0 |
| `poem Data` | dir: $DATA_DIR |
| `poem Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `poem Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `poem Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `poem Status:` | OK |
| `poem [Poem]` | run: $input |
| `poem Saved.` | Total run entries: $total |
| `poem [Poem]` | check: $input |
| `poem Saved.` | Total check entries: $total |
| `poem [Poem]` | convert: $input |
| `poem Saved.` | Total convert entries: $total |
| `poem [Poem]` | analyze: $input |
| `poem Saved.` | Total analyze entries: $total |
| `poem [Poem]` | generate: $input |
| `poem Saved.` | Total generate entries: $total |
| `poem [Poem]` | preview: $input |
| `poem Saved.` | Total preview entries: $total |
| `poem [Poem]` | batch: $input |
| `poem Saved.` | Total batch entries: $total |
| `poem [Poem]` | compare: $input |
| `poem Saved.` | Total compare entries: $total |
| `poem [Poem]` | export: $input |
| `poem Saved.` | Total export entries: $total |
| `poem [Poem]` | config: $input |
| `poem Saved.` | Total config entries: $total |
| `poem [Poem]` | status: $input |
| `poem Saved.` | Total status entries: $total |
| `poem [Poem]` | report: $input |
| `poem Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/poem/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
