---
name: "Deadline"
description: "Your personal Deadline assistant. Track, analyze, and manage all your content creation needs from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["social-media", "copywriting", "creative", "deadline", "writing"]
---

# Deadline

Your personal Deadline assistant. Track, analyze, and manage all your content creation needs from the command line.

## Why Deadline?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
deadline help

# Check current status
deadline status

# View your statistics
deadline stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `deadline draft` | Draft |
| `deadline edit` | Edit |
| `deadline optimize` | Optimize |
| `deadline schedule` | Schedule |
| `deadline hashtags` | Hashtags |
| `deadline hooks` | Hooks |
| `deadline cta` | Cta |
| `deadline rewrite` | Rewrite |
| `deadline translate` | Translate |
| `deadline tone` | Tone |
| `deadline headline` | Headline |
| `deadline outline` | Outline |
| `deadline stats` | Summary statistics |
| `deadline export` | <fmt>       Export (json|csv|txt) |
| `deadline search` | <term>      Search entries |
| `deadline recent` | Recent activity |
| `deadline status` | Health check |
| `deadline help` | Show this help |
| `deadline version` | Show version |
| `deadline $name:` | $c entries |
| `deadline Total:` | $total entries |
| `deadline Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `deadline Version:` | v2.0.0 |
| `deadline Data` | dir: $DATA_DIR |
| `deadline Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `deadline Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `deadline Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `deadline Status:` | OK |
| `deadline [Deadline]` | draft: $input |
| `deadline Saved.` | Total draft entries: $total |
| `deadline [Deadline]` | edit: $input |
| `deadline Saved.` | Total edit entries: $total |
| `deadline [Deadline]` | optimize: $input |
| `deadline Saved.` | Total optimize entries: $total |
| `deadline [Deadline]` | schedule: $input |
| `deadline Saved.` | Total schedule entries: $total |
| `deadline [Deadline]` | hashtags: $input |
| `deadline Saved.` | Total hashtags entries: $total |
| `deadline [Deadline]` | hooks: $input |
| `deadline Saved.` | Total hooks entries: $total |
| `deadline [Deadline]` | cta: $input |
| `deadline Saved.` | Total cta entries: $total |
| `deadline [Deadline]` | rewrite: $input |
| `deadline Saved.` | Total rewrite entries: $total |
| `deadline [Deadline]` | translate: $input |
| `deadline Saved.` | Total translate entries: $total |
| `deadline [Deadline]` | tone: $input |
| `deadline Saved.` | Total tone entries: $total |
| `deadline [Deadline]` | headline: $input |
| `deadline Saved.` | Total headline entries: $total |
| `deadline [Deadline]` | outline: $input |
| `deadline Saved.` | Total outline entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/deadline/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
