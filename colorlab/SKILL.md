---
name: ColorLab
description: "Color palette generator and converter. Convert between hex and RGB, generate harmonious color palettes from any base color, check WCAG contrast ratios for accessibility compliance, and browse named CSS colors. Essential for designers and frontend developers."
version: "2.0.0"
author: "BytesAgain"
tags: ["color","palette","design","hex","rgb","contrast","accessibility","css","wcag"]
categories: ["Design", "Developer Tools", "Utility"]
---

# ColorLab

Your color toolkit in the terminal. Convert, generate palettes, and check accessibility.

## Why ColorLab?

- **Format conversion**: Hex ↔ RGB instant conversion
- **Palette generation**: Create harmonious palettes from any color
- **Accessibility**: WCAG contrast ratio checking
- **Named colors**: Quick reference for CSS color names
- **No GUI needed**: Fast color work from command line

## Commands

- `hex2rgb <#hexcode>` — Convert hex to RGB
- `rgb2hex <r> <g> <b>` — Convert RGB to hex
- `palette [hex|random]` — Generate a 6-color palette
- `contrast <fg_hex> <bg_hex>` — Check WCAG contrast ratio
- `named` — Show named CSS colors
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
colorlab hex2rgb #ff5733
colorlab rgb2hex 255 87 51
colorlab palette #3498db
colorlab palette random
colorlab contrast #ffffff #000000
colorlab named
```

## Contrast Rating

- ✅ AAA (7:1+) — Excellent readability
- ✅ AA (4.5:1+) — Good for normal text
- ⚠️ AA Large (3:1+) — Only for large text
- ❌ Fail — Does not meet WCAG guidelines

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
