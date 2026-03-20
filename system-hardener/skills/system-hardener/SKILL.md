---
version: "1.0.0"
name: Lynis
description: "Lynis - Security auditing tool for Linux, macOS, and UNIX-based systems. Assists with compliance tes system-hardener, shell, auditing, compliance, devops."
---

# System Hardener

System Hardener v2.0.0 — a sysops toolkit for tracking and documenting system hardening activities from the command line. Record security scans, monitor compliance, log fixes, and maintain a complete audit trail of every hardening step you take.

## Why System Hardener?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Timestamped logging for every operation
- Export to JSON, CSV, or plain text for compliance evidence
- Automatic history and activity tracking
- Searchable records across all security categories

## Getting Started

```bash
# See all available commands
system-hardener help

# Check current health status
system-hardener status

# View summary statistics
system-hardener stats
```

## Commands

### Operations Commands

Each command works in two modes: run without arguments to view recent entries, or pass input to record a new entry.

| Command | Description |
|---------|-------------|
| `system-hardener scan <input>` | Record security scan results (vulnerability scans, CIS benchmarks, port audits) |
| `system-hardener monitor <input>` | Log monitoring observations (intrusion attempts, failed logins, file integrity) |
| `system-hardener report <input>` | Create report entries (compliance reports, audit summaries, risk assessments) |
| `system-hardener alert <input>` | Record alert events (security warnings, policy violations, anomaly detections) |
| `system-hardener top <input>` | Log top-level security metrics (most targeted services, top attack sources) |
| `system-hardener usage <input>` | Track usage data (firewall rule hits, SELinux denials, auth attempts) |
| `system-hardener check <input>` | Record health checks (config compliance, patch status, certificate validity) |
| `system-hardener fix <input>` | Document fixes applied (security patches, config hardening, permission fixes) |
| `system-hardener cleanup <input>` | Log cleanup operations (stale accounts, unused services, expired certs) |
| `system-hardener backup <input>` | Track backup operations (security config backups, key backups) |
| `system-hardener restore <input>` | Record restore operations (config rollbacks, key recovery) |
| `system-hardener log <input>` | General-purpose log entries (security notes, observations, research) |
| `system-hardener benchmark <input>` | Record benchmark results (CIS scores, hardening scores, before/after) |
| `system-hardener compare <input>` | Log comparison data (baseline diffs, cross-host audits, pre/post hardening) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `system-hardener stats` | Show summary statistics across all log categories |
| `system-hardener export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `system-hardener search <term>` | Search across all entries for a keyword |
| `system-hardener recent` | Show the 20 most recent history entries |
| `system-hardener status` | Health check — version, data dir, entry count, disk usage |
| `system-hardener help` | Show the built-in help message |
| `system-hardener version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/system-hardener/`. Structure:

- **`scan.log`**, **`monitor.log`**, **`report.log`**, etc. — one log file per command, pipe-delimited (`timestamp|value`)
- **`history.log`** — unified activity log across all commands
- **`export.json`** / **`export.csv`** / **`export.txt`** — generated export files

Each entry is stored as `YYYY-MM-DD HH:MM|<input>`. Use `export` to back up your data anytime.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies or internet access needed

## When to Use

1. **Compliance auditing** — Track every hardening action with timestamps to produce evidence for HIPAA, ISO 27001, or PCI DSS audits
2. **Security incident response** — During an incident, log scans, alerts, and fixes in one place to build a complete forensic timeline
3. **Baseline comparison** — Use `benchmark` and `compare` to record CIS scores before and after hardening to prove measurable improvement
4. **Change management documentation** — Log every security fix, config change, and cleanup so you have an auditable change history
5. **Multi-host hardening campaigns** — Track progress across a fleet by recording scan and check results per host, then `search` by hostname

## Examples

```bash
# Record a vulnerability scan result
system-hardener scan "CIS Level 2 scan on db-prod-01: 94% compliant, 7 findings"

# Log a security alert
system-hardener alert "3 failed SSH root login attempts from 203.0.113.42 in 5 min"

# Document a hardening fix
system-hardener fix "Disabled SSHv1, set PermitRootLogin=no on all prod hosts"

# Record a benchmark score
system-hardener benchmark "Lynis score: 78 → 91 after hardening pass on web-tier"

# Export audit trail to JSON for compliance
system-hardener export json

# Search logs for a specific host
system-hardener search "db-prod-01"

# View recent activity
system-hardener recent
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
system-hardener stats > audit-summary.txt
system-hardener export csv
```

## Configuration

Set `SYSTEM_HARDENER_DIR` environment variable to override the default data directory (`~/.local/share/system-hardener/`).

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
