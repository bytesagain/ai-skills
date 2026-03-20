---
version: "1.0.0"
name: Web Check
description: "Analyze websites with OSINT reconnaissance and security scanning. Use when inspecting headers, checking DNS, analyzing SSL certs, generating reports."
---

# Site Inspector

Website analysis and OSINT reconnaissance toolkit. Inspect sites, log security checks, analyze results, and generate reports — all from the command line.

## Commands

Run `site-inspector <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `run <input>` | Run a site inspection and log the result |
| `check <input>` | Check a specific URL or endpoint |
| `convert <input>` | Convert inspection data between formats |
| `analyze <input>` | Analyze site security or performance patterns |
| `generate <input>` | Generate inspection templates or configs |
| `preview <input>` | Preview an inspection configuration before running |
| `batch <input>` | Batch process multiple sites at once |
| `compare <input>` | Compare inspection results between sites or runs |
| `export <input>` | Export logged data (also supports `export <fmt>` for json/csv/txt) |
| `config <input>` | Save or view configuration entries |
| `status <input>` | Log status entries (also runs health check with no args via utility) |
| `report <input>` | Generate or log inspection reports |
| `stats` | Show summary statistics across all log files |
| `search <term>` | Search all entries for a keyword |
| `recent` | Show the 20 most recent history entries |
| `help` | Show help message |
| `version` | Show version (v2.0.0) |

Each data command (run, check, convert, analyze, generate, preview, batch, compare, export, config, status, report) works in two modes:
- **Without arguments** — displays the 20 most recent entries from its log
- **With arguments** — saves the input with a timestamp to its dedicated log file

## Data Storage

All data is stored in `~/.local/share/site-inspector/`:

- `run.log`, `check.log`, `convert.log`, `analyze.log`, `generate.log`, `preview.log` — per-command log files
- `batch.log`, `compare.log`, `export.log`, `config.log`, `status.log`, `report.log` — additional command logs
- `history.log` — unified activity history across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Set `SITE_INSPECTOR_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4+ with standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `sed`)
- No external dependencies — pure shell implementation

## When to Use

1. **Website security audits** — log and track OSINT reconnaissance findings for target sites
2. **DNS and header inspection** — record DNS records, HTTP headers, and SSL certificate details
3. **Batch site analysis** — process multiple domains or endpoints in one run
4. **Comparing site configurations** — compare inspection results across different sites or time periods
5. **Generating security reports** — produce structured reports from accumulated inspection data

## Examples

```bash
# Run an inspection on a domain
site-inspector run "example.com headers=OK ssl=valid dns=resolved"

# Check a specific endpoint
site-inspector check "https://api.example.com/health status=200 latency=42ms"

# Analyze logged patterns
site-inspector analyze "ssl_expiry_trend: 3 certs expiring within 30 days"

# Batch inspect multiple sites
site-inspector batch "domains=25 scanned=25 issues_found=3"

# Compare two inspection runs
site-inspector compare "example.com run1 vs run2: headers changed, ssl renewed"

# Generate a report entry
site-inspector report "Weekly security audit - 15 domains - all clear"

# Export all data as JSON
site-inspector export json

# Search for entries about a specific domain
site-inspector search "api.example.com"

# View recent activity
site-inspector recent

# Show statistics
site-inspector stats
```

## Output

All commands output results to stdout. Log entries are stored with timestamps in pipe-delimited format (`YYYY-MM-DD HH:MM|value`). Use `export` to convert all data to JSON, CSV, or plain text.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
