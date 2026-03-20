---
version: "2.0.0"
name: podcast-notes
description: "播客大纲、Show Notes生成、开场白、嘉宾问题、变现策略、分发渠道。Podcast assistant with outlines, show notes, intro scripts, guest questions, monetization strategies."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Podcast Notes

A content creation toolkit for podcast producers. Podcast Notes provides 12 dedicated commands for drafting show notes, editing content, optimizing text, scheduling episodes, generating hashtags, writing hooks, creating CTAs, rewriting copy, translating content, adjusting tone, crafting headlines, and building outlines — all backed by timestamped log files.

## Commands

| Command | Description |
|---------|-------------|
| `podcast-notes draft <input>` | Draft show notes or episode content. Without args, shows recent draft entries. |
| `podcast-notes edit <input>` | Log an edit pass on existing content (corrections, restructuring). Without args, shows recent edit entries. |
| `podcast-notes optimize <input>` | Record SEO or engagement optimization notes (keywords, structure). Without args, shows recent optimize entries. |
| `podcast-notes schedule <input>` | Log scheduling decisions (publish date, release cadence). Without args, shows recent schedule entries. |
| `podcast-notes hashtags <input>` | Save hashtag sets for episodes or social media promotion. Without args, shows recent hashtag entries. |
| `podcast-notes hooks <input>` | Record attention-grabbing hooks for episode intros or social clips. Without args, shows recent hook entries. |
| `podcast-notes cta <input>` | Save call-to-action copy (subscribe prompts, review requests, links). Without args, shows recent CTA entries. |
| `podcast-notes rewrite <input>` | Log rewritten versions of content for A/B testing or improvement. Without args, shows recent rewrite entries. |
| `podcast-notes translate <input>` | Record translated content or translation notes for multi-language episodes. Without args, shows recent translate entries. |
| `podcast-notes tone <input>` | Log tone adjustment notes (casual, professional, energetic, storytelling). Without args, shows recent tone entries. |
| `podcast-notes headline <input>` | Save episode title ideas and headline variations. Without args, shows recent headline entries. |
| `podcast-notes outline <input>` | Record episode outlines with segments, timing, and topic flow. Without args, shows recent outline entries. |
| `podcast-notes stats` | Show summary statistics across all categories — entry counts per log file, total entries, and data size. |
| `podcast-notes export <fmt>` | Export all data to a file. Supported formats: `json`, `csv`, `txt`. |
| `podcast-notes search <term>` | Search across all log files for a keyword (case-insensitive). |
| `podcast-notes recent` | Show the 20 most recent entries from the activity history log. |
| `podcast-notes status` | Health check — version, data directory, total entries, disk usage, last activity. |
| `podcast-notes help` | Display the full help message with all available commands. |
| `podcast-notes version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored as plain-text log files in `~/.local/share/podcast-notes/`:

- Each command writes to its own log file (e.g. `draft.log`, `hashtags.log`, `outline.log`)
- Every action is also recorded in `history.log` with a timestamp
- Entries use the format `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)
- Export produces files at `~/.local/share/podcast-notes/export.{json,csv,txt}`
- No database required — all data is grep-friendly and human-readable

## Requirements

- **Bash 4+** (uses `set -euo pipefail`)
- **Standard Unix utilities**: `date`, `wc`, `du`, `head`, `tail`, `grep`, `cat`, `cut`
- **No external dependencies** — pure bash, no Python, no API keys
- Works on **Linux** and **macOS**

## When to Use

1. **Episode pre-production** — Use `outline` to structure your episode segments, `hooks` to craft an attention-grabbing intro, and `schedule` to lock in your publish date.
2. **Show notes creation** — Run `draft` to write initial show notes, `edit` to refine them, and `optimize` with SEO keywords for better discoverability.
3. **Social media promotion** — Use `hashtags` to generate tag sets, `headline` to test different episode titles, and `cta` to create share-worthy call-to-action copy.
4. **Multi-language distribution** — Log `translate` entries for episode descriptions in different languages, and `tone` to adjust the style for different regional audiences.
5. **Content repurposing** — Use `rewrite` to transform episode content into blog posts, newsletters, or social clips, keeping all versions tracked with timestamps.

## Examples

```bash
# Draft show notes for a new episode
podcast-notes draft "Ep 42: Interview with Jane on AI trends — key topics: LLMs, agents, open source"

# Create a hook for the episode intro
podcast-notes hooks "What if your AI assistant could actually think? Today we talk to someone building exactly that."

# Save hashtag ideas for social promotion
podcast-notes hashtags "#podcast #AI #LLM #techtalks #futureofwork #ep42"

# Log an episode outline with segments
podcast-notes outline "Intro (2min) -> Guest intro (3min) -> Topic 1: LLMs (10min) -> Topic 2: Agents (10min) -> Q&A (5min) -> Outro (2min)"

# Export all content to JSON for your CMS
podcast-notes export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
