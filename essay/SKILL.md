---
name: "Essay"
description: "Manage Essay data right from your terminal. Built for people who want get things done faster without complex setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "essay", "cli", "utility"]
---

# Essay

Manage Essay data right from your terminal. Built for people who want get things done faster without complex setup.

## Why Essay?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
essay help

# Check current status
essay status

# View your statistics
essay stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `essay run` | Run |
| `essay check` | Check |
| `essay convert` | Convert |
| `essay analyze` | Analyze |
| `essay generate` | Generate |
| `essay preview` | Preview |
| `essay batch` | Batch |
| `essay compare` | Compare |
| `essay export` | Export |
| `essay config` | Config |
| `essay status` | Status |
| `essay report` | Report |
| `essay stats` | Summary statistics |
| `essay export` | <fmt>       Export (json|csv|txt) |
| `essay search` | <term>      Search entries |
| `essay recent` | Recent activity |
| `essay status` | Health check |
| `essay help` | Show this help |
| `essay version` | Show version |
| `essay $name:` | $c entries |
| `essay Total:` | $total entries |
| `essay Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `essay Version:` | v2.0.0 |
| `essay Data` | dir: $DATA_DIR |
| `essay Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `essay Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `essay Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `essay Status:` | OK |
| `essay [Essay]` | run: $input |
| `essay Saved.` | Total run entries: $total |
| `essay [Essay]` | check: $input |
| `essay Saved.` | Total check entries: $total |
| `essay [Essay]` | convert: $input |
| `essay Saved.` | Total convert entries: $total |
| `essay [Essay]` | analyze: $input |
| `essay Saved.` | Total analyze entries: $total |
| `essay [Essay]` | generate: $input |
| `essay Saved.` | Total generate entries: $total |
| `essay [Essay]` | preview: $input |
| `essay Saved.` | Total preview entries: $total |
| `essay [Essay]` | batch: $input |
| `essay Saved.` | Total batch entries: $total |
| `essay [Essay]` | compare: $input |
| `essay Saved.` | Total compare entries: $total |
| `essay [Essay]` | export: $input |
| `essay Saved.` | Total export entries: $total |
| `essay [Essay]` | config: $input |
| `essay Saved.` | Total config entries: $total |
| `essay [Essay]` | status: $input |
| `essay Saved.` | Total status entries: $total |
| `essay [Essay]` | report: $input |
| `essay Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/essay/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
