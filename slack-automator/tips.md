# Tips — Slack Automator

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Go to https://api.slack.com/apps and create a new app
2. Under "OAuth & Permissions", add bot token scopes:
   - `chat:write` — Send messages
   - `channels:read` — List channels
   - `channels:history` — Read channel history
   - `users:read` — List users
   - `users:read.email` — Look up by email
   - `search:read` — Search messages
   - `reactions:write` — Add reactions
   - `files:write` — Upload files
3. Install the app to your workspace
4. Copy the Bot User OAuth Token (`xoxb-...`)

## Channel References

- Use channel name with `#`: `#general`
- Use channel ID: `C01234ABCDE`
- For DMs, use user ID: `U01234ABCDE`

## Block Kit Messages

Build rich messages using Slack's Block Kit:
```json
[
  {"type": "header", "text": {"type": "plain_text", "text": "Daily Report"}},
  {"type": "section", "text": {"type": "mrkdwn", "text": "*Revenue:* $12,345\n*Users:* 1,234"}},
  {"type": "divider"},
  {"type": "actions", "elements": [{"type": "button", "text": {"type": "plain_text", "text": "View Dashboard"}, "url": "https://dashboard.example.com"}]}
]
```

Preview blocks at https://app.slack.com/block-kit-builder

## Search Modifiers

- `from:@username` — Messages from a specific user
- `in:#channel` — Messages in a specific channel
- `has:link` — Messages containing links
- `before:2024-01-01` — Messages before a date
- `after:2024-01-01` — Messages after a date
- Combine modifiers: `"deploy" from:@alice in:#engineering after:2024-01-01`

## Troubleshooting

- **not_in_channel**: Bot must be invited to the channel first (`/invite @your-bot`)
- **channel_not_found**: Use channel ID instead of name, or check access
- **missing_scope**: Add the required scope in app settings and reinstall
- **token_revoked**: Generate a new token from app settings

## Pro Tips

- Use threads (`reply`) to keep channels clean
- Set up Block Kit templates for recurring reports
- Use `search` with date ranges for auditing
- Pipe `json` output to `jq` for custom processing
