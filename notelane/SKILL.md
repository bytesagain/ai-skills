---
version: "1.0.0"
name: notelane
description: "Organize notes as a personal knowledge base with tagging and full-text search. Use when capturing notes, searching entries, building a knowledge base."
---

# Notelane

Notelane v2.0.0 — a productivity toolkit for adding, planning, tracking, reviewing, and organizing notes from the command line. Features streaks, reminders, prioritization, tagging, timelines, weekly reviews, and full data export.

## Commands

Run `notelane <command> [args]` to use. Each data command accepts optional input — with no arguments it shows recent entries; with arguments it records a new entry.

| Command | Description |
|---------|-------------|
| `add [input]` | Add a new note or entry |
| `plan [input]` | Record or review planning notes |
| `track [input]` | Track progress on goals or tasks |
| `review [input]` | Log review notes and reflections |
| `streak [input]` | Track daily streaks and consistency |
| `remind [input]` | Set and review reminders |
| `prioritize [input]` | Record prioritization decisions |
| `archive [input]` | Archive old notes and entries |
| `tag [input]` | Tag entries for organization |
| `timeline [input]` | Build timeline entries for projects or events |
| `report [input]` | Generate or record summary reports |
| `weekly-review [input]` | Log weekly review notes and retrospectives |
| `stats` | Show summary statistics across all entry types |
| `export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `search <term>` | Full-text search across all log entries |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show built-in help message |
| `version` | Print version string (`notelane v2.0.0`) |

## Features

- **18+ subcommands** covering the full note-taking and productivity lifecycle
- **Productivity-focused** — streaks, reminders, prioritization, weekly reviews built in
- **Local-first storage** — all data in `~/.local/share/notelane/` as plain-text logs
- **Timestamped entries** — every record includes `YYYY-MM-DD HH:MM` timestamps
- **Unified history log** — `history.log` tracks every action for auditability
- **Multi-format export** — JSON, CSV, and plain-text export built in
- **Full-text search** — grep-based search across all log files
- **Zero external dependencies** — pure Bash, runs anywhere
- **Automatic data directory creation** — no setup required

## Data Storage

All data is stored in `~/.local/share/notelane/`:

- `add.log`, `plan.log`, `track.log`, `review.log`, `streak.log`, `remind.log`, `prioritize.log`, `archive.log`, `tag.log`, `timeline.log`, `report.log`, `weekly-review.log` — per-command entry logs
- `history.log` — unified audit trail of all operations
- `export.json`, `export.csv`, `export.txt` — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No root privileges required
- No internet connection required

## When to Use

1. **Quick note capture** — run `notelane add "Meeting notes: decided to migrate to Postgres by Q3"` to instantly record a thought or decision
2. **Planning and goal tracking** — use `notelane plan "Sprint 12: finish API refactor, deploy staging"` and `notelane track "API refactor 80% complete"` to manage projects
3. **Building daily streaks** — log daily habits with `notelane streak "Day 15: morning workout done"` to maintain consistency tracking
4. **Weekly retrospectives** — use `notelane weekly-review "Shipped 3 features, 1 bug regression, need more testing"` to document weekly learnings
5. **Organizing with tags and timelines** — tag entries with `notelane tag "project:atlas priority:high"` and build event timelines with `notelane timeline "2024-03-15: v2.0 launched"`

## Examples

```bash
# Show all available commands
notelane help

# Add a quick note
notelane add "Idea: build a CLI dashboard for server metrics"

# Record a plan
notelane plan "This week: finalize docs, cut release, update changelog"

# Track progress
notelane track "Documentation: 3 of 5 sections complete"

# Log a reminder
notelane remind "Send invoice to client by Friday"

# Set priorities
notelane prioritize "P0: fix auth bug; P1: add export feature; P2: refactor tests"

# Run a weekly review
notelane weekly-review "Good week — shipped auth fix, started on export. Next: testing."

# View summary statistics
notelane stats

# Search all notes
notelane search "API"

# Export everything to JSON
notelane export json

# Check tool health
notelane status
```

## How It Works

Notelane stores all data locally in `~/.local/share/notelane/`. Each command logs activity with timestamps for full traceability. When called without arguments, data commands display their most recent 20 entries. When called with arguments, they append a new timestamped entry and update the unified history log.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
