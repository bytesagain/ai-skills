---
name: FontPreview
description: "Preview installed fonts, list typefaces, and check typography details. Use when browsing system fonts, previewing rendering, or comparing font styles."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["font","typography","preview","text","design","system","css","developer"]
categories: ["Developer Tools", "Utility"]
---
# FontPreview

A content toolkit for logging, tracking, and managing content creation operations. Each command records timestamped entries to its own log file for auditing and review.

## Commands

### Core Operations

| Command | Description |
|---------|-------------|
| `draft <input>` | Log a draft entry (view recent entries if no input given) |
| `edit <input>` | Log an edit entry for editing tasks |
| `optimize <input>` | Log an optimize entry for optimization tasks |
| `schedule <input>` | Log a schedule entry for scheduling tasks |
| `hashtags <input>` | Log a hashtags entry for hashtag research |
| `hooks <input>` | Log a hooks entry for hook/intro ideas |
| `cta <input>` | Log a CTA entry for call-to-action ideas |
| `rewrite <input>` | Log a rewrite entry for content rewrites |
| `translate <input>` | Log a translate entry for translation tasks |
| `tone <input>` | Log a tone entry for tone adjustment tasks |
| `headline <input>` | Log a headline entry for headline ideas |
| `outline <input>` | Log an outline entry for content outlines |

### Utility Commands

| Command | Description |
|---------|-------------|
| `stats` | Show summary statistics across all log files |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Search all log entries for a term (case-insensitive) |
| `recent` | Show the 20 most recent entries from history |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show available commands |
| `version` | Show version (v2.0.0) |

## Data Storage

All data is stored in `~/.local/share/fontpreview/`:

- Each command writes to its own log file (e.g., `draft.log`, `edit.log`, `headline.log`)
- All actions are also recorded in `history.log` with timestamps
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`
- Log format: `YYYY-MM-DD HH:MM|<input>` (pipe-delimited)

## Requirements

- Bash (no external dependencies)
- Works on Linux and macOS

## When to Use

- When you need to track content drafting and editing workflows
- To log headline, hook, and CTA ideas for later review
- When managing content translation and tone adjustment tasks
- For scheduling and optimizing content publication
- To search or export historical content operation records
- When building an outline or rewriting existing content

## Examples

```bash
# Log content operations
fontpreview draft "blog post about font pairing best practices"
fontpreview edit "revise intro paragraph for clarity"
fontpreview optimize "SEO keywords for typography article"
fontpreview schedule "publish Monday 9am EST"
fontpreview hashtags "#typography #fonts #design #webdev"
fontpreview hooks "Did you know 95% of web design is typography?"
fontpreview cta "Download our free font pairing guide"
fontpreview rewrite "simplify technical jargon in section 3"
fontpreview translate "convert to Spanish for LATAM audience"
fontpreview tone "shift from formal to conversational"
fontpreview headline "10 Font Combinations That Always Work"
fontpreview outline "intro > problem > solution > examples > CTA"

# View recent entries for a command (no args)
fontpreview draft
fontpreview headline

# Search and export
fontpreview search "typography"
fontpreview export csv
fontpreview stats
fontpreview recent
fontpreview status
```

## Output

All commands output to stdout. Redirect with `fontpreview draft > output.txt`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
