---
name: trend
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [trend, tool, utility]
description: "Track trending topics with popularity, sentiment, and alerts. Use when drafting reports, optimizing keywords, scheduling checks, tagging hashtags."
---
# Trend

Content creation and management toolkit. Draft posts, edit content, optimize for engagement, schedule publications, generate hashtags, write hooks and CTAs, rewrite text, translate content, adjust tone, craft headlines, and build outlines. All entries are timestamped and stored locally for full traceability.

## Commands

### Content Creation

| Command | Description |
|---------|-------------|
| `trend draft [input]` | Draft new content (no args = show recent drafts) |
| `trend edit [input]` | Edit/refine content (no args = show recent edits) |
| `trend rewrite [input]` | Rewrite existing content (no args = show recent rewrites) |
| `trend headline [input]` | Craft headlines (no args = show recent headlines) |
| `trend outline [input]` | Build content outlines (no args = show recent outlines) |

### Content Optimization

| Command | Description |
|---------|-------------|
| `trend optimize [input]` | Optimize content for engagement (no args = show recent) |
| `trend hashtags [input]` | Generate hashtags (no args = show recent) |
| `trend hooks [input]` | Write attention-grabbing hooks (no args = show recent) |
| `trend cta [input]` | Create calls-to-action (no args = show recent) |
| `trend tone [input]` | Adjust content tone (no args = show recent) |

### Publishing

| Command | Description |
|---------|-------------|
| `trend schedule [input]` | Schedule content for publication (no args = show recent) |
| `trend translate [input]` | Translate content (no args = show recent translations) |

### Data & Reporting

| Command | Description |
|---------|-------------|
| `trend stats` | Summary statistics across all entry types |
| `trend export <fmt>` | Export all data (json, csv, or txt) |
| `trend search <term>` | Search across all entries |
| `trend recent` | Show last 20 activity log entries |
| `trend status` | Health check: version, entry count, disk usage, last activity |

### Utility

| Command | Description |
|---------|-------------|
| `trend help` | Show help with all commands |
| `trend version` | Show version number |

## Data Storage

All data is stored locally at `~/.local/share/trend/` by default:

- `draft.log`, `edit.log`, `optimize.log`, etc. — One log file per command type, entries are `timestamp|input` format
- `history.log` — Unified activity history with timestamps for every command run
- `export.json`, `export.csv`, `export.txt` — Generated export files

Each command supports two modes:
- **With arguments:** Saves the input with a timestamp and confirms
- **Without arguments:** Shows the 20 most recent entries for that command type

## Requirements

- bash 4+
- Standard UNIX utilities (`date`, `wc`, `du`, `grep`, `tail`, `head`, `sed`, `cut`)
- No external dependencies or API keys required

## When to Use

1. **Content drafting workflow** — Use `draft` to capture ideas, `outline` to structure them, `headline` to title them, then `edit` to refine
2. **Social media optimization** — Run `hashtags` for tags, `hooks` for attention-grabbing openers, `cta` for calls-to-action, and `tone` to match platform voice
3. **Content scheduling** — Use `schedule` to log publication timelines and `translate` to prepare multi-language versions
4. **Content audit** — Run `stats` to see activity across all content types, `search` to find specific entries, and `recent` to review the latest work
5. **Data export and backup** — Use `export json` for structured data, `export csv` for spreadsheet import, or `export txt` for readable dumps

## Examples

```bash
# Draft a new blog post idea
trend draft "10 tips for better remote work productivity"

# View all recent drafts
trend draft

# Create an outline for the post
trend outline "Intro, 10 tips with examples, conclusion with CTA"

# Craft a headline
trend headline "Remote Work Productivity: 10 Tips That Actually Work"

# Generate hashtags for social media
trend hashtags "#remotework #productivity #wfh #tipsandtricks"

# Write a hook for the post
trend hooks "Most remote workers waste 3 hours a day. Here's how to fix that."

# Create a call-to-action
trend cta "Download our free remote work checklist"

# Optimize the content
trend optimize "Added power words, shortened paragraphs, added bullet points"

# Adjust tone for LinkedIn
trend tone "Professional but approachable, data-driven"

# Schedule for publication
trend schedule "Publish Monday 9am EST on blog, noon on LinkedIn"

# Translate to another language
trend translate "Spanish version for LATAM audience"

# Rewrite an existing section
trend rewrite "Simplified the introduction, removed jargon"

# Edit the final draft
trend edit "Final proofread, fixed typos, added links"

# Check overall stats
trend stats

# Export all data as JSON
trend export json

# Search for a specific topic
trend search "productivity"

# View recent activity
trend recent

# Health check
trend status
```

## Tips

- Every command with input is automatically timestamped and logged — nothing is lost
- Run commands without arguments to review your recent entries (shows last 20)
- Use `stats` to see entry counts per command type for a bird's-eye view
- Export supports three formats: `json` (structured), `csv` (spreadsheets), `txt` (human-readable)
- All log files are plain text and can be edited or grepped directly

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
