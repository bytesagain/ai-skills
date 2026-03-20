---
version: "1.0.0"
name: email-marketer
description: "Plan email campaigns with segmentation, A/B testing, and benchmarking. Use when designing campaigns, segmenting lists, benchmarking rates."
---

# Email Marketer

AI toolkit for email marketing operations — configure, benchmark, compare, prompt, evaluate, fine-tune, analyze, cost, usage, optimize, test, and report. All entries are logged locally with timestamps for tracking and audit.

## Commands

| Command | Description |
|---------|-------------|
| `email-marketer configure <input>` | Configure email marketing settings or record a config entry |
| `email-marketer benchmark <input>` | Run benchmarks or record a benchmark entry |
| `email-marketer compare <input>` | Compare campaigns or record a comparison entry |
| `email-marketer prompt <input>` | Generate or record email prompts |
| `email-marketer evaluate <input>` | Evaluate campaign performance or record an evaluation entry |
| `email-marketer fine-tune <input>` | Fine-tune parameters or record a fine-tuning entry |
| `email-marketer analyze <input>` | Analyze campaign data or record an analysis entry |
| `email-marketer cost <input>` | Track costs or record a cost entry |
| `email-marketer usage <input>` | Track usage metrics or record a usage entry |
| `email-marketer optimize <input>` | Optimize campaigns or record an optimization entry |
| `email-marketer test <input>` | Run A/B tests or record a test entry |
| `email-marketer report <input>` | Generate reports or record a report entry |
| `email-marketer stats` | Show summary statistics across all entry types |
| `email-marketer export <fmt>` | Export all data (json, csv, or txt) |
| `email-marketer search <term>` | Search across all log entries by keyword |
| `email-marketer recent` | Show the 20 most recent activity entries |
| `email-marketer status` | Health check — version, data dir, entry count, disk usage |
| `email-marketer help` | Show help with all available commands |
| `email-marketer version` | Show current version (v2.0.0) |

Each command (configure, benchmark, compare, prompt, evaluate, fine-tune, analyze, cost, usage, optimize, test, report) works in two modes:
- **No arguments**: displays the 20 most recent entries from that command's log
- **With arguments**: records the input with a timestamp and appends to the command's log file

## Data Storage

All data is stored locally at `~/.local/share/email-marketer/`. Each action is logged to its own file (e.g., `configure.log`, `benchmark.log`, `analyze.log`). A unified `history.log` tracks all operations. The built-in export function supports JSON, CSV, and plain text formats.

## Requirements

- bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)

## When to Use

- Tracking email campaign configurations and benchmark results
- Logging A/B test outcomes and evaluation metrics
- Recording cost and usage data for email marketing operations
- Fine-tuning campaign parameters with documented history
- Analyzing campaign performance trends over time
- Exporting marketing data for stakeholder reports

## Examples

```bash
# Configure a new campaign
email-marketer configure "weekly newsletter — segment: active users, send: Tuesday 9AM"

# Record a benchmark result
email-marketer benchmark "open rate 24.5%, click rate 3.2%, industry avg 21%"

# Compare two campaigns
email-marketer compare "Campaign A: 28% open vs Campaign B: 22% open"

# Evaluate campaign performance
email-marketer evaluate "Q1 drip sequence — 15% conversion, 2.1% unsubscribe"

# Record a cost entry
email-marketer cost "March send volume: 50K emails, cost: $45"

# Run an A/B test
email-marketer test "Subject line A vs B — A won with 31% open rate"

# View recent activity
email-marketer recent

# Export all data as CSV
email-marketer export csv

# Search for entries about "onboarding"
email-marketer search onboarding

# Check overall health
email-marketer status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
