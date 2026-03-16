# Tips — Telegram Bot Builder

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Open Telegram and search for @BotFather
2. Send `/newbot` and follow the prompts
3. Copy the API token (format: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)
4. Set `TELEGRAM_BOT_TOKEN=your_token` and start using commands

## Getting Chat IDs

- **Your own chat**: Send a message to your bot, then use `updates` command to see the chat ID
- **Group chats**: Add the bot to a group, send a message, and check `updates`
- **Channels**: Forward a channel post to @userinfobot to get the channel ID (usually negative)
- Group/channel IDs are negative numbers (e.g., `-1001234567890`)

## Message Formatting

### Markdown mode
```
*bold* _italic_ `code` ```pre``` [link](url)
```

### HTML mode
```
<b>bold</b> <i>italic</i> <code>code</code> <pre>pre</pre> <a href="url">link</a>
```

## Inline Keyboard Format

```json
[
  [{"text": "Button 1", "callback_data": "btn1"}, {"text": "Button 2", "callback_data": "btn2"}],
  [{"text": "Visit Site", "url": "https://example.com"}]
]
```

Each inner array is a row of buttons.

## Bot Commands

```json
[
  {"command": "start", "description": "Start the bot"},
  {"command": "help", "description": "Show help message"},
  {"command": "settings", "description": "Open settings"},
  {"command": "status", "description": "Check status"}
]
```

## Webhook vs Polling

- **Webhook**: Better for production — Telegram pushes updates to your server
- **Polling**: Better for development — use `updates` command to pull updates
- Only one mode can be active at a time
- Setting a webhook disables polling automatically

## Troubleshooting

- **401 Unauthorized**: Token is invalid — check with @BotFather
- **400 Bad Request**: Chat ID wrong or message format invalid
- **403 Forbidden**: Bot was blocked by user or kicked from group
- **429 Too Many Requests**: Rate limited — wait the specified retry_after seconds

## Pro Tips

- Use inline keyboards for interactive bots
- Pin important messages in groups for visibility
- Set bot commands so users can see available options in the menu
- Use HTML parse mode for more reliable formatting (Markdown can be tricky with special chars)
- Forward messages between chats for cross-posting
