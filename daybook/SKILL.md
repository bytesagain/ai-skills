---
version: "2.0.0"
name: daybook
description: "Personal daily journal and diary tool with mood tracking, gratitude logging, and writing streaks. Use when you need to write daily entries, track mood over time, search past journals, maintain a writing streak, log gratitude, or get writing prompts. Triggers on: journal, diary, daily writing, mood log, gratitude, reflection, writing prompt, morning pages."
author: BytesAgain
---

# Daily Journal

Daily Journal — write, reflect, remember

## Why This Skill?

- Designed for everyday personal use
- No external dependencies or accounts needed
 — your privacy, your data
- Simple commands, powerful results

## Commands

- `write` — [text]       Write today's entry
- `today` —              View today's entry
- `yesterday` —          View yesterday
- `list` — [n]           List recent entries (default 10)
- `search` — <query>     Search all entries
- `mood` — <1-5> [note]  Log mood (1=bad, 5=great)
- `streak` —             Writing streak
- `gratitude` — [text]   Gratitude log
- `prompt` —             Random writing prompt
- `stats` —              Journal statistics
- `export` — [format]    Export (md/json/html)
- `info` —               Version info

## Quick Start

```bash
daily_journal.sh help
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
