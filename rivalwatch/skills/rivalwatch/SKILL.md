---
version: "1.0.0"
name: Competitor Analysis
description: "Generate competitor analysis with SWOT and market positioning. Use when comparing features, checking market share, analyzing differentiation strategies."
---

# Rivalwatch

Rivalwatch v2.0.0 is a utility toolkit for tracking, analyzing, and managing competitive intelligence data. It provides a thorough CLI with timestamped logging, multi-format data export, and full activity history tracking for competitor analysis workflows.

## Commands

All commands accept optional `<input>` arguments. When called without arguments, they display the 20 most recent entries from their respective logs. When called with input, they record a new timestamped entry.

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `rivalwatch run [input]` | Run a competitive analysis task and log the result |
| `check` | `rivalwatch check [input]` | Check a competitor's status or validate data |
| `convert` | `rivalwatch convert [input]` | Convert competitive data between formats |
| `analyze` | `rivalwatch analyze [input]` | Analyze competitive positioning or market data |
| `generate` | `rivalwatch generate [input]` | Generate competitive intelligence reports |
| `preview` | `rivalwatch preview [input]` | Preview analysis output before finalizing |
| `batch` | `rivalwatch batch [input]` | Process multiple competitors in batch mode |
| `compare` | `rivalwatch compare [input]` | Compare two or more competitors side by side |
| `export` | `rivalwatch export [input]` | Log an export operation |
| `config` | `rivalwatch config [input]` | Manage analysis configuration settings |
| `status` | `rivalwatch status [input]` | Log or view status entries |
| `report` | `rivalwatch report [input]` | Generate or log competitive reports |

### Utility Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `stats` | `rivalwatch stats` | Show summary statistics across all log files |
| `export <fmt>` | `rivalwatch export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `search <term>` | `rivalwatch search <term>` | Search across all log entries (case-insensitive) |
| `recent` | `rivalwatch recent` | Show the 20 most recent activity entries |
| `status` | `rivalwatch status` | Health check — version, data dir, entry count, disk usage |
| `help` | `rivalwatch help` | Show full command reference |
| `version` | `rivalwatch version` | Print version string (`rivalwatch v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/rivalwatch/`:

- **`history.log`** — Master activity log with timestamps for every operation
- **`run.log`**, **`check.log`**, **`analyze.log`**, etc. — Per-command log files storing `timestamp|input` entries
- **`export.json`**, **`export.csv`**, **`export.txt`** — Generated export files

Each entry is stored in pipe-delimited format: `YYYY-MM-DD HH:MM|value`. The data directory is created automatically on first use.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`, `local` variables)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`
- No external dependencies, API keys, or network access required
- Works on Linux, macOS, and WSL

## When to Use

1. **Tracking competitor product changes** — Use `run` and `check` to log competitor updates, feature launches, or pricing changes over time
2. **Comparing market positioning** — Use `compare` to track how two or more competitors position themselves on features, pricing, or messaging
3. **Generating SWOT-style analysis** — Use `analyze` followed by `report` to build structured competitive intelligence documents
4. **Batch monitoring multiple competitors** — Use `batch` to queue and process data on several competitors in a single pass
5. **Exporting competitive data for presentations** — Use `export json` or `export csv` to produce structured data for dashboards or stakeholder reports

## Examples

```bash
# Log a competitor product update
rivalwatch run "Competitor X launched feature Y at $29/mo"

# Check competitor pricing
rivalwatch check "Competitor Z pricing page updated"

# Analyze market positioning
rivalwatch analyze "SaaS CRM market Q1 2025"

# Compare two competitors
rivalwatch compare "Slack vs Teams - enterprise features"

# Batch process multiple competitor entries
rivalwatch batch "CompA launch" "CompB pivot" "CompC funding"

# Export all competitive intel as JSON
rivalwatch export json

# Search for past entries mentioning a competitor
rivalwatch search "Competitor X"

# View summary statistics
rivalwatch stats
```

## Output

All commands output structured text to stdout. Use standard shell redirection to capture output:

```bash
rivalwatch stats > summary.txt
rivalwatch export json  # writes to ~/.local/share/rivalwatch/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
