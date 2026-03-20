---
version: "1.0.0"
name: Vegeta
description: "Run HTTP load tests to benchmark throughput, latency, and error rates under stress. Use when stress-testing APIs, benchmarking performance, simulating load."
---
# Load Tester

A content toolkit for drafting, editing, optimizing, scheduling, and managing content creation workflows. Each command logs timestamped entries to local files with full export, search, and statistics support.

## Commands

### Core Content Operations

| Command | Description |
|---------|-------------|
| `load-tester draft <input>` | Draft new content (or view recent drafts with no args) |
| `load-tester edit <input>` | Record an edit or revision note |
| `load-tester optimize <input>` | Log content optimization changes (SEO, readability, etc.) |
| `load-tester schedule <input>` | Schedule or log a publishing date/time |
| `load-tester hashtags <input>` | Record hashtag sets for social media posts |
| `load-tester hooks <input>` | Log attention hooks and opening lines |
| `load-tester cta <input>` | Record call-to-action variations |
| `load-tester rewrite <input>` | Log a content rewrite or alternative version |
| `load-tester translate <input>` | Record a translation task or result |
| `load-tester tone <input>` | Log tone/voice adjustments |
| `load-tester headline <input>` | Record headline variations and A/B test options |
| `load-tester outline <input>` | Log content outlines and structure plans |

### Utility Commands

| Command | Description |
|---------|-------------|
| `load-tester stats` | Show summary statistics across all log files |
| `load-tester export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `load-tester search <term>` | Search all entries for a keyword (case-insensitive) |
| `load-tester recent` | Show the 20 most recent activity log entries |
| `load-tester status` | Health check: version, entry count, disk usage, last activity |
| `load-tester help` | Display full command reference |
| `load-tester version` | Print current version (v2.0.0) |

## How It Works

Every core command accepts free-text input. When called with arguments, Load Tester:

1. Timestamps the entry (`YYYY-MM-DD HH:MM`)
2. Appends it to the command-specific log file (e.g. `draft.log`, `headline.log`)
3. Records the action in a central `history.log`
4. Reports the saved entry and running total

When called with **no arguments**, each command displays the 20 most recent entries from its log file.

## Data Storage

All data is stored locally in plain-text log files:

```
~/.local/share/load-tester/
├── draft.log         # Content drafts
├── edit.log          # Edit & revision notes
├── optimize.log      # Optimization changes
├── schedule.log      # Publishing schedules
├── hashtags.log      # Hashtag sets
├── hooks.log         # Attention hooks
├── cta.log           # Call-to-action variants
├── rewrite.log       # Rewrite alternatives
├── translate.log     # Translation tasks
├── tone.log          # Tone adjustments
├── headline.log      # Headline variations
├── outline.log       # Content outlines
├── history.log       # Central activity log
└── export.{json,csv,txt}  # Exported snapshots
```

Each log uses pipe-delimited format: `timestamp|value`.

## Requirements

- **Bash** 4.0+ with `set -euo pipefail`
- Standard Unix utilities: `wc`, `du`, `grep`, `tail`, `date`, `sed`
- No external dependencies — pure bash

## When to Use

1. **Managing a content calendar** — use `schedule` and `draft` to plan and log upcoming posts, then track edits through `edit` and `rewrite`
2. **A/B testing headlines and CTAs** — record multiple `headline` and `cta` variations to compare performance across campaigns
3. **Optimizing content for SEO** — log `optimize` entries for keyword changes, readability scores, and meta description tweaks
4. **Multi-language content production** — track `translate` tasks and `tone` adjustments when localizing content for different markets
5. **Building a content operations audit trail** — export all activity to JSON/CSV for team reviews, client reporting, or compliance

## Examples

```bash
# Draft a new blog post idea
load-tester draft "Top 10 AI Tools for Content Creators in 2024"

# Record an optimization pass
load-tester optimize "added target keyword 'AI content tools', improved readability score to 72"

# Log headline variations for A/B testing
load-tester headline "Version A: 'AI Tools That Actually Work' | Version B: '10 AI Tools You Need Now'"

# Schedule a post
load-tester schedule "2024-03-20 09:00 UTC — publish blog post to Medium and LinkedIn"

# Save hashtag sets for social media
load-tester hashtags "#AI #ContentCreation #MarTech #WritingTools #Productivity"

# Search all logs for a topic
load-tester search "SEO"

# Export everything to JSON
load-tester export json

# Check overall status
load-tester status

# View summary statistics
load-tester stats
```

## Configuration

Set the `DATA_DIR` variable in the script or modify the default path to change storage location. Default: `~/.local/share/load-tester/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
