---
version: "2.0.0"
name: roomba-control
description: "Manage iRobot Roomba vacuums via the cloud API. Start/stop/schedule cleaning jobs, monitor consumable status, and view cleaning maps and history. Use when you need roomba control capabilities. Triggers on: roomba control."
author: BytesAgain
---

# Roomba Control

Command your iRobot Roomba from the terminal.

---

## Table of Contents

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Core Commands](#core-commands)
- [Cleaning Jobs](#cleaning-jobs)
- [Scheduling](#scheduling)
- [Consumable Tracking](#consumable-tracking)
- [Cleaning History & Maps](#cleaning-history--maps)
- [Multi-Robot Support](#multi-robot-support)
- [Scripting & Automation](#scripting--automation)

---

## Requirements

- An iRobot Roomba with Wi-Fi connectivity (600/700/800/900/i/j/s series)
- iRobot account credentials
- Python 3.6+
- Network access to iRobot cloud services

## Configuration

```bash
export IROBOT_EMAIL="you@example.com"
export IROBOT_PASSWORD="your-password"
```

First-time setup discovers your robots:

```bash
$ bash scripts/roomba-ctl.sh setup

Discovering robots on your account...
Found 2 robots:
  [1] Rosie       — Roomba j7+    (Online, Docked)
  [2] Dusty       — Roomba i3     (Online, Docked)

Configuration saved to ~/.roomba-control/config.json
Default robot set to: Rosie
```

---

## Core Commands

```bash
# Robot status
bash scripts/roomba-ctl.sh status
# Output: Rosie (j7+) | Docked | Battery: 94% | Last clean: 2h ago | Bin: OK

# Detailed info
bash scripts/roomba-ctl.sh info

# Network/connectivity check
bash scripts/roomba-ctl.sh ping

# Identify robot (plays a sound)
bash scripts/roomba-ctl.sh find
```

---

## Cleaning Jobs

### Start & Stop

```bash
# Start cleaning (full house)
bash scripts/roomba-ctl.sh clean

# Clean specific rooms (requires room-mapping capable models)
bash scripts/roomba-ctl.sh clean --rooms "Kitchen,Living Room"

# Pause current job
bash scripts/roomba-ctl.sh pause

# Resume paused job
bash scripts/roomba-ctl.sh resume

# Send back to dock
bash scripts/roomba-ctl.sh dock

# Emergency stop
bash scripts/roomba-ctl.sh stop
```

### Job Monitoring

```bash
# Current job progress
bash scripts/roomba-ctl.sh progress
# Output: Cleaning... 65% complete | 23 min elapsed | Kitchen ✓ | Living Room (in progress)

# Follow job in real-time (updates every 30s)
bash scripts/roomba-ctl.sh progress --follow
```

---

## Scheduling

```bash
# View current schedule
bash scripts/roomba-ctl.sh schedule

# Set daily schedule
bash scripts/roomba-ctl.sh schedule set --daily 09:00

# Set weekday-only schedule
bash scripts/roomba-ctl.sh schedule set --weekdays 10:00

# Custom schedule
bash scripts/roomba-ctl.sh schedule set --days mon,wed,fri --time 14:00

# Specific rooms on schedule
bash scripts/roomba-ctl.sh schedule set --daily 09:00 --rooms "Kitchen,Hallway"

# Disable schedule
bash scripts/roomba-ctl.sh schedule off

# Enable schedule
bash scripts/roomba-ctl.sh schedule on
```

---

## Consumable Tracking

Keep tabs on parts that need replacement.

```bash
$ bash scripts/roomba-ctl.sh consumables

Consumable Status — Rosie (j7+)
────────────────────────────────────
Main Brush:     ████████░░ 78%   (~44 hours remaining)
Side Brush:     █████░░░░░ 52%   (~26 hours remaining)
Filter:         ███░░░░░░░ 31%   (~15 hours remaining)  ⚠️ Replace soon
Bin:            Full — Empty before next clean
Dust Bag:       ███████░░░ 68%   (auto-empty base)

Estimated based on 6.2 hrs/week average usage.
```

```bash
# Alert if any consumable below threshold
bash scripts/roomba-ctl.sh consumables --alert 20
# Exit code 1 if any below 20%

# Reset consumable counter after replacement
bash scripts/roomba-ctl.sh consumables reset filter
bash scripts/roomba-ctl.sh consumables reset main_brush
```

---

## Cleaning History & Maps

```bash
# Recent cleaning sessions
bash scripts/roomba-ctl.sh history
bash scripts/roomba-ctl.sh history --limit 20

# Detailed session report
bash scripts/roomba-ctl.sh history <session_id>

# Cleaning statistics
bash scripts/roomba-ctl.sh stats
# Output: This week: 4 cleans, 3.2 hrs, 1,240 sq ft avg
#         This month: 14 cleans, 11.8 hrs, 1,180 sq ft avg
#         Lifetime: 342 cleans, 298.5 hrs

# Export history as CSV
bash scripts/roomba-ctl.sh history export cleaning_log.csv --days 90

# Coverage map (ASCII visualization)
bash scripts/roomba-ctl.sh map
```

---

## Multi-Robot Support

```bash
# List all robots
bash scripts/roomba-ctl.sh robots

# Switch default robot
bash scripts/roomba-ctl.sh use "Dusty"

# Command a specific robot
bash scripts/roomba-ctl.sh --robot "Dusty" clean

# Start all robots
bash scripts/roomba-ctl.sh clean --all

# Status of all robots
bash scripts/roomba-ctl.sh status --all
```

---

## Scripting & Automation

**Clean before guests arrive (cron):**
```bash
# Friday at 4 PM — clean living areas
0 16 * * 5 bash /path/to/roomba-ctl.sh clean --rooms "Living Room,Dining Room,Kitchen"
```

**Post-clean notification:**
```bash
bash scripts/roomba-ctl.sh clean
while bash scripts/roomba-ctl.sh status --raw | grep -q "running"; do sleep 60; done
echo "Cleaning complete!" | mail -s "Roomba Done" you@email.com
```

**Consumable shopping reminder:**
```bash
LOW=$(bash scripts/roomba-ctl.sh consumables --alert 25 --names)
if [ -n "$LOW" ]; then
  echo "Time to order: $LOW" | mail -s "Roomba Parts Needed" you@email.com
fi
```

---

## Troubleshooting

| Issue | Solution |
| Command | Description |
|---------|-------------|
| `setup` | Configuration instructions |
| `status` | Full robot status + consumables |
| `clean` | Clean |
| `dock` | Send to charging dock |
| `pause` | Pause |
| `resume` | Resume |
| `schedule` | Schedule |
| `history` | View cleaning history |

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `roomba-control help` to see all available commands.
