---
name: "Usb"
description: "Terminal-first Usb manager. Keep your utility tools data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "cli", "utility", "usb"]
---

# Usb

Terminal-first Usb manager. Keep your utility tools data organized with simple commands.

## Why Usb?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
usb help

# Check current status
usb status

# View your statistics
usb stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `usb run` | Run |
| `usb check` | Check |
| `usb convert` | Convert |
| `usb analyze` | Analyze |
| `usb generate` | Generate |
| `usb preview` | Preview |
| `usb batch` | Batch |
| `usb compare` | Compare |
| `usb export` | Export |
| `usb config` | Config |
| `usb status` | Status |
| `usb report` | Report |
| `usb stats` | Summary statistics |
| `usb export` | <fmt>       Export (json|csv|txt) |
| `usb search` | <term>      Search entries |
| `usb recent` | Recent activity |
| `usb status` | Health check |
| `usb help` | Show this help |
| `usb version` | Show version |
| `usb $name:` | $c entries |
| `usb Total:` | $total entries |
| `usb Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `usb Version:` | v2.0.0 |
| `usb Data` | dir: $DATA_DIR |
| `usb Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `usb Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `usb Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `usb Status:` | OK |
| `usb [Usb]` | run: $input |
| `usb Saved.` | Total run entries: $total |
| `usb [Usb]` | check: $input |
| `usb Saved.` | Total check entries: $total |
| `usb [Usb]` | convert: $input |
| `usb Saved.` | Total convert entries: $total |
| `usb [Usb]` | analyze: $input |
| `usb Saved.` | Total analyze entries: $total |
| `usb [Usb]` | generate: $input |
| `usb Saved.` | Total generate entries: $total |
| `usb [Usb]` | preview: $input |
| `usb Saved.` | Total preview entries: $total |
| `usb [Usb]` | batch: $input |
| `usb Saved.` | Total batch entries: $total |
| `usb [Usb]` | compare: $input |
| `usb Saved.` | Total compare entries: $total |
| `usb [Usb]` | export: $input |
| `usb Saved.` | Total export entries: $total |
| `usb [Usb]` | config: $input |
| `usb Saved.` | Total config entries: $total |
| `usb [Usb]` | status: $input |
| `usb Saved.` | Total status entries: $total |
| `usb [Usb]` | report: $input |
| `usb Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/usb/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
