---
name: "Docs"
description: "Take control of Docs with this utility tools toolkit. Clean interface, local storage, zero configuration."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "docs", "cli", "utility"]
---

# Docs

Take control of Docs with this utility tools toolkit. Clean interface, local storage, zero configuration.

## Why Docs?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
docs help

# Check current status
docs status

# View your statistics
docs stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `docs run` | Run |
| `docs check` | Check |
| `docs convert` | Convert |
| `docs analyze` | Analyze |
| `docs generate` | Generate |
| `docs preview` | Preview |
| `docs batch` | Batch |
| `docs compare` | Compare |
| `docs export` | Export |
| `docs config` | Config |
| `docs status` | Status |
| `docs report` | Report |
| `docs stats` | Summary statistics |
| `docs export` | <fmt>       Export (json|csv|txt) |
| `docs search` | <term>      Search entries |
| `docs recent` | Recent activity |
| `docs status` | Health check |
| `docs help` | Show this help |
| `docs version` | Show version |
| `docs $name:` | $c entries |
| `docs Total:` | $total entries |
| `docs Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `docs Version:` | v2.0.0 |
| `docs Data` | dir: $DATA_DIR |
| `docs Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `docs Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `docs Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `docs Status:` | OK |
| `docs [Docs]` | run: $input |
| `docs Saved.` | Total run entries: $total |
| `docs [Docs]` | check: $input |
| `docs Saved.` | Total check entries: $total |
| `docs [Docs]` | convert: $input |
| `docs Saved.` | Total convert entries: $total |
| `docs [Docs]` | analyze: $input |
| `docs Saved.` | Total analyze entries: $total |
| `docs [Docs]` | generate: $input |
| `docs Saved.` | Total generate entries: $total |
| `docs [Docs]` | preview: $input |
| `docs Saved.` | Total preview entries: $total |
| `docs [Docs]` | batch: $input |
| `docs Saved.` | Total batch entries: $total |
| `docs [Docs]` | compare: $input |
| `docs Saved.` | Total compare entries: $total |
| `docs [Docs]` | export: $input |
| `docs Saved.` | Total export entries: $total |
| `docs [Docs]` | config: $input |
| `docs Saved.` | Total config entries: $total |
| `docs [Docs]` | status: $input |
| `docs Saved.` | Total status entries: $total |
| `docs [Docs]` | report: $input |
| `docs Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/docs/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
