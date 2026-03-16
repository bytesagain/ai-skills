---
version: "2.0.0"
name: ssl-checker
description: "Error: --domain required. Use when you need ssl checker capabilities. Triggers on: ssl checker, domain, port, warn-days, format, output."
author: BytesAgain
---

# ssl-checker

SSL/TLS certificate inspection tool that checks certificate expiry dates, issuer details, subject information, certificate chain validation, protocol support, and cipher suites. Provides days-until-expiry alerts with configurable thresholds for proactive certificate management. Uses openssl s_client and Python3 — no external dependencies. Perfect for DevOps monitoring, security audits, and certificate lifecycle management.

## Commands

| Command | Description |
|---------|-------------|

## Options

- `--port <port>` — Port to connect to (default: 443)
- `--format table|json|csv|text` — Output format (default: table)
- `--output <file>` — Save output to file
- `--warn-days <days>` — Expiry warning threshold (default: 30)
- `--crit-days <days>` — Expiry critical threshold (default: 7)
- `--timeout <seconds>` — Connection timeout (default: 10)
- `--sni <hostname>` — SNI hostname override
- `--verbose` — Show full certificate details
- `--quiet` — Only output warnings/errors

## Examples

```bash
# Full SSL check
bash scripts/main.sh check example.com

# Check expiry with custom thresholds
bash scripts/main.sh expiry example.com --warn-days 60 --crit-days 14

# Show certificate chain
bash scripts/main.sh chain example.com --format json

# Monitor multiple domains
bash scripts/main.sh monitor domains.txt --format json --output ssl-report.json

# Check non-standard port
bash scripts/main.sh check mail.example.com --port 993

# Verify chain trust
bash scripts/main.sh verify example.com --verbose
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | OK — Certificate valid, expiry > warn-days |
| 1 | WARNING — Certificate expiring within warn-days |
| 2 | CRITICAL — Certificate expiring within crit-days or expired |
| 3 | ERROR — Connection failed or certificate error |
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
