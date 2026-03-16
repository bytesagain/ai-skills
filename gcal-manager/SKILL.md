---
version: "2.0.0"
name: gcal-manager
description: "Error: --action required. Use when you need gcal manager capabilities. Triggers on: gcal manager, token, calendar, event-id, title, start."
author: BytesAgain
---

# Google Calendar Manager

A full-featured Google Calendar management toolkit for listing events, creating/updating/deleting events, checking availability, viewing daily agendas, and managing multiple calendars — all from the command line using the Google Calendar API with OAuth2 authentication.

## Description

Google Calendar Manager lets you interact with your Google Calendar programmatically. View your upcoming events, create new ones with attendees, check free/busy times, get a formatted daily agenda, and manage calendar settings. Supports multiple calendars, time zone handling, recurring events, and rich output formatting. Perfect for scheduling automation, meeting management, and calendar-based workflows.

## Requirements

- `list-calendars` — List all calendars
- `today` — Show today's events
- `list-events` — List upcoming events (--days for range)
- `create-event` — Create event (--title --start --end)
- `get-event` — Get event details (--event-id)
- `update-event` — Update event (--event-id --title)
- `delete-event` — Delete event (--event-id)
- `free-busy` — Check availability (--start --end)
- Enable the Google Calendar API in your Google Cloud Console
- Create OAuth2 credentials and obtain an access token with `calendar` scope

## Commands

See commands above.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GCAL_ACCESS_TOKEN` | Yes | Google OAuth2 access token |
| `GCAL_CALENDAR_ID` | No | Calendar ID (default: `primary`) |
| `GCAL_TIMEZONE` | No | Timezone (default: system timezone) |
| `GCAL_OUTPUT_FORMAT` | No | Output format: `table`, `json`, `markdown` |

## Examples

```bash
# List next 7 days of events
GCAL_ACCESS_TOKEN=ya29.xxx gcal-manager list

# Show today's agenda
GCAL_ACCESS_TOKEN=ya29.xxx gcal-manager today

# Create an event
GCAL_ACCESS_TOKEN=ya29.xxx gcal-manager create "Team Standup" "2024-01-15T09:00:00" "2024-01-15T09:30:00" '{"attendees":["alice@co.com"]}'

# Check availability
GCAL_ACCESS_TOKEN=ya29.xxx gcal-manager freebusy "2024-01-15T08:00:00" "2024-01-15T18:00:00"

# Quick-add with natural language
GCAL_ACCESS_TOKEN=ya29.xxx gcal-manager quick "Lunch with Bob tomorrow at noon"

# Search events
GCAL_ACCESS_TOKEN=ya29.xxx gcal-manager search "standup" 30
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
