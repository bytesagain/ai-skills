---
name: "Whatsapp"
description: "Terminal-first Whatsapp manager. Keep your integrations data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["whatsapp", "tool", "terminal", "cli", "utility"]
---

# Whatsapp

Terminal-first Whatsapp manager. Keep your integrations data organized with simple commands.

## Why Whatsapp?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
whatsapp help

# Check current status
whatsapp status

# View your statistics
whatsapp stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `whatsapp connect` | Connect |
| `whatsapp sync` | Sync |
| `whatsapp monitor` | Monitor |
| `whatsapp automate` | Automate |
| `whatsapp notify` | Notify |
| `whatsapp report` | Report |
| `whatsapp schedule` | Schedule |
| `whatsapp template` | Template |
| `whatsapp webhook` | Webhook |
| `whatsapp status` | Status |
| `whatsapp analytics` | Analytics |
| `whatsapp export` | Export |
| `whatsapp stats` | Summary statistics |
| `whatsapp export` | <fmt>       Export (json|csv|txt) |
| `whatsapp search` | <term>      Search entries |
| `whatsapp recent` | Recent activity |
| `whatsapp status` | Health check |
| `whatsapp help` | Show this help |
| `whatsapp version` | Show version |
| `whatsapp $name:` | $c entries |
| `whatsapp Total:` | $total entries |
| `whatsapp Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `whatsapp Version:` | v2.0.0 |
| `whatsapp Data` | dir: $DATA_DIR |
| `whatsapp Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `whatsapp Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `whatsapp Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `whatsapp Status:` | OK |
| `whatsapp [Whatsapp]` | connect: $input |
| `whatsapp Saved.` | Total connect entries: $total |
| `whatsapp [Whatsapp]` | sync: $input |
| `whatsapp Saved.` | Total sync entries: $total |
| `whatsapp [Whatsapp]` | monitor: $input |
| `whatsapp Saved.` | Total monitor entries: $total |
| `whatsapp [Whatsapp]` | automate: $input |
| `whatsapp Saved.` | Total automate entries: $total |
| `whatsapp [Whatsapp]` | notify: $input |
| `whatsapp Saved.` | Total notify entries: $total |
| `whatsapp [Whatsapp]` | report: $input |
| `whatsapp Saved.` | Total report entries: $total |
| `whatsapp [Whatsapp]` | schedule: $input |
| `whatsapp Saved.` | Total schedule entries: $total |
| `whatsapp [Whatsapp]` | template: $input |
| `whatsapp Saved.` | Total template entries: $total |
| `whatsapp [Whatsapp]` | webhook: $input |
| `whatsapp Saved.` | Total webhook entries: $total |
| `whatsapp [Whatsapp]` | status: $input |
| `whatsapp Saved.` | Total status entries: $total |
| `whatsapp [Whatsapp]` | analytics: $input |
| `whatsapp Saved.` | Total analytics entries: $total |
| `whatsapp [Whatsapp]` | export: $input |
| `whatsapp Saved.` | Total export entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/whatsapp/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
