---
name: "Tire"
description: "Your personal Tire assistant. Track, analyze, and manage all your home management needs from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["maintenance", "smart-home", "inventory", "household", "tire"]
---

# Tire

Your personal Tire assistant. Track, analyze, and manage all your home management needs from the command line.

## Why Tire?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
tire help

# Check current status
tire status

# View your statistics
tire stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `tire run` | Run |
| `tire check` | Check |
| `tire convert` | Convert |
| `tire analyze` | Analyze |
| `tire generate` | Generate |
| `tire preview` | Preview |
| `tire batch` | Batch |
| `tire compare` | Compare |
| `tire export` | Export |
| `tire config` | Config |
| `tire status` | Status |
| `tire report` | Report |
| `tire stats` | Summary statistics |
| `tire export` | <fmt>       Export (json|csv|txt) |
| `tire search` | <term>      Search entries |
| `tire recent` | Recent activity |
| `tire status` | Health check |
| `tire help` | Show this help |
| `tire version` | Show version |
| `tire $name:` | $c entries |
| `tire Total:` | $total entries |
| `tire Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `tire Version:` | v2.0.0 |
| `tire Data` | dir: $DATA_DIR |
| `tire Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `tire Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `tire Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `tire Status:` | OK |
| `tire [Tire]` | run: $input |
| `tire Saved.` | Total run entries: $total |
| `tire [Tire]` | check: $input |
| `tire Saved.` | Total check entries: $total |
| `tire [Tire]` | convert: $input |
| `tire Saved.` | Total convert entries: $total |
| `tire [Tire]` | analyze: $input |
| `tire Saved.` | Total analyze entries: $total |
| `tire [Tire]` | generate: $input |
| `tire Saved.` | Total generate entries: $total |
| `tire [Tire]` | preview: $input |
| `tire Saved.` | Total preview entries: $total |
| `tire [Tire]` | batch: $input |
| `tire Saved.` | Total batch entries: $total |
| `tire [Tire]` | compare: $input |
| `tire Saved.` | Total compare entries: $total |
| `tire [Tire]` | export: $input |
| `tire Saved.` | Total export entries: $total |
| `tire [Tire]` | config: $input |
| `tire Saved.` | Total config entries: $total |
| `tire [Tire]` | status: $input |
| `tire Saved.` | Total status entries: $total |
| `tire [Tire]` | report: $input |
| `tire Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/tire/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
