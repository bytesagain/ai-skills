---
name: APIMon
description: "API endpoint monitor and health checker. Monitor REST API availability, track response times over time, set up alerting thresholds, log API health history, and generate uptime reports. Keep your APIs healthy with automated monitoring."
version: "2.0.0"
author: "BytesAgain"
tags: ["api","monitor","health","uptime","response","latency","rest","devops"]
categories: ["Developer Tools", "System Tools"]
---
# APIMon
Monitor your APIs. Track response times. Catch outages early.
## Commands
- `check <url>` — Single health check
- `monitor <url> <interval_sec> <count>` — Monitor over time
- `history` — View check history
- `report` — Generate uptime report
## Usage Examples
```bash
apimon check https://api.example.com/health
apimon monitor https://api.example.com/status 30 10
apimon report
```
---
Powered by BytesAgain | bytesagain.com

- Run `apimon help` for commands
- No API keys needed

- Run `apimon help` for all commands

## When to Use

- Quick apimon tasks from terminal
- Automation pipelines

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
