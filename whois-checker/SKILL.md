---
version: "2.0.0"
name: whois-checker
description: "Error: --domain required. Use when you need whois checker capabilities. Triggers on: whois checker, domain, format, output, help."
author: BytesAgain
---

# whois-checker

WHOIS domain lookup tool that retrieves and parses domain registration information including registrar, registration date, expiry date, nameservers, domain status, and registrant contact details. Supports expiry monitoring with configurable warning thresholds, batch lookups for domain portfolios, and multiple output formats. Parses the system whois CLI output using Python3 — no external dependencies. Great for domain portfolio management, expiry tracking, and competitive research.

## Commands

| Command | Description |
|---------|-------------|
| `lookup <domain>` | Full WHOIS lookup for a domain |
| `expiry <domain>` | Check domain expiry date and days remaining |
| `registrar <domain>` | Show registrar information only |
| `nameservers <domain>` | Show nameservers only |
| `status <domain>` | Show domain status codes |
| `raw <domain>` | Show raw WHOIS output |
| `batch <file>` | Check multiple domains from a file |
| `monitor <file>` | Check expiry for domains and alert on upcoming expirations |
| `available <domain>` | Quick check if domain is available |

## Options

- `--format table|json|csv|text` — Output format (default: table)
- `--output <file>` — Save output to file
- `--warn-days <days>` — Expiry warning threshold (default: 30)
- `--crit-days <days>` — Expiry critical threshold (default: 7)
- `--timeout <seconds>` — WHOIS query timeout (default: 10)
- `--verbose` — Show all parsed WHOIS fields
- `--quiet` — Suppress non-essential output

## Examples

```bash
# Full WHOIS lookup
bash scripts/main.sh lookup example.com

# Check domain expiry
bash scripts/main.sh expiry example.com --format json

# Monitor domain portfolio
bash scripts/main.sh monitor domains.txt --warn-days 60 --crit-days 14

# Check domain availability
bash scripts/main.sh available mynewdomain.com

# Batch lookup
bash scripts/main.sh batch domains.txt --format csv --output whois-report.csv

# Raw WHOIS output
bash scripts/main.sh raw example.com
```

## Parsed Fields

| Field | Description |
|-------|-------------|
| Domain Name | The queried domain |
| Registrar | Domain registrar company |
| Created Date | Domain registration date |
| Expiry Date | Domain expiration date |
| Updated Date | Last modification date |
| Nameservers | Authoritative nameservers |
| Status | Domain status codes (clientTransferProhibited, etc.) |
| Days Until Expiry | Calculated days remaining |
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
