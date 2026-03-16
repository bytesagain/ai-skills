---
name: "Compose"
description: "Take control of Compose with this music & audio toolkit. Clean interface, local storage, zero configuration."
version: "2.0.0"
author: "BytesAgain"
tags: ["music", "production", "creative", "sound", "compose"]
---

# Compose

Take control of Compose with this music & audio toolkit. Clean interface, local storage, zero configuration.

## Why Compose?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
compose help

# Check current status
compose status

# View your statistics
compose stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `compose run` | Run |
| `compose check` | Check |
| `compose convert` | Convert |
| `compose analyze` | Analyze |
| `compose generate` | Generate |
| `compose preview` | Preview |
| `compose batch` | Batch |
| `compose compare` | Compare |
| `compose export` | Export |
| `compose config` | Config |
| `compose status` | Status |
| `compose report` | Report |
| `compose stats` | Summary statistics |
| `compose export` | <fmt>       Export (json|csv|txt) |
| `compose search` | <term>      Search entries |
| `compose recent` | Recent activity |
| `compose status` | Health check |
| `compose help` | Show this help |
| `compose version` | Show version |
| `compose $name:` | $c entries |
| `compose Total:` | $total entries |
| `compose Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compose Version:` | v2.0.0 |
| `compose Data` | dir: $DATA_DIR |
| `compose Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `compose Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compose Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `compose Status:` | OK |
| `compose [Compose]` | run: $input |
| `compose Saved.` | Total run entries: $total |
| `compose [Compose]` | check: $input |
| `compose Saved.` | Total check entries: $total |
| `compose [Compose]` | convert: $input |
| `compose Saved.` | Total convert entries: $total |
| `compose [Compose]` | analyze: $input |
| `compose Saved.` | Total analyze entries: $total |
| `compose [Compose]` | generate: $input |
| `compose Saved.` | Total generate entries: $total |
| `compose [Compose]` | preview: $input |
| `compose Saved.` | Total preview entries: $total |
| `compose [Compose]` | batch: $input |
| `compose Saved.` | Total batch entries: $total |
| `compose [Compose]` | compare: $input |
| `compose Saved.` | Total compare entries: $total |
| `compose [Compose]` | export: $input |
| `compose Saved.` | Total export entries: $total |
| `compose [Compose]` | config: $input |
| `compose Saved.` | Total config entries: $total |
| `compose [Compose]` | status: $input |
| `compose Saved.` | Total status entries: $total |
| `compose [Compose]` | report: $input |
| `compose Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/compose/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
