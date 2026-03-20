---
name: "Terms"
description: "Store, rotate, and audit API keys and tokens securely. Use when generating keys, checking strength, rotating tokens, auditing credentials."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["terms", "tool", "terminal", "cli", "utility"]
---

# Terms

Terms v2.0.0 — a security toolkit for managing API keys, tokens, and credentials from the command line. Generate, store, rotate, audit, and revoke secrets — all logged locally with timestamps for full accountability.

## Why Terms?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Timestamped logging for every credential operation
- Export to JSON, CSV, or plain text for compliance evidence
- Automatic history and activity tracking
- Searchable records across all security operations

## Getting Started

```bash
# See all available commands
terms help

# Check current health status
terms status

# View summary statistics
terms stats
```

## Commands

### Security Operations Commands

Each command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `terms generate <input>` | Record key/token generation events (API keys created, tokens issued) |
| `terms check-strength <input>` | Log strength assessments (password entropy, key length validation) |
| `terms rotate <input>` | Record rotation events (scheduled rotations, emergency rotations) |
| `terms audit <input>` | Log audit results (access reviews, usage audits, compliance checks) |
| `terms store <input>` | Record storage events (vault entries, secure storage operations) |
| `terms retrieve <input>` | Log retrieval events (key lookups, secret access, credential fetches) |
| `terms expire <input>` | Record expiration events (expired tokens, cert expirations, TTL resets) |
| `terms policy <input>` | Log policy operations (policy creation, enforcement rules, rotation schedules) |
| `terms report <input>` | Create report entries (compliance reports, audit summaries, risk findings) |
| `terms hash <input>` | Record hashing operations (password hashing, integrity checks, checksums) |
| `terms verify <input>` | Log verification events (signature checks, token validation, cert verification) |
| `terms revoke <input>` | Record revocation events (compromised keys, decommissioned tokens) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `terms stats` | Show summary statistics across all log categories |
| `terms export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `terms search <term>` | Search across all entries for a keyword |
| `terms recent` | Show the 20 most recent history entries |
| `terms status` | Health check — version, data dir, entry count, disk usage |
| `terms help` | Show the built-in help message |
| `terms version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/terms/`. Structure:

- **`generate.log`**, **`rotate.log`**, **`audit.log`**, etc. — one log file per command, pipe-delimited (`timestamp|value`)
- **`history.log`** — unified activity log across all commands
- **`export.json`** / **`export.csv`** / **`export.txt`** — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<input>`. Use `export` to back up your data anytime.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies or internet access needed

## When to Use

1. **Credential lifecycle management** — Track every API key from generation through rotation to revocation, maintaining a complete chain of custody
2. **Compliance auditing** — Use `audit` and `report` to document credential reviews and produce evidence for SOC 2, ISO 27001, or PCI DSS audits
3. **Incident response** — When a key is compromised, log the `revoke` action, then `search` to find all related operations and assess blast radius
4. **Rotation tracking** — Record every `rotate` event with the old/new key identifiers so you know exactly when credentials changed and why
5. **Policy enforcement** — Use `policy` to document rotation schedules and strength requirements, then `check-strength` to verify compliance

## Examples

```bash
# Record generating a new API key
terms generate "Created prod API key for payment-service, expires 2025-06-01"

# Check and log key strength
terms check-strength "payment-service key: 256-bit, AES — STRONG"

# Record a rotation event
terms rotate "Rotated DB password for analytics-ro user, old key revoked"

# Log an audit finding
terms audit "Q1 review: 3 keys older than 90 days found, rotation scheduled"

# Record a revocation
terms revoke "Emergency revoke: staging key leaked in public repo, rotated immediately"

# Export audit trail to JSON
terms export json

# Search for a specific service
terms search "payment-service"
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
terms stats > credential-summary.txt
terms export csv
```

## Configuration

Set `TERMS_DIR` environment variable to override the default data directory (`~/.local/share/terms/`).

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
