---
name: It Tools
description: "Access handy dev utilities for encoding, hashing, formatting, and converting. Use when encoding Base64, generating UUIDs, formatting JSON, or converting."
version: "1.0.0"
license: GPL-3.0
runtime: python3
---
# It Tools

It Tools v2.0.0 — a utility toolkit for logging, tracking, and managing developer tool operations from the command line. Organize your encoding, hashing, formatting, and conversion tasks with full history and search.

Each command accepts free-text input. When called without arguments it displays recent entries; when called with input it logs the entry with a timestamp for future reference.

## Commands

| Command | Description |
|---------|-------------|
| `it-tools run <input>` | Log a general run entry (e.g. execute a utility operation) |
| `it-tools check <input>` | Log a check entry (e.g. verify a hash, validate an encoding) |
| `it-tools convert <input>` | Log a conversion entry (e.g. Base64 encode/decode, hex conversion) |
| `it-tools analyze <input>` | Log an analysis entry (e.g. analyze a JWT, inspect a certificate) |
| `it-tools generate <input>` | Log a generation entry (e.g. generate UUID, create random string) |
| `it-tools preview <input>` | Log a preview entry (e.g. preview formatted JSON, check output) |
| `it-tools batch <input>` | Log a batch entry (e.g. process multiple files at once) |
| `it-tools compare <input>` | Log a comparison entry (e.g. compare hashes, diff two outputs) |
| `it-tools export <input>` | Log an export entry (e.g. export results for sharing) |
| `it-tools config <input>` | Log a config entry (e.g. set default encoding, adjust preferences) |
| `it-tools status <input>` | Log a status entry (e.g. track current operation state) |
| `it-tools report <input>` | Log a report entry (e.g. summarize batch results) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `it-tools stats` | Show summary statistics across all entry types |
| `it-tools export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `it-tools search <term>` | Search all entries for a keyword (case-insensitive) |
| `it-tools recent` | Show the 20 most recent activity log entries |
| `it-tools status` | Health check — version, data dir, entry count, disk usage |
| `it-tools help` | Show the built-in help message |
| `it-tools version` | Print version string (`it-tools v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/it-tools/`. Each command writes to its own log file (e.g. `run.log`, `check.log`, `convert.log`). A unified `history.log` tracks all activity with timestamps. Exports are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Tracking encoding and conversion tasks** — use `convert` to log Base64, hex, or URL encoding operations, then `search` to find previous conversions quickly.
2. **Generating and cataloging unique identifiers** — use `generate` to log UUIDs, random strings, or hash values, building a searchable reference library.
3. **Auditing and verifying data integrity** — use `check` to log hash verifications and validation results, `analyze` to inspect JWTs or certificates, and `report` to summarize findings.
4. **Batch processing developer operations** — use `batch` to log multi-file or multi-operation runs, then `stats` to see how many tasks you've processed across all categories.
5. **Building a personal dev-tool knowledge base** — log every tool operation you perform, then use `export json` or `export csv` to create a searchable archive of your encoding/hashing/formatting history.

## Examples

```bash
# Log a Base64 conversion
it-tools convert "Encoded API key to Base64 for config file"

# Generate and log a UUID
it-tools generate "UUID v4 for new microservice: 550e8400-e29b-41d4-a716-446655440000"

# Check a file hash
it-tools check "SHA256 of release.tar.gz matches expected: a3f2b8c..."

# Analyze a JWT token
it-tools analyze "JWT from auth service — expired 2h ago, issuer=auth.example.com"

# Batch process multiple files
it-tools batch "Converted 15 CSV files to JSON format for import"

# Search for all Base64-related entries
it-tools search "base64"

# View summary statistics
it-tools stats

# Export everything to CSV
it-tools export csv
```

## How It Works

It Tools is a lightweight Bash script that stores timestamped entries in plain-text log files. Each command follows the same pattern:

- **No arguments** → display the 20 most recent entries from that command's log
- **With arguments** → append a timestamped entry to the log and confirm the save

The `stats` command aggregates line counts across all `.log` files. The `export` command serializes all logs into your chosen format. The `search` command greps case-insensitively across every log file in the data directory.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
