---
version: "2.0.0"
name: slack-automator
description: "Error: --action required. Use when you need slack automator capabilities. Triggers on: slack automator, token, channel, message, user-id, query."
author: BytesAgain
---

# Slack Automator

A complete Slack automation toolkit for sending messages, managing channels, searching conversations, listing users, posting rich Block Kit messages, uploading files, and managing Slack workspace operations — all from the command line using the Slack Web API with a bot token.

## Description

Slack Automator provides programmatic access to your Slack workspace. Send messages to channels or DMs, search through message history, manage channels (create, archive, set topic/purpose), list and look up users, post rich formatted messages with Block Kit, react to messages, and more. Ideal for notification pipelines, ChatOps automation, reporting bots, and workspace administration.

## Requirements

- `SLACK_BOT_TOKEN` — Slack Bot User OAuth Token (starts with `xoxb-`)
- Create a Slack App at [configured-endpoint]
- Add required bot scopes: `chat:write`, `channels:read`, `channels:history`, `users:read`, `search:read`, etc.
- Install the app to your workspace

## Commands

- `channel-history` — Error: --channel required
- `list-channels` — {} — {} members{}'.format(priv, ch.get('name',''), members, 
- `list-members` — Execute list-members
- `message` — general" --message "Hello!" --token xoxb-xxx
- `search` — {} — {}: {}'.format(channel, user, text))
- `set-topic` — Error: --channel required
- `stdin` — Error: --channel required
- `user-info` — Error: --user-id required
## Environment Variables

| Variable | Required | Description |
| Command | Description |
|---------|-------------|
| `send-message` | Send message to channel (--channel --message) |
| `list-channels` | List all channels |
| `list-members` | List workspace members |
| `channel-history` | Get channel messages (--channel) |
| `search` | Search messages (--query) |
| `set-topic` | Set channel topic (--channel --message) |
| `user-info` | Get user info (--user-id) |

## Examples

```bash
# Send a message
SLACK_BOT_TOKEN=xoxb-xxx slack-automator send "#general" "Hello team! 🚀"

# Send a rich Block Kit message
SLACK_BOT_TOKEN=xoxb-xxx slack-automator send-blocks "#alerts" '[{"type":"section","text":{"type":"mrkdwn","text":"*Alert:* Server CPU > 90%"}}]'

# Search messages
SLACK_BOT_TOKEN=xoxb-xxx slack-automator search "deployment from:alice in:#engineering"

# List channels
SLACK_BOT_TOKEN=xoxb-xxx slack-automator channels

# Look up user by email
SLACK_BOT_TOKEN=xoxb-xxx slack-automator user lookup alice@company.com
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
