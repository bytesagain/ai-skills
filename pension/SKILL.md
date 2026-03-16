---
name: "Pension"
description: "A focused personal finance tool built for Pension. Log entries, review trends, and export reports — all locally."
version: "2.0.0"
author: "BytesAgain"
tags: ["budget", "personal-finance", "tracking", "pension", "money"]
---

# Pension

A focused personal finance tool built for Pension. Log entries, review trends, and export reports — all locally.

## Why Pension?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
pension help

# Check current status
pension status

# View your statistics
pension stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `pension record` | Record |
| `pension categorize` | Categorize |
| `pension balance` | Balance |
| `pension trend` | Trend |
| `pension forecast` | Forecast |
| `pension export-report` | Export Report |
| `pension budget-check` | Budget Check |
| `pension summary` | Summary |
| `pension alert` | Alert |
| `pension history` | History |
| `pension compare` | Compare |
| `pension tax-note` | Tax Note |
| `pension stats` | Summary statistics |
| `pension export` | <fmt>       Export (json|csv|txt) |
| `pension search` | <term>      Search entries |
| `pension recent` | Recent activity |
| `pension status` | Health check |
| `pension help` | Show this help |
| `pension version` | Show version |
| `pension $name:` | $c entries |
| `pension Total:` | $total entries |
| `pension Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `pension Version:` | v2.0.0 |
| `pension Data` | dir: $DATA_DIR |
| `pension Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `pension Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `pension Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `pension Status:` | OK |
| `pension [Pension]` | record: $input |
| `pension Saved.` | Total record entries: $total |
| `pension [Pension]` | categorize: $input |
| `pension Saved.` | Total categorize entries: $total |
| `pension [Pension]` | balance: $input |
| `pension Saved.` | Total balance entries: $total |
| `pension [Pension]` | trend: $input |
| `pension Saved.` | Total trend entries: $total |
| `pension [Pension]` | forecast: $input |
| `pension Saved.` | Total forecast entries: $total |
| `pension [Pension]` | export-report: $input |
| `pension Saved.` | Total export-report entries: $total |
| `pension [Pension]` | budget-check: $input |
| `pension Saved.` | Total budget-check entries: $total |
| `pension [Pension]` | summary: $input |
| `pension Saved.` | Total summary entries: $total |
| `pension [Pension]` | alert: $input |
| `pension Saved.` | Total alert entries: $total |
| `pension [Pension]` | history: $input |
| `pension Saved.` | Total history entries: $total |
| `pension [Pension]` | compare: $input |
| `pension Saved.` | Total compare entries: $total |
| `pension [Pension]` | tax-note: $input |
| `pension Saved.` | Total tax-note entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/pension/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
