---
name: "Parking"
description: "Parking — a fast home management tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["maintenance", "domestic", "parking", "smart-home", "home"]
---

# Parking

Parking — a fast home management tool. Log anything, find it later, export when needed.

## Why Parking?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
parking help

# Check current status
parking status

# View your statistics
parking stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `parking run` | Run |
| `parking check` | Check |
| `parking convert` | Convert |
| `parking analyze` | Analyze |
| `parking generate` | Generate |
| `parking preview` | Preview |
| `parking batch` | Batch |
| `parking compare` | Compare |
| `parking export` | Export |
| `parking config` | Config |
| `parking status` | Status |
| `parking report` | Report |
| `parking stats` | Summary statistics |
| `parking export` | <fmt>       Export (json|csv|txt) |
| `parking search` | <term>      Search entries |
| `parking recent` | Recent activity |
| `parking status` | Health check |
| `parking help` | Show this help |
| `parking version` | Show version |
| `parking $name:` | $c entries |
| `parking Total:` | $total entries |
| `parking Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `parking Version:` | v2.0.0 |
| `parking Data` | dir: $DATA_DIR |
| `parking Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `parking Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `parking Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `parking Status:` | OK |
| `parking [Parking]` | run: $input |
| `parking Saved.` | Total run entries: $total |
| `parking [Parking]` | check: $input |
| `parking Saved.` | Total check entries: $total |
| `parking [Parking]` | convert: $input |
| `parking Saved.` | Total convert entries: $total |
| `parking [Parking]` | analyze: $input |
| `parking Saved.` | Total analyze entries: $total |
| `parking [Parking]` | generate: $input |
| `parking Saved.` | Total generate entries: $total |
| `parking [Parking]` | preview: $input |
| `parking Saved.` | Total preview entries: $total |
| `parking [Parking]` | batch: $input |
| `parking Saved.` | Total batch entries: $total |
| `parking [Parking]` | compare: $input |
| `parking Saved.` | Total compare entries: $total |
| `parking [Parking]` | export: $input |
| `parking Saved.` | Total export entries: $total |
| `parking [Parking]` | config: $input |
| `parking Saved.` | Total config entries: $total |
| `parking [Parking]` | status: $input |
| `parking Saved.` | Total status entries: $total |
| `parking [Parking]` | report: $input |
| `parking Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/parking/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
