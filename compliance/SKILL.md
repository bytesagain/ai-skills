---
name: "Compliance"
description: "Compliance — a fast security tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["encryption", "protection", "compliance", "security", "privacy"]
---

# Compliance

Compliance — a fast security tool. Log anything, find it later, export when needed.

## Why Compliance?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
compliance help

# Check current status
compliance status

# View your statistics
compliance stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `compliance generate` | Generate |
| `compliance check-strength` | Check Strength |
| `compliance rotate` | Rotate |
| `compliance audit` | Audit |
| `compliance store` | Store |
| `compliance retrieve` | Retrieve |
| `compliance expire` | Expire |
| `compliance policy` | Policy |
| `compliance report` | Report |
| `compliance hash` | Hash |
| `compliance verify` | Verify |
| `compliance revoke` | Revoke |
| `compliance stats` | Summary statistics |
| `compliance export` | <fmt>       Export (json|csv|txt) |
| `compliance search` | <term>      Search entries |
| `compliance recent` | Recent activity |
| `compliance status` | Health check |
| `compliance help` | Show this help |
| `compliance version` | Show version |
| `compliance $name:` | $c entries |
| `compliance Total:` | $total entries |
| `compliance Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compliance Version:` | v2.0.0 |
| `compliance Data` | dir: $DATA_DIR |
| `compliance Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `compliance Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compliance Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `compliance Status:` | OK |
| `compliance [Compliance]` | generate: $input |
| `compliance Saved.` | Total generate entries: $total |
| `compliance [Compliance]` | check-strength: $input |
| `compliance Saved.` | Total check-strength entries: $total |
| `compliance [Compliance]` | rotate: $input |
| `compliance Saved.` | Total rotate entries: $total |
| `compliance [Compliance]` | audit: $input |
| `compliance Saved.` | Total audit entries: $total |
| `compliance [Compliance]` | store: $input |
| `compliance Saved.` | Total store entries: $total |
| `compliance [Compliance]` | retrieve: $input |
| `compliance Saved.` | Total retrieve entries: $total |
| `compliance [Compliance]` | expire: $input |
| `compliance Saved.` | Total expire entries: $total |
| `compliance [Compliance]` | policy: $input |
| `compliance Saved.` | Total policy entries: $total |
| `compliance [Compliance]` | report: $input |
| `compliance Saved.` | Total report entries: $total |
| `compliance [Compliance]` | hash: $input |
| `compliance Saved.` | Total hash entries: $total |
| `compliance [Compliance]` | verify: $input |
| `compliance Saved.` | Total verify entries: $total |
| `compliance [Compliance]` | revoke: $input |
| `compliance Saved.` | Total revoke entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/compliance/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
