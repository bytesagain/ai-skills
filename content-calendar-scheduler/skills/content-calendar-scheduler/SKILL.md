---
version: "2.0.0"
name: content-calendar-scheduler
description: "Plan content publishing schedules with editorial calendar views. Use when scheduling posts, planning campaigns, tracking publishing deadlines."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Content Calendar Scheduler

Content creation and optimization assistant for drafting, outlining, scheduling, and analyzing content from the command line.

## Commands

| Command     | Description                        |
|-------------|------------------------------------|
| `draft`     | Create a content draft with a target word count (default 800 words) |
| `headline`  | Generate multiple headline variations for a topic |
| `outline`   | Produce a structured content outline (Intro → Problem → Solution → Examples → CTA) |
| `seo`       | Get SEO tips including keywords, title tags, meta descriptions, headings, and internal links |
| `schedule`  | Generate a weekly content schedule (Mon: Research → Fri: Promote) |
| `hooks`     | Suggest opening hook styles (Question, Statistic, Story, Bold claim, Controversy) |
| `cta`       | Generate call-to-action suggestions (Subscribe, Share, Comment, Try it, Learn more) |
| `repurpose` | Show repurposing pipeline (Blog → Thread → Video → Carousel → Newsletter) |
| `metrics`   | Display key content metrics to track (Views, Clicks, Shares, Time on page, Conversions) |
| `ideas`     | Generate content format ideas (How-to, Listicle, Case study, Interview, Comparison) |
| `help`      | Show help and list all commands    |
| `version`   | Print current version              |

## Usage

```bash
content-calendar-scheduler <command> [args]
```

All actions are logged to `$DATA_DIR/history.log` for auditing.

## Data Storage

- **Default directory:** `~/.local/share/content-calendar-scheduler/`
- **Override:** Set the `CONTENT_CALENDAR_SCHEDULER_DIR` environment variable to change the data directory.
- **Files:**
  - `history.log` — timestamped log of every command executed
  - `data.log` — general data log

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **Planning a content calendar** — Run `content-calendar-scheduler schedule` to generate a weekly publishing plan with dedicated days for research, writing, editing, publishing, and promotion.
2. **Starting a new blog post** — Use `content-calendar-scheduler draft "topic"` to create a draft framework, then `content-calendar-scheduler outline "topic"` for a structured outline.
3. **Optimizing for search engines** — Run `content-calendar-scheduler seo "keyword"` to get SEO recommendations including title tags, meta descriptions, and heading structure.
4. **Generating headline ideas** — Use `content-calendar-scheduler headline "topic"` to get multiple headline variations before committing to a title.
5. **Repurposing existing content** — Run `content-calendar-scheduler repurpose` to see how to transform a blog post into threads, videos, carousels, and newsletters.

## Examples

```bash
# Create a draft about remote work
content-calendar-scheduler draft "remote work tips"

# Generate headlines for a topic
content-calendar-scheduler headline "AI in healthcare"

# Get a content outline
content-calendar-scheduler outline "startup funding"

# Get SEO tips for a keyword
content-calendar-scheduler seo "content marketing"

# Generate a weekly schedule
content-calendar-scheduler schedule
```

```bash
# Get opening hook ideas
content-calendar-scheduler hooks

# Generate call-to-action suggestions
content-calendar-scheduler cta

# View content repurposing pipeline
content-calendar-scheduler repurpose

# Check key content metrics
content-calendar-scheduler metrics

# Get content format ideas
content-calendar-scheduler ideas
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
content-calendar-scheduler draft "topic" > draft.txt
content-calendar-scheduler outline "topic" > outline.md
```

## Configuration

Set `CONTENT_CALENDAR_SCHEDULER_DIR` to customize where data is stored:

```bash
export CONTENT_CALENDAR_SCHEDULER_DIR=/path/to/custom/dir
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
