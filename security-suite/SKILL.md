---
version: "1.0.0"
name: Fsociety
description: "security-suite Hacking Tools Pack – A Penetration Testing Framework security-suite, python, brute-force-attacks, desktop, exploitation, finder."
---

# Security Suite

A utility toolkit for managing security suite operations from the terminal. Run checks, analyze findings, generate reports, and manage configuration — all with timestamped logging and export support.

## Commands

| Command | Description |
|---------|-------------|
| `security-suite run <input>` | Run a security task (or view recent runs with no args) |
| `security-suite check <input>` | Perform a security check and log the result |
| `security-suite convert <input>` | Convert data between formats or representations |
| `security-suite analyze <input>` | Analyze security findings or data |
| `security-suite generate <input>` | Generate security artifacts (keys, configs, etc.) |
| `security-suite preview <input>` | Preview a security operation before executing |
| `security-suite batch <input>` | Batch-process multiple security operations |
| `security-suite compare <input>` | Compare two security states or configurations |
| `security-suite export <input>` | Log an export operation (or view recent exports) |
| `security-suite config <input>` | Store or review configuration settings |
| `security-suite status <input>` | Log a status update (or view recent status entries) |
| `security-suite report <input>` | Generate or log a security report |
| `security-suite stats` | Show summary statistics across all categories |
| `security-suite export <fmt>` | Export all data (formats: json, csv, txt) |
| `security-suite search <term>` | Search across all logged entries |
| `security-suite recent` | Show the 20 most recent activity log entries |
| `security-suite status` | Health check — version, data dir, entry count, disk usage |
| `security-suite help` | Show full usage information |
| `security-suite version` | Show version (v2.0.0) |

Each action command works in two modes:
- **With arguments:** saves the input with a timestamp to `<command>.log` and logs to history
- **Without arguments:** displays the 20 most recent entries for that command

## Data Storage

All data is stored locally in `~/.local/share/security-suite/`. Each command writes to its own dedicated log file (e.g., `run.log`, `check.log`, `analyze.log`). A unified `history.log` tracks all activity with timestamps. Data never leaves your machine.

Directory structure:
```
~/.local/share/security-suite/
├── run.log
├── check.log
├── convert.log
├── analyze.log
├── generate.log
├── preview.log
├── batch.log
├── compare.log
├── export.log
├── config.log
├── status.log
├── report.log
└── history.log
```

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Running security checks on infrastructure** — use `run`, `check`, and `analyze` to log and track the results of security scans, vulnerability assessments, and penetration tests
2. **Generating security reports for stakeholders** — use `report` and `export` to compile findings and export them in JSON, CSV, or plain text for sharing
3. **Comparing security configurations across environments** — use `compare` and `config` to document differences between staging and production security settings
4. **Batch-processing multiple security operations** — use `batch` to log and track bulk security tasks like rotating credentials or scanning multiple hosts
5. **Previewing destructive security operations** — use `preview` before executing sensitive changes to document what will happen, then `run` when ready

## Examples

```bash
# Run a security scan and log the result
security-suite run "Nmap scan of 192.168.1.0/24 — 14 hosts found"

# Log a security check finding
security-suite check "SSH root login disabled on web-01, web-02, web-03"

# Analyze a vulnerability report
security-suite analyze "CVE-2024-1234 affects nginx < 1.25.4 — patched on 3 servers"

# Export all logged data as CSV
security-suite export csv

# Search for all entries related to SSH
security-suite search ssh
```

## Configuration

Set the `SECURITY_SUITE_DIR` environment variable to change the data directory. Default: `~/.local/share/security-suite/`

## Output

All commands output results to stdout. Redirect to a file with `> output.txt` if needed. The `export` command writes directly to `~/.local/share/security-suite/export.<fmt>`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
