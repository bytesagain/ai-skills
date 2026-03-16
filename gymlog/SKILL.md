---
version: "2.0.0"
name: gymlog
description: "Fitness and workout tracker with calorie estimation, weight logging, and personal bests. Use when you need to log workouts (run/gym/yoga/swim/bike), track body weight, view weekly summaries, generate workout plans, or check fitness streaks. Triggers on: workout, exercise, fitness, gym, run, weight, calories, training plan."
---

# Fitness Log

Fitness Log — track workouts & progress

## Why This Skill?

- Designed for everyday personal use
- No external dependencies or accounts needed
- Simple commands, powerful results

## Commands

- `log` — <type> <dur> [note]  Log workout (type=run/gym/yoga/swim/bike)
- `weight` — <kg>              Log body weight
- `today` —                    Today's activity
- `week` —                     Weekly summary
- `history` — [n]              Workout history (default 10)
- `stats` —                    Overall statistics
- `streak` —                   Workout streak
- `plan` — <goal>              Generate workout plan
- `progress` —                 Weight progress chart
- `personal-best` —            Personal records
- `export` — [format]          Export (csv/json)
- `info` —                     Version info

## Quick Start

```bash
fitness_log.sh help
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
