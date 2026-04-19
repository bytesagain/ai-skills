---
description: "Summarize and analyze text documents without external APIs. Use when extracting key points from reports, ranking bullet points, identifying keywords, checking document quality, or comparing two versions."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-doc-summarizer

Summarize, analyze, and extract insights from text documents. Supports extractive summarization, keyword extraction, readability stats, outline detection, and document comparison — all without external APIs.

## Usage

```
bytesagain-doc-summarizer summary <file>
bytesagain-doc-summarizer bullets <file>
bytesagain-doc-summarizer keywords <file>
bytesagain-doc-summarizer stats <file>
bytesagain-doc-summarizer outline <file>
bytesagain-doc-summarizer compare <file1> <file2>
```

## Commands

- `summary` — Extract 3-5 key sentences as an extractive summary
- `bullets` — Generate ranked bullet points from most important sentences
- `keywords` — Extract and rank top 20 keywords with frequency chart
- `stats` — Word count, sentence count, reading time, and text metrics
- `outline` — Detect document structure from Markdown headers or numbered sections
- `compare` — Compare vocabulary overlap and unique terms between two documents

## Examples

```bash
bytesagain-doc-summarizer summary report.txt
bytesagain-doc-summarizer bullets meeting-notes.md
bytesagain-doc-summarizer keywords article.txt
bytesagain-doc-summarizer stats essay.md
bytesagain-doc-summarizer outline documentation.md
bytesagain-doc-summarizer compare v1.txt v2.txt
```

## Requirements

- bash
- python3

## When to Use

Use when you need to quickly digest long documents, extract key points from reports, analyze text metrics, or compare two document versions for content differences.
