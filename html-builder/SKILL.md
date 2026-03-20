---
version: "2.0.0"
name: HTML Builder
description: "Generate HTML pages, landing pages, email templates, and forms with ease. Use when building landing pages, creating emails, or prototyping portfolios."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# HTML Builder

A design reference and helper tool for web development. Quickly look up color palettes, font pairings, layout grids, icon libraries, spacing scales, responsive breakpoints, contrast checkers, shadow presets, mockup tools, and design checklists — all from your terminal.

## Commands

| Command | Description |
|---------|-------------|
| `palette` | Display a curated color palette with Primary (#2563EB), Secondary (#7C3AED), and Accent (#F59E0B) values |
| `font` | Show recommended font pairings — Heading: Inter/Poppins, Body: Open Sans/Lato |
| `layout` | Output layout template specs — 12-column grid, 8px base spacing, 1200px max-width |
| `icon` | List popular icon libraries — Heroicons, Lucide, Phosphor, Tabler |
| `spacing` | Show spacing scale guide — xs:4 sm:8 md:16 lg:24 xl:32 2xl:48 |
| `breakpoint` | Display responsive breakpoints — sm:640 md:768 lg:1024 xl:1280 2xl:1536 |
| `contrast` | Provide contrast checker reference (webaim.org tool link) |
| `shadow` | Show box-shadow presets — sm, md, lg with CSS values |
| `mockup` | List recommended mockup/design tools — Figma, Sketch, Adobe XD |
| `checklist` | Output a design checklist — consistent spacing, color contrast, mobile responsive |
| `help` | Show all available commands |
| `version` | Display current version (v2.0.0) |

## Data Storage

- **Data directory:** `~/.local/share/html-builder/` (override with `$HTML_BUILDER_DIR` or `$XDG_DATA_HOME`)
- **History log:** `$DATA_DIR/history.log` — records every command invocation with timestamp
- All data is stored locally; no external services or accounts required

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies — pure bash, no API keys needed
- Works on Linux and macOS

## When to Use

1. **Starting a new web project** — quickly reference standard color palettes, font pairings, and grid layouts without leaving the terminal
2. **Checking responsive design** — look up breakpoint values (sm/md/lg/xl/2xl) to ensure your CSS media queries follow common conventions
3. **Reviewing accessibility** — use the `contrast` command to get the WCAG contrast checker link and the `checklist` command for a quick design audit
4. **Prototyping UI components** — reference spacing scales and shadow presets to maintain consistent visual rhythm across your design
5. **Onboarding a new designer or developer** — share the tool as a quick-reference cheat sheet for design system fundamentals

## Examples

```bash
# Get the default color palette
html-builder palette

# Look up recommended heading and body font pairings
html-builder font

# Check responsive breakpoint values for CSS media queries
html-builder breakpoint

# Get box-shadow CSS presets (small, medium, large)
html-builder shadow

# Run through the design checklist before shipping
html-builder checklist
```

### Example Output

```
$ html-builder spacing
  xs:4 sm:8 md:16 lg:24 xl:32 2xl:48

$ html-builder icon
  Libraries: Heroicons | Lucide | Phosphor | Tabler
```

## Configuration

Set `HTML_BUILDER_DIR` environment variable to change the data directory. Default: `~/.local/share/html-builder/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
