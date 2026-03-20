---
name: Apollo Client
description: "Manage GraphQL queries, caching, and state with Apollo Client. Use when building React apps, debugging cache, or optimizing GraphQL fetches."
version: "1.0.0"
license: MIT
runtime: python3
---

# Apollo Client

Utility toolkit for logging, tracking, and managing data entries. Each command records timestamped entries to individual log files and supports viewing recent entries, searching, exporting, and statistics.

## Commands

| Command | Description |
|---------|-------------|
| `apollo-client run <input>` | Record a run entry; without args shows recent run entries |
| `apollo-client check <input>` | Record a check entry; without args shows recent check entries |
| `apollo-client convert <input>` | Record a convert entry; without args shows recent convert entries |
| `apollo-client analyze <input>` | Record an analyze entry; without args shows recent analyze entries |
| `apollo-client generate <input>` | Record a generate entry; without args shows recent generate entries |
| `apollo-client preview <input>` | Record a preview entry; without args shows recent preview entries |
| `apollo-client batch <input>` | Record a batch entry; without args shows recent batch entries |
| `apollo-client compare <input>` | Record a compare entry; without args shows recent compare entries |
| `apollo-client export <input>` | Record an export entry; without args shows recent export entries |
| `apollo-client config <input>` | Record a config entry; without args shows recent config entries |
| `apollo-client status <input>` | Record a status entry; without args shows recent status entries |
| `apollo-client report <input>` | Record a report entry; without args shows recent report entries |
| `apollo-client stats` | Show summary statistics across all log files (entry counts, data size) |
| `apollo-client search <term>` | Search all log files for a term (case-insensitive) |
| `apollo-client recent` | Show last 20 lines from history.log |
| `apollo-client help` | Show help message with all available commands |
| `apollo-client version` | Show version (v2.0.0) |

Note: The `stats` command also provides a built-in `export <fmt>` (json/csv/txt) and a `status` health check via internal functions, but these share names with the case-branch commands above. The case branches take priority.

## Data Storage

Data stored in `~/.local/share/apollo-client/`

Each command writes timestamped entries to its own `.log` file (e.g., `run.log`, `check.log`). All actions are also recorded in `history.log`.

## Requirements

- Bash 4+

## When to Use

- Tracking and logging various activities with timestamped records
- Searching across historical log entries for specific terms
- Exporting accumulated data in JSON, CSV, or TXT format
- Reviewing recent activity across all command categories
- Getting summary statistics on logged data volume and size

## Examples

```bash
# Record a run entry
apollo-client run "deployed frontend v3.2"

# Search all logs for a keyword
apollo-client search "deploy"

# View summary stats across all log categories
apollo-client stats

# Show last 20 history entries
apollo-client recent
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
