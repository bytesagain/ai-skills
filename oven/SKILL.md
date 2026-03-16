---
name: "Oven"
description: "Lightweight Oven tracker. Add entries, view stats, search history, and export in multiple formats."
version: "2.0.0"
author: "BytesAgain"
tags: ["maintenance", "oven", "domestic", "smart-home", "household"]
---

# Oven

Lightweight Oven tracker. Add entries, view stats, search history, and export in multiple formats.

## Why Oven?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
oven help

# Check current status
oven status

# View your statistics
oven stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `oven add` | Add |
| `oven inventory` | Inventory |
| `oven schedule` | Schedule |
| `oven remind` | Remind |
| `oven checklist` | Checklist |
| `oven usage` | Usage |
| `oven cost` | Cost |
| `oven maintain` | Maintain |
| `oven log` | Log |
| `oven report` | Report |
| `oven seasonal` | Seasonal |
| `oven tips` | Tips |
| `oven stats` | Summary statistics |
| `oven export` | <fmt>       Export (json|csv|txt) |
| `oven search` | <term>      Search entries |
| `oven recent` | Recent activity |
| `oven status` | Health check |
| `oven help` | Show this help |
| `oven version` | Show version |
| `oven $name:` | $c entries |
| `oven Total:` | $total entries |
| `oven Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `oven Version:` | v2.0.0 |
| `oven Data` | dir: $DATA_DIR |
| `oven Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `oven Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `oven Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `oven Status:` | OK |
| `oven [Oven]` | add: $input |
| `oven Saved.` | Total add entries: $total |
| `oven [Oven]` | inventory: $input |
| `oven Saved.` | Total inventory entries: $total |
| `oven [Oven]` | schedule: $input |
| `oven Saved.` | Total schedule entries: $total |
| `oven [Oven]` | remind: $input |
| `oven Saved.` | Total remind entries: $total |
| `oven [Oven]` | checklist: $input |
| `oven Saved.` | Total checklist entries: $total |
| `oven [Oven]` | usage: $input |
| `oven Saved.` | Total usage entries: $total |
| `oven [Oven]` | cost: $input |
| `oven Saved.` | Total cost entries: $total |
| `oven [Oven]` | maintain: $input |
| `oven Saved.` | Total maintain entries: $total |
| `oven [Oven]` | log: $input |
| `oven Saved.` | Total log entries: $total |
| `oven [Oven]` | report: $input |
| `oven Saved.` | Total report entries: $total |
| `oven [Oven]` | seasonal: $input |
| `oven Saved.` | Total seasonal entries: $total |
| `oven [Oven]` | tips: $input |
| `oven Saved.` | Total tips entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/oven/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
