---
name: MarkPad
description: "Preview, convert, and validate Markdown with TOC generation and HTML export. Use when previewing MD, generating TOC, converting Markdown to HTML."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["markdown","editor","html","converter","docs","writing","developer"]
categories: ["Developer Tools", "Utility"]
---
# MarkPad

Content toolkit for drafting, editing, optimizing, and managing written content. MarkPad provides a complete content creation workflow — from initial drafts and outlines through editing, rewriting, tone adjustment, translation, and scheduling. All entries are timestamped and stored locally for full traceability.

## Commands

### Content Creation
| Command | Description |
|---------|-------------|
| `markpad draft <input>` | Create a new draft entry. Run without args to view recent drafts |
| `markpad outline <input>` | Create a content outline. Run without args to view recent outlines |
| `markpad headline <input>` | Generate or store headline ideas. Run without args to view recent headlines |
| `markpad hooks <input>` | Create attention-grabbing hooks. Run without args to view recent hooks |
| `markpad cta <input>` | Create call-to-action copy. Run without args to view recent CTAs |

### Content Editing & Optimization
| Command | Description |
|---------|-------------|
| `markpad edit <input>` | Edit and refine content. Run without args to view recent edits |
| `markpad rewrite <input>` | Rewrite content for clarity or style. Run without args to view recent rewrites |
| `markpad optimize <input>` | Optimize content for engagement or SEO. Run without args to view recent optimizations |
| `markpad tone <input>` | Adjust content tone (formal, casual, etc.). Run without args to view recent tone entries |
| `markpad translate <input>` | Translate content across languages. Run without args to view recent translations |

### Content Management
| Command | Description |
|---------|-------------|
| `markpad schedule <input>` | Schedule content for publishing. Run without args to view recent schedules |
| `markpad hashtags <input>` | Generate or store hashtag sets. Run without args to view recent hashtag entries |

### Utility Commands
| Command | Description |
|---------|-------------|
| `markpad stats` | Show summary statistics across all entry types |
| `markpad export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `markpad search <term>` | Search across all entries by keyword |
| `markpad recent` | Show the 20 most recent activity log entries |
| `markpad status` | Health check — version, data dir, entry count, disk usage |
| `markpad help` | Show usage information and available commands |
| `markpad version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/markpad/`:

- Each command type has its own log file (e.g., `draft.log`, `edit.log`, `optimize.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|value` format
- A unified `history.log` tracks all activity across commands
- Export supports JSON, CSV, and plain text formats
- No external services or API keys required

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)
- No external dependencies — works on any POSIX-compatible system

## When to Use

1. **Content creation workflow** — Draft blog posts, social media copy, or marketing content with full revision history
2. **Multi-language content** — Use `translate` and `tone` to adapt content for different audiences and markets
3. **Social media management** — Generate hashtags, hooks, and CTAs for social media campaigns, then schedule posts
4. **Editorial pipeline** — Move content through draft → edit → optimize → rewrite stages with timestamped tracking
5. **Content auditing** — Use `stats`, `search`, and `export` to review content output, find specific entries, and generate reports

## Examples

```bash
# Draft a new blog post intro
markpad draft "AI is transforming how we write — here's what you need to know"

# Optimize existing content for engagement
markpad optimize "Rewrite the intro to lead with a question instead of a statement"

# Generate hashtags for a social campaign
markpad hashtags "#AIwriting #ContentCreation #MarketingTips #BloggingLife"

# Create a call-to-action
markpad cta "Sign up for our free content toolkit — start creating better content today"

# Export all data as JSON for analysis
markpad export json

# Search for all entries mentioning "AI"
markpad search AI

# View overall statistics
markpad stats
```

## How It Works

Each content command (draft, edit, optimize, etc.) works the same way:
- **With arguments**: Saves the input as a new timestamped entry and logs it to history
- **Without arguments**: Displays the 20 most recent entries for that command type

This makes MarkPad both a content creation tool and a searchable content journal.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
