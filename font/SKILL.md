---
name: font
description: "Work with system fonts. Use when listing, searching, previewing, getting metadata, finding pairings, or installing font files."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - fonts
  - typography
  - design
  - font-management
  - preview
---

# Font — Font Management Tool

Manage system fonts: list installed fonts, search by name, preview samples, get metadata, find pairings, and install new fonts.

## Commands

### list — List installed fonts

```bash
bash scripts/script.sh list [--family] [--limit N]
```

Shows all installed system fonts. Use `--family` to group by family. Use `--limit N` to cap output.

### search — Search fonts by name

```bash
bash scripts/script.sh search "<query>"
```

Searches installed fonts matching the query string (case-insensitive).

### preview — Preview a font sample

```bash
bash scripts/script.sh preview "<font_name>" ["sample text"]
```

Prints a text sample rendered as ASCII art banner using the specified font. Falls back to a formatted display if figlet is not available.

### pair — Font pairing suggestions

```bash
bash scripts/script.sh pair "<font_name>"
```

Suggests complementary fonts for pairing based on font classification (serif, sans-serif, monospace, display).

### info — Font metadata

```bash
bash scripts/script.sh info "<font_name_or_path>"
```

Shows metadata for a font: family, style, weight, file path, format, and character count.

### install — Install a font file

```bash
bash scripts/script.sh install "<font_file_path>"
```

Installs a `.ttf`, `.otf`, or `.woff2` font file to the user font directory and refreshes the font cache.

## Output

All commands print plain text to stdout. Font operations use `fc-list`, `fc-query`, and `fc-cache` on Linux; `system_profiler` on macOS.


## Requirements
- bash 4+
- python3 (standard library only)

## Feedback

Report issues or suggestions: [https://bytesagain.com/feedback/](https://bytesagain.com/feedback/)

---

Powered by BytesAgain | bytesagain.com
