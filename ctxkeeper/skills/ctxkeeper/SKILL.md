---
version: "1.0.0"
name: ctxkeeper
description: "Manage conversation context with saving, loading, and pruning tools. Use when preserving context, loading sessions, pruning old history."
---

# Ctxkeeper

A utility toolkit for logging, tracking, and managing operational entries across multiple categories. Each command records timestamped entries to dedicated log files for later review, search, and export.

Data stored in `~/.local/share/ctxkeeper/`

## Commands

| Command | Description |
|---------|-------------|
| `run <input>` | Record a run entry. Without args, shows recent run entries. |
| `check <input>` | Record a check entry. Without args, shows recent check entries. |
| `convert <input>` | Record a convert entry. Without args, shows recent convert entries. |
| `analyze <input>` | Record an analyze entry. Without args, shows recent analyze entries. |
| `generate <input>` | Record a generate entry. Without args, shows recent generate entries. |
| `preview <input>` | Record a preview entry. Without args, shows recent preview entries. |
| `batch <input>` | Record a batch entry. Without args, shows recent batch entries. |
| `compare <input>` | Record a compare entry. Without args, shows recent compare entries. |
| `export <input>` | Record an export entry. Without args, shows recent export entries. |
| `config <input>` | Record a config entry. Without args, shows recent config entries. |
| `status <input>` | Record a status entry. Without args, shows recent status entries. |
| `report <input>` | Record a report entry. Without args, shows recent report entries. |
| `stats` | Show summary statistics across all log files (entry counts, data size). |
| `search <term>` | Search all log files for a term (case-insensitive). |
| `recent` | Show the last 20 lines from history.log. |
| `help` | Show usage and available commands. |
| `version` | Print version string (ctxkeeper v2.0.0). |

## Requirements

- Bash 4+

## When to Use

- Tracking context changes, runs, and checks over time with timestamped logs
- Keeping a structured journal of operational activities across categories
- Searching historical entries to find when something was run, checked, or analyzed
- Exporting logged data for review or sharing with teammates
- Monitoring overall activity via stats and recent commands

## Examples

```bash
# Record a run entry
ctxkeeper run "deployed api v2.3 to staging"

# Search all logs for a keyword
ctxkeeper search "staging"

# View summary statistics
ctxkeeper stats

# Check recent activity across all categories
ctxkeeper recent

# Record an analyze entry then review it
ctxkeeper analyze "memory usage spike at 14:00"
ctxkeeper analyze
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
