---
name: Epoch
description: "Convert Unix timestamps, compare epochs, and do time arithmetic. Use when converting dates, debugging timestamps, or checking timezone offsets."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["epoch","unix","timestamp","time","converter","calculator","developer"]
categories: ["Developer Tools", "Utility"]
---

# Epoch

A real Unix timestamp tool for converting, comparing, and calculating epoch timestamps. All conversions use the system `date` command with support for both local and UTC output.

## Commands

| Command | Description |
|---------|-------------|
| `epoch now` | Show current epoch timestamp + human-readable date (local & UTC) |
| `epoch convert <timestamp>` | Convert an epoch timestamp to human-readable local, UTC, and age |
| `epoch from <date-string>` | Convert a human-readable date string to epoch |
| `epoch diff <ts1> <ts2>` | Calculate difference between two timestamps (seconds, minutes, hours, days) |
| `epoch add <timestamp> <seconds>` | Add seconds to a timestamp and show the result |
| `epoch version` | Show version |
| `epoch help` | Show available commands and usage |

## Requirements

- Bash 4+ (`set -euo pipefail`)
- `date`, `awk` — standard Unix utilities
- No external dependencies or API keys

## When to Use

1. **Quick timestamp lookup** — `epoch now` gives you the current epoch + human date instantly
2. **Debugging timestamps in logs** — `epoch convert 1700000000` shows you what that number actually means
3. **Parsing date strings** — `epoch from '2024-01-15 10:30:00'` gets you the epoch value
4. **Calculating time differences** — `epoch diff <ts1> <ts2>` shows the gap in every unit
5. **Time arithmetic** — `epoch add 1700000000 3600` adds an hour and shows the result

## Examples

```bash
# Show current epoch + human-readable date
epoch now

# Convert epoch to date
epoch convert 1700000000

# Convert date string to epoch
epoch from '2024-01-15 10:30:00'
epoch from 'Jan 15 2024'

# Difference between two timestamps
epoch diff 1700000000 1700086400

# Add 1 hour (3600 seconds) to a timestamp
epoch add 1700000000 3600

# Add 7 days to a timestamp
epoch add 1700000000 604800
```

### Example Output

```
$ epoch now
┌─────────────────────────────────────┐
│  Current Time                       │
├─────────────────────────────────────┤
│  Epoch:  1773916290                 │
│  Human:  2026-03-19 18:31:30 CST   │
├─────────────────────────────────────┤
│  UTC:    2026-03-19 10:31:30 UTC   │
└─────────────────────────────────────┘

$ epoch diff 1700000000 1700086400
┌───────────────────────────────────────────────────┐
│  Timestamp Difference                             │
├───────────────────────────────────────────────────┤
│  From:     1700000000 (2023-11-15 06:13:20 CST)   │
│  To:       1700086400 (2023-11-16 06:13:20 CST)   │
├───────────────────────────────────────────────────┤
│  Seconds:  86400                                   │
│  Minutes:  1440.00                                 │
│  Hours:    24.00                                   │
│  Days:     1.0000                                  │
│  Duration: 1d 0h 0m 0s                             │
└───────────────────────────────────────────────────┘
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
