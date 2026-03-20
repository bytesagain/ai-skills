---
version: "1.0.0"
name: Laf
description: "Laf is a vibrant cloud development platform that provides essential tools like cloud functions, data serverless-runner, typescript, cloudbase, faas."
---

# Serverless Runner

Terminal-first devtools toolkit for checking, validating, generating, formatting, linting, and managing code and configuration — all from the command line.

## Why Serverless Runner?

- Works entirely offline — your data never leaves your machine
- Complete devtools workflow: check → validate → generate → format → lint → fix → report
- Template and diff support for code generation and comparison
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging with timestamps

## Getting Started

```bash
# See all available commands
serverless-runner help

# Check current health status
serverless-runner status

# View summary statistics
serverless-runner stats

# Show recent activity
serverless-runner recent
```

## Commands

| Command | What it does |
|---------|-------------|
| `serverless-runner check <input>` | Check code or config (or view recent checks with no args) |
| `serverless-runner validate <input>` | Validate input against rules (or view recent validations) |
| `serverless-runner generate <input>` | Generate code or config from templates (or view recent generations) |
| `serverless-runner format <input>` | Format code or data (or view recent formats) |
| `serverless-runner lint <input>` | Lint code for style issues (or view recent lints) |
| `serverless-runner explain <input>` | Explain code or config (or view recent explanations) |
| `serverless-runner convert <input>` | Convert between formats (or view recent conversions) |
| `serverless-runner template <input>` | Manage or apply templates (or view recent templates) |
| `serverless-runner diff <input>` | Diff two inputs or versions (or view recent diffs) |
| `serverless-runner preview <input>` | Preview output before committing (or view recent previews) |
| `serverless-runner fix <input>` | Auto-fix detected issues (or view recent fixes) |
| `serverless-runner report <input>` | Generate a report (or view recent reports) |
| `serverless-runner stats` | Show summary statistics across all data categories |
| `serverless-runner export <fmt>` | Export all data in a format: json, csv, or txt |
| `serverless-runner search <term>` | Search across all log entries for a keyword |
| `serverless-runner recent` | Show the 20 most recent activity entries |
| `serverless-runner status` | Health check: version, disk usage, entry counts |
| `serverless-runner help` | Show the full help message |
| `serverless-runner version` | Print current version (v2.0.0) |

Each devtools command works in two modes:
- **With arguments:** saves the input with a timestamp to `<command>.log` and logs to history
- **Without arguments:** displays the 20 most recent entries for that command

## Data Storage

All data is stored locally at `~/.local/share/serverless-runner/`:

- `check.log`, `validate.log`, `generate.log`, etc. — one log file per command
- `history.log` — unified activity log with timestamps
- `export.json`, `export.csv`, `export.txt` — generated export files

Data format: each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

Set the `SERVERLESS_RUNNER_DIR` environment variable to change the data directory.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard UNIX utilities: `wc`, `du`, `grep`, `tail`, `sed`, `date`, `cat`, `basename`
- No external dependencies or network access required

## When to Use

1. **Checking and validating configs** — run `check` and `validate` on config files, YAML, or JSON before deploying
2. **Generating boilerplate** — use `generate` and `template` to scaffold new projects or components
3. **Linting and auto-fixing code** — chain `lint` → `fix` to catch and resolve style issues automatically
4. **Comparing versions** — use `diff` and `preview` to review changes before committing
5. **Exporting devtools reports** — generate JSON, CSV, or TXT snapshots of your activity for auditing or sharing

## Examples

```bash
# Check a configuration file
serverless-runner check "nginx.conf syntax valid"

# Validate and lint
serverless-runner validate "docker-compose.yml schema check"
serverless-runner lint "src/main.py flake8 style"

# Generate from template and preview
serverless-runner generate "new-service from microservice-template"
serverless-runner template "microservice: port=8080 name=auth-svc"
serverless-runner preview "auth-svc deployment manifest"

# Diff two versions, then auto-fix
serverless-runner diff "v1.2.0 vs v1.3.0 config changes"
serverless-runner fix "auto-fix lint warnings in src/"

# Export everything as JSON, then search
serverless-runner export json
serverless-runner search "nginx"

# Check overall health
serverless-runner status
serverless-runner stats
```

## Output

All commands return human-readable output to stdout. Redirect to a file for scripting:

```bash
serverless-runner stats > report.txt
serverless-runner export csv
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
