---
name: "Sensor"
description: "Terminal-first Sensor manager. Keep your utility tools data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["sensor", "tool", "terminal", "cli", "utility"]
---

# Sensor

Terminal-first Sensor manager. Keep your utility tools data organized with simple commands.

## Why Sensor?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
sensor help

# Check current status
sensor status

# View your statistics
sensor stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `sensor run` | Run |
| `sensor check` | Check |
| `sensor convert` | Convert |
| `sensor analyze` | Analyze |
| `sensor generate` | Generate |
| `sensor preview` | Preview |
| `sensor batch` | Batch |
| `sensor compare` | Compare |
| `sensor export` | Export |
| `sensor config` | Config |
| `sensor status` | Status |
| `sensor report` | Report |
| `sensor stats` | Summary statistics |
| `sensor export` | <fmt>       Export (json|csv|txt) |
| `sensor search` | <term>      Search entries |
| `sensor recent` | Recent activity |
| `sensor status` | Health check |
| `sensor help` | Show this help |
| `sensor version` | Show version |
| `sensor $name:` | $c entries |
| `sensor Total:` | $total entries |
| `sensor Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `sensor Version:` | v2.0.0 |
| `sensor Data` | dir: $DATA_DIR |
| `sensor Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `sensor Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `sensor Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `sensor Status:` | OK |
| `sensor [Sensor]` | run: $input |
| `sensor Saved.` | Total run entries: $total |
| `sensor [Sensor]` | check: $input |
| `sensor Saved.` | Total check entries: $total |
| `sensor [Sensor]` | convert: $input |
| `sensor Saved.` | Total convert entries: $total |
| `sensor [Sensor]` | analyze: $input |
| `sensor Saved.` | Total analyze entries: $total |
| `sensor [Sensor]` | generate: $input |
| `sensor Saved.` | Total generate entries: $total |
| `sensor [Sensor]` | preview: $input |
| `sensor Saved.` | Total preview entries: $total |
| `sensor [Sensor]` | batch: $input |
| `sensor Saved.` | Total batch entries: $total |
| `sensor [Sensor]` | compare: $input |
| `sensor Saved.` | Total compare entries: $total |
| `sensor [Sensor]` | export: $input |
| `sensor Saved.` | Total export entries: $total |
| `sensor [Sensor]` | config: $input |
| `sensor Saved.` | Total config entries: $total |
| `sensor [Sensor]` | status: $input |
| `sensor Saved.` | Total status entries: $total |
| `sensor [Sensor]` | report: $input |
| `sensor Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/sensor/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
