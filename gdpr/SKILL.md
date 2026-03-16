---
name: "Gdpr"
description: "Gdpr — a fast security tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["encryption", "protection", "gdpr", "compliance", "privacy"]
---

# Gdpr

Gdpr — a fast security tool. Log anything, find it later, export when needed.

## Why Gdpr?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
gdpr help

# Check current status
gdpr status

# View your statistics
gdpr stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `gdpr generate` | Generate |
| `gdpr check-strength` | Check Strength |
| `gdpr rotate` | Rotate |
| `gdpr audit` | Audit |
| `gdpr store` | Store |
| `gdpr retrieve` | Retrieve |
| `gdpr expire` | Expire |
| `gdpr policy` | Policy |
| `gdpr report` | Report |
| `gdpr hash` | Hash |
| `gdpr verify` | Verify |
| `gdpr revoke` | Revoke |
| `gdpr stats` | Summary statistics |
| `gdpr export` | <fmt>       Export (json|csv|txt) |
| `gdpr search` | <term>      Search entries |
| `gdpr recent` | Recent activity |
| `gdpr status` | Health check |
| `gdpr help` | Show this help |
| `gdpr version` | Show version |
| `gdpr $name:` | $c entries |
| `gdpr Total:` | $total entries |
| `gdpr Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `gdpr Version:` | v2.0.0 |
| `gdpr Data` | dir: $DATA_DIR |
| `gdpr Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `gdpr Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `gdpr Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `gdpr Status:` | OK |
| `gdpr [Gdpr]` | generate: $input |
| `gdpr Saved.` | Total generate entries: $total |
| `gdpr [Gdpr]` | check-strength: $input |
| `gdpr Saved.` | Total check-strength entries: $total |
| `gdpr [Gdpr]` | rotate: $input |
| `gdpr Saved.` | Total rotate entries: $total |
| `gdpr [Gdpr]` | audit: $input |
| `gdpr Saved.` | Total audit entries: $total |
| `gdpr [Gdpr]` | store: $input |
| `gdpr Saved.` | Total store entries: $total |
| `gdpr [Gdpr]` | retrieve: $input |
| `gdpr Saved.` | Total retrieve entries: $total |
| `gdpr [Gdpr]` | expire: $input |
| `gdpr Saved.` | Total expire entries: $total |
| `gdpr [Gdpr]` | policy: $input |
| `gdpr Saved.` | Total policy entries: $total |
| `gdpr [Gdpr]` | report: $input |
| `gdpr Saved.` | Total report entries: $total |
| `gdpr [Gdpr]` | hash: $input |
| `gdpr Saved.` | Total hash entries: $total |
| `gdpr [Gdpr]` | verify: $input |
| `gdpr Saved.` | Total verify entries: $total |
| `gdpr [Gdpr]` | revoke: $input |
| `gdpr Saved.` | Total revoke entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/gdpr/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
