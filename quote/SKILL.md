---
name: "Quote"
description: "Quote makes utility tools simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "quote", "cli", "utility"]
---

# Quote

Quote makes utility tools simple. Record, search, and analyze your data with clear terminal output.

## Why Quote?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
quote help

# Check current status
quote status

# View your statistics
quote stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `quote run` | Run |
| `quote check` | Check |
| `quote convert` | Convert |
| `quote analyze` | Analyze |
| `quote generate` | Generate |
| `quote preview` | Preview |
| `quote batch` | Batch |
| `quote compare` | Compare |
| `quote export` | Export |
| `quote config` | Config |
| `quote status` | Status |
| `quote report` | Report |
| `quote stats` | Summary statistics |
| `quote export` | <fmt>       Export (json|csv|txt) |
| `quote search` | <term>      Search entries |
| `quote recent` | Recent activity |
| `quote status` | Health check |
| `quote help` | Show this help |
| `quote version` | Show version |
| `quote $name:` | $c entries |
| `quote Total:` | $total entries |
| `quote Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `quote Version:` | v2.0.0 |
| `quote Data` | dir: $DATA_DIR |
| `quote Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `quote Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `quote Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `quote Status:` | OK |
| `quote [Quote]` | run: $input |
| `quote Saved.` | Total run entries: $total |
| `quote [Quote]` | check: $input |
| `quote Saved.` | Total check entries: $total |
| `quote [Quote]` | convert: $input |
| `quote Saved.` | Total convert entries: $total |
| `quote [Quote]` | analyze: $input |
| `quote Saved.` | Total analyze entries: $total |
| `quote [Quote]` | generate: $input |
| `quote Saved.` | Total generate entries: $total |
| `quote [Quote]` | preview: $input |
| `quote Saved.` | Total preview entries: $total |
| `quote [Quote]` | batch: $input |
| `quote Saved.` | Total batch entries: $total |
| `quote [Quote]` | compare: $input |
| `quote Saved.` | Total compare entries: $total |
| `quote [Quote]` | export: $input |
| `quote Saved.` | Total export entries: $total |
| `quote [Quote]` | config: $input |
| `quote Saved.` | Total config entries: $total |
| `quote [Quote]` | status: $input |
| `quote Saved.` | Total status entries: $total |
| `quote [Quote]` | report: $input |
| `quote Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/quote/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
