---
name: "Beer"
description: "Terminal-first Beer manager. Keep your food & cooking data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["food", "recipes", "kitchen", "beer", "cooking"]
---

# Beer

Terminal-first Beer manager. Keep your food & cooking data organized with simple commands.

## Why Beer?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
beer help

# Check current status
beer status

# View your statistics
beer stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `beer run` | Run |
| `beer check` | Check |
| `beer convert` | Convert |
| `beer analyze` | Analyze |
| `beer generate` | Generate |
| `beer preview` | Preview |
| `beer batch` | Batch |
| `beer compare` | Compare |
| `beer export` | Export |
| `beer config` | Config |
| `beer status` | Status |
| `beer report` | Report |
| `beer stats` | Summary statistics |
| `beer export` | <fmt>       Export (json|csv|txt) |
| `beer search` | <term>      Search entries |
| `beer recent` | Recent activity |
| `beer status` | Health check |
| `beer help` | Show this help |
| `beer version` | Show version |
| `beer $name:` | $c entries |
| `beer Total:` | $total entries |
| `beer Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `beer Version:` | v2.0.0 |
| `beer Data` | dir: $DATA_DIR |
| `beer Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `beer Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `beer Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `beer Status:` | OK |
| `beer [Beer]` | run: $input |
| `beer Saved.` | Total run entries: $total |
| `beer [Beer]` | check: $input |
| `beer Saved.` | Total check entries: $total |
| `beer [Beer]` | convert: $input |
| `beer Saved.` | Total convert entries: $total |
| `beer [Beer]` | analyze: $input |
| `beer Saved.` | Total analyze entries: $total |
| `beer [Beer]` | generate: $input |
| `beer Saved.` | Total generate entries: $total |
| `beer [Beer]` | preview: $input |
| `beer Saved.` | Total preview entries: $total |
| `beer [Beer]` | batch: $input |
| `beer Saved.` | Total batch entries: $total |
| `beer [Beer]` | compare: $input |
| `beer Saved.` | Total compare entries: $total |
| `beer [Beer]` | export: $input |
| `beer Saved.` | Total export entries: $total |
| `beer [Beer]` | config: $input |
| `beer Saved.` | Total config entries: $total |
| `beer [Beer]` | status: $input |
| `beer Saved.` | Total status entries: $total |
| `beer [Beer]` | report: $input |
| `beer Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/beer/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
