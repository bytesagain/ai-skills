---
name: "License"
description: "Manage software license keys with generation, rotation, and audit tracking. Use when generating keys, auditing licenses, rotating expired credentials."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["protection", "compliance", "license", "audit", "privacy"]
---

# License

A command-line security toolkit for managing software licenses. Generate, check strength, rotate, audit, store, retrieve, expire, set policies, report, hash, verify, and revoke license keys — all from your terminal with persistent logging and full activity history.

## Why License?

- Works entirely offline — your license data never leaves your machine
- No external dependencies or accounts needed
- Every action is timestamped and logged for full auditability
- Export your history to JSON, CSV, or plain text anytime
- Simple CLI interface with consistent command patterns

## Commands

| Command | Description |
|---------|-------------|
| `license generate <input>` | Generate a new license key or credential |
| `license check-strength <input>` | Check the strength of a license key or password |
| `license rotate <input>` | Rotate an existing license key to a new one |
| `license audit <input>` | Audit license entries for compliance or issues |
| `license store <input>` | Store a license key securely in the vault |
| `license retrieve <input>` | Retrieve a stored license key by identifier |
| `license expire <input>` | Mark a license key as expired |
| `license policy <input>` | View or set license policies and rules |
| `license report <input>` | Generate a report on license activity or status |
| `license hash <input>` | Hash a license key for secure comparison |
| `license verify <input>` | Verify a license key's validity or signature |
| `license revoke <input>` | Revoke an active license key |
| `license stats` | Show summary statistics across all actions |
| `license export <fmt>` | Export all logs (formats: `json`, `csv`, `txt`) |
| `license search <term>` | Search across all log entries |
| `license recent` | Show the 20 most recent activity entries |
| `license status` | Health check — version, disk usage, entry count |
| `license help` | Show help with all available commands |
| `license version` | Print current version (v2.0.0) |

Each data command (generate, check-strength, rotate, etc.) works in two modes:
- **With arguments** — logs the input with a timestamp and saves to its dedicated log file
- **Without arguments** — displays the 20 most recent entries from that command's log

## Getting Started

```bash
# See all available commands
license help

# Check current system status
license status

# View statistics across all commands
license stats
```

## Data Storage

All data is stored locally in `~/.local/share/license/`. The directory structure:

- `generate.log`, `check-strength.log`, `rotate.log`, `audit.log`, etc. — per-command log files
- `history.log` — unified activity log across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Modify the `DATA_DIR` variable in `script.sh` to change the storage path.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- Works on Linux and macOS
- No external packages or network access required

## When to Use

1. **Generating new license keys** — use `license generate` to create secure, unique license keys for software distribution or internal tools
2. **Rotating expired credentials** — run `license rotate` to replace old keys with fresh ones, then `license expire` to mark the originals as invalid
3. **Auditing license compliance** — use `license audit` and `license report` to review all active licenses and identify keys that need attention
4. **Verifying key authenticity** — run `license verify` and `license hash` to confirm a key hasn't been tampered with or forged
5. **Tracking license lifecycle** — use `license stats`, `license recent`, and `license export` to maintain a full audit trail from generation through revocation

## Examples

```bash
# Generate a new license key
license generate "enterprise-plan-client-42"

# Check the strength of a key
license check-strength "ABCD-1234-EFGH-5678"

# Store a license securely
license store "client-42 ABCD-1234-EFGH-5678"

# Retrieve a stored license
license retrieve "client-42"

# Rotate an existing key
license rotate "client-42"

# Audit all licenses for compliance
license audit "full-scan"

# Verify a key's validity
license verify "ABCD-1234-EFGH-5678"

# Revoke a compromised key
license revoke "ABCD-1234-EFGH-5678"

# View summary statistics
license stats

# Export all history as CSV
license export csv

# Search for entries related to a client
license search "client-42"
```

## Output

All commands output structured text to stdout. You can redirect output to a file:

```bash
license report annual-review > review.txt
license export json
```

## Configuration

The data directory defaults to `~/.local/share/license/`. Modify the `DATA_DIR` variable at the top of `script.sh` to customize the storage path.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
