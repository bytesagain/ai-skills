---
name: caption
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [caption, tool, utility]
description: "Generate captions for images, videos, and social media posts. Use when writing post captions, creating accessibility text, or batch-processing media."
---

# Caption

Caption is a content toolkit for drafting, editing, optimizing, and managing written content directly from the terminal. It tracks every entry with timestamps and supports searching, exporting, and reviewing your content history.

## Commands

| Command | Description |
|---------|-------------|
| `caption draft <text>` | Save a draft entry (no args = show recent drafts) |
| `caption edit <text>` | Save an edit entry (no args = show recent edits) |
| `caption optimize <text>` | Save an optimization note (no args = show recent) |
| `caption schedule <text>` | Schedule content for publishing (no args = show recent) |
| `caption hashtags <text>` | Save hashtag sets (no args = show recent) |
| `caption hooks <text>` | Save hook ideas (no args = show recent) |
| `caption cta <text>` | Save call-to-action text (no args = show recent) |
| `caption rewrite <text>` | Save rewritten content (no args = show recent) |
| `caption translate <text>` | Save translated content (no args = show recent) |
| `caption tone <text>` | Save tone-adjusted content (no args = show recent) |
| `caption headline <text>` | Save headline variations (no args = show recent) |
| `caption outline <text>` | Save content outlines (no args = show recent) |
| `caption stats` | Show summary statistics across all categories |
| `caption export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `caption search <term>` | Search across all logs for a term |
| `caption recent` | Show the 20 most recent activities |
| `caption status` | Health check — version, disk usage, entry counts |
| `caption help` | Show all available commands |
| `caption version` | Show version |

## How It Works

Caption organizes content into separate log files by category (e.g., `draft.log`, `hooks.log`, `tone.log`). Each entry is timestamped and appended to the appropriate log. Running a command without arguments shows the 20 most recent entries for that category.

All actions are also recorded in `history.log` for a unified activity timeline.

## Data Storage

All data is stored locally in `~/.local/share/caption/` by default:

- `draft.log`, `edit.log`, `optimize.log`, etc. — Category-specific entry logs
- `history.log` — Unified timestamped activity log
- `export.json`, `export.csv`, `export.txt` — Generated export files

Each log entry uses the format: `YYYY-MM-DD HH:MM|<content>`

## Requirements

- **bash 4+** (uses `set -euo pipefail` for strict mode)
- Standard Unix tools (`grep`, `wc`, `du`, `tail`, `head`)
- No API keys needed
- No external dependencies

## When to Use

1. **Drafting social media captions** — Use `caption draft` to quickly log caption ideas as they come to you, then review with `caption draft` (no args)
2. **Managing hashtag collections** — Save curated hashtag sets with `caption hashtags` and search them later with `caption search`
3. **Content optimization workflow** — Chain `caption draft` → `caption edit` → `caption optimize` → `caption rewrite` to track your content refinement pipeline
4. **Scheduling and planning posts** — Use `caption schedule` to log planned publication dates alongside content
5. **Exporting content for other tools** — Run `caption export json` to get structured data for import into social media schedulers or CMS platforms

## Examples

```bash
# Draft a new caption
caption draft "Exploring the hidden trails of Hangzhou 🌿 #nature #hiking"

# View recent drafts
caption draft

# Save a set of hashtags
caption hashtags "#tech #ai #machinelearning #coding #devlife"

# Write a call-to-action
caption cta "Drop a 🔥 if you agree — link in bio for more!"
```

```bash
# Search for anything mentioning "hiking"
caption search hiking

# Export everything as JSON
caption export json

# Export as CSV for spreadsheet analysis
caption export csv

# Check overall stats
caption stats
```

```bash
# Save a headline variation
caption headline "10 Things I Wish I Knew About Content Creation"

# Save a content outline
caption outline "Intro → Problem → 3 Tips → CTA → Outro"

# Adjust tone
caption tone "More casual and conversational version of the launch post"

# View recent activity across all categories
caption recent

# Health check
caption status
```

## Output

All command output goes to stdout. Export files are saved to the data directory. Redirect output as needed:

```bash
caption stats > content-report.txt
```

## Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `CAPTION_DIR` | Override data directory | `~/.local/share/caption/` |

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
