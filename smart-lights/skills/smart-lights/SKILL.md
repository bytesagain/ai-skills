---
version: "1.0.0"
name: smart-lights
description: "Control Philips Hue lights with colors, effects, and schedules. Use when setting scenes, running effects, checking bulbs, analyzing energy, generating presets."
---

# Smart Lights

Smart Lights v2.0.0 — a general-purpose utility toolkit for logging, tracking, and managing data entries from the command line. Each command records timestamped entries into its own log file and supports review of recent history.

## Commands

The script (`scripts/script.sh`) exposes the following commands via a `case` dispatcher:

| Command | Description |
|---------|-------------|
| `run <input>` | Record a "run" entry. Without args, shows the 20 most recent run entries. |
| `check <input>` | Record a "check" entry. Without args, lists recent check entries. |
| `convert <input>` | Record a "convert" entry. Without args, lists recent convert entries. |
| `analyze <input>` | Record an "analyze" entry. Without args, lists recent analyze entries. |
| `generate <input>` | Record a "generate" entry. Without args, lists recent generate entries. |
| `preview <input>` | Record a "preview" entry. Without args, lists recent preview entries. |
| `batch <input>` | Record a "batch" entry. Without args, lists recent batch entries. |
| `compare <input>` | Record a "compare" entry. Without args, lists recent compare entries. |
| `export <input>` | Record an "export" entry. Without args, lists recent export entries. |
| `config <input>` | Record a "config" entry. Without args, lists recent config entries. |
| `status <input>` | Record a "status" entry. Without args, lists recent status entries. |
| `report <input>` | Record a "report" entry. Without args, lists recent report entries. |
| `stats` | Show summary statistics across all log files (entry counts per type, total, disk usage). |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format to `$DATA_DIR/export.<fmt>`. |
| `search <term>` | Search all log files for a term (case-insensitive grep). |
| `recent` | Show the 20 most recent lines from `history.log`. |
| `status` | Health check — shows version, data directory, total entries, disk usage, last activity. |
| `help` | Display the full help/usage message. |
| `version` | Print `smart-lights v2.0.0`. |

> **Note:** The `export` and `status` commands appear twice in the case statement. The first match (entry-logging form) takes precedence. The standalone `_export` and `_status` helper functions are reachable only if the entry-logging branches are bypassed.

## How Each Entry Command Works

1. If called **without arguments**, it tails the last 20 lines of `<command>.log`.
2. If called **with arguments**, it:
   - Timestamps the input (`YYYY-MM-DD HH:MM|<input>`)
   - Appends it to `$DATA_DIR/<command>.log`
   - Prints confirmation with the current total count
   - Logs the action to `history.log`

## Data Storage

All data is stored as plain-text log files under:

```
~/.local/share/smart-lights/
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
└── history.log          # unified activity log
```

Each log line uses pipe-delimited format: `YYYY-MM-DD HH:MM|<value>`

The `history.log` uses: `MM-DD HH:MM <command>: <value>`

## Requirements

- **Bash** 4.0+ (uses `local` variables, `set -euo pipefail`)
- **coreutils**: `date`, `wc`, `du`, `tail`, `cat`, `basename`, `grep`, `sed`
- No external dependencies, API keys, or network access required
- Works on Linux and macOS

## When to Use

1. **Quick data logging** — when you need a lightweight CLI to record timestamped entries without setting up a database
2. **Activity tracking** — log daily tasks, checks, or observations and review them later with `recent` or `search`
3. **Batch operations** — record batch job inputs/outputs for auditing purposes
4. **Data export** — when you need to pull all logged entries into JSON, CSV, or TXT for reporting or integration with other tools
5. **Health monitoring** — use `stats` and `status` to get a quick overview of how much data has been collected and disk usage

## Examples

### Log a run entry and review history

```bash
# Record something
bash scripts/script.sh run "deployed v1.2.3 to staging"

# Check recent runs
bash scripts/script.sh run
```

### Search across all logs

```bash
bash scripts/script.sh search "deploy"
```

### Export everything as CSV

```bash
bash scripts/script.sh export csv
# Output: ~/.local/share/smart-lights/export.csv
```

### View summary statistics

```bash
bash scripts/script.sh stats
# Shows per-type counts, totals, and disk usage
```

### Quick health check

```bash
bash scripts/script.sh status
# Shows version, entry count, disk, last activity
```

## Configuration

Set the `DATA_DIR` variable (or modify it in the script) to change the storage directory. Default: `~/.local/share/smart-lights/`

## Output

All commands print to stdout. Redirect to a file as needed:

```bash
bash scripts/script.sh stats > summary.txt
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
