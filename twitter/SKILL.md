---
name: "Twitter"
description: "Twitter makes utility tools simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["twitter", "tool", "terminal", "cli", "utility"]
---

# Twitter

Twitter makes utility tools simple. Record, search, and analyze your data with clear terminal output.

## Why Twitter?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
twitter help

# Check current status
twitter status

# View your statistics
twitter stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `twitter run` | Run |
| `twitter check` | Check |
| `twitter convert` | Convert |
| `twitter analyze` | Analyze |
| `twitter generate` | Generate |
| `twitter preview` | Preview |
| `twitter batch` | Batch |
| `twitter compare` | Compare |
| `twitter export` | Export |
| `twitter config` | Config |
| `twitter status` | Status |
| `twitter report` | Report |
| `twitter stats` | Summary statistics |
| `twitter export` | <fmt>       Export (json|csv|txt) |
| `twitter search` | <term>      Search entries |
| `twitter recent` | Recent activity |
| `twitter status` | Health check |
| `twitter help` | Show this help |
| `twitter version` | Show version |
| `twitter $name:` | $c entries |
| `twitter Total:` | $total entries |
| `twitter Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `twitter Version:` | v2.0.0 |
| `twitter Data` | dir: $DATA_DIR |
| `twitter Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `twitter Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `twitter Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `twitter Status:` | OK |
| `twitter [Twitter]` | run: $input |
| `twitter Saved.` | Total run entries: $total |
| `twitter [Twitter]` | check: $input |
| `twitter Saved.` | Total check entries: $total |
| `twitter [Twitter]` | convert: $input |
| `twitter Saved.` | Total convert entries: $total |
| `twitter [Twitter]` | analyze: $input |
| `twitter Saved.` | Total analyze entries: $total |
| `twitter [Twitter]` | generate: $input |
| `twitter Saved.` | Total generate entries: $total |
| `twitter [Twitter]` | preview: $input |
| `twitter Saved.` | Total preview entries: $total |
| `twitter [Twitter]` | batch: $input |
| `twitter Saved.` | Total batch entries: $total |
| `twitter [Twitter]` | compare: $input |
| `twitter Saved.` | Total compare entries: $total |
| `twitter [Twitter]` | export: $input |
| `twitter Saved.` | Total export entries: $total |
| `twitter [Twitter]` | config: $input |
| `twitter Saved.` | Total config entries: $total |
| `twitter [Twitter]` | status: $input |
| `twitter Saved.` | Total status entries: $total |
| `twitter [Twitter]` | report: $input |
| `twitter Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/twitter/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
