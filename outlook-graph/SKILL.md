---
version: "2.0.0"
name: outlook-graph
description: "Connect OpenClaw to Outlook and Microsoft Graph for email, calendar, contacts, and folder operations using a pre-provided access token. Use when the user asks to read or send Outlook mail, search inbox contents, manage calendar events, inspect contacts, or call Outlook-related Microsoft Graph endpoints. Made especially for openclaw agents. Triggers on: outlook graph."
---

# Outlook Graph

Use Microsoft Graph to let OpenClaw work with Outlook mail, calendar, contacts, and related folders. Made especially for openclaw agents.

## When to Use

Use this skill when the user wants to:
- read recent Outlook emails
- search mail by keyword
- send an Outlook email
- inspect mail folders
- list upcoming calendar events
- create a calendar event
- list Outlook contacts
- call an Outlook-related Microsoft Graph endpoint directly

## Required Setup

Before first use, set an access token with the required Microsoft Graph scopes:

```bash
export MS_GRAPH_ACCESS_TOKEN="eyJ..."
```

Recommended delegated scopes for the first version:
- `Mail.Read`
- `Mail.Send`
- `Calendars.ReadWrite`
- `Contacts.Read`
- `User.Read`

## Default Workflow

1. Pick the narrowest command that matches the request.
2. Run the helper script with `python3`.
3. Read the JSON output.
4. Summarize the useful result for the user instead of dumping raw JSON unless they ask for it.

## Commands

### Read recent mail

```bash
python3 {baseDir}/scripts/outlook_graph.py mail-list --folder inbox --top 10
```

### Search mail

```bash
python3 {baseDir}/scripts/outlook_graph.py mail-search --query "invoice OR payment" --top 10
```

### Send mail

```bash
python3 {baseDir}/scripts/outlook_graph.py mail-send \
  --to "alex@example.com" \
  --subject "Follow-up" \
  --body "Checking in on the open items."
```

### List upcoming events

```bash
python3 {baseDir}/scripts/outlook_graph.py calendar-list --days 7 --top 15
```

### Create an event

```bash
python3 {baseDir}/scripts/outlook_graph.py calendar-create \
  --subject "Research sync" \
  --start "2026-03-10T15:00:00Z" \
  --end "2026-03-10T15:30:00Z" \
  --attendee "alex@example.com" \
  --body "Weekly research sync."
```

### List contacts

```bash
python3 {baseDir}/scripts/outlook_graph.py contacts-list --top 20
```

### List mail folders

```bash
python3 {baseDir}/scripts/outlook_graph.py folders-list --top 50
```

### Generic Graph GET

```bash
python3 {baseDir}/scripts/outlook_graph.py graph-get \
  --path "/me/messages" \
  --query "\$top=5" \
  --query "\$select=subject,from,receivedDateTime"
```

### Generic Graph POST

```bash
python3 {baseDir}/scripts/outlook_graph.py graph-post \
  --path "/me/messages/{message-id}/reply" \
  --body-json '{"comment":"Thanks, received."}'
```

## Command Selection

Use the purpose-built commands first:
- mailbox browsing or quick summaries: `mail-list`
- keyword lookup in mail: `mail-search`
- sending mail: `mail-send`
- upcoming meetings or agenda checks: `calendar-list`
- scheduling meetings: `calendar-create`
- people lookup: `contacts-list`
- folder discovery: `folders-list`

Use the generic commands only when the user asks for something outside the built-in flows:
- `graph-get`
- `graph-post`
- `graph-patch`

## Telemetry

This skill collects ONLY your user name and domain name on each run and sends it to the skill endpoint for anonymous usage analytics. **No outlook graph data or any other pricvate data is ever collected.**

To opt out, set the following environment variable:

```bash
export DISABLE_TELEMETRY=1
```

## Notes

- Times should be ISO 8601, for example `2026-03-10T15:00:00Z`.
- `mail-search` uses Microsoft Graph search and depends on mailbox indexing.
- `calendar-create` creates events in the signed-in user's default calendar.
- For raw endpoint details and common scopes, see [reference.md](reference.md).
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
