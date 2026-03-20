---
name: blog
version: "2.0.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [blog, tool, utility]
description: "Manage blog posts with drafts, scheduling, and SEO optimization. Use when creating articles, optimizing metadata, or scheduling publication dates."
---

# Blog

A content creation toolkit for drafting, editing, optimizing, scheduling, and managing blog content workflows — all from the command line with timestamped local logging.

## Commands

| Command | Description |
|---------|-------------|
| `blog draft <input>` | Log a draft idea or snippet. Without args, shows recent drafts |
| `blog edit <input>` | Record an editing pass or revision note. Without args, shows recent edits |
| `blog optimize <input>` | Log SEO or content optimization notes. Without args, shows recent optimizations |
| `blog schedule <input>` | Record a publication schedule entry. Without args, shows recent schedules |
| `blog hashtags <input>` | Log hashtag sets for social promotion. Without args, shows recent hashtag entries |
| `blog hooks <input>` | Record attention hooks or opening lines. Without args, shows recent hooks |
| `blog cta <input>` | Log call-to-action ideas. Without args, shows recent CTAs |
| `blog rewrite <input>` | Record a rewrite or major revision. Without args, shows recent rewrites |
| `blog translate <input>` | Log a translation task or result. Without args, shows recent translations |
| `blog tone <input>` | Record tone/voice notes for a piece. Without args, shows recent tone entries |
| `blog headline <input>` | Log headline options and A/B test ideas. Without args, shows recent headlines |
| `blog outline <input>` | Record a post outline or structure. Without args, shows recent outlines |
| `blog stats` | Show summary statistics across all entry types |
| `blog search <term>` | Search across all log entries for a keyword |
| `blog recent` | Show the 20 most recent activity entries |
| `blog status` | Health check — version, data dir, entry count, disk usage, last activity |
| `blog export <fmt>` | Export all data in json, csv, or txt format |
| `blog help` | Show all available commands |
| `blog version` | Print version (v2.0.0) |

Each content command (draft, edit, optimize, etc.) works the same way:
- **With arguments**: saves the entry with a timestamp to its dedicated `.log` file and records it in activity history
- **Without arguments**: displays the 20 most recent entries from that command's log

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/blog/
├── draft.log           # Draft ideas and snippets
├── edit.log            # Editing notes and revisions
├── optimize.log        # SEO / content optimization records
├── schedule.log        # Publication schedule entries
├── hashtags.log        # Hashtag sets for social media
├── hooks.log           # Attention hooks / opening lines
├── cta.log             # Call-to-action ideas
├── rewrite.log         # Major revision records
├── translate.log       # Translation tasks and results
├── tone.log            # Tone / voice notes
├── headline.log        # Headline options and A/B ideas
├── outline.log         # Post outlines and structures
└── history.log         # Unified activity log with timestamps
```

Each entry is stored as `YYYY-MM-DD HH:MM|<value>` for easy parsing and export.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities: `date`, `wc`, `du`, `grep`, `head`, `tail`, `cat`
- No external dependencies or API keys required
- Runs without internet — all data stays on your machine

## When to Use

1. **Blog content pipeline** — Track a post from draft → outline → edit → optimize → schedule in one place with timestamps, so you always know where each piece stands
2. **SEO workflow** — Log optimization notes, headline variants, and hashtag sets for each post, then search or export them later for analysis
3. **Editorial calendar** — Use `schedule` to record publication dates and `recent` to see upcoming deadlines at a glance
4. **Multi-language content** — Track translations with `translate`, tone adjustments with `tone`, and rewrites with `rewrite` to manage localized content
5. **Social media prep** — Build a library of hooks, CTAs, and hashtag sets that you can search and reuse across posts

## Examples

### Full blog post workflow

```bash
# Start with a draft idea
blog draft "10 productivity hacks for remote developers — listicle format"

# Create the outline
blog outline "Intro (hook) → 10 tips with examples → CTA → conclusion"

# Write headline options
blog headline "Option A: 10 Hacks That Actually Work | Option B: Remote Dev Productivity Guide"

# Log editing notes
blog edit "tightened intro paragraph, added code examples to tips 3 and 7"

# Optimize for SEO
blog optimize "target keyword: remote developer productivity, density 1.2%, meta desc added"

# Schedule publication
blog schedule "publish 2024-04-15 09:00 UTC — cross-post to Dev.to and Medium"
```

### Social media preparation

```bash
# Create hashtag sets
blog hashtags "#remotework #developer #productivity #coding #devtips"

# Write hooks for social posts
blog hooks "Most devs waste 2 hours daily on context switching. Here's how to fix it."

# Add a CTA
blog cta "Download our free remote work checklist — link in bio"

# Set the tone
blog tone "conversational, slightly informal, use second person (you/your)"
```

### Review and export

```bash
# Search for entries about a topic
blog search "productivity"

# View recent activity
blog recent

# Check stats across all categories
blog stats

# Export everything as JSON for backup
blog export json

# Quick health check
blog status
```

### Rewrite and translate

```bash
# Log a major rewrite
blog rewrite "complete overhaul of intro section — new angle focusing on data"

# Track a translation
blog translate "EN → ES: productivity article translated, 1800 words, reviewed by Maria"
```

## Output

All commands print confirmation to stdout. Data is persisted in `~/.local/share/blog/`. Use `blog stats` for an overview, `blog search <term>` to find specific entries, or `blog export <fmt>` to extract all data as JSON, CSV, or plain text.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
