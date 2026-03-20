---
name: "Signup"
description: "Organize and track signups with simple terminal commands and export. Use when logging registrations, checking status, analyzing trends, generating reports."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["tool", "terminal", "cli", "utility", "signup"]
---

# Signup

Terminal-first Signup manager. Keep your utility tools data organized with simple commands.

## Why Signup?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
signup help

# Check current status
signup status

# View your statistics
signup stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `signup run` | Run |
| `signup check` | Check |
| `signup convert` | Convert |
| `signup analyze` | Analyze |
| `signup generate` | Generate |
| `signup preview` | Preview |
| `signup batch` | Batch |
| `signup compare` | Compare |
| `signup export` | Export |
| `signup config` | Config |
| `signup status` | Status |
| `signup report` | Report |
| `signup stats` | Summary statistics |
| `signup export` | <fmt>       Export (json|csv|txt) |
| `signup search` | <term>      Search entries |
| `signup recent` | Recent activity |
| `signup status` | Health check |
| `signup help` | Show this help |
| `signup version` | Show version |
| `signup $name:` | $c entries |
| `signup Total:` | $total entries |
| `signup Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `signup Version:` | v2.0.0 |
| `signup Data` | dir: $DATA_DIR |
| `signup Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `signup Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `signup Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `signup Status:` | OK |
| `signup [Signup]` | run: $input |
| `signup Saved.` | Total run entries: $total |
| `signup [Signup]` | check: $input |
| `signup Saved.` | Total check entries: $total |
| `signup [Signup]` | convert: $input |
| `signup Saved.` | Total convert entries: $total |
| `signup [Signup]` | analyze: $input |
| `signup Saved.` | Total analyze entries: $total |
| `signup [Signup]` | generate: $input |
| `signup Saved.` | Total generate entries: $total |
| `signup [Signup]` | preview: $input |
| `signup Saved.` | Total preview entries: $total |
| `signup [Signup]` | batch: $input |
| `signup Saved.` | Total batch entries: $total |
| `signup [Signup]` | compare: $input |
| `signup Saved.` | Total compare entries: $total |
| `signup [Signup]` | export: $input |
| `signup Saved.` | Total export entries: $total |
| `signup [Signup]` | config: $input |
| `signup Saved.` | Total config entries: $total |
| `signup [Signup]` | status: $input |
| `signup Saved.` | Total status entries: $total |
| `signup [Signup]` | report: $input |
| `signup Saved.` | Total report entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/signup/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
