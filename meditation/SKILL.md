---
name: meditation
description: "Guide meditation practice. Use when starting timed sessions, breathing exercises, body scans, logging practice, or viewing stats."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - meditation
  - mindfulness
  - breathing
  - wellness
  - timer
  - body-scan
---

# Meditation Skill

Time meditation sessions, guide breathing and body scans, log practice, and track stats.

## Commands

### start

Start a meditation timer with optional bell intervals.

```bash
bash scripts/script.sh start [--duration <minutes>] [--bell <interval_min>] [--type focus|open|loving-kindness]
```

### breathe

Run a guided breathing exercise.

```bash
bash scripts/script.sh breathe [--pattern 4-7-8|box|deep] [--cycles <num>]
```

### body-scan

Generate a body scan meditation guide.

```bash
bash scripts/script.sh body-scan [--duration short|medium|long] [--focus full|upper|lower]
```

### log

Record a meditation session to the journal.

```bash
bash scripts/script.sh log <duration_min> [--type <type>] [--mood <1-10>] [--note <text>]
```

### stats

View meditation practice statistics.

```bash
bash scripts/script.sh stats [--period week|month|year|all] [--format table|json]
```

### playlist

Generate a meditation audio playlist.

```bash
bash scripts/script.sh playlist [--mood calm|sleep|focus|energy] [--duration <minutes>] [--count <num>]
```

## Output

All commands print to stdout. Session logs are stored in `~/.meditation/sessions.json`. Timer and breathing commands print real-time prompts to the terminal.


## Requirements
- bash 4+
- python3 (standard library only)

## Feedback

Questions or suggestions? → [https://bytesagain.com/feedback/](https://bytesagain.com/feedback/)

---

Powered by BytesAgain | bytesagain.com
