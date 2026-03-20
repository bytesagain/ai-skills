---
version: "3.0.2"
name: api-tester-cn
description: "Test and debug API endpoints from terminal. Use when checking endpoint status, validating JSON responses, comparing API versions, or running best-practice lints."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# api-tester-cn

API testing and debugging toolkit — check endpoint status codes, validate JSON responses, lint for best practices (HTTPS, CORS, caching), compare two API responses, manage request templates, and export test history.

## Commands

### `check`

Test an API endpoint — shows HTTP status code, response time, content type, and server header.

```bash
scripts/script.sh check "https://api.github.com"
```

### `validate`

Fetch a URL and validate the JSON response. Shows structure info (keys, types, array lengths).

```bash
scripts/script.sh validate "https://jsonplaceholder.typicode.com/posts/1"
```

### `lint`

Check an API endpoint for best practices — HTTPS, CORS headers, content-type, rate limiting, and caching.

```bash
scripts/script.sh lint "https://api.example.com/v1/users"
```

### `diff`

Compare JSON responses from two API endpoints side by side.

```bash
scripts/script.sh diff "https://api.v1.example.com/data" "https://api.v2.example.com/data"
```

### `format`

Pretty-print JSON from a file or stdin.

```bash
scripts/script.sh format response.json
cat data.json | scripts/script.sh format
```

### `convert`

Convert between JSON and CSV formats.

```bash
scripts/script.sh convert json2csv data.json
scripts/script.sh convert csv2json data.csv
```

### `template`

Manage reusable request templates — save, list, and run API calls.

```bash
scripts/script.sh template list
scripts/script.sh template save "github-user" GET "https://api.github.com/users/octocat"
scripts/script.sh template run "github-user"
```

### `report`

Generate a summary report of all tests run — counts by type, recent activity.

```bash
scripts/script.sh report
```

### `recent`

Show the most recent test entries from history.

```bash
scripts/script.sh recent 20
```

### `search`

Search test history by URL or keyword.

```bash
scripts/script.sh search "github"
```

### `stats`

Show usage statistics — total requests, template count, date range.

```bash
scripts/script.sh stats
```

### `export`

Export test history in json, csv, or txt format.

```bash
scripts/script.sh export json
```

### `status`

Show tool status — version, data directory, entry count.

```bash
scripts/script.sh status
```

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Examples

```bash
# Quick API health check
scripts/script.sh check "https://api.github.com"
scripts/script.sh validate "https://jsonplaceholder.typicode.com/posts"
scripts/script.sh lint "https://api.github.com"

# Compare API versions
scripts/script.sh diff "https://api.v1.example.com/data" "https://api.v2.example.com/data"

# Template workflow
scripts/script.sh template save "posts" GET "https://jsonplaceholder.typicode.com/posts"
scripts/script.sh template run "posts"
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `API_TESTER_CN_DIR` | No | Data directory (default: `~/.api-tester-cn/`) |

## Data Storage

All data saved in `~/.api-tester-cn/`:
- `history.log` — Test history log
- `templates/` — Saved request templates
- `responses/` — Cached responses

## Requirements

- bash 4.0+
- curl (for HTTP requests)
- python3 (for JSON parsing)

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
