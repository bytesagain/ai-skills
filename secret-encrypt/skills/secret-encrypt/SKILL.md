---
version: "1.0.0"
name: Sops
description: "Encrypt, rotate, and manage application secrets securely. Use when scanning exposed credentials, monitoring expiry, reporting access, alerting on violations."
---

# Secret Encrypt

Secret Encrypt v2.0.0 is a sysops toolkit for scanning, monitoring, and managing encrypted secrets across your infrastructure. It provides a thorough CLI with timestamped logging, multi-format data export, and full activity history tracking for security operations.

## Commands

All commands accept optional `<input>` arguments. When called without arguments, they display the 20 most recent entries from their respective logs. When called with input, they record a new timestamped entry.

| Command | Usage | Description |
|---------|-------|-------------|
| `scan` | `secret-encrypt scan [input]` | Scan for exposed secrets or credentials |
| `monitor` | `secret-encrypt monitor [input]` | Monitor secret rotation and expiry status |
| `report` | `secret-encrypt report [input]` | Generate or log security reports |
| `alert` | `secret-encrypt alert [input]` | Log or view security alerts and violations |
| `top` | `secret-encrypt top [input]` | Show top-level security metrics or entries |
| `usage` | `secret-encrypt usage [input]` | Track secret usage patterns and access |
| `check` | `secret-encrypt check [input]` | Check encryption status or validate secrets |
| `fix` | `secret-encrypt fix [input]` | Apply fixes for detected security issues |
| `cleanup` | `secret-encrypt cleanup [input]` | Clean up expired or orphaned secrets |
| `backup` | `secret-encrypt backup [input]` | Backup encrypted secrets and configurations |
| `restore` | `secret-encrypt restore [input]` | Restore secrets from a previous backup |
| `log` | `secret-encrypt log [input]` | View or add entries to the operations log |
| `benchmark` | `secret-encrypt benchmark [input]` | Benchmark encryption/decryption performance |
| `compare` | `secret-encrypt compare [input]` | Compare secret states across environments |

### Utility Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `stats` | `secret-encrypt stats` | Show summary statistics across all log files |
| `export <fmt>` | `secret-encrypt export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `search <term>` | `secret-encrypt search <term>` | Search across all log entries (case-insensitive) |
| `recent` | `secret-encrypt recent` | Show the 20 most recent activity entries |
| `status` | `secret-encrypt status` | Health check — version, data dir, entry count, disk usage |
| `help` | `secret-encrypt help` | Show full command reference |
| `version` | `secret-encrypt version` | Print version string (`secret-encrypt v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/secret-encrypt/`:

- **`history.log`** — Master activity log with timestamps for every operation
- **`scan.log`**, **`monitor.log`**, **`alert.log`**, etc. — Per-command log files storing `timestamp|input` entries
- **`export.json`**, **`export.csv`**, **`export.txt`** — Generated export files

Each entry is stored in pipe-delimited format: `YYYY-MM-DD HH:MM|value`. The data directory is created automatically on first use.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`, `local` variables)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`
- No external dependencies, API keys, or network access required
- Works on Linux, macOS, and WSL

## When to Use

1. **Scanning for exposed credentials** — Use `scan` to detect leaked API keys, tokens, or passwords in your codebase or environment
2. **Monitoring secret rotation schedules** — Use `monitor` to track which secrets are due for rotation and log expiry warnings
3. **Auditing secret access and usage** — Use `usage` and `report` to produce structured audit trails for compliance reviews
4. **Backing up and restoring secrets** — Use `backup` and `restore` to safely archive encrypted secrets before infrastructure changes
5. **Benchmarking encryption performance** — Use `benchmark` to measure and compare encryption/decryption speeds across different configurations

## Examples

```bash
# Scan a project for exposed secrets
secret-encrypt scan /path/to/project

# Monitor secret rotation status
secret-encrypt monitor "API keys expiring in 7 days"

# Log a security alert
secret-encrypt alert "Exposed token found in public repo"

# Check encryption status
secret-encrypt check production-secrets.enc

# Backup current secrets
secret-encrypt backup "pre-migration snapshot"

# Restore from backup
secret-encrypt restore "pre-migration snapshot"

# Benchmark encryption performance
secret-encrypt benchmark "AES-256 vs ChaCha20"

# Clean up expired secrets
secret-encrypt cleanup "remove tokens older than 90 days"

# Export all history as JSON
secret-encrypt export json

# Search for past scan results
secret-encrypt search "API key"

# View summary statistics
secret-encrypt stats
```

## Output

All commands output structured text to stdout. Use standard shell redirection to capture output:

```bash
secret-encrypt stats > summary.txt
secret-encrypt export json  # writes to ~/.local/share/secret-encrypt/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
