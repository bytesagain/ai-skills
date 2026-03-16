---
version: "2.0.0"
name: logscope
description: "Goaccess — GoAccess — web server log analyzer. Automated tool for goaccess tasks. Use when you need Goaccess capabilities. Triggers on: logscope."
---

# Goaccess

GoAccess — web server log analyzer

## Why This Skill?

- No installation required — works with standard system tools
- Real functionality — runs actual commands, produces real output

## Commands

Run `scripts/goaccess.sh <command>` to use.

- `parse` — <logfile> Parse access log (auto-detect format)
- `top-pages` — <log> Top requested pages
- `top-ips` — <log> Top visitor IPs
- `status` — <log> HTTP status code distribution
- `hourly` — <log> Requests per hour
- `bandwidth` — <log> Bandwidth usage
- `errors` — <log> Error log analysis (4xx/5xx)
- `bots` — <log> Bot/crawler detection
- `summary` — <log> Full summary report
- `info` — Version info

## Quick Start

```bash
goaccess.sh help
```

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
