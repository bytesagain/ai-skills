---
name: "Options"
description: "A focused utility tools tool built for Options. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "cli", "utility", "options"]
---

# Options

A focused utility tools tool built for Options. Log entries, review trends, and export reports — all locally.

## Why Options?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
options help

# Check current status
options status

# View your statistics
options stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `options run` | Run |
| `options check` | Check |
| `options convert` | Convert |
| `options analyze` | Analyze |
| `options generate` | Generate |
| `options preview` | Preview |
| `options batch` | Batch |
| `options compare` | Compare |
| `options export` | Export |
| `options config` | Config |
| `options status` | Status |
| `options report` | Report |
| `options stats` | Summary statistics |
| `options export` | <fmt>       Export (json|csv|txt) |
| `options search` | <term>      Search entries |
| `options recent` | Recent activity |
| `options status` | Health check |
| `options help` | Show this help |
| `options version` | Show version |
| `options $name:` | $c entries |
| `options Total:` | $total entries |
| `options Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `options Version:` | v2.0.0 |
| `options Data` | dir: $DATA_DIR |
| `options Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `options Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `options Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `options Status:` | OK |
| `options [Options]` | run: $input |
| `options Saved.` | Total run entries: $total |
| `options [Options]` | check: $input |
| `options Saved.` | Total check entries: $total |
| `options [Options]` | convert: $input |
| `options Saved.` | Total convert entries: $total |
| `options [Options]` | analyze: $input |
| `options Saved.` | Total analyze entries: $total |
| `options [Options]` | generate: $input |
| `options Saved.` | Total generate entries: $total |
| `options [Options]` | preview: $input |
| `options Saved.` | Total preview entries: $total |
| `options [Options]` | batch: $input |
| `options Saved.` | Total batch entries: $total |
| `options [Options]` | compare: $input |
| `options Saved.` | Total compare entries: $total |
| `options [Options]` | export: $input |
| `options Saved.` | Total export entries: $total |
| `options [Options]` | config: $input |
| `options Saved.` | Total config entries: $total |
| `options [Options]` | status: $input |
| `options Saved.` | Total status entries: $total |
| `options [Options]` | report: $input |
| `options Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/options/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
