---
name: ColorLab
description: "Convert colors and generate palettes with WCAG contrast checks. Use when building palettes, converting hex/RGB, checking accessibility."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["color","palette","design","hex","rgb","contrast","accessibility","css","wcag"]
categories: ["Design", "Developer Tools", "Utility"]
---

# ColorLab — Color Tool

Convert colors, generate palettes, check WCAG contrast ratios, and find closest CSS color names. Uses `printf` and `awk` for calculations, with ANSI 24-bit color swatches in terminal output.

## Commands

| Command | Description |
|---------|-------------|
| `hex-to-rgb <hex>` | Convert hex color to RGB values |
| `rgb-to-hex <r> <g> <b>` | Convert RGB values (0-255) to hex |
| `contrast <hex1> <hex2>` | Calculate WCAG 2.0 contrast ratio with AA/AAA pass/fail ratings |
| `palette <hex> [count]` | Generate lighter and darker variants of a color (default: 5 each direction) |
| `random [count]` | Generate random colors with hex and RGB values (default: 1) |
| `name <hex>` | Find the closest named CSS color (from ~50 common colors) |

## Examples

```bash
# Convert hex to RGB
colorlab hex-to-rgb "#FF5733"    # → rgb(255, 87, 51)

# Convert RGB to hex
colorlab rgb-to-hex 255 87 51    # → #FF5733

# Check contrast for accessibility
colorlab contrast "#FFFFFF" "#000000"
# → 21.00:1, WCAG AA/AAA all pass

# Generate a palette
colorlab palette "#3498db" 3
# → Shows 3 darker + base + 3 lighter variants with color swatches

# Random colors
colorlab random 5

# Find closest CSS color name
colorlab name "#e74c3c"          # → Crimson
```

## Notes

- Hex colors accept `#` prefix (optional) and 3-digit shorthand (`#F00` → `#FF0000`)
- WCAG contrast checks report AA/AAA compliance for normal and large text
- Palette output includes ANSI 24-bit color swatches (requires a modern terminal)
- Color naming uses Euclidean distance in RGB space against ~50 common CSS color names
