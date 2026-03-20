---
version: "1.0.0"
name: gitbuddy
description: "Extend Git with utilities for changelogs, branch cleanup, and repo stats. Use when generating changelogs, squashing branches, or viewing repo statistics."
---

# GitBuddy

GitBuddy v2.0.0 — a developer toolkit for managing code quality workflows from the command line. Log checks, validations, lint results, diffs, fixes, and more. Each entry is timestamped and persisted locally. Works entirely offline — your data never leaves your machine.

## Why GitBuddy?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface with no GUI dependency
- Export to JSON, CSV, or plain text at any time for sharing or archival
- Automatic activity history logging across all commands
- Each domain command doubles as both a logger and a viewer

## Commands

### Domain Commands

Each domain command works in two modes: **log mode** (with arguments) saves a timestamped entry, **view mode** (no arguments) shows the 20 most recent entries.

| Command | Description |
|---------|-------------|
| `gitbuddy check <input>` | Log a check operation such as code quality checks, dependency audits, or pre-commit verification results. Track what was checked and the outcome. |
| `gitbuddy validate <input>` | Log a validation entry for schema validations, test suite passes, or configuration checks. Record pass/fail status and details of what was validated. |
| `gitbuddy generate <input>` | Log a generation task such as changelog generation, boilerplate scaffolding, or code generation results. Track what was generated and from what source. |
| `gitbuddy format <input>` | Log a formatting operation including code formatter runs, style enforcement results, and auto-fix summaries. Record files affected and changes made. |
| `gitbuddy lint <input>` | Log a lint result with error counts, warning details, and rule violations found. Useful for tracking code quality trends across commits and branches. |
| `gitbuddy explain <input>` | Log an explanation entry for code review notes, architecture decisions, or complex logic documentation. Build a searchable knowledge base of explanations. |
| `gitbuddy convert <input>` | Log a conversion task such as format migrations, encoding changes, or data transformations. Record source format, target format, and conversion outcomes. |
| `gitbuddy template <input>` | Log a template operation for project scaffolding, commit message templates, or PR description templates. Track template creation and usage patterns. |
| `gitbuddy diff <input>` | Log a diff result including lines added/removed, files changed, and branch comparison summaries. Essential for tracking code change patterns over time. |
| `gitbuddy preview <input>` | Log a preview entry for build previews, deployment previews, or staged change reviews. Record what was previewed and the assessment. |
| `gitbuddy fix <input>` | Log a fix operation for bug fixes, lint auto-fixes, or configuration corrections. Track what was broken, what was changed, and whether the fix resolved the issue. |
| `gitbuddy report <input>` | Log a report entry for code quality summaries, sprint retrospectives, or weekly development reports. Capture key metrics and findings. |

### Utility Commands

| Command | Description |
|---------|-------------|
| `gitbuddy stats` | Show summary statistics across all log files, including entry counts per category and total data size on disk. |
| `gitbuddy export <fmt>` | Export all data to a file in the specified format. Supported formats: `json`, `csv`, `txt`. Output is saved to the data directory. |
| `gitbuddy search <term>` | Search all log entries for a term using case-insensitive matching. Results are grouped by log category for easy scanning. |
| `gitbuddy recent` | Show the 20 most recent entries from the unified activity log, giving a quick overview of recent work across all commands. |
| `gitbuddy status` | Health check showing version, data directory path, total entry count, disk usage, and last activity timestamp. |
| `gitbuddy help` | Show the built-in help message listing all available commands and usage information. |
| `gitbuddy version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored locally at `~/.local/share/gitbuddy/`. Each domain command writes to its own log file (e.g., `check.log`, `lint.log`). A unified `history.log` tracks all actions across commands. Use `export` to back up your data at any time.

## Requirements

- Bash (4.0+)
- No external dependencies — pure shell script
- No network access required

## When to Use

- Tracking code quality checks and lint results across commits, branches, and releases over time
- Logging validation outcomes and formatting operations for audit trails and compliance
- Recording diffs and fix operations to maintain a searchable history of code changes
- Generating development activity reports for sprint retrospectives or team reviews
- Building a local knowledge base of code explanations, templates, and conversion records

## Examples

```bash
# Log a lint result
gitbuddy lint "src/main.js — 0 errors, 3 warnings (no-unused-vars, prefer-const)"

# Log a validation
gitbuddy validate "schema v2.1 passes all 47 test cases, zero regressions"

# Record a fix
gitbuddy fix "Resolved null pointer in auth middleware — missing user check on line 142"

# Log a diff
gitbuddy diff "feature-branch vs main: +342 -128 lines across 14 files"

# Generate a report entry
gitbuddy report "Weekly code quality summary — 98.5% pass rate, down 2 warnings from last week"

# View all statistics
gitbuddy stats

# Export everything to CSV
gitbuddy export csv

# Search entries mentioning auth
gitbuddy search auth

# Check recent activity
gitbuddy recent

# Health check
gitbuddy status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
