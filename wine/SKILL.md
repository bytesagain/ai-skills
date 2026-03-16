---
name: "Wine"
description: "Wine makes food & cooking simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["food", "wine", "nutrition", "kitchen", "cooking"]
---

# Wine

Wine makes food & cooking simple. Record, search, and analyze your data with clear terminal output.

## Why Wine?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
wine help

# Check current status
wine status

# View your statistics
wine stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `wine run` | Run |
| `wine check` | Check |
| `wine convert` | Convert |
| `wine analyze` | Analyze |
| `wine generate` | Generate |
| `wine preview` | Preview |
| `wine batch` | Batch |
| `wine compare` | Compare |
| `wine export` | Export |
| `wine config` | Config |
| `wine status` | Status |
| `wine report` | Report |
| `wine stats` | Summary statistics |
| `wine export` | <fmt>       Export (json|csv|txt) |
| `wine search` | <term>      Search entries |
| `wine recent` | Recent activity |
| `wine status` | Health check |
| `wine help` | Show this help |
| `wine version` | Show version |
| `wine $name:` | $c entries |
| `wine Total:` | $total entries |
| `wine Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `wine Version:` | v2.0.0 |
| `wine Data` | dir: $DATA_DIR |
| `wine Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `wine Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `wine Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `wine Status:` | OK |
| `wine [Wine]` | run: $input |
| `wine Saved.` | Total run entries: $total |
| `wine [Wine]` | check: $input |
| `wine Saved.` | Total check entries: $total |
| `wine [Wine]` | convert: $input |
| `wine Saved.` | Total convert entries: $total |
| `wine [Wine]` | analyze: $input |
| `wine Saved.` | Total analyze entries: $total |
| `wine [Wine]` | generate: $input |
| `wine Saved.` | Total generate entries: $total |
| `wine [Wine]` | preview: $input |
| `wine Saved.` | Total preview entries: $total |
| `wine [Wine]` | batch: $input |
| `wine Saved.` | Total batch entries: $total |
| `wine [Wine]` | compare: $input |
| `wine Saved.` | Total compare entries: $total |
| `wine [Wine]` | export: $input |
| `wine Saved.` | Total export entries: $total |
| `wine [Wine]` | config: $input |
| `wine Saved.` | Total config entries: $total |
| `wine [Wine]` | status: $input |
| `wine Saved.` | Total status entries: $total |
| `wine [Wine]` | report: $input |
| `wine Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/wine/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
