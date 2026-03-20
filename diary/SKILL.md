---
name: diary
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [diary, tool, utility]
description: "Write diary entries with mood tracking, photos, and monthly summaries. Use when recording thoughts, tracking moods, reviewing monthly patterns."
---

# Diary

A productivity logging and tracking toolkit. Record entries across 13 categories — add, plan, track, review, streak, remind, prioritize, archive, tag, timeline, report, and weekly-review. Each command stores timestamped entries locally with full activity history, search, statistics, and multi-format export.

## Commands

### `add` — Add a diary entry

Record a new entry or view recent entries. Called with no arguments, shows the last 20 entries.

```bash
bash scripts/script.sh add "morning standup: discussed sprint priorities"
bash scripts/script.sh add "completed code review for PR #142"
bash scripts/script.sh add
```

### `plan` — Record or view plans

Log planning decisions, goals, or upcoming task outlines.

```bash
bash scripts/script.sh plan "Q2 goals: ship v2.0, hire 2 engineers, reduce p50 latency"
bash scripts/script.sh plan "this week: finish API migration, write docs"
bash scripts/script.sh plan
```

### `track` — Track progress

Record progress on ongoing tasks, habits, or metrics.

```bash
bash scripts/script.sh track "reading: finished chapter 7 of DDIA"
bash scripts/script.sh track "exercise: 30min run, 5km"
bash scripts/script.sh track
```

### `review` — Record reviews

Log review notes — code reviews, sprint retros, or self-reflection.

```bash
bash scripts/script.sh review "sprint retro: deployment process needs automation"
bash scripts/script.sh review "1:1 feedback: improve async communication"
```

### `streak` — Track streaks

Record streak milestones for habits or daily practices.

```bash
bash scripts/script.sh streak "coding: day 45 consecutive"
bash scripts/script.sh streak "meditation: day 12"
bash scripts/script.sh streak
```

### `remind` — Set reminders

Log reminders and follow-up items.

```bash
bash scripts/script.sh remind "follow up with vendor on contract renewal by Friday"
bash scripts/script.sh remind "dentist appointment next Tuesday 2pm"
```

### `prioritize` — Record priorities

Log prioritization decisions and task rankings.

```bash
bash scripts/script.sh prioritize "P0: fix auth bug, P1: deploy monitoring, P2: update docs"
bash scripts/script.sh prioritize "today: database migration > API tests > code review"
```

### `archive` — Archive entries

Mark items as archived or log archival operations.

```bash
bash scripts/script.sh archive "moved Q1 OKRs to archive"
bash scripts/script.sh archive "closed 14 stale tickets from backlog"
```

### `tag` — Tag entries

Add tags or categorizations to organize your log data.

```bash
bash scripts/script.sh tag "project:atlas, type:bugfix, severity:high"
bash scripts/script.sh tag "#learning #rust #systems"
```

### `timeline` — Record timeline events

Log chronological milestones and key events.

```bash
bash scripts/script.sh timeline "v2.0 released to production"
bash scripts/script.sh timeline "team offsite: Tokyo, March 15-17"
```

### `report` — Generate or record reports

Log report creation or summary observations.

```bash
bash scripts/script.sh report "weekly status: 12 PRs merged, 3 bugs fixed, 1 incident"
bash scripts/script.sh report "monthly review: on track for Q2 targets"
```

### `weekly-review` — Weekly review entries

Record weekly review summaries for reflection and planning.

```bash
bash scripts/script.sh weekly-review "good: shipped search feature. improve: testing coverage"
bash scripts/script.sh weekly-review "wins: closed 8 tickets. blockers: CI flakiness"
```

### `stats` — Summary statistics

Show entry counts per category, total entries, data size, and earliest recorded activity.

```bash
bash scripts/script.sh stats
```

### `export` — Export all data

Export all logged entries to JSON, CSV, or plain text format.

```bash
bash scripts/script.sh export json
bash scripts/script.sh export csv
bash scripts/script.sh export txt
```

### `search` — Search across all entries

Search all log files for a keyword (case-insensitive).

```bash
bash scripts/script.sh search "sprint"
bash scripts/script.sh search "meditation"
```

### `recent` — View recent activity

Show the last 20 entries from the global activity history.

```bash
bash scripts/script.sh recent
```

### `status` — Health check

Display version, data directory, total entries, disk usage, and last activity timestamp.

```bash
bash scripts/script.sh status
```

### `help` / `version`

```bash
bash scripts/script.sh help
bash scripts/script.sh version
```

## Data Storage

All data is stored locally in `~/.local/share/diary/`:

- **Per-command logs:** `add.log`, `plan.log`, `track.log`, `review.log`, `streak.log`, `remind.log`, `prioritize.log`, `archive.log`, `tag.log`, `timeline.log`, `report.log`, `weekly-review.log`
- **Activity history:** `history.log` — global log of all operations with timestamps
- **Exports:** `export.json`, `export.csv`, or `export.txt` (generated on demand)

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` with pipe-delimited fields.

## Requirements

- **bash 4+**
- **grep, wc, du, tail, head, cat, date, basename** (standard coreutils)
- No external dependencies

## When to Use

1. **Daily work journaling** — Use `add` throughout the day to capture what you did, decisions made, and things learned
2. **Sprint planning and retros** — Combine `plan`, `review`, and `weekly-review` for agile workflow documentation
3. **Habit tracking** — Use `track` and `streak` to build accountability for daily habits (exercise, reading, coding)
4. **Priority management** — Log priority decisions with `prioritize` and set follow-ups with `remind`
5. **Long-term reflection** — Export monthly data with `export json` and use `timeline` to mark significant milestones

## Examples

```bash
# Start your day with a plan
bash scripts/script.sh plan "today: fix auth bug, review PR #200, update API docs"

# Track progress throughout the day
bash scripts/script.sh add "fixed auth token refresh — was using expired key"
bash scripts/script.sh track "PR #200 reviewed, left 3 comments"
bash scripts/script.sh tag "#bugfix #auth #security"

# End-of-week review
bash scripts/script.sh weekly-review "shipped: auth fix, search feature. next: monitoring dashboard"
bash scripts/script.sh stats

# Search and export
bash scripts/script.sh search "auth"
bash scripts/script.sh export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
