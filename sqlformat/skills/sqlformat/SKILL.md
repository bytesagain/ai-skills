---
name: SQLFormat
description: "Format, lint, and pretty-print SQL with dialect conversion. Use when checking style, validating syntax, formatting queries, generating clean SQL."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["sql","format","lint","query","database","developer"]
categories: ["Developer Tools", "Utility"]
---

# SQLFormat

SQL query formatter, linter, and devtools toolkit. Check SQL style, validate syntax, format and pretty-print queries, lint for best practices, explain execution plans, convert between dialects, and manage SQL templates — all from the command line.

## Commands

Run `sqlformat <command> [args]` to use. Each command records timestamped entries to its own log file.

### Core Operations

| Command | Description |
|---------|-------------|
| `check <input>` | Check SQL code for style or correctness issues |
| `validate <input>` | Validate SQL syntax against rules |
| `generate <input>` | Generate formatted SQL snippets or boilerplate |
| `format <input>` | Format and pretty-print a SQL query with proper indentation |
| `lint <input>` | Lint SQL for style violations and anti-patterns |
| `explain <input>` | Record query explanation or execution plan notes |
| `convert <input>` | Convert SQL between dialects (MySQL ↔ PostgreSQL, etc.) |
| `template <input>` | Store or retrieve reusable SQL templates |
| `diff <input>` | Record differences between SQL versions |
| `preview <input>` | Preview a formatting transformation before applying |
| `fix <input>` | Log an applied fix to a SQL issue |
| `report <input>` | Record a formatting or lint report |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files (entry counts, disk usage) |
| `export <fmt>` | Export all data in a given format: `json`, `csv`, or `txt` |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Display the last 20 lines from the activity history log |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show the full command reference |
| `version` | Print current version (v2.0.0) |

> **Note:** Each core command works in two modes — call with no arguments to view recent entries (last 20), or pass input to record a new timestamped entry.

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/sqlformat/
├── check.log          # Style check records
├── validate.log       # Syntax validation results
├── generate.log       # Generated SQL snippets
├── format.log         # Formatted query records
├── lint.log           # Lint findings
├── explain.log        # Execution plan notes
├── convert.log        # Dialect conversion records
├── template.log       # Reusable SQL templates
├── diff.log           # SQL version diffs
├── preview.log        # Preview entries
├── fix.log            # Applied fix records
├── report.log         # Lint/format reports
└── history.log        # Unified activity log (all commands)
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). The `history.log` file receives a line for every command executed, providing a single timeline of all activity.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies — pure bash, works on any Linux or macOS system

## When to Use

1. **Code review prep** — use `format` and `lint` to clean up SQL before submitting a pull request
2. **SQL style enforcement** — use `check` and `lint` to document style violations across a codebase
3. **Dialect migration** — use `convert` when porting queries from MySQL to PostgreSQL (or vice versa)
4. **Query documentation** — use `explain` and `template` to catalog common query patterns with notes
5. **Batch formatting workflows** — use `generate` and `preview` to build formatted SQL output pipelines

## Examples

```bash
# Format a messy query
sqlformat format "SELECT u.id,u.name,o.total FROM users u JOIN orders o ON u.id=o.user_id WHERE o.status='active'"

# Lint SQL for anti-patterns
sqlformat lint "SELECT * FROM users WHERE 1=1"

# Validate SQL syntax
sqlformat validate "INSERT INTO products (name, price) VALUES ('Widget', 9.99)"

# Convert MySQL to PostgreSQL syntax
sqlformat convert "MySQL: AUTO_INCREMENT -> PostgreSQL: SERIAL"

# Store a reusable template
sqlformat template "pagination: SELECT * FROM {table} LIMIT {limit} OFFSET {offset}"

# Export all records to CSV
sqlformat export csv

# Search for entries about JOIN formatting
sqlformat search JOIN

# View statistics
sqlformat stats
```

## Configuration

Set the `SQLFORMAT_DIR` environment variable to change the data directory:

```bash
export SQLFORMAT_DIR="/custom/path/to/data"
```

Default: `~/.local/share/sqlformat/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
