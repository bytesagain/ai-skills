---
version: "2.0.0"
name: instagram-caption
description: "Instagram文案、精准Hashtag(30个)、Story脚本、Reels脚本、简介优化、内容日历。Instagram caption writer with hashtags, Story scripts, Reels scripts, bio optimization."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Instagram Caption

A content creation toolkit for Instagram workflows. Draft captions, edit text, optimize posts, schedule content, generate hashtags, write hooks, create CTAs, rewrite copy, translate captions, adjust tone, craft headlines, and build outlines — all logged with timestamps and exportable in multiple formats.

## Commands

| Command | Description |
|---------|-------------|
| `draft [input]` | Draft a new caption or content idea. Without input, shows the 20 most recent draft entries |
| `edit [input]` | Log an edit or revision to existing content. Without input, shows recent edits |
| `optimize [input]` | Log an optimization note (e.g., engagement improvements). Without input, shows recent entries |
| `schedule [input]` | Log a scheduling entry (e.g., post date/time). Without input, shows recent schedule entries |
| `hashtags [input]` | Log hashtag sets for posts. Without input, shows recent hashtag entries |
| `hooks [input]` | Log attention-grabbing opening hooks. Without input, shows recent hooks |
| `cta [input]` | Log call-to-action text. Without input, shows recent CTAs |
| `rewrite [input]` | Log a content rewrite or alternative version. Without input, shows recent rewrites |
| `translate [input]` | Log a translation of caption content. Without input, shows recent translations |
| `tone [input]` | Log a tone adjustment note (e.g., casual, professional). Without input, shows recent tone entries |
| `headline [input]` | Log a headline or title idea. Without input, shows recent headlines |
| `outline [input]` | Log a content outline or structure. Without input, shows recent outlines |
| `stats` | Show summary statistics — entry counts per category, total entries, data size, and first activity date |
| `export <fmt>` | Export all data to a file in `json`, `csv`, or `txt` format |
| `search <term>` | Search across all content categories for a keyword or phrase |
| `recent` | Show the 20 most recent history entries across all categories |
| `status` | Health check — version, data dir, total entries, disk usage, last activity |
| `help` | Show all available commands |
| `version` | Display current version (v2.0.0) |

## Data Storage

- **Data directory:** `~/.local/share/instagram-caption/`
- **Category logs:** Each command stores entries in its own log file (e.g., `draft.log`, `hashtags.log`, `schedule.log`)
- **History log:** `history.log` — unified timeline of all activity with timestamps
- **Export files:** `export.json`, `export.csv`, or `export.txt` generated on demand
- All data is stored locally in plain text; no Instagram API access or external accounts required

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard POSIX utilities (`date`, `wc`, `du`, `grep`, `tail`, `head`, `cat`)
- No API keys, no Instagram login, no external dependencies

## When to Use

1. **Brainstorming caption ideas** — use `draft` to quickly log caption concepts as they come to mind, then review them later before posting
2. **Building a hashtag library** — use `hashtags` to save curated hashtag sets for different content themes, then search them with `search`
3. **Content planning and scheduling** — use `schedule` to log planned post dates and `outline` to structure upcoming content series
4. **A/B testing copy** — use `rewrite` to log alternative versions of the same caption, then `compare` performance notes later
5. **Multi-language content** — use `translate` to log translated versions of captions for international audiences, with `tone` adjustments per locale

## Examples

```bash
# Draft a new caption idea
instagram-caption draft "Golden hour vibes ☀️ — chasing light and good energy"

# Save a hashtag set for travel content
instagram-caption hashtags "#travel #wanderlust #explore #adventure #travelgram"

# Log a scheduled post
instagram-caption schedule "March 20, 6:00 PM — carousel post about productivity tips"

# Write a hook for a reel
instagram-caption hooks "Stop scrolling — this 3-second trick will change your morning routine"

# Export all content data to JSON
instagram-caption export json
```

### Example Output

```
$ instagram-caption draft "Sunday reset routine ✨"
  [Instagram Caption] draft: Sunday reset routine ✨
  Saved. Total draft entries: 15

$ instagram-caption stats
=== Instagram Caption Stats ===
  draft: 15 entries
  hashtags: 8 entries
  hooks: 6 entries
  schedule: 12 entries
  ---
  Total: 41 entries
  Data size: 24K
  Since: 03-10 14:30

$ instagram-caption status
=== Instagram Caption Status ===
  Version: v2.0.0
  Data dir: /home/user/.local/share/instagram-caption
  Entries: 41 total
  Disk: 24K
  Last activity: 03-18 11:22 draft: Sunday reset routine ✨
  Status: OK
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
