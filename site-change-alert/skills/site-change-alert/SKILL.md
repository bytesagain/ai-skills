---
version: "1.0.0"
name: Changedetectionio
description: "Best and simplest tool for website change detection, web page monitoring, and website change alerts. site-change-alert, python, back-in-stock, change-alert."
---

# Site Change Alert

Website change detection and monitoring toolkit. Track content changes, log alerts, compare snapshots, and generate reports — all from the command line.

## Commands

Run `site-change-alert <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `run <input>` | Run a change detection check and log the result |
| `check <input>` | Check a specific URL or target for changes |
| `convert <input>` | Convert logged data between formats |
| `analyze <input>` | Analyze change patterns and frequency |
| `generate <input>` | Generate alert rules or templates |
| `preview <input>` | Preview a change detection configuration |
| `batch <input>` | Batch process multiple URLs or targets at once |
| `compare <input>` | Compare two snapshots or change records |
| `export <input>` | Export logged data (also supports `export <fmt>` for json/csv/txt) |
| `config <input>` | Save or view configuration entries |
| `status <input>` | Log status entries (also runs health check with no args via utility) |
| `report <input>` | Generate or log change reports |
| `stats` | Show summary statistics across all log files |
| `search <term>` | Search all entries for a keyword |
| `recent` | Show the 20 most recent history entries |
| `help` | Show help message |
| `version` | Show version (v2.0.0) |

Each data command (run, check, convert, analyze, generate, preview, batch, compare, export, config, status, report) works in two modes:
- **Without arguments** — displays the 20 most recent entries from its log
- **With arguments** — saves the input with a timestamp to its dedicated log file

## Data Storage

All data is stored in `~/.local/share/site-change-alert/`:

- `run.log`, `check.log`, `convert.log`, `analyze.log`, `generate.log`, `preview.log` — per-command log files
- `batch.log`, `compare.log`, `export.log`, `config.log`, `status.log`, `report.log` — additional command logs
- `history.log` — unified activity history across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Set `SITE_CHANGE_ALERT_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4+ with standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `sed`)
- No external dependencies — pure shell implementation

## When to Use

1. **Monitoring website content** — track when a page's text, price, or stock status changes
2. **Logging change detection results** — keep a timestamped history of checks and their outcomes
3. **Batch URL monitoring** — process multiple targets in one run for efficiency
4. **Comparing snapshots** — compare before/after states of web content
5. **Generating change reports** — produce reports summarizing detected changes over time

## Examples

```bash
# Run a change detection check on a URL
site-change-alert run "https://example.com/products checked - no change"

# Check and log a specific target
site-change-alert check "https://shop.example.com/item-42 price=$19.99"

# Batch process multiple URLs
site-change-alert batch "group=electronics urls=15 changes_found=3"

# Compare two snapshots
site-change-alert compare "page_v1 vs page_v2: 12 differences found"

# Export all data as CSV
site-change-alert export csv

# Search for entries mentioning a domain
site-change-alert search "example.com"

# View recent activity across all commands
site-change-alert recent

# Show statistics
site-change-alert stats
```

## Output

All commands output results to stdout. Log entries are stored with timestamps in pipe-delimited format (`YYYY-MM-DD HH:MM|value`). Use `export` to convert all data to JSON, CSV, or plain text.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
