---
version: "2.0.0"
name: tweet-generator
description: "Craft tweets, threads, and viral hooks with schedule tips. Use when drafting copy, editing threads, optimizing engagement, scheduling posts."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Tweet Generator

A content creation toolkit for social media writers. Draft tweets, edit copy, optimize for engagement, schedule posts, generate hashtags, craft hooks, write CTAs, rewrite content, translate text, adjust tone, create headlines, and build outlines — all with local logging and history.

## Commands

| Command | Description |
|---------|-------------|
| `draft <text>` | Draft a tweet or content piece (saves to log; no args shows recent drafts) |
| `edit <text>` | Edit and refine existing content |
| `optimize <text>` | Optimize content for engagement and reach |
| `schedule <text>` | Log a scheduled post with timestamp |
| `hashtags <text>` | Generate or log hashtag ideas for content |
| `hooks <text>` | Craft attention-grabbing opening hooks |
| `cta <text>` | Create call-to-action lines |
| `rewrite <text>` | Rewrite content in a different style or angle |
| `translate <text>` | Translate content to another language |
| `tone <text>` | Adjust the tone of content (formal, casual, urgent, etc.) |
| `headline <text>` | Generate headline variations |
| `outline <text>` | Build a content outline or structure |
| `stats` | Show summary statistics across all command logs |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `search <term>` | Search across all logs for a keyword |
| `recent` | Show the 20 most recent activity entries |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show all available commands |
| `version` | Display current version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/tweet-generator/`:

- **`draft.log`**, **`edit.log`**, **`optimize.log`**, etc. — One log file per command, storing timestamped entries in `YYYY-MM-DD HH:MM|content` format
- **`history.log`** — Global activity log tracking every command executed
- **`export.json`** / **`export.csv`** / **`export.txt`** — Generated export files

Each command called without arguments shows the 20 most recent entries from its log. Data never leaves your machine.

## Requirements

- **Bash** ≥ 4.0 (uses `set -euo pipefail` and `local` variables)
- **coreutils** — `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `mkdir`
- No API keys, no internet connection, no external dependencies

## When to Use

1. **Daily content creation** — Use `draft` to capture tweet ideas throughout the day, then `edit` and `optimize` before posting
2. **Content calendar planning** — Use `schedule` to log planned posts with timestamps, then `recent` to review upcoming content
3. **Engagement optimization** — Use `hashtags`, `hooks`, and `cta` to systematically improve each piece of content before publishing
4. **Multilingual content** — Use `translate` and `tone` to adapt content for different audiences and platforms
5. **Content audit and analysis** — Use `stats` to see your output volume, `search` to find past content on a topic, and `export` to back up everything

## Examples

```bash
# Draft a new tweet
tweet-generator draft "Just shipped v2.0 — faster, cleaner, better. Here's what changed:"

# Optimize content for engagement
tweet-generator optimize "We just launched our new product"

# Generate hashtag ideas
tweet-generator hashtags "AI productivity tools for developers"

# Craft an opening hook
tweet-generator hooks "Why most startups fail at content marketing"

# Rewrite in a different style
tweet-generator rewrite "Our Q4 results exceeded expectations by 40%"

# View all recent activity
tweet-generator recent

# Export everything as JSON
tweet-generator export json

# Search for past content about a topic
tweet-generator search "product launch"

# Check tool health and stats
tweet-generator status
tweet-generator stats
```

## Tips

- Every command doubles as a log — call it with text to save, call it empty to review history
- Use `export json` periodically to back up your content library
- Chain commands: `draft` → `edit` → `optimize` → `hashtags` for a complete workflow
- Use `search` to find and repurpose old content ideas
- `stats` gives you a bird's-eye view of your content output over time

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
