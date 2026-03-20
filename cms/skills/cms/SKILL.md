---
name: cms
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [cms, tool, utility]
description: "Manage web content with page creation, media library, and templates. Use when building site pages, organizing media assets, or versioning content."
---
# CMS

Utility toolkit for content management workflows. Provides commands for running tasks, checking content, converting formats, analyzing data, generating output, previewing results, batch processing, comparing items, exporting in multiple formats (JSON/CSV/TXT), managing configuration, tracking status, generating reports, viewing statistics, searching entries, and reviewing recent activity — all from a single CLI interface with persistent local logging.

## Commands

| Command | Description |
|---------|-------------|
| `cms run [input]` | Execute the main function; without args shows recent run entries |
| `cms check [input]` | Run a check; without args shows recent check entries |
| `cms convert [input]` | Convert content; without args shows recent convert entries |
| `cms analyze [input]` | Analyze data; without args shows recent analyze entries |
| `cms generate [input]` | Generate output; without args shows recent generate entries |
| `cms preview [input]` | Preview content; without args shows recent preview entries |
| `cms batch [input]` | Batch process items; without args shows recent batch entries |
| `cms compare [input]` | Compare items; without args shows recent compare entries |
| `cms export [input]` | Export data; without args shows recent export entries |
| `cms config [input]` | Manage configuration; without args shows recent config entries |
| `cms status [input]` | Track status; without args shows recent status entries |
| `cms report [input]` | Generate reports; without args shows recent report entries |
| `cms stats` | Show summary statistics across all log files (entry counts, data size, first entry date) |
| `cms export <fmt>` | Export all data in a specific format: `json`, `csv`, or `txt` |
| `cms search <term>` | Search across all log files for a given term (case-insensitive) |
| `cms recent` | Show the 20 most recent entries from the activity history log |
| `cms help` | Show the built-in help message with all available commands |
| `cms version` | Print the current version (v2.0.0) |

Each data command (run, check, convert, analyze, generate, preview, batch, compare, export, config, status, report) operates in two modes:

- **With arguments**: logs the input with a timestamp to `<command>.log` and records it in `history.log`
- **Without arguments**: displays the 20 most recent entries from that command's log file

## Data Storage

All operational data is stored in `~/.local/share/cms/` by default. Key files inside the data directory:

- `history.log` — master timestamped log of every command executed
- `run.log`, `check.log`, `convert.log`, etc. — per-command log files storing timestamped entries in `YYYY-MM-DD HH:MM|value` format
- `export.json`, `export.csv`, `export.txt` — generated export files (created by `cms export <fmt>`)

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail` for strict error handling)
- **coreutils** (standard `date`, `mkdir`, `echo`, `wc`, `du`, `head`, `tail`, `cat`)
- **grep** (for the `search` command)
- No external dependencies or API keys required
- Works on Linux and macOS out of the box

## When to Use

1. **Logging content operations** — use `cms run`, `cms check`, `cms convert`, etc. to record timestamped entries for any content workflow, creating an audit trail of all actions taken
2. **Searching past work** — run `cms search <term>` to find specific entries across all log files when you need to recall what was done or locate a particular piece of content
3. **Exporting data for reporting** — use `cms export json` or `cms export csv` to pull all logged data into structured formats for external analysis, dashboards, or archival
4. **Reviewing activity and statistics** — run `cms stats` to get a quick summary of entry counts, data size, and operational history; use `cms recent` to see the latest 20 activities at a glance
5. **Batch processing workflows** — use `cms batch` to log batch operations, and combine with `cms compare` and `cms analyze` for multi-step content processing pipelines

## Examples

```bash
# Log a content run
cms run "Published homepage update v3"

# Check content quality
cms check "Reviewed landing page copy for typos"

# Convert a format
cms convert "Migrated blog posts from MD to HTML"

# Analyze content performance
cms analyze "Q1 traffic report for /pricing page"

# Generate output
cms generate "Monthly newsletter template"

# Preview before publishing
cms preview "Draft press release for product launch"

# Batch process multiple items
cms batch "Resized 45 product images to 800x600"

# Compare two versions
cms compare "v2.1 vs v2.0 changelog differences"

# Export all data as JSON
cms export json

# Export all data as CSV
cms export csv

# View summary statistics
cms stats

# Search for entries containing "newsletter"
cms search newsletter

# View the 20 most recent activities
cms recent

# Check system status
cms status

# Show version
cms version
```

## Configuration

Data is stored in `~/.local/share/cms/` by default. The data directory is created automatically on first run.

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
cms stats > summary.txt
cms export json  # writes to ~/.local/share/cms/export.json
```

History is automatically logged to `$DATA_DIR/history.log` with timestamps for every command execution.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
