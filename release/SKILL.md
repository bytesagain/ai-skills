---
name: "Release"
description: "Terminal-first Release manager. Keep your utility tools data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["release", "tool", "terminal", "cli", "utility"]
---

# Release

Terminal-first Release manager. Keep your utility tools data organized with simple commands.

## Why Release?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
release help

# Check current status
release status

# View your statistics
release stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `release run` | Run |
| `release check` | Check |
| `release convert` | Convert |
| `release analyze` | Analyze |
| `release generate` | Generate |
| `release preview` | Preview |
| `release batch` | Batch |
| `release compare` | Compare |
| `release export` | Export |
| `release config` | Config |
| `release status` | Status |
| `release report` | Report |
| `release stats` | Summary statistics |
| `release export` | <fmt>       Export (json|csv|txt) |
| `release search` | <term>      Search entries |
| `release recent` | Recent activity |
| `release status` | Health check |
| `release help` | Show this help |
| `release version` | Show version |
| `release $name:` | $c entries |
| `release Total:` | $total entries |
| `release Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `release Version:` | v2.0.0 |
| `release Data` | dir: $DATA_DIR |
| `release Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `release Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `release Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `release Status:` | OK |
| `release [Release]` | run: $input |
| `release Saved.` | Total run entries: $total |
| `release [Release]` | check: $input |
| `release Saved.` | Total check entries: $total |
| `release [Release]` | convert: $input |
| `release Saved.` | Total convert entries: $total |
| `release [Release]` | analyze: $input |
| `release Saved.` | Total analyze entries: $total |
| `release [Release]` | generate: $input |
| `release Saved.` | Total generate entries: $total |
| `release [Release]` | preview: $input |
| `release Saved.` | Total preview entries: $total |
| `release [Release]` | batch: $input |
| `release Saved.` | Total batch entries: $total |
| `release [Release]` | compare: $input |
| `release Saved.` | Total compare entries: $total |
| `release [Release]` | export: $input |
| `release Saved.` | Total export entries: $total |
| `release [Release]` | config: $input |
| `release Saved.` | Total config entries: $total |
| `release [Release]` | status: $input |
| `release Saved.` | Total status entries: $total |
| `release [Release]` | report: $input |
| `release Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/release/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
