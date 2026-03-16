---
version: "2.0.0"
name: doc-converter
description: "Document format converter. Markdown to HTML, HTML to Markdown, JSON to CSV, CSV to JSON, YAML to JSON, JSON to YAML, text to table, format cleaning. Use when converting between document or data formats, cleaning up messy text, or generating Markdown tables from raw data. Triggers on: doc converter."
---

# 🔄 Doc Converter — Format Transformer

> Data in any format, output in the format you need. One command, zero hassle.

## 🚀 Quick Start (3 Steps)

### Step 1: Identify Source and Target Format

Supported conversion paths:
- Markdown ↔ HTML
- JSON ↔ CSV
- YAML ↔ JSON
- Plain text → Markdown table
- Any format → Clean text

### Step 2: Prepare Your Input

Pass content as arguments or pipe it in. The script auto-detects and converts.

### Step 3: Run the Conversion

```bash
bash scripts/convert.sh <command> <input>
```

## 📋 Command Reference

### `md2html` — Markdown to HTML
Converts Markdown markup to corresponding HTML tags. Supports headings, bold, italic, lists, links, and code blocks.

### `html2md` — HTML to Markdown
Parses HTML tags and outputs clean Markdown text.

### `json2csv` — JSON Array to CSV
Extracts field names from a JSON array as headers and generates CSV output.

### `csv2json` — CSV to JSON
Converts each CSV row into a JSON object, outputs a JSON array.

### `yaml2json` — YAML to JSON
Parses YAML key-value pairs and outputs formatted JSON.

### `json2yaml` — JSON to YAML
Converts JSON to human-readable YAML format.

### `table` — Plain Text to Table
Auto-detects delimiters (comma, tab, pipe) and outputs a Markdown table.

### `clean` — Format Cleanup
Removes extra blank lines, trailing spaces, and special characters. Outputs clean text.

## 📂 Scripts
- `scripts/convert.sh` — Main script
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

| Command | Description |
|---------|-------------|
| `doc-converter help` | Show usage info |
| `doc-converter run` | Run main task |
