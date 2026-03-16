---
name: Uptime
description: "Website and service uptime checker. Monitor URLs for availability, measure response times, check HTTP status codes, verify SSL certificates, and track uptime history. Quick website health monitoring from your terminal without complex monitoring setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["uptime","monitoring","website","http","ssl","availability","health","devops"]
categories: ["Developer Tools", "System Tools"]
---
# Uptime
Check if websites are up. Measure response times. Monitor availability.
## Commands
- `check <url>` — Check URL status and response time
- `batch <file>` — Check multiple URLs from a file
- `ssl <domain>` — Check SSL certificate expiry
- `history` — View check history
## Usage Examples
```bash
uptime check [configured-endpoint]
uptime check [configured-endpoint]
uptime ssl github.com
```
---
Powered by BytesAgain | bytesagain.com

- Run `uptime help` for all commands

## When to Use

- to automate uptime tasks in your workflow
- for batch processing uptime operations

## Output

Returns reports to stdout. Redirect to a file with `uptime run > output.txt`.

## Configuration

Set `UPTIME_DIR` environment variable to change the data directory. Default: `~/.local/share/uptime/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
