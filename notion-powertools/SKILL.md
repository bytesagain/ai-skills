---
version: "2.0.0"
name: notion-powertools
description: "Unknown: help. Use when you need notion powertools capabilities. Triggers on: notion powertools, token, database-id, page-id, title, content."
author: BytesAgain
---

# Notion Powertools

A complete Notion API toolkit for managing pages, databases, blocks, and content directly from the command line. Create and update pages, query databases with filters, manage block content, search across your workspace, and export structured data — all using the official Notion API with your own integration token.

## Description

Notion Powertools provides full programmatic access to your Notion workspace. Whether you need to automate content creation, query databases for reporting, manage page properties, or bulk-update blocks, this skill handles it all through a clean CLI interface. Supports formatted output in table, JSON, or markdown formats.

## Requirements

- `search` — Search workspace (--query)
- `list-databases` — List all databases
- `query-database` — Query a database (--database-id)
- `create-page` — Create a page (--database-id --title --content)
- `get-page` — Get page details (--page-id)
- `update-page` — Update a page (--page-id --title)
- `list-blocks` — List page blocks (--page-id)
- `append-block` — Append content to page (--page-id --content)
- Create an integration at [configured-endpoint]
- Share target pages/databases with your integration

## Commands

See commands above.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `NOTION_API_KEY` | Yes | Notion integration token |
| `NOTION_OUTPUT_FORMAT` | No | Output format: `table` (default), `json`, `markdown` |

## Examples

```bash
# Search for pages
NOTION_API_KEY=ntn_xxx notion-powertools search "Meeting Notes"

# Query a database with filter
NOTION_API_KEY=ntn_xxx notion-powertools db query abc123 '{"property":"Status","select":{"equals":"In Progress"}}'

# Create a new page
NOTION_API_KEY=ntn_xxx notion-powertools page create parent123 "New Task" '{"Status":{"select":{"name":"Todo"}}}'

# Append content to a page
NOTION_API_KEY=ntn_xxx notion-powertools block append page123 "Hello world" paragraph

# List workspace users
NOTION_API_KEY=ntn_xxx notion-powertools user list
```

## Output Formats

- **table** — Human-readable formatted table (default)
- **json** — Raw JSON response from API
- **markdown** — Markdown-formatted output for docs/notes
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
