---
name: "Bonds"
description: "Bonds makes personal finance simple. Record, search, and analyze your data with clear terminal output."
version: "2.0.0"
author: "BytesAgain"
tags: ["planning", "budget", "tracking", "finance", "bonds"]
---

# Bonds

Bonds makes personal finance simple. Record, search, and analyze your data with clear terminal output.

## Why Bonds?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
bonds help

# Check current status
bonds status

# View your statistics
bonds stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `bonds run` | Run |
| `bonds check` | Check |
| `bonds convert` | Convert |
| `bonds analyze` | Analyze |
| `bonds generate` | Generate |
| `bonds preview` | Preview |
| `bonds batch` | Batch |
| `bonds compare` | Compare |
| `bonds export` | Export |
| `bonds config` | Config |
| `bonds status` | Status |
| `bonds report` | Report |
| `bonds stats` | Summary statistics |
| `bonds export` | <fmt>       Export (json|csv|txt) |
| `bonds search` | <term>      Search entries |
| `bonds recent` | Recent activity |
| `bonds status` | Health check |
| `bonds help` | Show this help |
| `bonds version` | Show version |
| `bonds $name:` | $c entries |
| `bonds Total:` | $total entries |
| `bonds Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `bonds Version:` | v2.0.0 |
| `bonds Data` | dir: $DATA_DIR |
| `bonds Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `bonds Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `bonds Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `bonds Status:` | OK |
| `bonds [Bonds]` | run: $input |
| `bonds Saved.` | Total run entries: $total |
| `bonds [Bonds]` | check: $input |
| `bonds Saved.` | Total check entries: $total |
| `bonds [Bonds]` | convert: $input |
| `bonds Saved.` | Total convert entries: $total |
| `bonds [Bonds]` | analyze: $input |
| `bonds Saved.` | Total analyze entries: $total |
| `bonds [Bonds]` | generate: $input |
| `bonds Saved.` | Total generate entries: $total |
| `bonds [Bonds]` | preview: $input |
| `bonds Saved.` | Total preview entries: $total |
| `bonds [Bonds]` | batch: $input |
| `bonds Saved.` | Total batch entries: $total |
| `bonds [Bonds]` | compare: $input |
| `bonds Saved.` | Total compare entries: $total |
| `bonds [Bonds]` | export: $input |
| `bonds Saved.` | Total export entries: $total |
| `bonds [Bonds]` | config: $input |
| `bonds Saved.` | Total config entries: $total |
| `bonds [Bonds]` | status: $input |
| `bonds Saved.` | Total status entries: $total |
| `bonds [Bonds]` | report: $input |
| `bonds Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/bonds/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
