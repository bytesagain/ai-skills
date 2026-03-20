---
version: "1.0.0"
name: Ssl Cert Manager
description: "A pure Unix shell script ACME client for SSL / TLS certificate automation ssl cert manager, shell, acme, acme-challenge, acme-protocol, acme-v2."
---

# SSL Cert Manager

SSL/TLS certificate management and devtools toolkit. Check certificate status, validate configurations, generate CSRs, format cert data, lint security settings, explain certificate chains, convert between formats, and more — all from the command line.

## Commands

Run `ssl-cert-manager <command> [args]` to use. Each command records timestamped entries to its own log file.

### Core Operations

| Command | Description |
|---------|-------------|
| `check <input>` | Check a certificate's validity, expiration, or chain |
| `validate <input>` | Validate SSL/TLS configuration or certificate data |
| `generate <input>` | Generate CSRs, self-signed certs, or key pairs |
| `format <input>` | Format certificate data for display or storage |
| `lint <input>` | Lint SSL configuration for security best practices |
| `explain <input>` | Record notes explaining certificate chains or protocols |
| `convert <input>` | Convert between certificate formats (PEM ↔ DER ↔ PKCS12) |
| `template <input>` | Store or retrieve certificate configuration templates |
| `diff <input>` | Record differences between certificate versions or configs |
| `preview <input>` | Preview a certificate operation before applying |
| `fix <input>` | Log a fix applied to a certificate issue |
| `report <input>` | Record an SSL audit report or scan finding |

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
~/.local/share/ssl-cert-manager/
├── check.log          # Certificate check records
├── validate.log       # Validation results
├── generate.log       # Generated CSRs/certs
├── format.log         # Formatted certificate data
├── lint.log           # Security lint findings
├── explain.log        # Chain/protocol explanations
├── convert.log        # Format conversion records
├── template.log       # Config templates
├── diff.log           # Cert version diffs
├── preview.log        # Preview entries
├── fix.log            # Applied fix records
├── report.log         # Audit reports
└── history.log        # Unified activity log (all commands)
```

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). The `history.log` file receives a line for every command executed, providing a single timeline of all activity.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies — pure bash, works on any Linux or macOS system

## When to Use

1. **Certificate expiration monitoring** — use `check` to record cert expiry dates and set up renewal reminders
2. **SSL configuration audits** — use `lint` and `report` to document security findings across your domains
3. **Certificate format conversion** — use `convert` when switching between PEM, DER, and PKCS12 formats for different services
4. **CSR and key generation tracking** — use `generate` to log when new CSRs or self-signed certs are created
5. **Migration planning** — use `diff` and `template` to track certificate changes during infrastructure migrations

## Examples

```bash
# Check certificate expiration for a domain
ssl-cert-manager check "example.com: expires 2025-12-31, SHA-256, Let's Encrypt"

# Validate SSL configuration
ssl-cert-manager validate "nginx TLS 1.3 config — HSTS enabled, OCSP stapling on"

# Generate a CSR record
ssl-cert-manager generate "CSR for api.example.com — RSA 2048, CN=api.example.com"

# Convert certificate format
ssl-cert-manager convert "PEM -> PKCS12 for api.example.com (with chain)"

# Lint for security issues
ssl-cert-manager lint "WARNING: TLS 1.0 still enabled on legacy.example.com"

# Export all records to JSON
ssl-cert-manager export json

# Search for all entries about a specific domain
ssl-cert-manager search example.com

# View overall statistics
ssl-cert-manager stats
```

## Configuration

Set the `SSL_CERT_MANAGER_DIR` environment variable to change the data directory:

```bash
export SSL_CERT_MANAGER_DIR="/custom/path/to/data"
```

Default: `~/.local/share/ssl-cert-manager/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
