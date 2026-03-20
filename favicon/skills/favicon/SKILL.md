---
name: Favicon
description: "Fetch and download favicons from any website for your design projects. Use when grabbing icons, checking availability, or previewing favicon renders."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["favicon","icon","website","image","web","html","branding","developer"]
categories: ["Developer Tools", "Utility"]
---

# Favicon — Favicon Tool

Check, download, and generate favicons. Detects favicons via /favicon.ico, HTML `<link>` tags, and apple-touch-icon. Can generate SVG placeholder favicons from text.

## Commands

| Command | Description |
|---------|-------------|
| `check <url>` | Check if a website has a favicon (tries /favicon.ico, HTML link tags, apple-touch-icon) |
| `download <url> [output]` | Download a site's favicon (tries direct, HTML parsing, Google API fallback) |
| `generate <text> [size]` | Generate an SVG favicon placeholder with text (1-2 chars, random background) |
| `info <file>` | Show image file info — size, MIME type, format (ICO/PNG/JPEG/GIF/SVG/WebP) |

## Examples

```bash
# Check if a site has a favicon
favicon check https://github.com
# → ✓ /favicon.ico — 200
# → ✓ apple-touch-icon found

# Download a favicon
favicon download https://google.com google-icon.ico

# Generate an SVG placeholder
favicon generate "AB" 64
# → Creates AB-favicon.svg with random background color

# Get info about a favicon file
favicon info favicon.ico
# → Size, MIME type, format (detected from magic bytes)
```

## Detection Methods

1. **Direct:** Checks `<url>/favicon.ico`
2. **HTML Parsing:** Looks for `<link rel="icon">` and `<link rel="shortcut icon">` in page HTML
3. **Apple Touch Icon:** Checks for `<link rel="apple-touch-icon">`
4. **Google API (download only):** Falls back to `google.com/s2/favicons` API

## Requirements

- `curl` — for HTTP requests
- `file` (optional) — for MIME type detection in `info` command
- `xxd` (optional) — for magic byte detection in `info` command
