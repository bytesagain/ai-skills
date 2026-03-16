---
name: "Compass"
description: "Your personal Compass assistant. Track, analyze, and manage all your security needs from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["encryption", "compass", "protection", "compliance", "privacy"]
---

# Compass

Your personal Compass assistant. Track, analyze, and manage all your security needs from the command line.

## Why Compass?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
compass help

# Check current status
compass status

# View your statistics
compass stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `compass generate` | Generate |
| `compass check-strength` | Check Strength |
| `compass rotate` | Rotate |
| `compass audit` | Audit |
| `compass store` | Store |
| `compass retrieve` | Retrieve |
| `compass expire` | Expire |
| `compass policy` | Policy |
| `compass report` | Report |
| `compass hash` | Hash |
| `compass verify` | Verify |
| `compass revoke` | Revoke |
| `compass stats` | Summary statistics |
| `compass export` | <fmt>       Export (json|csv|txt) |
| `compass search` | <term>      Search entries |
| `compass recent` | Recent activity |
| `compass status` | Health check |
| `compass help` | Show this help |
| `compass version` | Show version |
| `compass $name:` | $c entries |
| `compass Total:` | $total entries |
| `compass Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compass Version:` | v2.0.0 |
| `compass Data` | dir: $DATA_DIR |
| `compass Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `compass Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `compass Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `compass Status:` | OK |
| `compass [Compass]` | generate: $input |
| `compass Saved.` | Total generate entries: $total |
| `compass [Compass]` | check-strength: $input |
| `compass Saved.` | Total check-strength entries: $total |
| `compass [Compass]` | rotate: $input |
| `compass Saved.` | Total rotate entries: $total |
| `compass [Compass]` | audit: $input |
| `compass Saved.` | Total audit entries: $total |
| `compass [Compass]` | store: $input |
| `compass Saved.` | Total store entries: $total |
| `compass [Compass]` | retrieve: $input |
| `compass Saved.` | Total retrieve entries: $total |
| `compass [Compass]` | expire: $input |
| `compass Saved.` | Total expire entries: $total |
| `compass [Compass]` | policy: $input |
| `compass Saved.` | Total policy entries: $total |
| `compass [Compass]` | report: $input |
| `compass Saved.` | Total report entries: $total |
| `compass [Compass]` | hash: $input |
| `compass Saved.` | Total hash entries: $total |
| `compass [Compass]` | verify: $input |
| `compass Saved.` | Total verify entries: $total |
| `compass [Compass]` | revoke: $input |
| `compass Saved.` | Total revoke entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/compass/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
