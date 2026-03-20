---
version: "1.0.0"
name: Apollo Client
description: "The industry-leading GraphQL client for TypeScript, JavaScript, React, Vue, Angular, and more. Apoll apollo client, typescript, graphql-client."
---

# Graphql Client

Graphql Client v2.0.0 — a devtools toolkit for logging and tracking GraphQL-related operations from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `graphql-client check <input>` | Log a check entry (no args = show recent) |
| `graphql-client validate <input>` | Log a validate entry (no args = show recent) |
| `graphql-client generate <input>` | Log a generate entry (no args = show recent) |
| `graphql-client format <input>` | Log a format entry (no args = show recent) |
| `graphql-client lint <input>` | Log a lint entry (no args = show recent) |
| `graphql-client explain <input>` | Log an explain entry (no args = show recent) |
| `graphql-client convert <input>` | Log a convert entry (no args = show recent) |
| `graphql-client template <input>` | Log a template entry (no args = show recent) |
| `graphql-client diff <input>` | Log a diff entry (no args = show recent) |
| `graphql-client preview <input>` | Log a preview entry (no args = show recent) |
| `graphql-client fix <input>` | Log a fix entry (no args = show recent) |
| `graphql-client report <input>` | Log a report entry (no args = show recent) |
| `graphql-client stats` | Show summary statistics across all log files |
| `graphql-client export <fmt>` | Export all data (json, csv, or txt) |
| `graphql-client search <term>` | Search across all log entries |
| `graphql-client recent` | Show last 20 history entries |
| `graphql-client status` | Health check (version, data dir, entry count, disk usage) |
| `graphql-client help` | Show usage information |
| `graphql-client version` | Show version string |

## Data Storage

All data is stored locally in `~/.local/share/graphql-client/`. Each command writes timestamped entries to its own `.log` file (e.g., `check.log`, `validate.log`, `lint.log`). A unified `history.log` tracks all operations for the `recent` command.

Log format per entry: `YYYY-MM-DD HH:MM|<input>`

## Requirements

- Bash (with `set -euo pipefail`)
- No external dependencies — uses only standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `cat`, `sed`)

## When to Use

- To log and track GraphQL development operations over time
- To maintain a searchable history of check/validate/lint/format tasks
- To export accumulated data in JSON, CSV, or plain text for reporting
- To get a quick health check on your graphql-client data directory
- For tracking schema changes, query validation, and code generation tasks

## Examples

```bash
# Log a check entry
graphql-client check "schema endpoint https://api.example.com/graphql"

# Log a validate entry
graphql-client validate "query GetUser { user { id name } }"

# Log a lint entry
graphql-client lint "src/queries/*.graphql"

# View recent format entries
graphql-client format

# Search all logs for a term
graphql-client search "schema"

# Export everything as CSV
graphql-client export csv

# View aggregate statistics
graphql-client stats

# Health check
graphql-client status

# Show last 20 history entries
graphql-client recent
```

## Configuration

Set the `GRAPHQL_CLIENT_DIR` environment variable to override the default data directory. Default: `~/.local/share/graphql-client/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
