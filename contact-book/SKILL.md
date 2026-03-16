---
version: "2.0.0"
name: contact-book
description: "Personal contact manager with groups, birthdays, and vCard export. Use when you need to store contacts (name/phone/email), organize into groups, track birthdays, search contacts, or export as CSV/vCard. Triggers on: contact, phone number, address book, birthday reminder, vCard."
author: BytesAgain
---

# Contact Book

Contact Book — manage personal contacts

## Why This Skill?

- Designed for everyday personal use
- No external dependencies or accounts needed
 — your privacy, your data
- Simple commands, powerful results

## Commands

- `add` — <name> <phone> [email]  Add contact
- `list` — [n]                    List contacts (default all)
- `search` — <query>              Search contacts
- `view` — <name>                 View contact details
- `edit` — <name> <field> <val>   Edit contact field
- `group` — <name> <group>        Add to group
- `groups` —                      List groups
- `birthday` — <name> <date>      Set birthday
- `birthdays` —                   Upcoming birthdays
- `delete` — <name>               Delete contact
- `export` — [format]             Export (csv/vcf/json)
- `stats` —                       Contact statistics

## Quick Start

```bash
contact_book.sh help
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
