---
name: Screenshot
description: "Website screenshot capture tool. Take screenshots of any URL using free APIs, save as image files, capture full-page screenshots, set viewport sizes, and batch-capture multiple URLs. Visual website testing from the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["screenshot","capture","website","image","browser","testing","visual","web"]
categories: ["Developer Tools", "Utility"]
---
# Screenshot
Capture website screenshots from your terminal. No browser needed.
## Commands
- `capture <url> [output]` — Capture screenshot of URL
- `thumb <url>` — Generate thumbnail URL
- `batch <urls_file>` — Capture multiple URLs
- `info <url>` — Show URL metadata without capturing
## Usage Examples
```bash
screenshot capture https://example.com screenshot.png
screenshot thumb [configured-endpoint]
screenshot batch urls.txt
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- to automate screenshot tasks in your workflow
- for batch processing screenshot operations

## Output

Returns summaries to stdout. Redirect to a file with `screenshot run > output.txt`.

## Configuration

Set `SCREENSHOT_DIR` environment variable to change the data directory. Default: `~/.local/share/screenshot/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
