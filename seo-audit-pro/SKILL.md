---
version: "2.0.0"
name: seo-audit-pro
description: "Error: --url required. Use when you need seo audit pro capabilities. Triggers on: seo audit pro, url, format, output, help."
---

# seo-audit-pro

complete SEO analysis tool that audits web pages for search engine optimization issues. Checks meta tags (title, description, canonical, robots), heading hierarchy (H1-H6), image alt text coverage, page speed hints, Open Graph / Twitter Card metadata, and structured data (JSON-LD) validation. Generates beautiful HTML reports with scores, recommendations, and practical fixes. Uses only Python3 stdlib — no external dependencies.


## Commands

| Command | Description |
|---------|-------------|
| `audit <url>` | Full SEO audit with HTML report |
| `meta <url>` | Check meta tags only |
| `headings <url>` | Analyze heading structure |
| `images <url>` | Check image alt text coverage |
| `links <url>` | Analyze internal/external link distribution |
| `social <url>` | Check Open Graph and Twitter Card tags |
| `structured <url>` | Validate JSON-LD structured data |
| `speed <url>` | Page speed hints and recommendations |
| `score <url>` | Quick SEO score (0-100) |

## Options

- `--output <file>` — Save HTML report to file (default: seo-report.html)
- `--format html|json|text` — Output format (default: html)
- `--timeout <seconds>` — Request timeout (default: 15)
- `--user-agent <string>` — Custom User-Agent string
- `--mobile` — Use mobile User-Agent for audit
- `--verbose` — Show detailed analysis for each check

## Examples

```bash
# Full SEO audit with HTML report
bash scripts/main.sh audit https://example.com --output report.html

# Quick SEO score
bash scripts/main.sh score https://example.com

# Check meta tags in JSON format
bash scripts/main.sh meta https://example.com --format json

# Analyze heading structure
bash scripts/main.sh headings https://example.com

# Check image alt text
bash scripts/main.sh images https://example.com --verbose

# Validate structured data
bash scripts/main.sh structured https://example.com
```

## Scoring

The SEO score (0-100) is calculated from:
- Title tag (10pts) — exists, length 30-60 chars
- Meta description (10pts) — exists, length 120-160 chars
- H1 tag (10pts) — exactly one H1
- Heading hierarchy (10pts) — proper nesting
- Image alt text (10pts) — all images have alt
- Internal links (10pts) — sufficient internal linking
- Meta robots (5pts) — no accidental noindex
- Canonical URL (5pts) — canonical tag present
- Open Graph (10pts) — OG tags present
- Structured data (10pts) — valid JSON-LD
- Page size hints (10pts) — reasonable page weight
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
