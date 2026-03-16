---
version: "2.0.0"
name: site-monitor
description: "Website uptime monitoring tool that checks HTTP status codes, measures response times, validates SSL certificate expiry, and generates alerts on downtime or degraded performance. Designed to be cron-c. Use when you need site monitor capabilities. Triggers on: site monitor."
---

# site-monitor

Website uptime monitoring tool that checks HTTP status codes, measures response times, validates SSL certificate expiry, and generates alerts on downtime or degraded performance. Designed to be cron-compatible with structured output for easy integration into monitoring pipelines. Supports multiple URLs, threshold-based alerting, and historical log tracking. No external dependencies — uses Python3 stdlib and openssl CLI.


## Commands

| Command | Description |
|---------|-------------|
| `check <url>` | Check a single URL for status, response time, SSL |
| `batch <file>` | Check multiple URLs from a file (one per line) |
| `ssl <domain>` | Check SSL certificate expiry for a domain |
| `history <url>` | Show check history from log file |
| `report` | Generate a summary report from recent checks |
| `cron <url>` | Cron-optimized output (single line, exit code based) |

## Options

- `--timeout <seconds>` — Request timeout (default: 10)
- `--warn-ms <ms>` — Response time warning threshold (default: 2000)
- `--crit-ms <ms>` — Response time critical threshold (default: 5000)
- `--ssl-warn-days <days>` — SSL expiry warning days (default: 30)
- `--ssl-crit-days <days>` — SSL expiry critical days (default: 7)
- `--log <file>` — Append results to log file
- `--format json|text|nagios` — Output format (default: text)
- `--quiet` — Only output on errors
- `--expected-status <code>` — Expected HTTP status (default: 200)

## Examples

```bash
# Basic check
bash scripts/main.sh check https://example.com

# Cron job with alerting thresholds
bash scripts/main.sh cron https://example.com --warn-ms 1000 --crit-ms 3000 --log /var/log/site-monitor.log

# Check SSL certificate
bash scripts/main.sh ssl example.com --ssl-warn-days 14

# Batch check from file
bash scripts/main.sh batch urls.txt --format json --log checks.log

# Generate report
bash scripts/main.sh report --log checks.log
```

## Cron Integration

```cron
*/5 * * * * bash /path/to/scripts/main.sh cron https://example.com --log /var/log/uptime.log --quiet
```

Exit codes: 0=OK, 1=WARNING, 2=CRITICAL
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
