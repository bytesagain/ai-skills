---
name: DNSCheck
description: "Query DNS records and diagnose domain resolution and email configs. Use when checking propagation, debugging resolution, verifying SPF records."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["dns","lookup","domain","nameserver","mx","txt","network","diagnostic"]
categories: ["System Tools", "Developer Tools"]
---

# DNSCheck

A sysops toolkit for scanning, monitoring, reporting, alerting, tracking top entries, recording usage, checking health, fixing issues, cleaning up, backing up, restoring, logging, benchmarking, and comparing DNS-related operations — all from the command line with full history tracking.

## Commands

| Command | Description |
|---------|-------------|
| `dnscheck scan <input>` | Record and review DNS scan entries (run without args to see recent) |
| `dnscheck monitor <input>` | Record and review monitoring entries |
| `dnscheck report <input>` | Record and review report entries |
| `dnscheck alert <input>` | Record and review alert entries |
| `dnscheck top <input>` | Record and review top-priority entries |
| `dnscheck usage <input>` | Record and review usage entries |
| `dnscheck check <input>` | Record and review health check entries |
| `dnscheck fix <input>` | Record and review fix entries |
| `dnscheck cleanup <input>` | Record and review cleanup entries |
| `dnscheck backup <input>` | Record and review backup entries |
| `dnscheck restore <input>` | Record and review restore entries |
| `dnscheck log <input>` | Record and review log entries |
| `dnscheck benchmark <input>` | Record and review benchmark entries |
| `dnscheck compare <input>` | Record and review comparison entries |
| `dnscheck stats` | Show summary statistics across all log files |
| `dnscheck export <fmt>` | Export all data in JSON, CSV, or TXT format |
| `dnscheck search <term>` | Search across all logged entries |
| `dnscheck recent` | Show the 20 most recent activity entries |
| `dnscheck status` | Health check — version, data dir, entry count, disk usage |
| `dnscheck help` | Show usage info and all available commands |
| `dnscheck version` | Print version string |

Each data command (scan, monitor, report, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves to the corresponding `.log` file
- **Without arguments:** Displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/dnscheck/`. Each command writes to its own log file (e.g., `scan.log`, `monitor.log`, `check.log`). A unified `history.log` tracks all activity across commands with timestamps.

- Log format: `YYYY-MM-DD HH:MM|<input>`
- History format: `MM-DD HH:MM <command>: <input>`
- No external database or network access required

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard POSIX utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No root privileges needed
- No API keys or external dependencies

## When to Use

1. **Logging DNS lookup results** — Use `dnscheck scan` and `dnscheck check` to record DNS query results for domains, building a searchable history of resolution data over time
2. **Monitoring DNS changes and propagation** — Use `dnscheck monitor` to log periodic DNS state checks across providers, then `dnscheck search` to find when a record changed
3. **Recording DNS incidents and alerts** — Use `dnscheck alert` and `dnscheck report` to document DNS outages, misconfigurations, or propagation delays with timestamps
4. **Tracking DNS configuration fixes** — Use `dnscheck fix` and `dnscheck cleanup` to maintain an audit trail of record changes, stale entry removals, and zone file updates
5. **Benchmarking DNS resolver performance** — Use `dnscheck benchmark` and `dnscheck compare` to log response times from different DNS resolvers and compare their performance

## Examples

### Log a DNS scan and review history

```bash
# Record a DNS scan result
dnscheck scan "example.com A record: 93.184.216.34 (TTL 3600)"

# View recent scan entries
dnscheck scan
```

### Monitor and alert workflow

```bash
# Log a monitoring observation
dnscheck monitor "api.example.com CNAME still pointing to old ALB — propagation pending"

# Log an alert
dnscheck alert "MX records missing for newdomain.com — email delivery failing"

# Generate a report entry
dnscheck report "Weekly DNS audit: 2 stale CNAMEs, 1 missing SPF record"

# Search across all entries
dnscheck search "example.com"
```

### Fix and cleanup tracking

```bash
# Log a fix
dnscheck fix "Updated SPF record for company.com to include new mail server IP"

# Log a cleanup
dnscheck cleanup "Removed 5 stale A records from legacy.example.com zone"

# View recent activity
dnscheck recent
```

### Export and statistics

```bash
# Summary stats across all log files
dnscheck stats

# Export everything as JSON
dnscheck export json

# Export as CSV for spreadsheet analysis
dnscheck export csv

# Health check
dnscheck status
```

### Benchmark and compare DNS resolvers

```bash
# Log a benchmark
dnscheck benchmark "Google DNS (8.8.8.8): avg 12ms for example.com A lookup"

# Log a comparison
dnscheck compare "Cloudflare 1.1.1.1 (8ms) vs Google 8.8.8.8 (12ms) for example.com"

# Backup DNS zone data
dnscheck backup "Exported example.com zone file to /backups/dns/2025-03-18.zone"

# Log a restore
dnscheck restore "Restored example.com zone from backup after accidental deletion"
```

## How It Works

DNSCheck uses a simple case-dispatch architecture in a single Bash script. Each command maps to a log file under `~/.local/share/dnscheck/`. When called with arguments, the input is appended with a timestamp. When called without arguments, the last 20 lines of that log are displayed. The `stats` command aggregates entry counts across all logs, `export` serializes everything into JSON, CSV, or plain text, and `search` greps across all log files for a given term.

## Support

- Website: [bytesagain.com](https://bytesagain.com)
- Feedback: [bytesagain.com/feedback](https://bytesagain.com/feedback)
- Email: hello@bytesagain.com

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
