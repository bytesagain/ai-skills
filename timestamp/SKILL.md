---
name: Timestamp
description: "Unix timestamp converter and time utility. Convert between human-readable dates and Unix timestamps, show current time in multiple formats, calculate time differences, convert between timezones, and format dates. Never struggle with date math again."
version: "2.0.0"
author: "BytesAgain"
tags: ["timestamp","unix","time","date","converter","timezone","epoch","utility"]
categories: ["Developer Tools", "Utility"]
---
# Timestamp
Convert timestamps. Work with dates. Time math made easy.
## Commands
- `now` — Current time in all formats
- `to <date_string>` — Convert date to Unix timestamp
- `from <unix_timestamp>` — Convert timestamp to date
- `diff <ts1> <ts2>` — Time difference between timestamps
- `add <duration>` — Add duration to current time
## Usage Examples
```bash
timestamp now
timestamp to "2024-12-25 00:00:00"
timestamp from 1703462400
timestamp diff 1703462400 1703548800
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick timestamp from the command line

## Output

Returns logs to stdout. Redirect to a file with `timestamp run > output.txt`.

## Configuration

Set `TIMESTAMP_DIR` environment variable to change the data directory. Default: `~/.local/share/timestamp/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
