---
name: "Backup"
description: "Lightweight Backup tracker. Add entries, view stats, search history, and export in multiple formats."
version: "2.0.0"
author: "BytesAgain"
tags: ["server", "linux", "devops", "backup", "sysadmin"]
---

# Backup

Lightweight Backup tracker. Add entries, view stats, search history, and export in multiple formats.

## Why Backup?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
backup help

# Check current status
backup status

# View your statistics
backup stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `backup scan` | Scan |
| `backup monitor` | Monitor |
| `backup report` | Report |
| `backup alert` | Alert |
| `backup top` | Top |
| `backup usage` | Usage |
| `backup check` | Check |
| `backup fix` | Fix |
| `backup cleanup` | Cleanup |
| `backup backup` | Backup |
| `backup restore` | Restore |
| `backup log` | Log |
| `backup benchmark` | Benchmark |
| `backup compare` | Compare |
| `backup stats` | Summary statistics |
| `backup export` | <fmt>       Export (json|csv|txt) |
| `backup search` | <term>      Search entries |
| `backup recent` | Recent activity |
| `backup status` | Health check |
| `backup help` | Show this help |
| `backup version` | Show version |
| `backup $name:` | $c entries |
| `backup Total:` | $total entries |
| `backup Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `backup Version:` | v2.0.0 |
| `backup Data` | dir: $DATA_DIR |
| `backup Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `backup Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `backup Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `backup Status:` | OK |
| `backup [Backup]` | scan: $input |
| `backup Saved.` | Total scan entries: $total |
| `backup [Backup]` | monitor: $input |
| `backup Saved.` | Total monitor entries: $total |
| `backup [Backup]` | report: $input |
| `backup Saved.` | Total report entries: $total |
| `backup [Backup]` | alert: $input |
| `backup Saved.` | Total alert entries: $total |
| `backup [Backup]` | top: $input |
| `backup Saved.` | Total top entries: $total |
| `backup [Backup]` | usage: $input |
| `backup Saved.` | Total usage entries: $total |
| `backup [Backup]` | check: $input |
| `backup Saved.` | Total check entries: $total |
| `backup [Backup]` | fix: $input |
| `backup Saved.` | Total fix entries: $total |
| `backup [Backup]` | cleanup: $input |
| `backup Saved.` | Total cleanup entries: $total |
| `backup [Backup]` | backup: $input |
| `backup Saved.` | Total backup entries: $total |
| `backup [Backup]` | restore: $input |
| `backup Saved.` | Total restore entries: $total |
| `backup [Backup]` | log: $input |
| `backup Saved.` | Total log entries: $total |
| `backup [Backup]` | benchmark: $input |
| `backup Saved.` | Total benchmark entries: $total |
| `backup [Backup]` | compare: $input |
| `backup Saved.` | Total compare entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/backup/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
