---
name: "extract"
version: "1.0.0"
description: "Data extraction reference — parsing, scraping, regex, and ETL extraction patterns. Use when pulling structured data from unstructured sources, designing scrapers, or building ETL pipelines."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [extract, parsing, regex, scraping, etl, data, transform]
category: "atomic"
---

# Extract — Data Extraction Reference

Quick-reference skill for data extraction techniques, parsing patterns, and ETL best practices.

## When to Use

- Extracting structured data from HTML, PDF, or log files
- Writing regex patterns for field extraction
- Designing ETL extraction layers
- Parsing semi-structured formats (email headers, log lines, CSVs)
- Choosing between scraping, API, and feed-based extraction

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of data extraction — methods, use cases, and extraction pipeline design.

### `regex`

```bash
scripts/script.sh regex
```

Regex extraction patterns — emails, URLs, dates, IPs, phone numbers, and more.

### `html`

```bash
scripts/script.sh html
```

HTML/web extraction — CSS selectors, XPath, and DOM traversal strategies.

### `text`

```bash
scripts/script.sh text
```

Text extraction — log parsing, delimiter handling, fixed-width fields.

### `pdf`

```bash
scripts/script.sh pdf
```

PDF extraction — tools, table extraction, OCR fallbacks.

### `etl`

```bash
scripts/script.sh etl
```

ETL extraction patterns — incremental loads, CDC, watermarks, and idempotency.

### `tools`

```bash
scripts/script.sh tools
```

Extraction tools — jq, grep, awk, sed, Beautiful Soup, Scrapy, Tesseract.

### `pitfalls`

```bash
scripts/script.sh pitfalls
```

Common extraction mistakes — encoding, edge cases, and data quality issues.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `EXTRACT_DIR` | Data directory (default: ~/.extract/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
