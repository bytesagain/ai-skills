---
name: Uptime
description: "Monitor website availability and response times. Use when checking site status, benchmarking latency, tracking uptime history, or alerting on outages."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["uptime","monitoring","website","http","ssl","availability","health","devops"]
categories: ["Developer Tools", "System Tools"]
---

# Uptime

System and website uptime monitor. Check system load, test URL reachability with timing, log uptime history, and set up outage alerts.

## Commands

| Command | Description |
|---------|-------------|
| `uptime status` | Show system uptime, load average, CPU count, and logged-in users |
| `uptime check <url>` | Check if a URL is reachable (HTTP status, connect time, TTFB) |
| `uptime log` | Log current system uptime snapshot to `~/.uptime-monitor/uptime.log` |
| `uptime history` | Show uptime log history (last 30 entries) |
| `uptime alert <url> <email>` | Check URL and send email alert if down |
| `uptime since` | Show system boot time |
| `uptime multi <url1> <url2> ...` | Check multiple URLs at once with summary |
| `uptime version` | Show version |

## Examples

```bash
uptime status                    # → uptime, load, users, hostname
uptime check https://example.com # → HTTP 200, connect 0.1s, TTFB 0.2s
uptime log                       # → saves snapshot to log file
uptime history                   # → shows recent log entries
uptime alert https://mysite.com admin@example.com  # → alerts if down
uptime since                     # → boot time
uptime multi https://google.com https://github.com # → batch check
```

## Requirements

- `/proc/uptime`, `/proc/loadavg` (Linux)
- `curl` (for URL checks)
- `mail` (optional, for email alerts)
