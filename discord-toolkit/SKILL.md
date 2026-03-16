---
version: "2.0.0"
name: discord-toolkit
description: "Error: --action required. Use when you need discord toolkit capabilities. Triggers on: discord toolkit, token, guild-id, channel-id, message, user-id."
author: BytesAgain
---

# Discord Toolkit

A complete Discord bot management toolkit for sending messages, managing channels and roles, listing guild members, creating rich embeds, managing reactions, and automating server administration — all from the command line using the Discord REST API with a bot token.

## Description

Discord Toolkit gives you full programmatic control over your Discord server. Send plain or embed-rich messages, manage channels (create, delete, edit), list and query members, manage roles, pin messages, add reactions, and perform server administration tasks. Supports formatted output for easy integration with other tools and automation pipelines. Ideal for notification bots, server management, community tooling, and ChatOps workflows.

## Requirements

- `list-guilds` — List Guilds
- `list-channels` — List Channels
- `send-message` — Send Message
- `send-embed` — Send Embed
- `channel-messages` — Channel Messages
- `list-members` — List Members
- `guild-info` — Guild Info
- `get-user` — Get User
- `create-channel` — Create Channel
- Create a bot at [configured-endpoint]
- Enable required intents (Server Members, Message Content) in bot settings
- Invite bot to your server with appropriate permissions

## Commands

See commands above.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DISCORD_BOT_TOKEN` | Yes | Discord bot token |
| `DISCORD_OUTPUT_FORMAT` | No | Output format: `table`, `json`, `markdown` |

## Examples

```bash
# Send a message
DISCORD_BOT_TOKEN=xxx discord-toolkit send 123456789 "Hello Discord! 🎮"

# Send a rich embed
DISCORD_BOT_TOKEN=xxx discord-toolkit embed 123456789 '{"title":"Server Status","description":"All systems operational","color":65280}'

# List channels
DISCORD_BOT_TOKEN=xxx discord-toolkit channels 987654321

# List members
DISCORD_BOT_TOKEN=xxx discord-toolkit members 987654321 100

# Add a role to a member
DISCORD_BOT_TOKEN=xxx discord-toolkit role add 987654321 111222333 444555666
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
