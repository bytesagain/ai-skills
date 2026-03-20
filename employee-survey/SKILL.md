---
version: "2.0.0"
name: Employee Survey
description: "Design employee surveys with eNPS scoring and trend analysis templates. Use when creating surveys, calculating eNPS, analyzing feedback."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Employee Survey

A utility toolkit for managing employee survey workflows — run surveys, check responses, convert formats, analyze results, generate reports, preview templates, batch process data, compare periods, export findings, configure settings, track status, and build reports — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `employee-survey run <input>` | Run a survey task — log survey execution details and parameters |
| `employee-survey check <input>` | Check survey responses or completion rates — record check results |
| `employee-survey convert <input>` | Convert survey data between formats — track conversion operations |
| `employee-survey analyze <input>` | Analyze survey results — log analysis parameters and findings |
| `employee-survey generate <input>` | Generate survey templates or reports — save generation requests |
| `employee-survey preview <input>` | Preview survey layouts or results — record preview sessions |
| `employee-survey batch <input>` | Batch process multiple surveys or datasets — log batch operations |
| `employee-survey compare <input>` | Compare survey results across periods or groups — track comparisons |
| `employee-survey export <input>` | Export survey data — log export operations |
| `employee-survey config <input>` | Configure survey settings — record configuration changes |
| `employee-survey status <input>` | Track survey status — log status updates |
| `employee-survey report <input>` | Build survey reports — save report specifications |
| `employee-survey stats` | Show summary statistics across all command categories |
| `employee-survey export json\|csv\|txt` | Export all logged data in JSON, CSV, or plain text format |
| `employee-survey search <term>` | Search across all log entries for a keyword |
| `employee-survey recent` | Show the 20 most recent activity entries |
| `employee-survey status` (no args) | Health check — version, data directory, entry count, disk usage |
| `employee-survey help` | Show available commands and usage |
| `employee-survey version` | Show version (v2.0.0) |

Each domain command (run, check, convert, etc.) works in two modes:
- **Without arguments**: displays the 20 most recent entries from that category
- **With arguments**: logs a new timestamped entry and shows the running total

## Data Storage

All data is stored locally in `~/.local/share/employee-survey/`. Each command writes to its own log file (e.g., `run.log`, `analyze.log`, `report.log`) and a shared `history.log` tracks all activity with timestamps. No cloud sync, no external API calls — everything stays on your machine.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `head`, `tail`, `basename`
- No external dependencies or API keys required

## When to Use

1. **Running periodic employee surveys** — Use `run` to log each survey execution, `config` to track parameter changes, and `status` to monitor completion across teams
2. **Analyzing survey trends over time** — Use `analyze` to record findings from each survey cycle and `compare` to track how results shift between quarters or departments
3. **Generating and previewing survey templates** — Use `generate` to create new survey specifications and `preview` to review how they'll look before distribution
4. **Batch processing multi-department surveys** — Use `batch` to log bulk processing operations when running surveys across many teams, then `export` to consolidate results
5. **Building executive reports** — Use `report` to log report-building activities, `stats` to get a quick summary of all survey data, and `export json` to feed dashboards

## Examples

```bash
# Run a new survey and log it
employee-survey run "Q1 2025 engagement survey — 500 employees, 12 questions"

# Check response rates
employee-survey check "Engineering dept: 87% response rate, 43 of 50 completed"

# Analyze results
employee-survey analyze "eNPS score: +42, up from +35 last quarter"

# Compare two periods
employee-survey compare "Q4 2024 vs Q1 2025: satisfaction up 8%, retention stable"

# Generate a report template
employee-survey generate "Monthly pulse survey — 5 questions, Likert scale"

# Batch process across departments
employee-survey batch "Processing 8 department surveys, total 2400 responses"

# Export all data to CSV
employee-survey export csv

# View statistics
employee-survey stats

# Search logs for a keyword
employee-survey search engagement
```

## How It Works

Employee Survey uses a simple append-only log architecture. Each command appends a timestamped, pipe-delimited entry (`YYYY-MM-DD HH:MM|value`) to its category-specific log file. The `stats` command aggregates line counts across all logs, `search` runs case-insensitive grep across all files, and `export` serializes everything into your chosen format (JSON, CSV, or plain text). The `status` command (without arguments) gives a quick system health overview including version, total entries, disk usage, and last activity timestamp.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
