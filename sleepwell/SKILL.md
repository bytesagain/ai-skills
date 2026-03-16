---
name: SleepWell
description: "Sleep quality tracker for better rest. Log your bedtime and wake-up time with a quality rating (1-5), track sleep duration patterns, view weekly sleep charts with visual bars, get long-term sleep statistics including average duration and quality, and receive evidence-based sleep improvement tips. Helps identify whether you're getting the recommended 7-9 hours."
version: "2.0.0"
author: "BytesAgain"
tags: ["sleep","health","wellness","tracker","rest","habits","quality","bedtime"]
categories: ["Health & Wellness", "Personal Management", "Productivity"]
---

# SleepWell

SleepWell helps you understand and improve your sleep habits. Track when you go to bed, when you wake up, and how well you slept — then see patterns over time.

## Why SleepWell?

- **Simple logging**: Record sleep in one command
- **Quality tracking**: Rate sleep quality 1-5 alongside duration
- **Visual charts**: Weekly sleep duration bars
- **Smart analysis**: Warns when below recommended 7-9 hours
- **Sleep tips**: Evidence-based tips for better rest
## Commands

- `log <bedtime> <wakeup> [quality 1-5]` — Log a night's sleep (times in HH:MM format)
- `today` — View today's sleep entry
- `week` — Weekly sleep chart with visual duration bars
- `stats` — Long-term sleep statistics (average hours, quality, best/worst nights)
- `tips` — Get a random evidence-based sleep improvement tip
- `info` — Version information
- `help` — Show available commands

## Usage Examples

```bash
sleepwell log 23:00 07:00 4
sleepwell log 00:30 08:15 3
sleepwell week
sleepwell stats
sleepwell tips
```

## Weekly Chart Example

```
03-08 ████████  8.0h (q:4)
03-09 ███████   7.0h (q:3)
03-10 █████     5.5h (q:2)
03-11 ████████  8.5h (q:5)
  Avg: 7.3h/night, quality 3.5/5
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
