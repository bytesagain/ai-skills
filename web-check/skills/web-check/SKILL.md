---
name: Web Check
description: "Analyze websites with OSINT: DNS, SSL, headers, and tech detection. Use when auditing domains, inspecting headers, fingerprinting stacks, or reviewing DNS."
version: "1.0.0"
license: MIT
runtime: python3
---

# Web Check

A terminal-first utility toolkit for website analysis and OSINT. Run checks, convert data, analyze results, generate reports, preview operations, batch process, compare sites, export findings, manage configs, track status, and produce reports — all with persistent logging, search, and export capabilities.

## Why Web Check?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Persistent timestamped logging for every action
- Export to JSON, CSV, or plain text anytime
- Built-in search across all logged entries
- Automatic history and activity tracking

## Commands

| Command | Description |
|---------|-------------|
| `web-check run <input>` | Run a website check or analysis. Without args, shows recent run entries |
| `web-check check <input>` | Check a domain, URL, or endpoint. Without args, shows recent entries |
| `web-check convert <input>` | Convert between data formats. Without args, shows recent entries |
| `web-check analyze <input>` | Analyze website data (headers, DNS, SSL, etc.). Without args, shows recent entries |
| `web-check generate <input>` | Generate reports or configurations. Without args, shows recent entries |
| `web-check preview <input>` | Preview an operation before executing. Without args, shows recent entries |
| `web-check batch <input>` | Batch process multiple website checks. Without args, shows recent entries |
| `web-check compare <input>` | Compare websites, configs, or results. Without args, shows recent entries |
| `web-check export <input>` | Export check results or data. Without args, shows recent entries |
| `web-check config <input>` | Manage configuration settings. Without args, shows recent entries |
| `web-check status <input>` | Log or review check status. Without args, shows recent entries |
| `web-check report <input>` | Generate or review analysis reports. Without args, shows recent entries |
| `web-check stats` | Show summary statistics across all command categories |
| `web-check export <fmt>` | Export all data (formats: json, csv, txt) |
| `web-check search <term>` | Search across all logged entries |
| `web-check recent` | Show the 20 most recent activity entries |
| `web-check status` | Health check — version, data dir, entry count, disk usage |
| `web-check help` | Show help with all available commands |
| `web-check version` | Show version (v2.0.0) |

Each action command (run, check, convert, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves it to the corresponding log file
- **Without arguments:** Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally at `~/.local/share/web-check/`. Each command category maintains its own `.log` file with timestamped entries in `timestamp|value` format. A unified `history.log` tracks all activity across commands. Use `export` to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ with `set -euo pipefail` support
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Auditing website security** — Run checks and analyses on domains to log DNS records, SSL certificates, HTTP headers, and security configurations
2. **Batch checking multiple domains** — Use batch command to process multiple websites at once and track results across your domain portfolio
3. **Comparing website configurations** — Use compare to log side-by-side differences between domains, stacks, or hosting setups
4. **Generating OSINT reports** — Use report, stats, and export to produce thorough summaries of your web analysis findings in JSON, CSV, or text
5. **Tracking domain changes over time** — Log periodic checks with status and search historical entries to detect configuration drift or outages

## Examples

```bash
# Check a domain
web-check check "example.com — DNS, SSL, headers"

# Analyze website headers and tech stack
web-check analyze "bytesagain.com tech fingerprint"

# Batch check multiple domains
web-check batch "example.com example.org example.net"

# Compare two websites
web-check compare "site-a.com vs site-b.com SSL config"

# Generate a report
web-check report "Monthly security audit — March 2025"

# Export all logged data as JSON
web-check export json

# Search for entries about SSL
web-check search SSL

# View summary statistics
web-check stats
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
