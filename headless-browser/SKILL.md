---
version: "1.0.0"
name: Phantomjs
description: "Automate browser tasks with scriptable headless browsing for tests and scraping. Use when scraping pages, running tests, or capturing screenshots."
---

# Headless Browser

Headless Browser v2.0.0 — a content toolkit for logging and tracking content creation operations from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `headless-browser draft <input>` | Log a draft entry (no args = show recent) |
| `headless-browser edit <input>` | Log an edit entry (no args = show recent) |
| `headless-browser optimize <input>` | Log an optimize entry (no args = show recent) |
| `headless-browser schedule <input>` | Log a schedule entry (no args = show recent) |
| `headless-browser hashtags <input>` | Log a hashtags entry (no args = show recent) |
| `headless-browser hooks <input>` | Log a hooks entry (no args = show recent) |
| `headless-browser cta <input>` | Log a CTA entry (no args = show recent) |
| `headless-browser rewrite <input>` | Log a rewrite entry (no args = show recent) |
| `headless-browser translate <input>` | Log a translate entry (no args = show recent) |
| `headless-browser tone <input>` | Log a tone entry (no args = show recent) |
| `headless-browser headline <input>` | Log a headline entry (no args = show recent) |
| `headless-browser outline <input>` | Log an outline entry (no args = show recent) |
| `headless-browser stats` | Show summary statistics across all log files |
| `headless-browser export <fmt>` | Export all data (json, csv, or txt) |
| `headless-browser search <term>` | Search across all log entries |
| `headless-browser recent` | Show last 20 history entries |
| `headless-browser status` | Health check (version, data dir, entry count, disk usage) |
| `headless-browser help` | Show usage information |
| `headless-browser version` | Show version string |

## Data Storage

All data is stored locally in `~/.local/share/headless-browser/`. Each command writes timestamped entries to its own `.log` file (e.g., `draft.log`, `edit.log`, `headline.log`). A unified `history.log` tracks all operations for the `recent` command.

Log format per entry: `YYYY-MM-DD HH:MM|<input>`

## Requirements

- Bash (with `set -euo pipefail`)
- No external dependencies — uses only standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `cat`, `sed`)

## When to Use

- To log and track content creation operations over time
- To maintain a searchable history of draft/edit/rewrite/translate tasks
- To track headline creation, CTA writing, and scheduling
- To export accumulated data in JSON, CSV, or plain text for reporting
- To get a quick health check on your headless-browser data directory
- For managing content workflows with hashtags, hooks, and tone adjustments

## Examples

```bash
# Log a draft entry
headless-browser draft "Blog post about AI trends in 2025"

# Log an edit entry
headless-browser edit "Revised intro paragraph for clarity"

# Log a headline entry
headless-browser headline "10 Ways to Boost Your Productivity"

# Log a hashtags entry
headless-browser hashtags "#AI #MachineLearning #DeepLearning"

# Log a CTA entry
headless-browser cta "Sign up for our free newsletter today"

# Log a rewrite entry
headless-browser rewrite "Simplified technical jargon in section 3"

# Log a translate entry
headless-browser translate "English to Spanish: landing page copy"

# View recent schedule entries
headless-browser schedule

# Search all logs for a term
headless-browser search "blog"

# Export everything as JSON
headless-browser export json

# View aggregate statistics
headless-browser stats

# Health check
headless-browser status

# Show last 20 history entries
headless-browser recent

# Log an outline entry
headless-browser outline "Product launch announcement: intro, features, pricing, CTA"
```

## Configuration

Set the `HEADLESS_BROWSER_DIR` environment variable to override the default data directory. Default: `~/.local/share/headless-browser/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
