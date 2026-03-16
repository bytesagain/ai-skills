---
version: "2.0.0"
name: chatbot-builder
description: "Error: --action required. Use when you need telegram bot builder capabilities. Triggers on: telegram bot builder, token, chat-id, message, parse-mode, file."
---

# Telegram Bot Builder


A complete Telegram Bot API management toolkit for sending messages, managing groups, setting bot commands, handling webhooks, sending media, managing inline keyboards, and automating Telegram bot operations — all from the command line using the Telegram Bot HTTP API.

## Description

Telegram Bot Builder provides full access to the Telegram Bot API for managing your bot. Send text messages with markdown or HTML formatting, manage groups and supergroups, set custom bot commands, configure webhooks for receiving updates, send photos/documents/videos, create inline keyboards and reply keyboards, pin messages, and retrieve bot/chat information. Supports polling and webhook modes. Perfect for notification bots, group management, content distribution, and chat automation.

## Requirements

- `TELEGRAM_BOT_TOKEN` — Telegram Bot API token (from @BotFather)
- Create a bot by messaging @BotFather on Telegram with `/newbot`

## Commands

| Command | Description |
|---------|-------------|
| `send <chat_id> <message> [parse_mode]` | Send a text message (markdown/html) |
| `reply <chat_id> <message_id> <message>` | Reply to a specific message |
| `forward <chat_id> <from_chat_id> <message_id>` | Forward a message |
| `photo <chat_id> <url_or_file_id> [caption]` | Send a photo |
| `document <chat_id> <url_or_file_id> [caption]` | Send a document |
| `keyboard <chat_id> <message> <buttons_json>` | Send inline keyboard message |
| `edit <chat_id> <message_id> <new_text>` | Edit a sent message |
| `delete <chat_id> <message_id>` | Delete a message |
| `pin <chat_id> <message_id>` | Pin a message in chat |
| `unpin <chat_id> [message_id]` | Unpin message(s) |
| `chat info <chat_id>` | Get chat details |
| `chat members <chat_id>` | Get chat member count |
| `chat member <chat_id> <user_id>` | Get member info |
| `setcommands <commands_json>` | Set bot menu commands |
| `getcommands` | Get current bot commands |
| `webhook set <url>` | Set webhook URL |
| `webhook delete` | Remove webhook |
| `webhook info` | Get webhook status |
| `me` | Get bot information |
| `updates [limit]` | Get recent updates (polling mode) |

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Yes | Bot API token from @BotFather |
| `TELEGRAM_OUTPUT_FORMAT` | No | Output format: `table`, `json`, `markdown` |

## Examples

```bash
# Send a message
TELEGRAM_BOT_TOKEN=123:ABC telegram-bot-builder send 456789 "Hello! 🤖"

# Send with markdown formatting
TELEGRAM_BOT_TOKEN=123:ABC telegram-bot-builder send 456789 "*Bold* and _italic_" markdown

# Send inline keyboard
TELEGRAM_BOT_TOKEN=123:ABC telegram-bot-builder keyboard 456789 "Choose:" '[[{"text":"Yes","callback_data":"yes"},{"text":"No","callback_data":"no"}]]'

# Set bot commands
TELEGRAM_BOT_TOKEN=123:ABC telegram-bot-builder setcommands '[{"command":"start","description":"Start the bot"},{"command":"help","description":"Show help"}]'

# Set webhook
TELEGRAM_BOT_TOKEN=123:ABC telegram-bot-builder webhook set "[configured-endpoint]

# Get bot info
TELEGRAM_BOT_TOKEN=123:ABC telegram-bot-builder me
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
