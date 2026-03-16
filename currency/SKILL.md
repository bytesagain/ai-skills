---
name: "Currency"
description: "Your personal Currency assistant. Track, analyze, and manage all your travel planning needs from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["planning", "travel", "trips", "currency", "booking"]
---

# Currency

Your personal Currency assistant. Track, analyze, and manage all your travel planning needs from the command line.

## Why Currency?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
currency help

# Check current status
currency status

# View your statistics
currency stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `currency plan` | Plan |
| `currency search` | Search |
| `currency book` | Book |
| `currency pack-list` | Pack List |
| `currency budget` | Budget |
| `currency convert` | Convert |
| `currency weather` | Weather |
| `currency route` | Route |
| `currency checklist` | Checklist |
| `currency journal` | Journal |
| `currency compare` | Compare |
| `currency remind` | Remind |
| `currency stats` | Summary statistics |
| `currency export` | <fmt>       Export (json|csv|txt) |
| `currency search` | <term>      Search entries |
| `currency recent` | Recent activity |
| `currency status` | Health check |
| `currency help` | Show this help |
| `currency version` | Show version |
| `currency $name:` | $c entries |
| `currency Total:` | $total entries |
| `currency Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `currency Version:` | v2.0.0 |
| `currency Data` | dir: $DATA_DIR |
| `currency Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `currency Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `currency Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `currency Status:` | OK |
| `currency [Currency]` | plan: $input |
| `currency Saved.` | Total plan entries: $total |
| `currency [Currency]` | search: $input |
| `currency Saved.` | Total search entries: $total |
| `currency [Currency]` | book: $input |
| `currency Saved.` | Total book entries: $total |
| `currency [Currency]` | pack-list: $input |
| `currency Saved.` | Total pack-list entries: $total |
| `currency [Currency]` | budget: $input |
| `currency Saved.` | Total budget entries: $total |
| `currency [Currency]` | convert: $input |
| `currency Saved.` | Total convert entries: $total |
| `currency [Currency]` | weather: $input |
| `currency Saved.` | Total weather entries: $total |
| `currency [Currency]` | route: $input |
| `currency Saved.` | Total route entries: $total |
| `currency [Currency]` | checklist: $input |
| `currency Saved.` | Total checklist entries: $total |
| `currency [Currency]` | journal: $input |
| `currency Saved.` | Total journal entries: $total |
| `currency [Currency]` | compare: $input |
| `currency Saved.` | Total compare entries: $total |
| `currency [Currency]` | remind: $input |
| `currency Saved.` | Total remind entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/currency/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
