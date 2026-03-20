---
version: "1.0.0"
name: Rundeck
description: "Enable Self-Service Operations: Give specific users access to your existing tools, services, and scr job-scheduler, groovy, ansible, audit, automation."
---
# Job Scheduler

Job Scheduler v2.0.0 — a productivity toolkit for managing scheduled tasks, tracking job execution, and organizing workflow automation from the command line.

Each command accepts free-text input. When called without arguments it displays recent entries; when called with input it logs the entry with a timestamp for future reference.

## Commands

| Command | Description |
|---------|-------------|
| `job-scheduler add <input>` | Add a new job or task entry |
| `job-scheduler plan <input>` | Log a planning note (e.g. schedule layout, dependency mapping) |
| `job-scheduler track <input>` | Track job execution progress or milestones |
| `job-scheduler review <input>` | Log a review entry (e.g. post-run analysis, feedback) |
| `job-scheduler streak <input>` | Track streaks (e.g. consecutive successful runs) |
| `job-scheduler remind <input>` | Log a reminder for an upcoming job or deadline |
| `job-scheduler prioritize <input>` | Log priority decisions (e.g. reorder job queue, set urgency) |
| `job-scheduler archive <input>` | Archive completed or obsolete jobs |
| `job-scheduler tag <input>` | Tag entries with labels for organization |
| `job-scheduler timeline <input>` | Log timeline entries (e.g. milestone dates, Gantt-style notes) |
| `job-scheduler report <input>` | Log a report entry (e.g. summarize job outcomes) |
| `job-scheduler weekly-review <input>` | Log a weekly review summary |

### Utility Commands

| Command | Description |
|---------|-------------|
| `job-scheduler stats` | Show summary statistics across all entry types |
| `job-scheduler export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `job-scheduler search <term>` | Search all entries for a keyword (case-insensitive) |
| `job-scheduler recent` | Show the 20 most recent activity log entries |
| `job-scheduler status` | Health check — version, data dir, entry count, disk usage |
| `job-scheduler help` | Show the built-in help message |
| `job-scheduler version` | Print version string (`job-scheduler v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/job-scheduler/`. Each command writes to its own log file (e.g. `add.log`, `plan.log`, `track.log`, `weekly-review.log`). A unified `history.log` tracks all activity with timestamps. Exports are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Managing recurring job schedules** — use `add` to register new jobs, `plan` to lay out execution schedules, and `remind` to set deadline reminders so nothing slips through.
2. **Tracking job execution and success rates** — use `track` to log each run's outcome, `streak` to monitor consecutive successes, and `stats` to get an overview of all activity.
3. **Conducting weekly operational reviews** — use `weekly-review` to summarize the week's job outcomes, `review` to analyze individual runs, and `report` to generate stakeholder summaries.
4. **Prioritizing and organizing a job queue** — use `prioritize` to log priority decisions, `tag` to categorize jobs by team or system, and `timeline` to map out execution order and dependencies.
5. **Archiving and auditing historical jobs** — use `archive` to move completed jobs out of active view, `search` to find past entries by keyword, and `export json` to create audit-ready snapshots.

## Examples

```bash
# Add a new scheduled job
job-scheduler add "Daily DB backup — runs at 02:00 UTC, retention 30 days"

# Plan the execution schedule
job-scheduler plan "Q2 migration jobs: Phase 1 (Apr 1-15), Phase 2 (Apr 16-30)"

# Track a job execution result
job-scheduler track "Daily backup completed successfully — 4.2 GB, 12 min"

# Set a reminder for an upcoming deadline
job-scheduler remind "Quarterly report generation due Friday 5pm"

# Prioritize jobs in the queue
job-scheduler prioritize "Move security patching ahead of feature deployments"

# Tag a job for organization
job-scheduler tag "backup-daily: critical, infrastructure, automated"

# Log a weekly review
job-scheduler weekly-review "15/17 jobs succeeded, 2 failed (disk space), resolved"

# Search for all backup-related entries
job-scheduler search "backup"

# View summary statistics
job-scheduler stats

# Export all data to JSON
job-scheduler export json
```

## How It Works

Job Scheduler is a lightweight Bash script that stores timestamped entries in plain-text log files. Each command follows the same pattern:

- **No arguments** → display the 20 most recent entries from that command's log
- **With arguments** → append a timestamped entry to the log and confirm the save

The `stats` command aggregates line counts across all `.log` files. The `export` command serializes all logs into your chosen format. The `search` command greps case-insensitively across every log file in the data directory.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
