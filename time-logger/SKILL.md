---
version: "2.0.0"
name: time-logger
description: "Time tracking for tasks and projects with reports and exports. Use when you need to start/stop timers, log time on tasks, view daily/weekly summaries, generate time reports, or export timesheets. Triggers on: time tracking, timesheet, billable hours, time log, productivity, pomodoro."
---

# Activitywatch

Time Tracker — track where your time goes

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/activitywatch.sh <command>` to use.

- `start` — <task> [project]  Start timer
- `stop` —                    Stop current timer
- `status` —                  Current timer status
- `log` — [days]              Time log (default 7 days)
- `report` — [days]           Summary report
- `projects` —                List projects
- `today` —                   Today's breakdown
- `week` —                    This week summary
- `export` — [format]         Export (csv/json/md)
- `info` —                    Version info

## Quick Start

```bash
activitywatch.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
