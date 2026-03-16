# Tips — Notion Powertools

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Create a Notion integration at https://www.notion.so/my-integrations
2. Copy your integration token (starts with `ntn_` or `secret_`)
3. Share your target pages/databases with the integration (click "..." → "Connections" → select your integration)
4. Set `NOTION_API_KEY=your_token` and start using commands

## Common Patterns

### Finding Page/Database IDs
- Open the page in Notion browser
- The ID is in the URL: `notion.so/Your-Page-<32-char-id>`
- Remove dashes or keep them — both work

### Database Queries with Filters
Filters follow the Notion API filter format:
```json
{"property": "Status", "select": {"equals": "Done"}}
```

Compound filters:
```json
{"and": [{"property": "Status", "select": {"equals": "Done"}}, {"property": "Priority", "select": {"equals": "High"}}]}
```

### Sorting Database Results
```json
[{"property": "Created", "direction": "descending"}]
```

### Block Types for Append
Supported types: `paragraph`, `heading_1`, `heading_2`, `heading_3`, `bulleted_list_item`, `numbered_list_item`, `to_do`, `toggle`, `code`, `quote`, `callout`, `divider`

## Troubleshooting

- **401 Unauthorized**: Check your API key is correct
- **404 Not Found**: Make sure the page/database is shared with your integration
- **400 Bad Request**: Verify your JSON filter/properties format
- **Rate Limited (429)**: The script auto-retries with backoff; wait a moment

## Pro Tips

- Use `json` output format for piping to `jq` for advanced processing
- Combine with cron for automated database reports
- Use `search` to discover page IDs before other operations
- Archive instead of delete — it's reversible
