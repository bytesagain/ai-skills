---
name: "Coffee"
description: "A focused food & cooking tool built for Coffee. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["food", "recipes", "kitchen", "coffee", "cooking"]
---

# Coffee

A focused food & cooking tool built for Coffee. Log entries, review trends, and export reports — all locally.

## Why Coffee?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
coffee help

# Check current status
coffee status

# View your statistics
coffee stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `coffee run` | Run |
| `coffee check` | Check |
| `coffee convert` | Convert |
| `coffee analyze` | Analyze |
| `coffee generate` | Generate |
| `coffee preview` | Preview |
| `coffee batch` | Batch |
| `coffee compare` | Compare |
| `coffee export` | Export |
| `coffee config` | Config |
| `coffee status` | Status |
| `coffee report` | Report |
| `coffee stats` | Summary statistics |
| `coffee export` | <fmt>       Export (json|csv|txt) |
| `coffee search` | <term>      Search entries |
| `coffee recent` | Recent activity |
| `coffee status` | Health check |
| `coffee help` | Show this help |
| `coffee version` | Show version |
| `coffee $name:` | $c entries |
| `coffee Total:` | $total entries |
| `coffee Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `coffee Version:` | v2.0.0 |
| `coffee Data` | dir: $DATA_DIR |
| `coffee Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `coffee Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `coffee Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `coffee Status:` | OK |
| `coffee [Coffee]` | run: $input |
| `coffee Saved.` | Total run entries: $total |
| `coffee [Coffee]` | check: $input |
| `coffee Saved.` | Total check entries: $total |
| `coffee [Coffee]` | convert: $input |
| `coffee Saved.` | Total convert entries: $total |
| `coffee [Coffee]` | analyze: $input |
| `coffee Saved.` | Total analyze entries: $total |
| `coffee [Coffee]` | generate: $input |
| `coffee Saved.` | Total generate entries: $total |
| `coffee [Coffee]` | preview: $input |
| `coffee Saved.` | Total preview entries: $total |
| `coffee [Coffee]` | batch: $input |
| `coffee Saved.` | Total batch entries: $total |
| `coffee [Coffee]` | compare: $input |
| `coffee Saved.` | Total compare entries: $total |
| `coffee [Coffee]` | export: $input |
| `coffee Saved.` | Total export entries: $total |
| `coffee [Coffee]` | config: $input |
| `coffee Saved.` | Total config entries: $total |
| `coffee [Coffee]` | status: $input |
| `coffee Saved.` | Total status entries: $total |
| `coffee [Coffee]` | report: $input |
| `coffee Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/coffee/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
