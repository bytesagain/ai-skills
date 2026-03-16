---
name: "Dictionary"
description: "Manage Dictionary data right from your terminal. Built for people who want get things done faster without complex setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["dictionary", "tool", "terminal", "cli", "utility"]
---

# Dictionary

Manage Dictionary data right from your terminal. Built for people who want get things done faster without complex setup.

## Why Dictionary?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
dictionary help

# Check current status
dictionary status

# View your statistics
dictionary stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `dictionary run` | Run |
| `dictionary check` | Check |
| `dictionary convert` | Convert |
| `dictionary analyze` | Analyze |
| `dictionary generate` | Generate |
| `dictionary preview` | Preview |
| `dictionary batch` | Batch |
| `dictionary compare` | Compare |
| `dictionary export` | Export |
| `dictionary config` | Config |
| `dictionary status` | Status |
| `dictionary report` | Report |
| `dictionary stats` | Summary statistics |
| `dictionary export` | <fmt>       Export (json|csv|txt) |
| `dictionary search` | <term>      Search entries |
| `dictionary recent` | Recent activity |
| `dictionary status` | Health check |
| `dictionary help` | Show this help |
| `dictionary version` | Show version |
| `dictionary $name:` | $c entries |
| `dictionary Total:` | $total entries |
| `dictionary Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `dictionary Version:` | v2.0.0 |
| `dictionary Data` | dir: $DATA_DIR |
| `dictionary Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `dictionary Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `dictionary Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `dictionary Status:` | OK |
| `dictionary [Dictionary]` | run: $input |
| `dictionary Saved.` | Total run entries: $total |
| `dictionary [Dictionary]` | check: $input |
| `dictionary Saved.` | Total check entries: $total |
| `dictionary [Dictionary]` | convert: $input |
| `dictionary Saved.` | Total convert entries: $total |
| `dictionary [Dictionary]` | analyze: $input |
| `dictionary Saved.` | Total analyze entries: $total |
| `dictionary [Dictionary]` | generate: $input |
| `dictionary Saved.` | Total generate entries: $total |
| `dictionary [Dictionary]` | preview: $input |
| `dictionary Saved.` | Total preview entries: $total |
| `dictionary [Dictionary]` | batch: $input |
| `dictionary Saved.` | Total batch entries: $total |
| `dictionary [Dictionary]` | compare: $input |
| `dictionary Saved.` | Total compare entries: $total |
| `dictionary [Dictionary]` | export: $input |
| `dictionary Saved.` | Total export entries: $total |
| `dictionary [Dictionary]` | config: $input |
| `dictionary Saved.` | Total config entries: $total |
| `dictionary [Dictionary]` | status: $input |
| `dictionary Saved.` | Total status entries: $total |
| `dictionary [Dictionary]` | report: $input |
| `dictionary Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/dictionary/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
