---
version: "2.0.0"
name: moodring
description: "Log daily moods, spot emotional patterns, and review wellbeing trends over time. Use when logging mood, spotting patterns, reviewing weekly wellbeing."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Mood Ring

Emotional wellbeing tracker. Log your mood on a 1–5 scale, add notes about what's happening, then use built-in analytics to spot patterns, track streaks, identify triggers, and review trends over days and weeks.

## Commands

All commands are invoked via `moodring <command> [args]`.

| Command | Description |
|---------|-------------|
| `log <1-5> [note]` | Log a mood entry. Score: 1=😞 Terrible, 2=😕 Bad, 3=😐 Okay, 4=😊 Good, 5=🤩 Amazing. Optional note for context. |
| `today` | Show all mood entries logged today with individual scores, times, notes, and daily average |
| `week` | Display a 7-day mood chart with ASCII bar visualization and weekly average |
| `history [n]` | Show mood history for the last *n* days (default: 14). Lists every entry with emoji, score, time, and note. |
| `stats` | Full mood statistics — total entries, overall average, best/worst scores, and score distribution with percentage bars |
| `patterns` | Identify mood patterns by day of week (Mon–Sun averages) and time of day (Morning/Afternoon/Evening) |
| `triggers [mood]` | Analyze notes to find common trigger words. Optionally filter by a specific mood score (e.g. `triggers 5` for what makes you happiest). |
| `streak` | Check your current positive mood streak (consecutive days with score ≥ 4) |
| `journal <text>` | Write a freeform journal entry, stored separately from mood scores, timestamped with date and time |
| `insights` | AI-style mood insights — overall average, recent trend (improving/declining/stable), and percentage of good days |
| `info` | Show version and credit info |
| `help` | Show the built-in help message with all available commands |

## Data Storage

- **Mood data:** `~/.moodring/moods.json` — JSON array of mood entries, each with date, time, weekday, score, and note
- **Journal data:** `~/.moodring/journal.json` — JSON array of journal entries, each with date, time, and text
- **Privacy:** All data remains on disk on your machine. No cloud sync, no telemetry, no external API calls.

## Requirements

- Bash 4+
- Python 3 (standard library only — uses `json`, `datetime`, `collections`)
- No pip packages, no API keys, no network access needed

## When to Use

1. **Daily mood tracking** — Log how you're feeling throughout the day with `moodring log 4 "great meeting with team"` to build a personal mood history
2. **Weekly check-ins** — Run `moodring week` every Sunday to see your 7-day mood chart and reflect on the week's emotional trajectory
3. **Pattern discovery** — Use `moodring patterns` after a few weeks of data to discover which days of the week or times of day tend to affect your mood
4. **Trigger identification** — Run `moodring triggers` to surface common words in your notes, or `moodring triggers 1` to see what's consistently associated with bad days
5. **Wellbeing journaling** — Combine `moodring log` with `moodring journal` for a complete emotional record — quantitative scores plus qualitative reflections

## Examples

```bash
# Log a good mood with context
moodring log 4 feeling great after morning run

# Log a rough day
moodring log 2 didn't sleep well, headache all day

# Check today's entries
moodring today

# View the weekly mood chart
moodring week

# See mood history for the last 30 days
moodring history 30

# Get full statistics
moodring stats

# Discover patterns by day and time
moodring patterns

# Find triggers for your best moods
moodring triggers 5

# Check your positive streak
moodring streak

# Write a journal entry
moodring journal "Grateful for a productive week. Need to prioritize sleep more."

# Get AI-style insights
moodring insights
```

## Output

All command output goes to stdout. Mood charts use ASCII bar graphs (`█`) for visual clarity in the terminal.

```bash
# Save your stats to a file
moodring stats > mood-report.txt

# Pipe weekly chart to less for scrolling
moodring history 90 | less
```

## Scoring Guide

| Score | Emoji | Meaning |
|-------|-------|---------|
| 1 | 😞 | Terrible |
| 2 | 😕 | Bad |
| 3 | 😐 | Okay |
| 4 | 😊 | Good |
| 5 | 🤩 | Amazing |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
