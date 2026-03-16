---
name: "Alert"
description: "Manage Alert data right from your terminal. Built for people who want get things done faster without complex setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["alert", "tool", "terminal", "cli", "utility"]
---

# Alert

Manage Alert data right from your terminal. Built for people who want get things done faster without complex setup.

## Why Alert?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
alert help

# Check current status
alert status

# View your statistics
alert stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `alert run` | Run |
| `alert check` | Check |
| `alert convert` | Convert |
| `alert analyze` | Analyze |
| `alert generate` | Generate |
| `alert preview` | Preview |
| `alert batch` | Batch |
| `alert compare` | Compare |
| `alert export` | Export |
| `alert config` | Config |
| `alert status` | Status |
| `alert report` | Report |
| `alert stats` | Summary statistics |
| `alert export` | <fmt>       Export (json|csv|txt) |
| `alert search` | <term>      Search entries |
| `alert recent` | Recent activity |
| `alert status` | Health check |
| `alert help` | Show this help |
| `alert version` | Show version |
| `alert $name:` | $c entries |
| `alert Total:` | $total entries |
| `alert Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `alert Version:` | v2.0.0 |
| `alert Data` | dir: $DATA_DIR |
| `alert Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `alert Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `alert Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `alert Status:` | OK |
| `alert [Alert]` | run: $input |
| `alert Saved.` | Total run entries: $total |
| `alert [Alert]` | check: $input |
| `alert Saved.` | Total check entries: $total |
| `alert [Alert]` | convert: $input |
| `alert Saved.` | Total convert entries: $total |
| `alert [Alert]` | analyze: $input |
| `alert Saved.` | Total analyze entries: $total |
| `alert [Alert]` | generate: $input |
| `alert Saved.` | Total generate entries: $total |
| `alert [Alert]` | preview: $input |
| `alert Saved.` | Total preview entries: $total |
| `alert [Alert]` | batch: $input |
| `alert Saved.` | Total batch entries: $total |
| `alert [Alert]` | compare: $input |
| `alert Saved.` | Total compare entries: $total |
| `alert [Alert]` | export: $input |
| `alert Saved.` | Total export entries: $total |
| `alert [Alert]` | config: $input |
| `alert Saved.` | Total config entries: $total |
| `alert [Alert]` | status: $input |
| `alert Saved.` | Total status entries: $total |
| `alert [Alert]` | report: $input |
| `alert Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/alert/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
