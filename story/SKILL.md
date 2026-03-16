---
name: "Story"
description: "Terminal-first Story manager. Keep your content creation data organized with simple commands."
version: "2.0.0"
author: "BytesAgain"
tags: ["story", "content", "marketing", "copywriting", "creative"]
---

# Story

Terminal-first Story manager. Keep your content creation data organized with simple commands.

## Why Story?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
story help

# Check current status
story status

# View your statistics
story stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `story draft` | Draft |
| `story edit` | Edit |
| `story optimize` | Optimize |
| `story schedule` | Schedule |
| `story hashtags` | Hashtags |
| `story hooks` | Hooks |
| `story cta` | Cta |
| `story rewrite` | Rewrite |
| `story translate` | Translate |
| `story tone` | Tone |
| `story headline` | Headline |
| `story outline` | Outline |
| `story stats` | Summary statistics |
| `story export` | <fmt>       Export (json|csv|txt) |
| `story search` | <term>      Search entries |
| `story recent` | Recent activity |
| `story status` | Health check |
| `story help` | Show this help |
| `story version` | Show version |
| `story $name:` | $c entries |
| `story Total:` | $total entries |
| `story Data` | size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `story Version:` | v2.0.0 |
| `story Data` | dir: $DATA_DIR |
| `story Entries:` | $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total |
| `story Disk:` | $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1) |
| `story Last:` | $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never) |
| `story Status:` | OK |
| `story [Story]` | draft: $input |
| `story Saved.` | Total draft entries: $total |
| `story [Story]` | edit: $input |
| `story Saved.` | Total edit entries: $total |
| `story [Story]` | optimize: $input |
| `story Saved.` | Total optimize entries: $total |
| `story [Story]` | schedule: $input |
| `story Saved.` | Total schedule entries: $total |
| `story [Story]` | hashtags: $input |
| `story Saved.` | Total hashtags entries: $total |
| `story [Story]` | hooks: $input |
| `story Saved.` | Total hooks entries: $total |
| `story [Story]` | cta: $input |
| `story Saved.` | Total cta entries: $total |
| `story [Story]` | rewrite: $input |
| `story Saved.` | Total rewrite entries: $total |
| `story [Story]` | translate: $input |
| `story Saved.` | Total translate entries: $total |
| `story [Story]` | tone: $input |
| `story Saved.` | Total tone entries: $total |
| `story [Story]` | headline: $input |
| `story Saved.` | Total headline entries: $total |
| `story [Story]` | outline: $input |
| `story Saved.` | Total outline entries: $total |

## Data Storage

All data is stored locally at `~/.local/share/story/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
