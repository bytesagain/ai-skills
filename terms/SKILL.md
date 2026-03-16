---
name: "Terms"
description: "Terms — a fast utility tools tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["terms", "tool", "terminal", "cli", "utility"]
---

# Terms

Terms — a fast utility tools tool. Log anything, find it later, export when needed.

## Why Terms?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
terms help

# Check current status
terms status

# View your statistics
terms stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `terms generate` | Generate |
| `terms check-strength` | Check Strength |
| `terms rotate` | Rotate |
| `terms audit` | Audit |
| `terms store` | Store |
| `terms retrieve` | Retrieve |
| `terms expire` | Expire |
| `terms policy` | Policy |
| `terms report` | Report |
| `terms hash` | Hash |
| `terms verify` | Verify |
| `terms revoke` | Revoke |
| `terms stats` | Summary statistics |
| `terms export` | <fmt>       Export (json|csv|txt) |
| `terms search` | <term>      Search entries |
| `terms recent` | Recent activity |
| `terms status` | Health check |
| `terms help` | Show this help |
| `terms version` | Show version |
| `terms $name:` | $c entries |
| `terms Total:` | $total entries |
| `terms Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `terms Version:` | v2.0.0 |
| `terms Data` | dir: $DATA_DIR |
| `terms Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `terms Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `terms Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `terms Status:` | OK |
| `terms [Terms]` | generate: $input |
| `terms Saved.` | Total generate entries: $total |
| `terms [Terms]` | check-strength: $input |
| `terms Saved.` | Total check-strength entries: $total |
| `terms [Terms]` | rotate: $input |
| `terms Saved.` | Total rotate entries: $total |
| `terms [Terms]` | audit: $input |
| `terms Saved.` | Total audit entries: $total |
| `terms [Terms]` | store: $input |
| `terms Saved.` | Total store entries: $total |
| `terms [Terms]` | retrieve: $input |
| `terms Saved.` | Total retrieve entries: $total |
| `terms [Terms]` | expire: $input |
| `terms Saved.` | Total expire entries: $total |
| `terms [Terms]` | policy: $input |
| `terms Saved.` | Total policy entries: $total |
| `terms [Terms]` | report: $input |
| `terms Saved.` | Total report entries: $total |
| `terms [Terms]` | hash: $input |
| `terms Saved.` | Total hash entries: $total |
| `terms [Terms]` | verify: $input |
| `terms Saved.` | Total verify entries: $total |
| `terms [Terms]` | revoke: $input |
| `terms Saved.` | Total revoke entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/terms/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
