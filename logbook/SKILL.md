---
name: LogBook
version: "2.0.0"
author: "BytesAgain"
tags: ["journal","diary","log","daily","writing","personal","productivity","notes"]
categories: ["Personal Management", "Productivity", "Writing"]
description: "Logbook - command-line tool for everyday use"
---

# LogBook

LogBook is your personal digital journal that runs in the terminal. Write down thoughts, ideas, and daily observations. Search through your history. Track your journaling habits.

## Why LogBook?

- **Instant capture**: Log a thought in 2 seconds
- **Searchable**: Find any past entry by keyword
- **Private**: All data stays on your machine
- **Lightweight**: No database, no accounts, just files
- **Exportable**: Export to markdown for backup or sharing

## Commands

- `write <text>` — Write a new log entry (auto-timestamped)
- `today` — View all of today's entries
- `week` — Browse entries from the past 7 days grouped by date
- `search <keyword>` — Full-text search across all entries
- `stats` — View journaling statistics (total entries, most active day, daily average)
- `export` — Export all entries as formatted markdown
- `info` — Version information
- `help` — Show available commands

## Usage Examples

```bash
logbook write Had a great meeting about the new project
logbook write Reminder: call dentist tomorrow
logbook today
logbook search project
logbook week
logbook stats
```

## Data Storage

All entries are stored in `~/.logbook/entries.json`. Back up this file to preserve your journal.

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
