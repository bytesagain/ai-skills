---
version: "2.0.0"
name: movie-review
description: "Write film reviews, get recommendations, and manage watchlists with spoiler control. Use when drafting reviews, getting recs, comparing films side by side."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Movie Review

A content toolkit for movie reviews. Draft reviews, edit text, optimize for SEO, schedule posts, generate hashtags, create hooks, write CTAs, rewrite content, translate, adjust tone, craft headlines, and build outlines — all from the command line with persistent local storage.

## Commands

### Content Creation

| Command | Description | Usage |
|---------|-------------|-------|
| `draft` | Draft a new movie review or content piece | `movie-review draft <text>` |
| `edit` | Edit and refine existing review text | `movie-review edit <text>` |
| `rewrite` | Rewrite content with a fresh perspective | `movie-review rewrite <text>` |
| `outline` | Build a structured outline for a review | `movie-review outline <text>` |
| `headline` | Craft compelling headlines for reviews | `movie-review headline <text>` |

### Optimization & Publishing

| Command | Description | Usage |
|---------|-------------|-------|
| `optimize` | Optimize content for readability and SEO | `movie-review optimize <text>` |
| `schedule` | Schedule review content for publishing | `movie-review schedule <text>` |
| `hashtags` | Generate relevant hashtags for social media | `movie-review hashtags <text>` |
| `hooks` | Create attention-grabbing opening hooks | `movie-review hooks <text>` |
| `cta` | Write call-to-action lines for engagement | `movie-review cta <text>` |

### Content Transformation

| Command | Description | Usage |
|---------|-------------|-------|
| `translate` | Translate review content to other languages | `movie-review translate <text>` |
| `tone` | Adjust the tone of writing (formal, casual, etc.) | `movie-review tone <text>` |

### Data & Management

| Command | Description | Usage |
|---------|-------------|-------|
| `stats` | Show summary statistics across all entries | `movie-review stats` |
| `export <fmt>` | Export data in json, csv, or txt format | `movie-review export json` |
| `search <term>` | Search across all stored entries | `movie-review search "Nolan"` |
| `recent` | Show the 20 most recent activity entries | `movie-review recent` |
| `status` | Health check — version, disk usage, last activity | `movie-review status` |
| `help` | Show the built-in help message | `movie-review help` |
| `version` | Print the current version (v2.0.0) | `movie-review version` |

Each content command (draft, edit, optimize, etc.) works in two modes:

- **Without arguments** — displays the most recent 20 entries from that command's log
- **With arguments** — saves the input with a timestamp and logs it to history

## Data Storage

All data is stored locally in `~/.local/share/movie-review/`:

- Each command writes to its own log file (e.g., `draft.log`, `edit.log`, `hashtags.log`)
- A unified `history.log` tracks all activity across commands
- Entries are timestamped in `YYYY-MM-DD HH:MM|<content>` format
- Export supports JSON, CSV, and plain text formats

## Requirements

- Bash (any modern version)
- No external dependencies — pure shell script
- Works on Linux and macOS

## When to Use

1. **Drafting a movie review** — use `draft` to capture your initial thoughts, then `edit` and `rewrite` to polish
2. **Preparing social media posts** — use `hashtags`, `hooks`, and `cta` to create engaging content around your review
3. **Planning a review series** — use `outline` to structure your content and `schedule` to plan publishing dates
4. **Optimizing for reach** — use `optimize` for SEO, `headline` for click-worthy titles, and `tone` to match your audience
5. **Tracking your review portfolio** — use `stats` to see totals, `recent` for latest activity, and `export` to back up everything

## Examples

```bash
# Draft a new review
movie-review draft "Inception (2010) - Nolan's masterpiece of layered storytelling"

# Generate hashtags for social media
movie-review hashtags "Inception review sci-fi thriller Christopher Nolan"

# Create an attention-grabbing hook
movie-review hooks "What if the greatest heist movie ever made took place inside your mind?"

# Write a call-to-action
movie-review cta "Share your favorite Nolan film in the comments"

# Export all data as JSON
movie-review export json

# Search for all entries mentioning a director
movie-review search "Nolan"

# Check overall statistics
movie-review stats
```

## Output

All content commands print a confirmation with the saved entry and a running total count. Data management commands (stats, status, export) output structured summaries. Use `export json` for machine-readable output.

## Configuration

Set `DATA_DIR` by editing the script or symlinking `~/.local/share/movie-review/` to your preferred location.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
