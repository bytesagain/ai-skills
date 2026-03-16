# Tips — Google Calendar Manager

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Go to https://console.cloud.google.com/
2. Enable the Google Calendar API
3. Create OAuth2 credentials (Desktop application type)
4. Get an access token using the OAuth2 flow with scope `https://www.googleapis.com/auth/calendar`
5. Set `GCAL_ACCESS_TOKEN=your_token` and start using commands

## Getting an Access Token

The simplest method for personal use:
1. Use Google's OAuth Playground: https://developers.google.com/oauthplayground
2. Select "Google Calendar API v3" scopes
3. Authorize and exchange for tokens
4. Use the access token (expires in 1 hour)

For automation, implement a refresh token flow.

## Date/Time Formats

- Use ISO 8601 format: `2024-01-15T09:00:00`
- Include timezone offset if needed: `2024-01-15T09:00:00+08:00`
- For all-day events, use date only: `2024-01-15`

## Create Event Options

```json
{
  "attendees": ["email1@example.com", "email2@example.com"],
  "location": "Conference Room A",
  "description": "Weekly sync meeting",
  "reminders": [{"method": "popup", "minutes": 10}],
  "recurrence": ["RRULE:FREQ=WEEKLY;COUNT=10"],
  "colorId": "5"
}
```

## Color IDs
1=Lavender, 2=Sage, 3=Grape, 4=Flamingo, 5=Banana, 6=Tangerine, 7=Peacock, 8=Graphite, 9=Blueberry, 10=Basil, 11=Tomato

## Troubleshooting

- **401 Unauthorized**: Access token expired — refresh it
- **403 Forbidden**: Check API is enabled and scopes are correct
- **404 Not Found**: Event ID may be wrong or event was deleted
- **Rate Limited**: Google allows ~1M queries/day for most users

## Pro Tips

- Use `today` command for a morning briefing
- Pipe `json` output to `jq` for custom filtering
- Use `freebusy` before creating events to avoid conflicts
- `quick` command supports natural language like "Meeting with Alice next Tuesday at 3pm for 1 hour"
