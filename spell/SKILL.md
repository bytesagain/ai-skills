---
name: "Spell"
description: "Spell — a fast utility tools tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["spell", "tool", "terminal", "cli", "utility"]
---

# Spell

Spell — a fast utility tools tool. Log anything, find it later, export when needed.

## Why Spell?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
spell help

# Check current status
spell status

# View your statistics
spell stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `spell run` | Run |
| `spell check` | Check |
| `spell convert` | Convert |
| `spell analyze` | Analyze |
| `spell generate` | Generate |
| `spell preview` | Preview |
| `spell batch` | Batch |
| `spell compare` | Compare |
| `spell export` | Export |
| `spell config` | Config |
| `spell status` | Status |
| `spell report` | Report |
| `spell stats` | Summary statistics |
| `spell export` | <fmt>       Export (json|csv|txt) |
| `spell search` | <term>      Search entries |
| `spell recent` | Recent activity |
| `spell status` | Health check |
| `spell help` | Show this help |
| `spell version` | Show version |
| `spell $name:` | $c entries |
| `spell Total:` | $total entries |
| `spell Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `spell Version:` | v2.0.0 |
| `spell Data` | dir: $DATA_DIR |
| `spell Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `spell Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `spell Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `spell Status:` | OK |
| `spell [Spell]` | run: $input |
| `spell Saved.` | Total run entries: $total |
| `spell [Spell]` | check: $input |
| `spell Saved.` | Total check entries: $total |
| `spell [Spell]` | convert: $input |
| `spell Saved.` | Total convert entries: $total |
| `spell [Spell]` | analyze: $input |
| `spell Saved.` | Total analyze entries: $total |
| `spell [Spell]` | generate: $input |
| `spell Saved.` | Total generate entries: $total |
| `spell [Spell]` | preview: $input |
| `spell Saved.` | Total preview entries: $total |
| `spell [Spell]` | batch: $input |
| `spell Saved.` | Total batch entries: $total |
| `spell [Spell]` | compare: $input |
| `spell Saved.` | Total compare entries: $total |
| `spell [Spell]` | export: $input |
| `spell Saved.` | Total export entries: $total |
| `spell [Spell]` | config: $input |
| `spell Saved.` | Total config entries: $total |
| `spell [Spell]` | status: $input |
| `spell Saved.` | Total status entries: $total |
| `spell [Spell]` | report: $input |
| `spell Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/spell/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
