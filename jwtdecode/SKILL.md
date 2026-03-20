---
name: JWTDecode
description: "Decode and inspect JWT tokens showing header, payload, and expiry. Use when debugging auth tokens, inspecting claims, checking token expiration."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["jwt","token","decode","auth","security","api","developer"]
categories: ["Developer Tools", "Utility"]
---

# JWTDecode

A command-line devtools toolkit for working with JWT tokens. Check, validate, generate, format, lint, explain, convert, diff, preview, fix, and report on JWT data — all from your terminal with persistent logging and activity tracking.

## Why JWTDecode?

- Works entirely offline — tokens and data never leave your machine
- No external dependencies or accounts needed
- Every action is timestamped and logged for full auditability
- Export your history to JSON, CSV, or plain text anytime
- Pure bash implementation — lightweight and portable

## Commands

| Command | Description |
|---------|-------------|
| `jwtdecode check <input>` | Check a JWT token for issues; view recent checks without args |
| `jwtdecode validate <input>` | Validate JWT token structure and format |
| `jwtdecode generate <input>` | Generate JWT-related data or test tokens |
| `jwtdecode format <input>` | Format JWT token output for readability |
| `jwtdecode lint <input>` | Lint JWT tokens for common problems |
| `jwtdecode explain <input>` | Explain JWT token structure (header, payload, signature) |
| `jwtdecode convert <input>` | Convert JWT data between formats |
| `jwtdecode template <input>` | Create or apply JWT templates |
| `jwtdecode diff <input>` | Diff two JWT tokens to find claim differences |
| `jwtdecode preview <input>` | Preview decoded JWT token output |
| `jwtdecode fix <input>` | Auto-fix common JWT formatting issues |
| `jwtdecode report <input>` | Generate a report from JWT analysis |
| `jwtdecode stats` | Show summary statistics across all actions |
| `jwtdecode export <fmt>` | Export all logs (formats: `json`, `csv`, `txt`) |
| `jwtdecode search <term>` | Search across all log entries |
| `jwtdecode recent` | Show the 20 most recent activity entries |
| `jwtdecode status` | Health check — version, disk usage, entry count |
| `jwtdecode help` | Show help with all available commands |
| `jwtdecode version` | Print current version (v2.0.0) |

Each data command (check, validate, generate, etc.) works in two modes:
- **With arguments** — logs the input with a timestamp and saves to its dedicated log file
- **Without arguments** — displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/jwtdecode/`. The directory structure:

- `check.log`, `validate.log`, `generate.log`, etc. — per-command log files
- `history.log` — unified activity log across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Set the `JWTDECODE_DIR` environment variable or modify `DATA_DIR` in the script to change the storage location.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- Works on Linux and macOS
- No external packages or network access required

## When to Use

1. **Debugging authentication flows** — use `jwtdecode check` and `jwtdecode explain` to inspect token contents when troubleshooting login or API auth issues
2. **Validating token structure** — run `jwtdecode validate` to verify that tokens conform to expected JWT format before deploying auth changes
3. **Comparing tokens across environments** — use `jwtdecode diff` to spot claim differences between staging and production tokens
4. **Auditing token usage** — use `jwtdecode stats`, `jwtdecode recent`, and `jwtdecode export` to review your JWT analysis history over time
5. **Formatting tokens for documentation** — run `jwtdecode format` to produce clean, readable token breakdowns for technical docs or code reviews

## Examples

```bash
# Check a JWT token for issues
jwtdecode check "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Validate a token's structure
jwtdecode validate "eyJhbGciOiJSUzI1NiJ9..."

# Explain what a JWT token contains
jwtdecode explain "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0..."

# View all recent checks (no args = show history)
jwtdecode check

# Export all history as JSON
jwtdecode export json

# Search for a specific claim in logs
jwtdecode search "admin"

# View summary statistics
jwtdecode stats

# Health check
jwtdecode status
```

## Output

All commands output structured text to stdout. You can redirect output to a file:

```bash
jwtdecode report mytoken > analysis.txt
jwtdecode export csv
```

## Configuration

The data directory defaults to `~/.local/share/jwtdecode/`. Modify the `DATA_DIR` variable at the top of `script.sh` to customize the storage path.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
