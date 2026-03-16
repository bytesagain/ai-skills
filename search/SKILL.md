---
name: "Search"
description: "Terminal-first Search manager. Keep your utility tools data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["tool", "terminal", "cli", "utility", "search"]
---

# Search

Terminal-first Search manager. Keep your utility tools data organized with simple commands.

## Why Search?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
search help

# Check current status
search status

# View your statistics
search stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `search run` | Run |
| `search check` | Check |
| `search convert` | Convert |
| `search analyze` | Analyze |
| `search generate` | Generate |
| `search preview` | Preview |
| `search batch` | Batch |
| `search compare` | Compare |
| `search export` | Export |
| `search config` | Config |
| `search status` | Status |
| `search report` | Report |
| `search stats` | Summary statistics |
| `search export` | <fmt>       Export (json|csv|txt) |
| `search search` | <term>      Search entries |
| `search recent` | Recent activity |
| `search status` | Health check |
| `search help` | Show this help |
| `search version` | Show version |
| `search $name:` | $c entries |
| `search Total:` | $total entries |
| `search Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `search Version:` | v2.0.0 |
| `search Data` | dir: $DATA_DIR |
| `search Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `search Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `search Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `search Status:` | OK |
| `search [Search]` | run: $input |
| `search Saved.` | Total run entries: $total |
| `search [Search]` | check: $input |
| `search Saved.` | Total check entries: $total |
| `search [Search]` | convert: $input |
| `search Saved.` | Total convert entries: $total |
| `search [Search]` | analyze: $input |
| `search Saved.` | Total analyze entries: $total |
| `search [Search]` | generate: $input |
| `search Saved.` | Total generate entries: $total |
| `search [Search]` | preview: $input |
| `search Saved.` | Total preview entries: $total |
| `search [Search]` | batch: $input |
| `search Saved.` | Total batch entries: $total |
| `search [Search]` | compare: $input |
| `search Saved.` | Total compare entries: $total |
| `search [Search]` | export: $input |
| `search Saved.` | Total export entries: $total |
| `search [Search]` | config: $input |
| `search Saved.` | Total config entries: $total |
| `search [Search]` | status: $input |
| `search Saved.` | Total status entries: $total |
| `search [Search]` | report: $input |
| `search Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/search/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
