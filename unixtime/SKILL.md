---
name: UnixTime
description: "Convert Unix timestamps to dates and back. Use when parsing epoch values, calculating time differences, debugging logs, or generating relative dates."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["unix","time","timestamp","date","convert","epoch","utility","developer"]
categories: ["Developer Tools", "Utility"]
---

# UnixTime

A Unix time utility for converting timestamps, counting down to events, and analyzing time ranges. Features millisecond detection, ISO 8601 output, and detailed duration breakdowns.

## Commands

| Command | Description |
|---------|-------------|
| `unixtime current` | Show current Unix timestamp with epoch (s/ms), local, UTC, ISO 8601, day-of-year, week number |
| `unixtime to-date <timestamp>` | Convert a Unix timestamp to readable date (auto-detects milliseconds for 13+ digit values) |
| `unixtime to-epoch <date-string>` | Convert a human-readable date string to Unix epoch |
| `unixtime countdown <future-timestamp>` | Show time remaining until a future timestamp (or how long ago it passed) |
| `unixtime ranges <start> <end>` | Show full duration between two timestamps (seconds through weeks) |
| `unixtime version` | Show version |
| `unixtime help` | Show available commands and usage |

## Requirements

- Bash 4+ (`set -euo pipefail`)
- `date`, `awk` — standard Unix utilities
- `python3` (optional, for millisecond epoch)
- No external dependencies or API keys

## When to Use

1. **Quick timestamp check** — `unixtime current` gives epoch, local, UTC, ISO 8601, and calendar info
2. **Parsing log timestamps** — `unixtime to-date 1700000000` or even `unixtime to-date 1700000000000` (auto-detects ms)
3. **Date string conversion** — `unixtime to-epoch '2025-06-15 14:00:00'` for quick epoch lookup
4. **Event countdowns** — `unixtime countdown <future-epoch>` shows remaining time in a breakdown
5. **Duration analysis** — `unixtime ranges <start> <end>` shows the gap in seconds, minutes, hours, days, and weeks

## Examples

```bash
# Show current Unix time with full details
unixtime current

# Convert timestamp to date (auto-detects milliseconds)
unixtime to-date 1700000000
unixtime to-date 1700000000000

# Convert date string to epoch
unixtime to-epoch '2025-06-15 14:00:00'
unixtime to-epoch 'Jan 15 2025'

# Countdown to a future timestamp
unixtime countdown 1800000000

# Analyze a time range
unixtime ranges 1700000000 1700086400
```

### Example Output

```
$ unixtime current
┌───────────────────────────────────────────────┐
│  Current Unix Time                            │
├───────────────────────────────────────────────┤
│  Epoch (s):   1773916290                       │
│  Epoch (ms):  1773916290572                    │
│  Local:       2026-03-19 18:31:30 CST          │
│  UTC:         2026-03-19 10:31:30 UTC          │
│  ISO 8601:    2026-03-19T10:31:30Z             │
├───────────────────────────────────────────────┤
│  Day of year: 78/365                           │
│  Week:        12                               │
│  Day:         Thursday                         │
└───────────────────────────────────────────────┘

$ unixtime countdown 1800000000
┌───────────────────────────────────────────────────┐
│  ⏳ Countdown                                     │
├───────────────────────────────────────────────────┤
│  Target:     1800000000 (2027-01-14 ...)          │
│  Now:        1773916290                            │
│  Remaining:  301d 12h 1m 50s                       │
├───────────────────────────────────────────────────┤
│  Seconds:    26083710                              │
│  Minutes:    434728.5                              │
│  Hours:      7245.47                               │
│  Days:       301.894                               │
└───────────────────────────────────────────────────┘
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
