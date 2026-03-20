---
version: "2.1.0"
name: link-checker
description: "Crawl web pages and detect broken links, redirects, and HTTP errors. Use when auditing site links, finding 404 errors, validating URLs before launch."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Link Checker

Check URLs for HTTP status codes, find broken links in documents, and track link health over time. Feed it a single URL, a file full of links, or a batch of addresses — it hits each one with `curl`, records the status code, and tells you what's alive and what's dead. Results are stored in `~/.link-checker/` so you can review history, pull stats, and export reports.

## Commands

### `check`

Check a single URL. Sends an HTTP HEAD request and returns the status code.

```
link-checker check <url>
```

Output includes status code, a human-readable label (OK, REDIRECT, CLIENT_ERROR, etc.), and an icon.

### `scan`

Extract all URLs from a file (markdown, HTML, plain text — anything with `http://` or `https://` links) and check each one.

```
link-checker scan <file>
```

Uses `grep` to pull URLs, deduplicates them, then checks each. Prints a summary at the end with pass/fail counts.

### `batch`

Check multiple URLs in one go. Pass them as arguments.

```
link-checker batch <url1> <url2> <url3> ...
```

### `report`

Generate a report from the current session's results. Supports three formats.

```
link-checker report [txt|csv|json]
```

Default format is `txt`. Reports are saved to `~/.link-checker/report.<format>`.

### `history`

Display the last 50 check results from the history log.

```
link-checker history
```

Shows timestamp, status code, status label, and URL for each entry.

### `broken`

Filter results to show only failed links — status codes 4xx, 5xx, timeouts, and connection errors.

```
link-checker broken
```

### `stats`

Show statistics across all checks: total count, breakdown by status category (2xx, 3xx, 4xx, 5xx, timeout, error), success rate percentage, and the most common status codes.

```
link-checker stats
```

### `export`

Export the full history log to a file. Supports `csv`, `json`, and `txt`.

```
link-checker export <format>
```

Exported files are timestamped and saved to `~/.link-checker/`.

### `config`

View current configuration or change settings.

```
link-checker config
link-checker config set <key> <value>
```

Available keys: `timeout` (seconds per request), `retries` (retry count on failure), `user_agent`.

### `help`

Show usage information and available commands.

```
link-checker help
```

### `version`

Print the current version.

```
link-checker version
```

## Examples

```bash
# Check if a URL is reachable
link-checker check https://example.com

# Scan a markdown file for broken links
link-checker scan ./README.md

# Batch check several URLs
link-checker batch https://example.com https://httpstat.us/404 https://httpstat.us/500

# See only the broken ones
link-checker broken

# Get a stats overview
link-checker stats

# Generate a JSON report
link-checker report json

# Export full history as CSV
link-checker export csv

# Set request timeout to 15 seconds
link-checker config set timeout 15

# Set retry count to 3
link-checker config set retries 3
```

## Configuration

Settings are stored in `~/.link-checker/config` as key-value pairs.

| Key | Default | Description |
|-----|---------|-------------|
| `timeout` | `10` | Connection timeout in seconds per request |
| `retries` | `2` | Number of retry attempts on timeout/error |
| `user_agent` | `LinkChecker/1.0.0` | User-Agent header sent with requests |

Change any setting with `link-checker config set <key> <value>`.

## Data Storage

All data lives in `~/.link-checker/`:

| File | Purpose |
|------|---------|
| `results.log` | Current session results (pipe-delimited) |
| `history.log` | Cumulative log of all checks ever run |
| `config` | Configuration key-value file |
| `report.*` | Generated reports (txt/csv/json) |
| `export_*.*` | Timestamped exports |

Log format: `timestamp|url|status_code|status_label`

## Status Categories

| Icon | Category | Codes |
|------|----------|-------|
| ✅ | OK | 2xx |
| 🔄 | Redirect | 3xx |
| ❌ | Client Error | 4xx |
| ⚠️ | Server Error | 5xx |
| ⏱️ | Timeout | Connection timed out |
| 🚫 | Error | DNS failure, connection refused |

## Requirements

- `bash` (4.0+)
- `curl`
- `grep`, `sort`, `awk` (standard Unix tools)

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
