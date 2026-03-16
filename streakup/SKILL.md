---
version: "2.0.0"
name: streakup
description: "Habit tracker with streaks, calendars, and progress reports. Use when you need to build habits, track daily check-ins, maintain streaks, view habit calendars, or generate progress reports. Triggers on: habit, streak, daily routine, consistency, discipline, behavior change."
---

# Habit Builder

Habit Tracker — build better habits

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/habitica.sh <command>` to use.

- `add` — <name> [freq]     Add habit (daily/weekly/custom)
- `check` — <name>          Mark habit done today
- `list` —                  List all habits with streaks
- `streak` — <name>         Show streak for habit
- `stats` —                 Overall statistics
- `calendar` — <name>       Visual calendar view
- `reset` — <name>          Reset streak
- `remove` — <name>         Remove habit
- `report` — [days]         Progress report
- `info` —                  Version info

## Quick Start

```bash
habitica.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
