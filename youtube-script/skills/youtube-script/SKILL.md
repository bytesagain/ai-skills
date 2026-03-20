---
version: "2.0.0"
name: youtube-script
description: "YouTube视频脚本、标题A/B测试、缩略图文案、SEO优化、开头Hook、章节标记。YouTube script writer with title testing, thumbnail copy, SEO optimization, hooks."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# YouTube Script

YouTube content creation toolkit — draft scripts, edit copy, optimize for SEO, schedule uploads, generate hashtags, craft hooks, write CTAs, rewrite content, translate, adjust tone, create headlines, and build outlines. All operations are logged with timestamps for tracking your content workflow.

## Core Features

- 📝 **Draft & Edit** — Write and refine video scripts from scratch
- 🔍 **SEO Optimize** — Improve discoverability with keyword optimization
- 🎣 **Hooks & CTAs** — Craft attention-grabbing openings and effective calls-to-action
- 📅 **Schedule** — Plan and track your upload calendar
- #️⃣ **Hashtags** — Generate relevant hashtags for reach
- 🔄 **Rewrite & Translate** — Repurpose content across styles and languages
- 🎯 **Tone & Headlines** — Fine-tune voice and create click-worthy titles
- 📋 **Outline** — Build structured video outlines before scripting
- 📊 **Stats & Export** — Track usage and export data in multiple formats

## Commands

### Content Creation

| Command | Usage | Description |
|---------|-------|-------------|
| `draft` | `youtube-script draft <input>` | Draft a new video script or section |
| `edit` | `youtube-script edit <input>` | Edit and refine existing script content |
| `rewrite` | `youtube-script rewrite <input>` | Rewrite content in a different style or angle |
| `outline` | `youtube-script outline <input>` | Build a structured outline for a video |
| `headline` | `youtube-script headline <input>` | Generate click-worthy video titles |
| `hooks` | `youtube-script hooks <input>` | Craft attention-grabbing opening lines |
| `cta` | `youtube-script cta <input>` | Write effective calls-to-action |

### Optimization & Distribution

| Command | Usage | Description |
|---------|-------|-------------|
| `optimize` | `youtube-script optimize <input>` | Optimize script for watch time and retention |
| `hashtags` | `youtube-script hashtags <input>` | Generate relevant hashtags for the video |
| `tone` | `youtube-script tone <input>` | Adjust the tone/voice of the script |
| `translate` | `youtube-script translate <input>` | Translate script to another language |
| `schedule` | `youtube-script schedule <input>` | Plan upload timing and track schedule |

### Data & Management

| Command | Usage | Description |
|---------|-------|-------------|
| `stats` | `youtube-script stats` | Show summary statistics (entries per type, total, disk usage) |
| `export` | `youtube-script export <fmt>` | Export all data (json, csv, or txt format) |
| `search` | `youtube-script search <term>` | Search across all logged entries |
| `recent` | `youtube-script recent` | Show last 20 activity log entries |
| `status` | `youtube-script status` | Health check — version, data dir, entry count, last activity |
| `help` | `youtube-script help` | Show all available commands |
| `version` | `youtube-script version` | Print version number |

## Data Storage

All data is stored locally in `~/.local/share/youtube-script/`:

- `draft.log` — Script draft history
- `edit.log` — Edit operation history
- `optimize.log` — Optimization history
- `schedule.log` — Upload schedule tracking
- `hashtags.log` — Hashtag generation history
- `hooks.log` — Hook/opening line history
- `cta.log` — Call-to-action history
- `rewrite.log` — Rewrite operation history
- `translate.log` — Translation history
- `tone.log` — Tone adjustment history
- `headline.log` — Headline generation history
- `outline.log` — Outline history
- `history.log` — Master activity log (all operations)
- `export.{json,csv,txt}` — Exported data files

Each entry is timestamped (`YYYY-MM-DD HH:MM|value`) for full traceability.

## Requirements

- Bash 4.0+
- Standard Unix tools (`wc`, `du`, `grep`, `head`, `tail`, `date`)
- No external dependencies or network access required
- Works on Linux and macOS

## When to Use

1. **Starting a new video** — Use `outline` to structure ideas, then `draft` to write the full script
2. **Improving watch time** — Use `hooks` for a strong opening and `optimize` for retention improvements
3. **Repurposing content** — Use `rewrite` to adapt a script for a different audience or `translate` for other languages
4. **Planning upload cadence** — Use `schedule` to track your content calendar and maintain consistency
5. **Boosting discoverability** — Use `hashtags` and `headline` to maximize search visibility and CTR

## Examples

```bash
# Draft a new video script
youtube-script draft "10 Tips for Better Thumbnails"

# Generate attention-grabbing hooks
youtube-script hooks "Why 90% of YouTubers fail in year one"

# Create a structured outline
youtube-script outline "Complete Guide to YouTube SEO"

# Generate headlines for A/B testing
youtube-script headline "How I grew to 100K subscribers"

# Optimize a script for retention
youtube-script optimize "Remove filler words and tighten pacing"

# Generate hashtags
youtube-script hashtags "productivity tips for creators"

# Write a call-to-action
youtube-script cta "Subscribe and hit the bell for weekly uploads"

# View usage statistics
youtube-script stats

# Export all data as JSON
youtube-script export json

# Check system status
youtube-script status
```

## Pro Tips

- **First 30 seconds decide everything** — Viewers stay or bounce based on your opening hook
- **CTR + Watch Time** are the two most important metrics for the algorithm
- **Aim for 50%+ Average View Duration** — structure your script to maintain interest throughout
- **Thumbnails drive CTR more than titles** — pair `headline` with strong visual design
- **Consistency matters** — use `schedule` to maintain a regular upload cadence

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
