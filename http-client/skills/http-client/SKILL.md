---
version: "1.0.0"
name: Curl
description: "A command line tool and library for transferring data with URL syntax, supporting DICT, FILE, FTP, F http-client, c, c, client, http-client, ftp."
---

# Http Client

Http Client v2.0.0 — a devtools toolkit for checking, validating, generating, formatting, linting, explaining, converting, templating, diffing, previewing, fixing, and reporting on HTTP-related data. All entries are timestamped and logged locally for history tracking.

## Commands

### Core Commands

- `check <input>` — Record and log a check entry. Without arguments, shows the 20 most recent check entries.
- `validate <input>` — Record and log a validate entry. Without arguments, shows recent validate entries.
- `generate <input>` — Record and log a generate entry. Without arguments, shows recent generate entries.
- `format <input>` — Record and log a format entry. Without arguments, shows recent format entries.
- `lint <input>` — Record and log a lint entry. Without arguments, shows recent lint entries.
- `explain <input>` — Record and log an explain entry. Without arguments, shows recent explain entries.
- `convert <input>` — Record and log a convert entry. Without arguments, shows recent convert entries.
- `template <input>` — Record and log a template entry. Without arguments, shows recent template entries.
- `diff <input>` — Record and log a diff entry. Without arguments, shows recent diff entries.
- `preview <input>` — Record and log a preview entry. Without arguments, shows recent preview entries.
- `fix <input>` — Record and log a fix entry. Without arguments, shows recent fix entries.
- `report <input>` — Record and log a report entry. Without arguments, shows recent report entries.

### Utility Commands

- `stats` — Show summary statistics across all log files (entry counts per type, total entries, disk usage).
- `export <fmt>` — Export all logged data to a file. Supported formats: `json`, `csv`, `txt`.
- `search <term>` — Search all log files for a case-insensitive term match.
- `recent` — Show the 20 most recent entries from the activity history log.
- `status` — Health check showing version, data directory, total entries, disk usage, and last activity.
- `help` — Display the full help message with all available commands.
- `version` — Print the current version (v2.0.0).

## Data Storage

All data is stored in `~/.local/share/http-client/`:

- Each core command writes timestamped entries to its own log file (e.g., `check.log`, `validate.log`).
- A unified `history.log` tracks all operations across commands.
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`

## When to Use

- When you need to log and track devtools operations (checks, validations, linting, formatting, etc.)
- For maintaining an audit trail of HTTP client development activities
- To export accumulated data in JSON, CSV, or plain text for downstream processing
- As part of a larger automation pipeline that needs timestamped operation records
- When you need quick search across historical devtools entries

## Examples

```bash
# Record a check entry
http-client check "GET https://api.example.com/users"

# Validate something and log it
http-client validate "response schema v2"

# Lint an input
http-client lint "request headers"

# View recent activity
http-client recent

# Search across all logs
http-client search "api.example.com"

# Export everything to JSON
http-client export json

# Show stats
http-client stats

# Health check
http-client status
```

## Output

All commands output results to stdout. Redirect to a file if needed:

```bash
http-client stats > report.txt
http-client export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
