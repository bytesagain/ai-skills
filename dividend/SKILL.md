---
name: "Dividend"
description: "Lightweight Dividend tracker. Add entries, view stats, search history, and export in multiple formats."
version: "2.0.0"
author: "BytesAgain"
tags: ["planning", "dividend", "budget", "personal-finance", "accounting"]
---

# Dividend

Lightweight Dividend tracker. Add entries, view stats, search history, and export in multiple formats.

## Why Dividend?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
dividend help

# Check current status
dividend status

# View your statistics
dividend stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `dividend record` | Record |
| `dividend categorize` | Categorize |
| `dividend balance` | Balance |
| `dividend trend` | Trend |
| `dividend forecast` | Forecast |
| `dividend export-report` | Export Report |
| `dividend budget-check` | Budget Check |
| `dividend summary` | Summary |
| `dividend alert` | Alert |
| `dividend history` | History |
| `dividend compare` | Compare |
| `dividend tax-note` | Tax Note |
| `dividend stats` | Summary statistics |
| `dividend export` | <fmt>       Export (json|csv|txt) |
| `dividend search` | <term>      Search entries |
| `dividend recent` | Recent activity |
| `dividend status` | Health check |
| `dividend help` | Show this help |
| `dividend version` | Show version |
| `dividend $name:` | $c entries |
| `dividend Total:` | $total entries |
| `dividend Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `dividend Version:` | v2.0.0 |
| `dividend Data` | dir: $DATA_DIR |
| `dividend Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `dividend Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `dividend Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `dividend Status:` | OK |
| `dividend [Dividend]` | record: $input |
| `dividend Saved.` | Total record entries: $total |
| `dividend [Dividend]` | categorize: $input |
| `dividend Saved.` | Total categorize entries: $total |
| `dividend [Dividend]` | balance: $input |
| `dividend Saved.` | Total balance entries: $total |
| `dividend [Dividend]` | trend: $input |
| `dividend Saved.` | Total trend entries: $total |
| `dividend [Dividend]` | forecast: $input |
| `dividend Saved.` | Total forecast entries: $total |
| `dividend [Dividend]` | export-report: $input |
| `dividend Saved.` | Total export-report entries: $total |
| `dividend [Dividend]` | budget-check: $input |
| `dividend Saved.` | Total budget-check entries: $total |
| `dividend [Dividend]` | summary: $input |
| `dividend Saved.` | Total summary entries: $total |
| `dividend [Dividend]` | alert: $input |
| `dividend Saved.` | Total alert entries: $total |
| `dividend [Dividend]` | history: $input |
| `dividend Saved.` | Total history entries: $total |
| `dividend [Dividend]` | compare: $input |
| `dividend Saved.` | Total compare entries: $total |
| `dividend [Dividend]` | tax-note: $input |
| `dividend Saved.` | Total tax-note entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/dividend/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
