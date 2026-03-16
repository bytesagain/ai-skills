---
name: "Fish"
description: "Fish makes utility tools simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["fish", "tool", "terminal", "cli", "utility"]
---

# Fish

Fish makes utility tools simple. Record, search, and analyze your data with clear terminal output.

## Why Fish?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
fish help

# Check current status
fish status

# View your statistics
fish stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `fish run` | Run |
| `fish check` | Check |
| `fish convert` | Convert |
| `fish analyze` | Analyze |
| `fish generate` | Generate |
| `fish preview` | Preview |
| `fish batch` | Batch |
| `fish compare` | Compare |
| `fish export` | Export |
| `fish config` | Config |
| `fish status` | Status |
| `fish report` | Report |
| `fish stats` | Summary statistics |
| `fish export` | <fmt>       Export (json|csv|txt) |
| `fish search` | <term>      Search entries |
| `fish recent` | Recent activity |
| `fish status` | Health check |
| `fish help` | Show this help |
| `fish version` | Show version |
| `fish $name:` | $c entries |
| `fish Total:` | $total entries |
| `fish Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `fish Version:` | v2.0.0 |
| `fish Data` | dir: $DATA_DIR |
| `fish Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `fish Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `fish Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `fish Status:` | OK |
| `fish [Fish]` | run: $input |
| `fish Saved.` | Total run entries: $total |
| `fish [Fish]` | check: $input |
| `fish Saved.` | Total check entries: $total |
| `fish [Fish]` | convert: $input |
| `fish Saved.` | Total convert entries: $total |
| `fish [Fish]` | analyze: $input |
| `fish Saved.` | Total analyze entries: $total |
| `fish [Fish]` | generate: $input |
| `fish Saved.` | Total generate entries: $total |
| `fish [Fish]` | preview: $input |
| `fish Saved.` | Total preview entries: $total |
| `fish [Fish]` | batch: $input |
| `fish Saved.` | Total batch entries: $total |
| `fish [Fish]` | compare: $input |
| `fish Saved.` | Total compare entries: $total |
| `fish [Fish]` | export: $input |
| `fish Saved.` | Total export entries: $total |
| `fish [Fish]` | config: $input |
| `fish Saved.` | Total config entries: $total |
| `fish [Fish]` | status: $input |
| `fish Saved.` | Total status entries: $total |
| `fish [Fish]` | report: $input |
| `fish Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/fish/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
