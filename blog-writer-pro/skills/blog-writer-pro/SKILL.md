---
version: "2.1.0"
name: Blog Writer
description: "Draft blog articles with outlines, SEO optimization, and CTA copy. Use when producing long-form content, rewriting tone, or validating keywords."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [blog, writing, seo, content, copywriting]
category: "text"
---

# blog-writer-pro

Blog writing toolkit for generating outlines, drafts, titles, intros, CTAs, and SEO analysis — all from the CLI.

## Commands

### `outline`

Generate a structured article outline with H1/H2/H3 headings.

```bash
scripts/script.sh outline "Remote Work Productivity"
```

### `draft`

Generate a complete article draft framework with sections, tables, and CTAs.

```bash
scripts/script.sh draft "Email Marketing for Beginners"
```

### `title`

Generate 5 title candidates for a topic.

```bash
scripts/script.sh title "Machine Learning"
```

### `intro`

Generate an engaging opening paragraph.

```bash
scripts/script.sh intro "Personal Finance Tips"
```

### `conclusion`

Generate a closing paragraph with takeaways.

```bash
scripts/script.sh conclusion "Time Management"
```

### `cta`

Generate call-to-action copy by type.

```bash
scripts/script.sh cta subscribe
scripts/script.sh cta buy
scripts/script.sh cta share
scripts/script.sh cta download
```

### `seo`

Analyze a keyword for SEO placement — length, title fit, slug, and variations.

```bash
scripts/script.sh seo "content marketing strategy"
```

### `rewrite`

Analyze an article and suggest tone adjustments.

```bash
scripts/script.sh rewrite article.md formal
scripts/script.sh rewrite article.md casual
scripts/script.sh rewrite article.md persuasive
```

### `wordcount`

Word count with readability analysis — sentences, paragraphs, reading time.

```bash
scripts/script.sh wordcount article.md
```

### `export`

Export a draft to markdown, HTML, or plain text.

```bash
scripts/script.sh export draft.md html
scripts/script.sh export draft.md txt
```

### `list`

List all saved drafts with sizes and word counts.

```bash
scripts/script.sh list
```

### `history`

Show recent actions.

```bash
scripts/script.sh history
```

## Examples

```bash
# Full workflow: topic → outline → draft → SEO → export
scripts/script.sh outline "How to Start a Side Hustle"
scripts/script.sh draft "How to Start a Side Hustle"
scripts/script.sh seo "side hustle"
scripts/script.sh title "How to Start a Side Hustle"
scripts/script.sh wordcount ~/.blog-writer-pro/drafts/how-to-start-a-side-hustle-draft.md
scripts/script.sh export ~/.blog-writer-pro/drafts/how-to-start-a-side-hustle-draft.md html
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `BLOG_WRITER_PRO_DIR` | No | Data directory (default: `~/.blog-writer-pro/`) |

## Data Storage

All drafts and history saved in `~/.blog-writer-pro/`:

- `drafts/` — Generated outlines and article drafts
- `history.log` — Action log with timestamps

## Requirements

- bash 4.0+
- Standard Unix tools (wc, grep, sed)

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
