---
version: "2.0.0"
name: linkedin-post
description: "LinkedIn文案生成、开头Hook、热门话题标签、轮播内容规划、高质量评论、个人简介优化。LinkedIn post writer with hooks, hashtags, carousel planning, comment templates."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# LinkedIn Post

Content toolkit for drafting, editing, optimizing, scheduling, and managing LinkedIn posts from the command line. Generate hashtags, craft hooks, write CTAs, rewrite content, translate text, adjust tone, create headlines, and build outlines — all with timestamped logging and full export capabilities.

## Commands

| Command | Description |
|---------|-------------|
| `linkedin-post draft <input>` | Draft a new post (view recent drafts with no args) |
| `linkedin-post edit <input>` | Log an edit entry (view recent edits with no args) |
| `linkedin-post optimize <input>` | Log an optimization note (view recent with no args) |
| `linkedin-post schedule <input>` | Schedule a post (view recent schedules with no args) |
| `linkedin-post hashtags <input>` | Log hashtag ideas (view recent with no args) |
| `linkedin-post hooks <input>` | Log opening hooks (view recent with no args) |
| `linkedin-post cta <input>` | Log call-to-action ideas (view recent with no args) |
| `linkedin-post rewrite <input>` | Log a rewrite (view recent rewrites with no args) |
| `linkedin-post translate <input>` | Log a translation (view recent with no args) |
| `linkedin-post tone <input>` | Log tone adjustments (view recent with no args) |
| `linkedin-post headline <input>` | Log headline ideas (view recent with no args) |
| `linkedin-post outline <input>` | Log post outlines (view recent with no args) |
| `linkedin-post stats` | Show summary statistics across all log files |
| `linkedin-post export <fmt>` | Export all data (json, csv, or txt) |
| `linkedin-post search <term>` | Search all logs for a keyword |
| `linkedin-post recent` | Show the 20 most recent history entries |
| `linkedin-post status` | Health check with version, entries, disk usage |
| `linkedin-post help` | Show help message |
| `linkedin-post version` | Show version (v2.0.0) |

### How Data Commands Work

Each content command (draft, edit, optimize, schedule, hashtags, hooks, cta, rewrite, translate, tone, headline, outline) operates in two modes:

- **With arguments** — saves a timestamped entry (`YYYY-MM-DD HH:MM|value`) to the command's `.log` file and records the action in `history.log`
- **Without arguments** — displays the 20 most recent entries from that command's log file

### Utility Commands

- **stats** — iterates all `.log` files in the data directory, counts entries per category, and shows total count, disk usage, and earliest activity timestamp
- **export `<fmt>`** — exports all log data into `json`, `csv`, or `txt` format, saved to `~/.local/share/linkedin-post/export.<fmt>`. Reports output file path and byte count.
- **search `<term>`** — performs case-insensitive search across all log files, grouped by category
- **recent** — shows the last 20 lines from `history.log`
- **status** — health check displaying version, data directory, total entry count, disk usage, last activity, and OK status

## Data Storage

All data is stored in `~/.local/share/linkedin-post/`:

- Each command has its own log file (e.g., `draft.log`, `edit.log`, `hashtags.log`, `hooks.log`, etc.)
- `history.log` — centralized activity log recording every command invocation
- Export files saved as `export.json`, `export.csv`, or `export.txt`
- Entries use pipe-delimited format: `YYYY-MM-DD HH:MM|value`

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`
- No external dependencies or API keys required

## When to Use

1. **Drafting LinkedIn posts** — use `linkedin-post draft` to capture post ideas and first drafts as they come to you
2. **Crafting engaging hooks** — log attention-grabbing opening lines with `linkedin-post hooks` and iterate until you find the best one
3. **Managing hashtag strategy** — track and organize hashtag sets with `linkedin-post hashtags` for consistent post tagging
4. **Scheduling content calendars** — use `linkedin-post schedule` to plan when posts go live and maintain a publishing cadence
5. **Iterating on post quality** — use `linkedin-post rewrite`, `linkedin-post tone`, and `linkedin-post optimize` to refine content through multiple revisions

## Examples

```bash
# Draft a new post
linkedin-post draft "5 lessons I learned from shipping my first SaaS product in 30 days"

# Log hook ideas for the post
linkedin-post hooks "I almost quit on day 14. Here's why I didn't."
linkedin-post hooks "Most founders get this wrong about MVPs..."

# Add hashtag ideas
linkedin-post hashtags "#SaaS #StartupLife #ProductLaunch #IndieHacker #BuildInPublic"

# Write a CTA
linkedin-post cta "Drop a 🔥 if you've shipped something this month. I'll check out your project."

# Schedule the post
linkedin-post schedule "Publish Tuesday 9am EST — peak LinkedIn engagement window"

# Rewrite with different tone
linkedin-post rewrite "Shorter version: cut intro, lead with the lesson, end with question"
linkedin-post tone "Switch from formal to conversational — more 'you' and 'I', fewer buzzwords"

# Create a headline
linkedin-post headline "From Zero to $10K MRR: What Actually Worked"

# Build an outline
linkedin-post outline "1) Hook: surprising stat 2) Problem 3) 3 key lessons 4) CTA question"

# Translate for different audience
linkedin-post translate "Spanish version for LATAM LinkedIn audience"

# View summary statistics
linkedin-post stats

# Export everything as JSON
linkedin-post export json

# Search for all posts about SaaS
linkedin-post search "SaaS"

# Check system status
linkedin-post status

# View recent activity
linkedin-post recent
```

## LinkedIn Best Practices

- **First 3 lines are everything** — the "see more" hook determines whether people engage
- **Dwell time matters** — longer posts that keep people reading get boosted by the algorithm
- **Comments > Reactions** — posts with comments rank higher than those with just likes
- **Avoid external links in post body** — put URLs in the first comment instead
- **Carousel posts** get 1.5–2× more reach than text-only posts
- Use `linkedin-post hooks` to iterate on your opening lines before publishing

## Tips

- Run `linkedin-post help` to see all available commands
- Call any command without arguments to review recent entries for that category
- Use `linkedin-post search <term>` to find entries across all log files
- Export data regularly with `linkedin-post export json` for backups
- Combine `draft` → `hooks` → `hashtags` → `cta` → `optimize` as a content creation pipeline
- All data lives in `~/.local/share/linkedin-post/` — easy to back up or sync

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
