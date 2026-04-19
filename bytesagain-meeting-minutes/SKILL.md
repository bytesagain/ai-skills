---
description: "Record, manage, and export meeting minutes in your terminal. Use when capturing action items, logging decisions, tracking attendees, or generating formatted meeting reports from the command line."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-meeting-minutes

Manage meeting minutes from the terminal — create meetings, record decisions and action items, track deadlines, and export formatted reports. Stores data locally in JSON format.

## Usage

```
bytesagain-meeting-minutes new "<title>"
bytesagain-meeting-minutes add-action "<meeting_id>" "<action>" "<owner>" "<due_date>"
bytesagain-meeting-minutes add-decision "<meeting_id>" "<decision>"
bytesagain-meeting-minutes list
bytesagain-meeting-minutes view <meeting_id>
bytesagain-meeting-minutes export <meeting_id>
```

## Commands

- `new` — Create a new meeting record with title, date, and attendees
- `add-action` — Add an action item with owner and due date to a meeting
- `add-decision` — Record a decision made during the meeting
- `list` — List all meetings with summary stats
- `view` — View full details of a specific meeting
- `export` — Export meeting minutes as formatted Markdown

## Examples

```bash
bytesagain-meeting-minutes new "Q1 Planning Meeting"
bytesagain-meeting-minutes add-action "001" "Set up CI pipeline" "Alice" "2024-02-01"
bytesagain-meeting-minutes add-decision "001" "Adopt TypeScript for all new services"
bytesagain-meeting-minutes list
bytesagain-meeting-minutes export 001
```

## Requirements

- bash
- python3

## When to Use

Use when running meetings and need to track decisions and action items, or when reviewing past meeting outcomes and following up on commitments.
