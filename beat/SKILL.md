---
name: "Beat"
description: "Your personal Beat assistant. Track, analyze, and manage all your music & audio needs from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["music", "beat", "production", "creative", "sound"]
---

# Beat

Your personal Beat assistant. Track, analyze, and manage all your music & audio needs from the command line.

## Why Beat?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
beat help

# Check current status
beat status

# View your statistics
beat stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `beat run` | Run |
| `beat check` | Check |
| `beat convert` | Convert |
| `beat analyze` | Analyze |
| `beat generate` | Generate |
| `beat preview` | Preview |
| `beat batch` | Batch |
| `beat compare` | Compare |
| `beat export` | Export |
| `beat config` | Config |
| `beat status` | Status |
| `beat report` | Report |
| `beat stats` | Summary statistics |
| `beat export` | <fmt>       Export (json|csv|txt) |
| `beat search` | <term>      Search entries |
| `beat recent` | Recent activity |
| `beat status` | Health check |
| `beat help` | Show this help |
| `beat version` | Show version |
| `beat $name:` | $c entries |
| `beat Total:` | $total entries |
| `beat Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `beat Version:` | v2.0.0 |
| `beat Data` | dir: $DATA_DIR |
| `beat Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `beat Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `beat Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `beat Status:` | OK |
| `beat [Beat]` | run: $input |
| `beat Saved.` | Total run entries: $total |
| `beat [Beat]` | check: $input |
| `beat Saved.` | Total check entries: $total |
| `beat [Beat]` | convert: $input |
| `beat Saved.` | Total convert entries: $total |
| `beat [Beat]` | analyze: $input |
| `beat Saved.` | Total analyze entries: $total |
| `beat [Beat]` | generate: $input |
| `beat Saved.` | Total generate entries: $total |
| `beat [Beat]` | preview: $input |
| `beat Saved.` | Total preview entries: $total |
| `beat [Beat]` | batch: $input |
| `beat Saved.` | Total batch entries: $total |
| `beat [Beat]` | compare: $input |
| `beat Saved.` | Total compare entries: $total |
| `beat [Beat]` | export: $input |
| `beat Saved.` | Total export entries: $total |
| `beat [Beat]` | config: $input |
| `beat Saved.` | Total config entries: $total |
| `beat [Beat]` | status: $input |
| `beat Saved.` | Total status entries: $total |
| `beat [Beat]` | report: $input |
| `beat Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/beat/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
