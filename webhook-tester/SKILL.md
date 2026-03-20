---
name: Webhook Tester
description: "Send test payloads and inspect webhook responses locally. Use when debugging integrations, validating schemas, testing error handling, or simulating calls."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["webhook","testing","http","api","integration","debug","developer","automation"]
categories: ["Developer Tools", "Utility"]
---

# Webhook Tester

Devtools toolkit for tracking and managing webhook testing operations. Log checks, validations, linting results, diffs, and reports — all with timestamped history and multi-format export.

## Commands

All data commands accept optional input. Without input, they display the 20 most recent entries. With input, they log a new timestamped entry.

### Core Operations

| Command | Description |
|---------|-------------|
| `webhook-tester check [input]` | Log or view check entries — record webhook check results |
| `webhook-tester validate [input]` | Log or view validate entries — track payload validation |
| `webhook-tester generate [input]` | Log or view generate entries — track payload generation |
| `webhook-tester format [input]` | Log or view format entries — record formatting operations |
| `webhook-tester lint [input]` | Log or view lint entries — track linting results |
| `webhook-tester explain [input]` | Log or view explain entries — record explanations and notes |
| `webhook-tester convert [input]` | Log or view convert entries — track format conversions |
| `webhook-tester template [input]` | Log or view template entries — track template operations |
| `webhook-tester diff [input]` | Log or view diff entries — record payload comparisons |
| `webhook-tester preview [input]` | Log or view preview entries — track preview operations |
| `webhook-tester fix [input]` | Log or view fix entries — document applied fixes |
| `webhook-tester report [input]` | Log or view report entries — record generated reports |

### Utility Commands

| Command | Description |
|---------|-------------|
| `webhook-tester stats` | Show summary statistics: entry counts per category, total entries, data size, and earliest record date |
| `webhook-tester export <fmt>` | Export all data in `json`, `csv`, or `txt` format to the data directory |
| `webhook-tester search <term>` | Search across all log files for a term (case-insensitive) |
| `webhook-tester recent` | Show the 20 most recent entries from the activity history log |
| `webhook-tester status` | Health check: version, data directory, total entries, disk usage, last activity |
| `webhook-tester help` | Show full command listing |
| `webhook-tester version` | Print version string (`webhook-tester v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/webhook-tester/`:

- **Per-command logs**: `check.log`, `validate.log`, `lint.log`, `diff.log`, etc. — one file per command type
- **History log**: `history.log` — unified activity log with timestamps
- **Export files**: `export.json`, `export.csv`, `export.txt` — generated on demand
- **Format**: Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)

Set the `WEBHOOK_TESTER_DIR` environment variable to override the default data directory.

## Requirements

- **bash** (with `set -euo pipefail` strict mode)
- Standard Unix tools: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Tracking webhook validation results** — Log validation outcomes for payloads from Stripe, GitHub, Slack, etc. and review patterns over time
2. **Recording lint and format checks** — Use `lint` and `format` to track payload quality checks during integration development
3. **Documenting webhook fixes and debugging** — Use `fix`, `explain`, and `diff` to maintain a structured record of debugging sessions
4. **Comparing webhook payloads across versions** — Use `diff` and `compare` to log differences between expected and actual payloads during schema migrations
5. **Exporting test records for compliance** — Pull all logged data into JSON, CSV, or TXT for QA sign-off, audit trails, or integration documentation

## Examples

```bash
# Log a webhook validation result
webhook-tester validate "Stripe checkout.session.completed — signature verified OK"

# Record a linting result
webhook-tester lint "GitHub push event payload: missing 'ref' field in 3 of 12 test cases"

# Log a diff between expected and actual payloads
webhook-tester diff "v2 vs v3 payload: added 'metadata.source' field, removed 'legacy_id'"

# Document a fix applied to a webhook handler
webhook-tester fix "added retry logic for 429 responses from payment gateway"

# View recent check entries
webhook-tester check

# Search for entries related to a specific integration
webhook-tester search "Stripe"

# Get summary statistics across all categories
webhook-tester stats

# Export everything to JSON for analysis
webhook-tester export json

# Check tool health and data directory status
webhook-tester status

# View the 20 most recent activity entries
webhook-tester recent
```

## How It Works

Webhook Tester uses a simple append-only log architecture. Each command type writes to its own `.log` file, and all activity is also appended to a central `history.log` for chronological tracking. The `stats` command aggregates counts across all log files. The `export` command reads all logs and serializes them into the requested format (JSON array, CSV with headers, or plain text sections). The `search` command performs case-insensitive grep across all log files.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
