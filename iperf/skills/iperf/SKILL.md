---
name: Iperf
description: "Measure TCP/UDP/SCTP bandwidth between hosts with detailed throughput data. Use when benchmarking speed, testing links, or diagnosing network bottlenecks."
version: "1.0.0"
license: NOASSERTION
runtime: python3
---
# Iperf

Iperf v2.0.0 — a devtools toolkit for logging, tracking, and managing network performance testing notes and results from the command line.

Each command accepts free-text input. When called without arguments it displays recent entries; when called with input it logs the entry with a timestamp for future reference.

## Commands

| Command | Description |
|---------|-------------|
| `iperf check <input>` | Log a check entry (e.g. verify connectivity, check port availability) |
| `iperf validate <input>` | Log a validation entry (e.g. validate test parameters, confirm config) |
| `iperf generate <input>` | Log a generation entry (e.g. generate test configs, create test plans) |
| `iperf format <input>` | Log a format entry (e.g. format test output, restructure results) |
| `iperf lint <input>` | Log a lint entry (e.g. lint config files, check for issues) |
| `iperf explain <input>` | Log an explanation entry (e.g. explain throughput numbers, annotate results) |
| `iperf convert <input>` | Log a conversion entry (e.g. convert units Mbps→MBps, transform data) |
| `iperf template <input>` | Log a template entry (e.g. save test templates for reuse) |
| `iperf diff <input>` | Log a diff entry (e.g. compare two test runs, highlight changes) |
| `iperf preview <input>` | Log a preview entry (e.g. preview test plan before execution) |
| `iperf fix <input>` | Log a fix entry (e.g. fix configuration issues, resolve errors) |
| `iperf report <input>` | Log a report entry (e.g. summarize test results, create final report) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `iperf stats` | Show summary statistics across all entry types |
| `iperf export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `iperf search <term>` | Search all entries for a keyword (case-insensitive) |
| `iperf recent` | Show the 20 most recent activity log entries |
| `iperf status` | Health check — version, data dir, entry count, disk usage |
| `iperf help` | Show the built-in help message |
| `iperf version` | Print version string (`iperf v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/iperf/`. Each command writes to its own log file (e.g. `check.log`, `validate.log`, `generate.log`). A unified `history.log` tracks all activity with timestamps. Exports are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Logging network benchmark results** — use `report` to capture throughput numbers after each iperf3 test run, then `search` to find historical results for a specific host.
2. **Validating test configurations** — use `validate` to log config checks before running bandwidth tests, and `check` to verify port/firewall readiness.
3. **Comparing performance over time** — use `diff` to log side-by-side comparisons of test runs from different dates, then `export csv` to chart trends.
4. **Creating reusable test templates** — use `template` to save common iperf3 command patterns (TCP vs UDP, window sizes, parallel streams) for quick reference.
5. **Troubleshooting network issues** — use `explain` to annotate anomalous results, `fix` to log resolution steps, and `lint` to check configuration files for common mistakes.

## Examples

```bash
# Log a bandwidth test result
iperf report "Server A → Server B: 940 Mbps TCP, 1 stream, 30s duration"

# Validate a test configuration before running
iperf validate "UDP test, 100M bandwidth, port 5201, server 10.0.1.5"

# Compare two test runs
iperf diff "Monday: 890 Mbps avg | Friday: 720 Mbps avg — possible congestion"

# Save a reusable test template
iperf template "iperf3 -c 10.0.1.5 -t 60 -P 4 -w 256K — 4-stream TCP, 60s"

# Search for all entries mentioning a specific host
iperf search "10.0.1.5"

# Export all data to JSON format
iperf export json

# View summary statistics
iperf stats

# Check overall tool health
iperf status
```

## How It Works

Iperf is a lightweight Bash script that stores timestamped entries in plain-text log files. Each command follows the same pattern:

- **No arguments** → display the 20 most recent entries from that command's log
- **With arguments** → append a timestamped entry to the log and confirm the save

The `stats` command aggregates line counts across all `.log` files. The `export` command serializes all logs into your chosen format. The `search` command greps case-insensitively across every log file in the data directory.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
