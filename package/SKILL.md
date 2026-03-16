---
name: "Package"
description: "Package — a fast travel planning tool. Log anything, find it later, export when needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["planning", "exploration", "trips", "package", "booking"]
---

# Package

Package — a fast travel planning tool. Log anything, find it later, export when needed.

## Why Package?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
package help

# Check current status
package status

# View your statistics
package stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `package plan` | Plan |
| `package search` | Search |
| `package book` | Book |
| `package pack-list` | Pack List |
| `package budget` | Budget |
| `package convert` | Convert |
| `package weather` | Weather |
| `package route` | Route |
| `package checklist` | Checklist |
| `package journal` | Journal |
| `package compare` | Compare |
| `package remind` | Remind |
| `package stats` | Summary statistics |
| `package export` | <fmt>       Export (json|csv|txt) |
| `package search` | <term>      Search entries |
| `package recent` | Recent activity |
| `package status` | Health check |
| `package help` | Show this help |
| `package version` | Show version |
| `package $name:` | $c entries |
| `package Total:` | $total entries |
| `package Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `package Version:` | v2.0.0 |
| `package Data` | dir: $DATA_DIR |
| `package Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `package Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `package Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `package Status:` | OK |
| `package [Package]` | plan: $input |
| `package Saved.` | Total plan entries: $total |
| `package [Package]` | search: $input |
| `package Saved.` | Total search entries: $total |
| `package [Package]` | book: $input |
| `package Saved.` | Total book entries: $total |
| `package [Package]` | pack-list: $input |
| `package Saved.` | Total pack-list entries: $total |
| `package [Package]` | budget: $input |
| `package Saved.` | Total budget entries: $total |
| `package [Package]` | convert: $input |
| `package Saved.` | Total convert entries: $total |
| `package [Package]` | weather: $input |
| `package Saved.` | Total weather entries: $total |
| `package [Package]` | route: $input |
| `package Saved.` | Total route entries: $total |
| `package [Package]` | checklist: $input |
| `package Saved.` | Total checklist entries: $total |
| `package [Package]` | journal: $input |
| `package Saved.` | Total journal entries: $total |
| `package [Package]` | compare: $input |
| `package Saved.` | Total compare entries: $total |
| `package [Package]` | remind: $input |
| `package Saved.` | Total remind entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/package/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
