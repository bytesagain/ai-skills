---
version: "2.0.0"
name: deepfocus
description: "Pomodoro timer with session logging, streaks, and statistics. Use when you need timed focus sessions, short/long breaks, track daily pomodoro count, maintain focus streaks, or review productivity stats. Triggers on: pomodoro, focus, timer, productivity, deep work, concentration."
---

# Focus Timer

Pomodoro Timer — focus with timed sessions

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/pomotroid.sh <command>` to use.

- `start` — [min] [task]    Start session (default 25min)
- `break` — [min]           Short break (default 5min)
- `long-break` — [min]      Long break (default 15min)
- `status` —                Current session
- `log` — [n]               Recent sessions
- `stats` —                 Pomodoro statistics
- `today` —                 Today's sessions
- `streak` —                Current day streak
- `info` —                  Version info

## Quick Start

```bash
pomotroid.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
