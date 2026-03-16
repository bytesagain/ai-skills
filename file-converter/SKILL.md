---
version: "2.0.0"
name: file-converter
description: "File format converter. Detect formats, convert between JSON/YAML/XML/CSV/Markdown, minify and prettify code. Commands: detect, json2yaml, yaml2json, csv2md, md2csv, xml2json, json2xml, minify, prettify. Use for data format conversion, code compression, code beautification. Use when you need file converter capabilities. Triggers on: file converter."
author: BytesAgain
---

# 🔄 File Converter

> One command, any format. Convert between JSON, YAML, XML, CSV, and Markdown. Minify and prettify code files.

## Quick Start

```bash
bash scripts/convert.sh <command> [file]
```

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `detect <file>` | Auto-detect file format | `detect data.txt` |
| `json2yaml <file>` | JSON → YAML | `json2yaml config.json` |
| `yaml2json <file>` | YAML → JSON | `yaml2json config.yaml` |
| `csv2md <file>` | CSV → Markdown table | `csv2md report.csv` |
| `md2csv <file>` | Markdown table → CSV | `md2csv table.md` |
| `xml2json <file>` | XML → JSON | `xml2json data.xml` |
| `json2xml <file>` | JSON → XML | `json2xml data.json` |
| `minify <file>` | Compress JSON/CSS/JS | `minify app.js` |
| `prettify <file>` | Beautify code | `prettify min.json` |

## Workflow

1. Run `detect` to confirm source format
2. Pick the right conversion command
3. Use `prettify` to verify output readability
4. Use `minify` to compress production files

## Notes

- Output goes to stdout — redirect with `>` to save
- Supports pipe input: `cat data.json | bash scripts/convert.sh json2yaml -`
- Run `detect` first on unknown files to avoid garbled output
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
