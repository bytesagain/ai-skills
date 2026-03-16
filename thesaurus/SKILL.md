---
name: "Thesaurus"
description: "Lightweight Thesaurus tracker. Add entries, view stats, search history, and export in multiple formats."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "thesaurus", "cli", "utility"]
---

# Thesaurus

Lightweight Thesaurus tracker. Add entries, view stats, search history, and export in multiple formats.

## Why Thesaurus?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
thesaurus help

# Check current status
thesaurus status

# View your statistics
thesaurus stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `thesaurus run` | Run |
| `thesaurus check` | Check |
| `thesaurus convert` | Convert |
| `thesaurus analyze` | Analyze |
| `thesaurus generate` | Generate |
| `thesaurus preview` | Preview |
| `thesaurus batch` | Batch |
| `thesaurus compare` | Compare |
| `thesaurus export` | Export |
| `thesaurus config` | Config |
| `thesaurus status` | Status |
| `thesaurus report` | Report |
| `thesaurus stats` | Summary statistics |
| `thesaurus export` | <fmt>       Export (json|csv|txt) |
| `thesaurus search` | <term>      Search entries |
| `thesaurus recent` | Recent activity |
| `thesaurus status` | Health check |
| `thesaurus help` | Show this help |
| `thesaurus version` | Show version |
| `thesaurus $name:` | $c entries |
| `thesaurus Total:` | $total entries |
| `thesaurus Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `thesaurus Version:` | v2.0.0 |
| `thesaurus Data` | dir: $DATA_DIR |
| `thesaurus Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `thesaurus Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `thesaurus Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `thesaurus Status:` | OK |
| `thesaurus [Thesaurus]` | run: $input |
| `thesaurus Saved.` | Total run entries: $total |
| `thesaurus [Thesaurus]` | check: $input |
| `thesaurus Saved.` | Total check entries: $total |
| `thesaurus [Thesaurus]` | convert: $input |
| `thesaurus Saved.` | Total convert entries: $total |
| `thesaurus [Thesaurus]` | analyze: $input |
| `thesaurus Saved.` | Total analyze entries: $total |
| `thesaurus [Thesaurus]` | generate: $input |
| `thesaurus Saved.` | Total generate entries: $total |
| `thesaurus [Thesaurus]` | preview: $input |
| `thesaurus Saved.` | Total preview entries: $total |
| `thesaurus [Thesaurus]` | batch: $input |
| `thesaurus Saved.` | Total batch entries: $total |
| `thesaurus [Thesaurus]` | compare: $input |
| `thesaurus Saved.` | Total compare entries: $total |
| `thesaurus [Thesaurus]` | export: $input |
| `thesaurus Saved.` | Total export entries: $total |
| `thesaurus [Thesaurus]` | config: $input |
| `thesaurus Saved.` | Total config entries: $total |
| `thesaurus [Thesaurus]` | status: $input |
| `thesaurus Saved.` | Total status entries: $total |
| `thesaurus [Thesaurus]` | report: $input |
| `thesaurus Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/thesaurus/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
