---
version: "1.0.0"
name: keyvault
description: "Generate and manage passwords with strength auditing and secure vault storage. Use when creating strong passwords, rotating credentials, auditing vaults."
---

# Keyvault

A command-line utility toolkit for managing keys, credentials, and secure data. Run, check, convert, analyze, generate, preview, batch process, compare, export, configure, check status, and generate reports — all from your terminal with persistent logging and activity history.

## Why Keyvault?

- Works entirely offline — your secrets and data never leave your machine
- No external dependencies or accounts needed
- Every action is timestamped and logged for full auditability
- Export your history to JSON, CSV, or plain text anytime
- Simple CLI interface with consistent command patterns

## Commands

| Command | Description |
|---------|-------------|
| `keyvault run <input>` | Run a vault operation; view recent runs without args |
| `keyvault check <input>` | Check credentials or vault entries for issues |
| `keyvault convert <input>` | Convert vault data between formats |
| `keyvault analyze <input>` | Analyze vault entries for patterns or weaknesses |
| `keyvault generate <input>` | Generate new keys, passwords, or credentials |
| `keyvault preview <input>` | Preview a vault operation before executing |
| `keyvault batch <input>` | Batch process multiple vault operations |
| `keyvault compare <input>` | Compare two vault entries or credential sets |
| `keyvault export <input>` | Export vault data (also supports format-based export below) |
| `keyvault config <input>` | View or update vault configuration |
| `keyvault status <input>` | Check vault status; view recent status entries |
| `keyvault report <input>` | Generate a report on vault contents or activity |
| `keyvault stats` | Show summary statistics across all actions |
| `keyvault export <fmt>` | Export all logs (formats: `json`, `csv`, `txt`) |
| `keyvault search <term>` | Search across all log entries |
| `keyvault recent` | Show the 20 most recent activity entries |
| `keyvault help` | Show help with all available commands |
| `keyvault version` | Print current version (v2.0.0) |

Each data command (run, check, convert, etc.) works in two modes:
- **With arguments** — logs the input with a timestamp and saves to its dedicated log file
- **Without arguments** — displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in `~/.local/share/keyvault/`. The directory structure:

- `run.log`, `check.log`, `convert.log`, `analyze.log`, etc. — per-command log files
- `history.log` — unified activity log across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Modify the `DATA_DIR` variable in `script.sh` to change the storage path.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- Works on Linux and macOS
- No external packages or network access required

## When to Use

1. **Generating secure credentials** — use `keyvault generate` to create strong passwords, API keys, or tokens for new services and deployments
2. **Auditing existing credentials** — run `keyvault analyze` and `keyvault check` to identify weak or outdated entries in your vault
3. **Migrating credential formats** — use `keyvault convert` and `keyvault export` to transform vault data between JSON, CSV, and text formats for different tools
4. **Batch credential rotation** — use `keyvault batch` to process multiple credential updates in one operation, then `keyvault compare` to verify changes
5. **Tracking vault activity** — use `keyvault stats`, `keyvault recent`, and `keyvault report` to maintain a full audit trail of all vault operations

## Examples

```bash
# Generate a new credential entry
keyvault generate "api-key-production"

# Check a credential for issues
keyvault check "db-password-staging"

# Analyze vault entries for weaknesses
keyvault analyze "all-passwords"

# Batch process multiple operations
keyvault batch "rotate api-key-1 api-key-2 api-key-3"

# Compare two credential entries
keyvault compare "old-key vs new-key"

# View summary statistics
keyvault stats

# Export all history as JSON
keyvault export json

# Search for entries related to a service
keyvault search "production"

# View recent activity
keyvault recent

# Check vault health
keyvault status
```

## Output

All commands output structured text to stdout. You can redirect output to a file:

```bash
keyvault report vault-audit > audit.txt
keyvault export csv
```

## Configuration

The data directory defaults to `~/.local/share/keyvault/`. Use `keyvault config` to view or update settings, or modify the `DATA_DIR` variable at the top of `script.sh`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
