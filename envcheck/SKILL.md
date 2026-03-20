---
name: EnvCheck
description: "Validate .env files with missing-key detection and format linting. Use when auditing envs, detecting missing vars, comparing environments."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["env","environment","dotenv","config","variables","developer","devops","twelve-factor"]
categories: ["Developer Tools", "Utility"]
---

# EnvCheck

Utility toolkit for environment and configuration management — run, check, convert, analyze, generate, preview, batch, compare, export, config, status, and report. All entries are logged locally with timestamps for full traceability.

## Commands

| Command | Description |
|---------|-------------|
| `envcheck run <input>` | Run a task or record a run entry |
| `envcheck check <input>` | Check configurations or record a check entry |
| `envcheck convert <input>` | Convert formats or record a conversion entry |
| `envcheck analyze <input>` | Analyze environments or record an analysis entry |
| `envcheck generate <input>` | Generate configs or record a generation entry |
| `envcheck preview <input>` | Preview changes or record a preview entry |
| `envcheck batch <input>` | Batch process or record a batch entry |
| `envcheck compare <input>` | Compare environments or record a comparison entry |
| `envcheck export <input>` | Export configs or record an export entry |
| `envcheck config <input>` | Manage configuration or record a config entry |
| `envcheck status <input>` | Check status or record a status entry |
| `envcheck report <input>` | Generate reports or record a report entry |
| `envcheck stats` | Show summary statistics across all entry types |
| `envcheck search <term>` | Search across all log entries by keyword |
| `envcheck recent` | Show the 20 most recent activity entries |
| `envcheck help` | Show help with all available commands |
| `envcheck version` | Show current version (v2.0.0) |

Each command (run, check, convert, analyze, generate, preview, batch, compare, export, config, status, report) works in two modes:
- **No arguments**: displays the 20 most recent entries from that command's log
- **With arguments**: records the input with a timestamp and appends to the command's log file

## Data Storage

All data is stored locally at `~/.local/share/envcheck/`. Each action is logged to its own file (e.g., `run.log`, `check.log`, `analyze.log`). A unified `history.log` tracks all operations. The built-in export function supports JSON, CSV, and plain text formats for backup and portability.

## Requirements

- bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)

## When to Use

- Auditing environment configurations and recording check results
- Comparing environment setups across staging, production, and development
- Tracking configuration changes over time with timestamped logs
- Batch processing environment validation tasks
- Exporting environment audit history for compliance or reporting
- Searching past configuration entries by keyword

## Examples

```bash
# Record a check result
envcheck check ".env has 12 vars, all populated, no duplicates"

# Analyze an environment
envcheck analyze "production .env — 3 vars missing vs template"

# Compare two environments
envcheck compare "staging vs prod — DB_HOST and REDIS_URL differ"

# Generate a config entry
envcheck generate "template .env for microservice with 8 required vars"

# Run a batch validation
envcheck batch "validated 5 .env files across 3 services"

# View recent check entries
envcheck check

# Search for entries about "API_KEY"
envcheck search API_KEY

# Export all data as JSON
envcheck export json

# View summary stats
envcheck stats

# Show recent activity
envcheck recent

# Check overall health
envcheck status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
