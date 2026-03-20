---
version: "1.0.0"
name: slideshow-generator
description: "Create HTML slideshows from Markdown with live preview. Use when drafting slides, editing decks, optimizing layouts, scheduling talks, repurposing content."
---

# Slideshow Generator

Content creation and slide deck toolkit. Draft slides, edit content, optimize layouts, manage schedules, and generate headlines — all from the command line.

## Commands

Run `slideshow-generator <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `draft <input>` | Draft slide content or presentation ideas |
| `edit <input>` | Edit and refine existing slide text |
| `optimize <input>` | Optimize slide content for clarity and impact |
| `schedule <input>` | Schedule presentations or talk dates |
| `hashtags <input>` | Generate hashtags for slide content or social sharing |
| `hooks <input>` | Create attention-grabbing hooks for opening slides |
| `cta <input>` | Write calls-to-action for closing slides |
| `rewrite <input>` | Rewrite slide content in a different style |
| `translate <input>` | Translate slide text to another language |
| `tone <input>` | Adjust the tone of slide content (formal, casual, etc.) |
| `headline <input>` | Generate headlines or slide titles |
| `outline <input>` | Create presentation outlines and structure |
| `stats` | Show summary statistics across all log files |
| `export <fmt>` | Export all data (json, csv, or txt) |
| `search <term>` | Search all entries for a keyword |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data size, entry count |
| `help` | Show help message |
| `version` | Show version (v2.0.0) |

Each data command (draft, edit, optimize, schedule, hashtags, hooks, cta, rewrite, translate, tone, headline, outline) works in two modes:
- **Without arguments** — displays the 20 most recent entries from its log
- **With arguments** — saves the input with a timestamp to its dedicated log file

## Data Storage

All data is stored in `~/.local/share/slideshow-generator/`:

- `draft.log`, `edit.log`, `optimize.log`, `schedule.log`, `hashtags.log`, `hooks.log` — per-command log files
- `cta.log`, `rewrite.log`, `translate.log`, `tone.log`, `headline.log`, `outline.log` — additional command logs
- `history.log` — unified activity history across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Set `SLIDESHOW_GENERATOR_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4+ with standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `sed`)
- No external dependencies — pure shell implementation

## When to Use

1. **Drafting slide decks** — quickly draft and iterate on presentation content from the terminal
2. **Refining presentation text** — edit, rewrite, or adjust tone of existing slide content
3. **Scheduling talks** — keep track of upcoming presentation dates and deadlines
4. **Creating social hooks** — generate hashtags, headlines, and CTAs for promoting talks online
5. **Outlining presentations** — structure a talk from scratch with hierarchical outlines

## Examples

```bash
# Draft slide content
slideshow-generator draft "Intro slide: Why AI agents matter in 2026"

# Create an outline
slideshow-generator outline "1. Problem Statement 2. Our Solution 3. Demo 4. Results 5. Q&A"

# Generate a headline
slideshow-generator headline "The Future of Autonomous Coding: 5 Trends to Watch"

# Write a hook
slideshow-generator hooks "What if your code could write itself? (pause) It already can."

# Create a CTA
slideshow-generator cta "Star our repo on GitHub — join 10k+ developers building the future"

# Optimize content
slideshow-generator optimize "Slide 3: reduced from 85 words to 32, added visual cue"

# Generate hashtags
slideshow-generator hashtags "#AIAgents #DevTools #Presentation #TechTalk #Automation"

# Schedule a talk
slideshow-generator schedule "PyCon 2026: Apr 15 14:00, Room B, 30min slot"

# Export all data as JSON
slideshow-generator export json

# Search entries
slideshow-generator search "AI"

# View recent activity
slideshow-generator recent

# Show statistics
slideshow-generator stats
```

## Output

All commands output results to stdout. Log entries are stored with timestamps in pipe-delimited format (`YYYY-MM-DD HH:MM|value`). Use `export` to convert all data to JSON, CSV, or plain text.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
