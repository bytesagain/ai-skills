---
version: "2.0.0"
name: web-scraper-pro
description: "Web scraping toolkit for extracting structured data from web pages. Supports text extraction, link harvesting, image URL collection, and CSS-like selector filtering. Outputs results in JSON, CSV, or M. Use when you need web scraper pro capabilities. Triggers on: web scraper pro."
---

# web-scraper-pro

Web scraping toolkit for extracting structured data from web pages. Supports text extraction, link harvesting, image URL collection, and CSS-like selector filtering. Outputs results in JSON, CSV, or Markdown format. Uses only Python3 stdlib (urllib + html.parser) — no external dependencies required. Ideal for quick data extraction, content auditing, and competitive research.


## Commands

| Command | Description |
|---------|-------------|
| `text <url>` | Extract all visible text content from a page |
| `links <url>` | Extract all hyperlinks (href) with anchor text |
| `images <url>` | Extract all image URLs with alt text |
| `select <url> <selector>` | Extract elements matching a CSS-like selector (tag, .class, #id) |
| `full <url>` | Full extraction: text + links + images combined |
| `headers <url>` | Show HTTP response headers |

## Options

- `--format json|csv|md` — Output format (default: json)
- `--timeout <seconds>` — Request timeout (default: 10)
- `--user-agent <string>` — Custom User-Agent header
- `--follow-redirects` — Follow HTTP redirects (default: on)
- `--max-depth <n>` — For recursive scraping (default: 1)
- `--output <file>` — Save output to file instead of stdout
- `--quiet` — Suppress progress messages

## Examples

```bash
# Extract all links from a page as JSON
bash scripts/main.sh links https://example.com --format json

# Get all images with alt text in CSV format
bash scripts/main.sh images https://example.com --format csv

# Extract text from elements with class "article"
bash scripts/main.sh select https://example.com .article --format md

# Full page extraction saved to file
bash scripts/main.sh full https://example.com --output result.json

# Get HTTP headers
bash scripts/main.sh headers https://example.com
```

## Output Formats

### JSON
```json
{
  "url": "https://example.com",
  "timestamp": "2024-01-15T10:30:00",
  "data": [
    {"tag": "a", "href": "https://example.com/page", "text": "Page Link"}
  ]
}
```

### CSV
```
tag,href,text
a,https://example.com/page,Page Link
```

### Markdown
```markdown
| Tag | Href | Text |
|-----|------|------|
| a | https://example.com/page | Page Link |
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
