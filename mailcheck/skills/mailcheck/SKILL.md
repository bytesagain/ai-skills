---
name: MailCheck
description: "Validate emails by checking MX, SPF/DKIM records, and SMTP connectivity. Use when verifying addresses, diagnosing delivery failures, checking DNS mail."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["email","smtp","mx","spf","dkim","deliverability"]
categories: ["Developer Tools", "Utility"]
---

# Mailcheck

Mailcheck v2.0.0 — an AI toolkit for configuring, benchmarking, comparing, and managing AI/ML-related operations. Supports prompt engineering, model evaluation, fine-tuning tracking, cost analysis, usage monitoring, optimization, testing, and reporting — all tracked with timestamped entries stored locally.

## Commands

Run `scripts/script.sh <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `configure <input>` | Record a configuration entry. Without args, shows the 20 most recent configure entries. |
| `benchmark <input>` | Record a benchmark entry. Without args, shows recent benchmark entries. |
| `compare <input>` | Record a comparison entry. Without args, shows recent compare entries. |
| `prompt <input>` | Record a prompt engineering entry. Without args, shows recent prompt entries. |
| `evaluate <input>` | Record an evaluation entry. Without args, shows recent evaluate entries. |
| `fine-tune <input>` | Record a fine-tuning entry. Without args, shows recent fine-tune entries. |
| `analyze <input>` | Record an analysis entry. Without args, shows recent analyze entries. |
| `cost <input>` | Record a cost tracking entry. Without args, shows recent cost entries. |
| `usage <input>` | Record a usage entry. Without args, shows recent usage entries. |
| `optimize <input>` | Record an optimization entry. Without args, shows recent optimize entries. |
| `test <input>` | Record a test entry. Without args, shows recent test entries. |
| `report <input>` | Record a report entry. Without args, shows recent report entries. |
| `stats` | Show summary statistics across all entry types (counts, data size). |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search all log files for a term (case-insensitive). |
| `recent` | Show the 20 most recent entries from the activity history. |
| `status` | Health check — version, data directory, entry count, disk usage. |
| `help` | Show help message with all available commands. |
| `version` | Show version string (`mailcheck v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/mailcheck/`:

- Each command type writes to its own `.log` file (e.g., `configure.log`, `benchmark.log`, `prompt.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|<value>` format
- A unified `history.log` tracks all actions across command types
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies — works out of the box on Linux and macOS

## When to Use

1. **AI model benchmarking** — use `benchmark` and `compare` to record performance results across different AI models and track improvements over time
2. **Prompt engineering** — log `prompt` entries to document prompt iterations, capture effective templates, and build a prompt library
3. **Cost and usage tracking** — use `cost` and `usage` to monitor API spending, token usage, and resource consumption across AI services
4. **Model evaluation and fine-tuning** — record `evaluate` and `fine-tune` entries to track model accuracy, training runs, and hyperparameter experiments
5. **Testing and reporting** — use `test` to log test results and `report` to generate summary reports, then export data for stakeholder review

## Examples

```bash
# Record a benchmark result
mailcheck benchmark "GPT-4o: 92% accuracy on email classification, 1.2s avg latency"

# Log a prompt engineering iteration
mailcheck prompt "System: You are an email validator. Check format, domain, MX records."

# Track API costs
mailcheck cost "March 2025: $42.50 across 15,000 API calls"

# Record a model evaluation
mailcheck evaluate "Fine-tuned model v3: precision 0.95, recall 0.91, F1 0.93"

# Compare two approaches
mailcheck compare "Rule-based: 85% accuracy vs ML-based: 94% accuracy on spam detection"

# Search for entries mentioning a topic
mailcheck search "accuracy"

# Export all data as JSON
mailcheck export json

# View summary statistics
mailcheck stats
```

## Output

All commands print results to stdout. Each recording command confirms the save and shows the total entry count for that category. Redirect output to a file with:

```bash
mailcheck stats > report.txt
```

## Configuration

Set the `DATA_DIR` inside the script or modify the default path `~/.local/share/mailcheck/` to change where data is stored.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
