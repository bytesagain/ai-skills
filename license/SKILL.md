---
name: "License"
description: "Terminal-first License manager. Keep your security data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["protection", "compliance", "license", "audit", "privacy"]
---

# License

Terminal-first License manager. Keep your security data organized with simple commands.

## Why License?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
license help

# Check current status
license status

# View your statistics
license stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `license generate` | Generate |
| `license check-strength` | Check Strength |
| `license rotate` | Rotate |
| `license audit` | Audit |
| `license store` | Store |
| `license retrieve` | Retrieve |
| `license expire` | Expire |
| `license policy` | Policy |
| `license report` | Report |
| `license hash` | Hash |
| `license verify` | Verify |
| `license revoke` | Revoke |
| `license stats` | Summary statistics |
| `license export` | <fmt>       Export (json|csv|txt) |
| `license search` | <term>      Search entries |
| `license recent` | Recent activity |
| `license status` | Health check |
| `license help` | Show this help |
| `license version` | Show version |
| `license $name:` | $c entries |
| `license Total:` | $total entries |
| `license Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `license Version:` | v2.0.0 |
| `license Data` | dir: $DATA_DIR |
| `license Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `license Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `license Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `license Status:` | OK |
| `license [License]` | generate: $input |
| `license Saved.` | Total generate entries: $total |
| `license [License]` | check-strength: $input |
| `license Saved.` | Total check-strength entries: $total |
| `license [License]` | rotate: $input |
| `license Saved.` | Total rotate entries: $total |
| `license [License]` | audit: $input |
| `license Saved.` | Total audit entries: $total |
| `license [License]` | store: $input |
| `license Saved.` | Total store entries: $total |
| `license [License]` | retrieve: $input |
| `license Saved.` | Total retrieve entries: $total |
| `license [License]` | expire: $input |
| `license Saved.` | Total expire entries: $total |
| `license [License]` | policy: $input |
| `license Saved.` | Total policy entries: $total |
| `license [License]` | report: $input |
| `license Saved.` | Total report entries: $total |
| `license [License]` | hash: $input |
| `license Saved.` | Total hash entries: $total |
| `license [License]` | verify: $input |
| `license Saved.` | Total verify entries: $total |
| `license [License]` | revoke: $input |
| `license Saved.` | Total revoke entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/license/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
