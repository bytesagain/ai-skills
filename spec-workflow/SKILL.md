---
version: "1.0.0"
name: Spec Workflow Mcp
description: "Drive spec-driven dev workflows with planning, tracking, and review. Use when adding specs, planning sprints, tracking progress, reviewing deliverables."
---

# Spec Workflow

Spec Workflow v2.0.0 — a productivity toolkit for spec-driven development workflows. Manage tasks, plan sprints, track progress, review deliverables, set reminders, prioritize work, and run weekly reviews — all from the command line with timestamped log entries.

## Commands

The script (`scripts/script.sh`) exposes the following commands via a `case` dispatcher:

| Command | Description |
|---------|-------------|
| `add <input>` | Add a new spec/task entry. Without args, shows the 20 most recent add entries. |
| `plan <input>` | Record a planning entry (sprint planning, iteration goals). Without args, lists recent plans. |
| `track <input>` | Track progress on a task or deliverable. Without args, lists recent tracking entries. |
| `review <input>` | Record a review note (code review, spec review). Without args, lists recent reviews. |
| `streak <input>` | Log a streak entry (daily consistency tracking). Without args, lists recent streaks. |
| `remind <input>` | Set a reminder or log a reminder note. Without args, lists recent reminders. |
| `prioritize <input>` | Record a prioritization decision. Without args, lists recent prioritizations. |
| `archive <input>` | Archive a completed item. Without args, lists recent archive entries. |
| `tag <input>` | Tag or categorize an entry. Without args, lists recent tags. |
| `timeline <input>` | Record a timeline/milestone entry. Without args, lists recent timeline entries. |
| `report <input>` | Generate or log a report entry. Without args, lists recent reports. |
| `weekly-review <input>` | Record a weekly review summary. Without args, lists recent weekly reviews. |
| `stats` | Show summary statistics across all log files (entry counts per type, total, disk usage). |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format to `$DATA_DIR/export.<fmt>`. |
| `search <term>` | Search all log files for a term (case-insensitive grep). |
| `recent` | Show the 20 most recent lines from `history.log`. |
| `status` | Health check — shows version, data directory, total entries, disk usage, last activity. |
| `help` | Display the full help/usage message. |
| `version` | Print `spec-workflow v2.0.0`. |

## How Each Entry Command Works

1. If called **without arguments**, it tails the last 20 lines of `<command>.log`.
2. If called **with arguments**, it:
   - Timestamps the input (`YYYY-MM-DD HH:MM|<input>`)
   - Appends it to `$DATA_DIR/<command>.log`
   - Prints confirmation with the current total count
   - Logs the action to `history.log`

## Data Storage

All data is stored as plain-text log files under:

```
~/.local/share/spec-workflow/
├── add.log
├── plan.log
├── track.log
├── review.log
├── streak.log
├── remind.log
├── prioritize.log
├── archive.log
├── tag.log
├── timeline.log
├── report.log
├── weekly-review.log
└── history.log          # unified activity log
```

Each log line uses pipe-delimited format: `YYYY-MM-DD HH:MM|<value>`

The `history.log` uses: `MM-DD HH:MM <command>: <value>`

## Requirements

- **Bash** 4.0+ (uses `local` variables, `set -euo pipefail`)
- **coreutils**: `date`, `wc`, `du`, `tail`, `cat`, `basename`, `grep`, `sed`
- No external dependencies, API keys, or network access required
- Works on Linux and macOS

## When to Use

1. **Sprint planning** — use `plan` to record iteration goals, then `track` to log progress against them throughout the sprint
2. **Task management** — use `add` to capture new specs or tasks, `prioritize` to rank them, and `archive` when complete
3. **Daily standups** — use `streak` to maintain consistency tracking and `recent` to review what happened yesterday
4. **Code/spec reviews** — use `review` to log review notes and decisions for future reference
5. **Weekly retrospectives** — use `weekly-review` to capture weekly summaries, then `export` to generate reports for stakeholders

## Examples

### Add a task and plan a sprint

```bash
# Add a new spec
bash scripts/script.sh add "User authentication flow — OAuth2 + PKCE"

# Plan the sprint
bash scripts/script.sh plan "Sprint 12: auth flow, password reset, session mgmt"
```

### Track progress and review

```bash
# Track completion
bash scripts/script.sh track "auth flow: login endpoint done, tests passing"

# Log a review
bash scripts/script.sh review "auth PR #142: approved, minor naming nits"
```

### Prioritize and tag work items

```bash
# Set priority
bash scripts/script.sh prioritize "P0: fix token refresh race condition"

# Tag for categorization
bash scripts/script.sh tag "auth-flow: security-critical"
```

### Weekly review and export

```bash
# Record weekly summary
bash scripts/script.sh weekly-review "completed 8/10 sprint items, carried over 2 to next sprint"

# Export all data as JSON
bash scripts/script.sh export json
```

### Search and stats

```bash
# Find all entries mentioning "auth"
bash scripts/script.sh search "auth"

# View overall statistics
bash scripts/script.sh stats
```

## Configuration

Set the `DATA_DIR` variable (or modify it in the script) to change the storage directory. Default: `~/.local/share/spec-workflow/`

## Output

All commands print to stdout. Redirect to a file as needed:

```bash
bash scripts/script.sh report > sprint-report.txt
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
