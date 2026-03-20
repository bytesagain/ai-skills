---
version: "2.0.0"
name: Event Planner
description: "Plan events with budgets, guest lists, and timelines. Use when organizing weddings, coordinating birthdays, managing vendors, drafting invitations."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# PartyCraft — 活动策划助手

PartyCraft is a full-featured event planning assistant that runs entirely from the command line. Create events (weddings, birthdays, corporate gatherings, parties), manage budgets, track tasks with completion status, maintain guest lists with RSVP tracking, view countdown timelines, and generate suggested checklists by event type. All data is stored locally in JSON format.

## Commands

| Command | Description |
|---------|-------------|
| `partycraft create <name> <date> [type]` | Create a new event. Types: `wedding`, `birthday`, `corporate`, `party`, `general` (default) |
| `partycraft list` | List all events with task progress, guest count, and budget |
| `partycraft budget <event_id> <amount>` | Set or update the budget for an event |
| `partycraft task <event_id> add <text>` | Add a task to an event |
| `partycraft task <event_id> done <number>` | Mark a task as complete by its number |
| `partycraft task <event_id> list` | List all tasks for an event with ✅/⬜ status |
| `partycraft guest <event_id> add <name>` | Add a guest to an event |
| `partycraft guest <event_id> list` | List all guests with RSVP status |
| `partycraft timeline <event_id>` | Show countdown, task progress, and guest count for an event |
| `partycraft checklist [type]` | Show a suggested checklist for an event type (wedding/birthday/corporate/general) |
| `partycraft info` | Show version information |
| `partycraft help` | Show usage help |

## Data Storage

All data is stored locally in `~/.partycraft/`:

- **`events.json`** — Main data file containing all events as a JSON array. Each event object includes:
  - `id` — Unix timestamp at creation (unique identifier)
  - `name` — Event name
  - `date` — Event date in `YYYY-MM-DD` format
  - `type` — Event type (wedding/birthday/corporate/party/general)
  - `budget` — Budget amount (numeric)
  - `tasks` — Array of `{text, done}` objects
  - `guests` — Array of `{name, rsvp}` objects
  - `created` — Creation date

The directory is created automatically on first run. The `events.json` file is initialized as an empty array `[]` if it doesn't exist.

## Requirements

- **bash** (any modern version)
- **python3** (standard library only — uses `json`, `time`, `datetime`)
- No API keys, no network access, no external dependencies

## When to Use

1. **Planning a wedding** — Create the event, use `checklist wedding` for a suggested task list (venue, catering, photographer, flowers, seating, music, cake, rehearsal dinner), add tasks, track guest RSVPs, and set the budget.
2. **Organizing a birthday party** — Create a birthday event, get a suggested checklist (theme, invitations, cake, decorations, games, food, party favors), add and track tasks as you complete them.
3. **Managing a corporate event** — Create a corporate event with objectives, agenda, AV equipment, catering, and name badges tracked as tasks. Monitor completion with `task list`.
4. **Tracking event countdown** — Use `timeline <id>` to see how many days remain, get warnings when less than a week out (⚠️), and monitor task completion percentage.
5. **Managing guest lists** — Add guests with `guest <id> add <name>`, view the full list with RSVP status, and track headcount alongside budget and task progress in `list`.

## Examples

```bash
# Create a wedding event
partycraft create "Alice & Bob Wedding" 2025-06-15 wedding
# Event created: Alice & Bob Wedding (wedding) on 2025-06-15

# List all events with progress summary
partycraft list
# Your Events:
# --------------------------------------------------
#   [1710500000] Alice & Bob Wedding - 2025-06-15 (wedding)
#       Tasks: 0/0 | Guests: 0 | Budget: $0

# Set the budget
partycraft budget 1710500000 50000
# Budget set to $50000 for: Alice & Bob Wedding

# Add tasks
partycraft task 1710500000 add "Book venue"
# Task added: Book venue
partycraft task 1710500000 add "Send invitations"
# Task added: Send invitations

# Mark a task as done
partycraft task 1710500000 done 1
# Task completed: Book venue

# View tasks with status
partycraft task 1710500000 list
#   ✅ 1. Book venue
#   ⬜ 2. Send invitations

# Add guests
partycraft guest 1710500000 add "Charlie"
# Guest added: Charlie

# View the timeline countdown
partycraft timeline 1710500000
# Timeline for: Alice & Bob Wedding (2025-06-15)
# ----------------------------------------
#   89 days until event
#   Tasks: 1/2 complete
#   Guests: 1 invited
#   📋 One month out. Confirm details.

# Get a suggested checklist for a birthday party
partycraft checklist birthday
# Suggested Checklist for: birthday
#   □ Choose theme
#   □ Send invitations
#   □ Order cake
#   □ Buy decorations
#   □ Plan activities/games
#   □ Arrange food/drinks
#   □ Party favors
```

## Checklist Templates

PartyCraft includes built-in checklist templates for common event types:

- **Wedding** — Venue, invitations, catering, photographer, flowers, seating, music/DJ, cake, rehearsal dinner, final guest count
- **Birthday** — Theme, invitations, cake, decorations, activities/games, food/drinks, party favors
- **Corporate** — Objectives, venue, invitations, AV equipment, agenda/speakers, catering, name badges, follow-up materials
- **General** — Date/time, venue, guest list, invitations, food/drinks, decorations, entertainment, cleanup plan

## Output

All output is printed to stdout. Event data is persisted in `~/.partycraft/events.json` and can be viewed or edited directly.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
