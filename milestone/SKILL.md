---
name: "Milestone"
description: "A focused utility tools tool built for Milestone. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["milestone", "tool", "terminal", "cli", "utility"]
---

# Milestone

A focused utility tools tool built for Milestone. Log entries, review trends, and export reports — all locally.

## Why Milestone?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
milestone help

# Check current status
milestone status

# View your statistics
milestone stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `milestone run` | Run |
| `milestone check` | Check |
| `milestone convert` | Convert |
| `milestone analyze` | Analyze |
| `milestone generate` | Generate |
| `milestone preview` | Preview |
| `milestone batch` | Batch |
| `milestone compare` | Compare |
| `milestone export` | Export |
| `milestone config` | Config |
| `milestone status` | Status |
| `milestone report` | Report |
| `milestone stats` | Summary statistics |
| `milestone export` | <fmt>       Export (json|csv|txt) |
| `milestone search` | <term>      Search entries |
| `milestone recent` | Recent activity |
| `milestone status` | Health check |
| `milestone help` | Show this help |
| `milestone version` | Show version |
| `milestone $name:` | $c entries |
| `milestone Total:` | $total entries |
| `milestone Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `milestone Version:` | v2.0.0 |
| `milestone Data` | dir: $DATA_DIR |
| `milestone Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `milestone Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `milestone Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `milestone Status:` | OK |
| `milestone [Milestone]` | run: $input |
| `milestone Saved.` | Total run entries: $total |
| `milestone [Milestone]` | check: $input |
| `milestone Saved.` | Total check entries: $total |
| `milestone [Milestone]` | convert: $input |
| `milestone Saved.` | Total convert entries: $total |
| `milestone [Milestone]` | analyze: $input |
| `milestone Saved.` | Total analyze entries: $total |
| `milestone [Milestone]` | generate: $input |
| `milestone Saved.` | Total generate entries: $total |
| `milestone [Milestone]` | preview: $input |
| `milestone Saved.` | Total preview entries: $total |
| `milestone [Milestone]` | batch: $input |
| `milestone Saved.` | Total batch entries: $total |
| `milestone [Milestone]` | compare: $input |
| `milestone Saved.` | Total compare entries: $total |
| `milestone [Milestone]` | export: $input |
| `milestone Saved.` | Total export entries: $total |
| `milestone [Milestone]` | config: $input |
| `milestone Saved.` | Total config entries: $total |
| `milestone [Milestone]` | status: $input |
| `milestone Saved.` | Total status entries: $total |
| `milestone [Milestone]` | report: $input |
| `milestone Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/milestone/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
