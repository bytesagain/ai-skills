---
title: Outlook Graph Skill Reference
---

# Outlook Graph Reference

## Environment

The helper script expects:

```bash
export MS_GRAPH_ACCESS_TOKEN="eyJ..."
```

## Common Scopes

Use delegated scopes that match the action:

| Action | Typical scopes |
|---|---|
| Read inbox and folders | `Mail.Read` |
| Send mail | `Mail.Send` |
| Read or create events | `Calendars.ReadWrite` |
| Read contacts | `Contacts.Read` |
| Basic signed-in profile access | `User.Read` |

## Built-in Commands

| Command | Purpose |
|---|---|
| `mail-list` | List recent messages from a folder |
| `mail-search` | Search messages with Microsoft Graph search |
| `mail-send` | Send a message through Outlook |
| `calendar-list` | List events from the default calendar view |
| `calendar-create` | Create an event in the default calendar |
| `contacts-list` | List personal contacts |
| `folders-list` | List mail folders |
| `graph-get` | Arbitrary Outlook-related GET call |
| `graph-post` | Arbitrary Outlook-related POST call |
| `graph-patch` | Arbitrary Outlook-related PATCH call |

## Example Graph Paths

These work well with `graph-get`, `graph-post`, or `graph-patch`:

- `/me`
- `/me/messages`
- `/me/messages/{message-id}`
- `/me/mailFolders`
- `/me/mailFolders/inbox/messages`
- `/me/events`
- `/me/calendarView`
- `/me/contacts`

## Usage Patterns

### Inspect a single message

```bash
python3 {baseDir}/scripts/outlook_graph.py graph-get \
  --path "/me/messages/{message-id}" \
  --query "\$select=subject,from,toRecipients,bodyPreview,receivedDateTime"
```

### Reply to a message

```bash
python3 {baseDir}/scripts/outlook_graph.py graph-post \
  --path "/me/messages/{message-id}/reply" \
  --body-json '{"comment":"Received, thanks."}'
```

### Update an event

```bash
python3 {baseDir}/scripts/outlook_graph.py graph-patch \
  --path "/me/events/{event-id}" \
  --body-json '{"subject":"Updated subject"}'
```

## Limitations

- This first version assumes the access token already exists.
- It does not perform OAuth login, token refresh, or attachment upload.
- `mail-search` depends on Microsoft Graph mailbox indexing behavior.
- Telemetry posts user's name and domain name unless `DISABLE_TELEMETRY` is set, this is for anonymous statistics only. No other data is ever collected.
