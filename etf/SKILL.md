---
name: "Etf"
description: "Etf makes utility tools simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "etf", "cli", "utility"]
---

# Etf

Etf makes utility tools simple. Record, search, and analyze your data with clear terminal output.

## Why Etf?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
etf help

# Check current status
etf status

# View your statistics
etf stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `etf run` | Run |
| `etf check` | Check |
| `etf convert` | Convert |
| `etf analyze` | Analyze |
| `etf generate` | Generate |
| `etf preview` | Preview |
| `etf batch` | Batch |
| `etf compare` | Compare |
| `etf export` | Export |
| `etf config` | Config |
| `etf status` | Status |
| `etf report` | Report |
| `etf stats` | Summary statistics |
| `etf export` | <fmt>       Export (json|csv|txt) |
| `etf search` | <term>      Search entries |
| `etf recent` | Recent activity |
| `etf status` | Health check |
| `etf help` | Show this help |
| `etf version` | Show version |
| `etf $name:` | $c entries |
| `etf Total:` | $total entries |
| `etf Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `etf Version:` | v2.0.0 |
| `etf Data` | dir: $DATA_DIR |
| `etf Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `etf Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `etf Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `etf Status:` | OK |
| `etf [Etf]` | run: $input |
| `etf Saved.` | Total run entries: $total |
| `etf [Etf]` | check: $input |
| `etf Saved.` | Total check entries: $total |
| `etf [Etf]` | convert: $input |
| `etf Saved.` | Total convert entries: $total |
| `etf [Etf]` | analyze: $input |
| `etf Saved.` | Total analyze entries: $total |
| `etf [Etf]` | generate: $input |
| `etf Saved.` | Total generate entries: $total |
| `etf [Etf]` | preview: $input |
| `etf Saved.` | Total preview entries: $total |
| `etf [Etf]` | batch: $input |
| `etf Saved.` | Total batch entries: $total |
| `etf [Etf]` | compare: $input |
| `etf Saved.` | Total compare entries: $total |
| `etf [Etf]` | export: $input |
| `etf Saved.` | Total export entries: $total |
| `etf [Etf]` | config: $input |
| `etf Saved.` | Total config entries: $total |
| `etf [Etf]` | status: $input |
| `etf Saved.` | Total status entries: $total |
| `etf [Etf]` | report: $input |
| `etf Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/etf/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
