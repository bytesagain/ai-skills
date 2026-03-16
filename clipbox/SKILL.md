---
name: ClipBox
description: "Clipboard and snippet manager. Save reusable text snippets with names, retrieve them instantly, search across your collection, track usage frequency, and export all snippets. Perfect for storing code snippets, email templates, command lines, and frequently used text."
version: "2.0.0"
author: "BytesAgain"
tags: ["clipboard","snippets","text","paste","templates","productivity","developer"]
categories: ["Productivity", "Developer Tools", "Utility"]
---

# ClipBox

Save it once, paste it forever. ClipBox is your personal snippet library.

## Why ClipBox?

- **Named snippets**: Save any text with a memorable name
- **Instant recall**: Retrieve snippets by name in one command
- **Usage tracking**: See which snippets you use most
- **Searchable**: Find snippets by name or content
- **Exportable**: Export all snippets as markdown

## Commands

- `save <name> <content>` — Save a snippet with a name
- `get <name>` — Retrieve a snippet by name
- `list` — List all snippets sorted by usage
- `search <keyword>` — Search snippets by name or content
- `delete <name>` — Remove a snippet
- `export` — Export all snippets as markdown
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
clipbox save email-sig "Best regards, John Doe | john@example.com"
clipbox save ssh-prod "ssh admin@prod-server.com -p 2222"
clipbox save git-amend "git commit --amend --no-edit"
clipbox get email-sig
clipbox list
clipbox search ssh
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
