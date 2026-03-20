---
name: DeadLink
description: "Scan websites and files for broken links with HTTP status details. Use when auditing links, finding broken URLs, validating references."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["link","checker","broken","dead","404","website","seo","validation","html"]
categories: ["Developer Tools", "Utility"]
---

# DeadLink — Dead Link Checker

Check URLs for broken links. Scan individual URLs, files containing links, or crawl websites. Generates reports with HTTP status codes.

## Commands

| Command | Description |
|---------|-------------|
| `check <url>` | Check a single URL — shows HTTP status, redirect target if applicable |
| `scan <file>` | Extract and check all URLs found in a text file |
| `site <url> [depth]` | Crawl a webpage, extract all href/src links, and check each one |
| `report <file>` | Generate a timestamped report file from all URLs in a text file |

## Examples

```bash
# Check a single URL
deadlink check https://example.com/page
# → 200 OK

# Scan a markdown file for broken links
deadlink scan README.md
# → Extracts all http/https URLs and checks each one

# Crawl a website
deadlink site https://example.com 1
# → Fetches the page, extracts all links, checks each

# Generate a report file
deadlink report bookmarks.html
# → Creates deadlink-report-20240101-120000.txt
```

## Status Codes

- **2xx** — OK (alive)
- **3xx** — Redirect (alive, shows final URL)
- **4xx** — Client error (dead — 404 Not Found, 403 Forbidden, etc.)
- **5xx** — Server error (dead)
- **000** — Connection failed (DNS error, timeout, unreachable)

## Requirements

- `curl` — must be installed and in PATH
- Network access to check URLs

## Notes

- Timeout: 10 seconds per URL (5s connect timeout)
- URLs are extracted using regex pattern matching for `http://` and `https://` links
- The `site` command does basic HTML link extraction (href and src attributes)
- Reports are saved as plain text files in the current directory
