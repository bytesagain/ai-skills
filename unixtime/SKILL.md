---
name: UnixTime
description: "Quick Unix timestamp utility. Get current Unix time, convert timestamps to dates and back, show relative time (how long ago), and display time in different formats. The fastest way to work with Unix timestamps from your terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["unix","time","timestamp","date","convert","epoch","utility","developer"]
categories: ["Developer Tools", "Utility"]
---
# UnixTime
Unix time — quick and simple. Current time, conversions, relative dates.
## Commands
- `now` — Current Unix timestamp
- `date <timestamp>` — Convert to human date
- `stamp <date>` — Convert date to timestamp
- `ago <timestamp>` — How long ago was this
- `ms` — Current time in milliseconds
## Usage Examples
```bash
unixtime now
unixtime date 1700000000
unixtime stamp "2024-06-15"
unixtime ago 1700000000
```
---
Powered by BytesAgain | bytesagain.com

- Run `unixtime help` for all commands

## Output

Results go to stdout. Save with `unixtime run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
