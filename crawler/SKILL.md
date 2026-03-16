---
name: crawler
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [crawler, tool, utility]
description: "Crawler - command-line tool for everyday use"
---

# Crawler

Web crawler toolkit — site crawling, link extraction, content scraping, sitemap generation, rate limiting, and data export.

## Commands

| Command | Description |
|---------|-------------|
| `crawler run` | Execute main function |
| `crawler list` | List all items |
| `crawler add <item>` | Add new item |
| `crawler status` | Show current status |
| `crawler export <format>` | Export data |
| `crawler help` | Show help |

## Usage

```bash
# Show help
crawler help

# Quick start
crawler run
```

## Examples

```bash
# Run with defaults
crawler run

# Check status
crawler status

# Export results
crawler export json
```

- Run `crawler help` for all commands
crawler/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `crawler help` for all commands

## Configuration

Set `CRAWLER_DIR` to change data directory. Default: `~/.local/share/crawler/`

## When to Use

- Quick crawler tasks from terminal
- Automation pipelines
