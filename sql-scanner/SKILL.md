---
version: "1.0.0"
name: Sqlmap
description: "Detect SQL injection vulnerabilities and assess DB security. Use when checking queries, validating sanitization, generating tests, formatting reports."
---

# SQL Scanner

SQL security scanner and database devtools toolkit. Check queries for vulnerabilities, validate SQL syntax, generate test cases, format queries, lint code, explain execution plans, and more — all from the command line.

## Commands

Run `sql-scanner <command> [args]` to use. Each command records timestamped entries to its own log file.

### Core Operations

| Command | Description |
|---------|-------------|
| `check <input>` | Check a SQL query for security issues or correctness |
| `validate <input>` | Validate SQL syntax or sanitization rules |
| `generate <input>` | Generate SQL test cases, mock queries, or schemas |
| `format <input>` | Format and pretty-print a SQL query |
| `lint <input>` | Lint SQL code for style and best-practice violations |
| `explain <input>` | Record an execution plan analysis or query explanation |
| `convert <input>` | Convert between SQL dialects or formats |
| `template <input>` | Log or retrieve SQL templates for common patterns |
| `diff <input>` | Record differences between two SQL versions or schemas |
| `preview <input>` | Preview a query transformation before applying |
| `fix <input>` | Log a fix applied to a problematic query |
| `report <input>` | Record a scan report or audit finding |

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
~/.local/share/sql-scanner/
├── check.log          # Security check records
├── validate.log       # Validation results
├── generate.log       # Generated test cases
├── format.log         # Formatted queries
├── lint.log           # Lint findings
├── explain.log        # Execution plan notes
├── convert.log        # Dialect conversions
├── template.log       # SQL templates
├── diff.log           # Schema/query diffs
├── preview.log        # Preview entries
├── fix.log            # Applied fixes
├── report.log         # Audit reports
└── history.log        # Unified activity log (all commands)
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). The `history.log` file receives a line for every command executed, providing a single timeline of all activity.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies — pure bash, works on any Linux or macOS system

## When to Use

1. **SQL code review** — use `check` and `lint` to record findings when reviewing queries for injection risks or style issues
2. **Query formatting** — use `format` to log prettified versions of messy SQL before sharing with the team
3. **Schema migrations** — use `diff` and `convert` to track changes when migrating between database dialects
4. **Security auditing** — use `report` and `validate` to document SQL injection scan results and sanitization checks
5. **Test case generation** — use `generate` and `template` to build and catalog reusable SQL test patterns

## Examples

```bash
# Check a query for SQL injection risks
sql-scanner check "SELECT * FROM users WHERE id = '$input'"

# Lint a query for style issues
sql-scanner lint "select name,age from users where age>18"

# Format a messy query
sql-scanner format "SELECT a.id, b.name FROM table_a a JOIN table_b b ON a.id=b.aid WHERE a.status=1"

# Generate a test case
sql-scanner generate "INSERT injection test for login form"

# Log a schema diff
sql-scanner diff "users table: added column 'email_verified' BOOLEAN DEFAULT FALSE"

# Export all scan data to JSON
sql-scanner export json

# Search for all entries mentioning 'injection'
sql-scanner search injection

# View overall statistics
sql-scanner stats
```

## Configuration

Set the `SQL_SCANNER_DIR` environment variable to change the data directory:

```bash
export SQL_SCANNER_DIR="/custom/path/to/data"
```

Default: `~/.local/share/sql-scanner/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
