# Tips — Discord Toolkit

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Go to https://discord.com/developers/applications
2. Click "New Application" and give it a name
3. Go to "Bot" section and click "Add Bot"
4. Copy the bot token
5. Under "Privileged Gateway Intents", enable:
   - Server Members Intent
   - Message Content Intent
6. Go to "OAuth2" → "URL Generator", select `bot` scope with needed permissions
7. Use the generated URL to invite the bot to your server

## Getting IDs

Enable Developer Mode in Discord:
- User Settings → App Settings → Advanced → Developer Mode
- Right-click any user/channel/server → "Copy ID"

## Embed Format

```json
{
  "title": "Status Update",
  "description": "All systems are operational",
  "color": 65280,
  "fields": [
    {"name": "CPU", "value": "23%", "inline": true},
    {"name": "Memory", "value": "45%", "inline": true},
    {"name": "Disk", "value": "67%", "inline": true}
  ],
  "footer": {"text": "Updated just now"},
  "thumbnail": {"url": "https://example.com/icon.png"},
  "timestamp": "2024-01-15T12:00:00Z"
}
```

## Color Values

Colors are decimal integers:
- Red: `16711680` (0xFF0000)
- Green: `65280` (0x00FF00)
- Blue: `255` (0x0000FF)
- Yellow: `16776960` (0xFFFF00)
- Purple: `10494192` (0xA020F0)
- Orange: `16744448` (0xFF8C00)

## Channel Types

- `0` = Text channel (default)
- `2` = Voice channel
- `4` = Category
- `5` = Announcement channel
- `13` = Stage channel
- `15` = Forum channel

## Troubleshooting

- **401 Unauthorized**: Token is invalid or expired — regenerate it
- **403 Missing Permissions**: Bot needs appropriate permissions in the server
- **50001 Missing Access**: Bot doesn't have access to that channel
- **10008 Unknown Message**: Message ID is wrong or message was deleted

## Pro Tips

- Use embeds for structured messages (alerts, reports, dashboards)
- Create a dedicated bot channel for automated messages
- Use reactions for simple polls or acknowledgments
- Combine with cron for scheduled announcements
