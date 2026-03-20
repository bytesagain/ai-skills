---
version: "1.0.0"
name: Goreplay
description: "GoReplay is an open-source tool for capturing and replaying live HTTP traffic into a test environmen traffic-replay, go, devops, go, qa, testing."
---

# Traffic Replay

Traffic Replay v2.0.0 — a utility toolkit for logging, tracking, and managing HTTP traffic replay operations from the command line. All data is stored locally in flat log files with timestamps, making it easy to review history, export records, and search across entries.

## Commands

Run `scripts/script.sh <command> [args]` to use.

### Core Operations

| Command | Description |
|---------|-------------|
| `run <input>` | Log a run entry (e.g. execute a traffic replay session, start capture) |
| `check <input>` | Log a check entry (e.g. verify replay fidelity, validate response diffs) |
| `convert <input>` | Log a convert entry (e.g. convert pcap to HAR, transform traffic formats) |
| `analyze <input>` | Log an analyze entry (e.g. analyze response times, compare prod vs staging) |
| `generate <input>` | Log a generate entry (e.g. generate synthetic traffic, create test payloads) |
| `preview <input>` | Log a preview entry (e.g. preview replay plan, dry-run before execution) |
| `batch <input>` | Log a batch entry (e.g. batch replay sessions, bulk traffic processing) |
| `compare <input>` | Log a compare entry (e.g. compare responses across environments) |
| `export <input>` | Log an export entry (e.g. export captured traffic, save replay results) |
| `config <input>` | Log a config entry (e.g. configure replay targets, set rate limits) |
| `status <input>` | Log a status entry (e.g. replay session status, capture health) |
| `report <input>` | Log a report entry (e.g. replay summary reports, diff analysis results) |

Each command without arguments shows the 20 most recent entries for that category.

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Summary statistics across all log categories with entry counts and disk usage |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `search <term>` | Search across all log files for a keyword (case-insensitive) |
| `recent` | Show the 20 most recent entries from the global activity history |
| `status` | Health check — version, data directory, total entries, disk usage, last activity |
| `help` | Show full usage information |
| `version` | Show version string (`traffic-replay v2.0.0`) |

## Data Storage

All data is persisted locally under `~/.local/share/traffic-replay/`:

- **`<command>.log`** — One log file per command (e.g. `run.log`, `check.log`, `analyze.log`)
- **`history.log`** — Global activity log with timestamps for every operation
- **`export.<fmt>`** — Generated export files (json/csv/txt)

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited). No external services, no API keys, no network calls — everything stays on your machine.

Set `TRAFFIC_REPLAY_DIR` environment variable to change the data directory. Default: `~/.local/share/traffic-replay/`.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `cat`, `sed`, `basename`
- No external dependencies or packages required
- No API keys or accounts needed

## When to Use

1. **Recording traffic replay sessions** — Use `run` to log each replay execution, building a searchable history of what was replayed, when, and against which environment
2. **Validating deployments** — Use `check` and `compare` to record response diffs between production and staging, tracking regressions before they reach users
3. **Converting traffic formats** — Use `convert` to log format transformations (pcap → HAR, curl → replay format) so you can trace the data pipeline
4. **Generating test traffic** — Use `generate` and `batch` to log synthetic traffic creation sessions, then `preview` to dry-run before hitting target environments
5. **Reporting on replay results** — Use `report` to log summary findings, then `export json` to pull structured data for CI/CD dashboards or QA reviews

## Examples

```bash
# Log a replay session
traffic-replay run "Replayed 10K requests from prod to staging — 99.7% match rate"

# Check response diffs
traffic-replay check "3 endpoints with response diffs: /api/users (200→500), /api/orders (field mismatch), /health (timeout)"

# Convert traffic format
traffic-replay convert "Converted 2h pcap capture to HAR — 45K requests extracted"

# Analyze replay performance
traffic-replay analyze "Staging p99 latency: 230ms vs prod 180ms — 28% regression on /api/search"

# Compare environments
traffic-replay compare "Prod vs staging: 142/145 endpoints match, 3 diffs logged"

# Search for all entries mentioning an endpoint
traffic-replay search "/api/users"

# Export everything to CSV
traffic-replay export csv

# View summary statistics
traffic-replay stats
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
