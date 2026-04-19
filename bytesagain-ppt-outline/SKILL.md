---
description: "Generate structured presentation outlines for any topic or product. Use when planning slides, building pitch decks, creating training materials, or outlining technical talks."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-ppt-outline

Generate structured presentation outlines for business decks, TED-style talks, academic conferences, and investor pitches. Includes timing guides, speaker notes, and slide-by-slide breakdowns.

## Usage

```
bytesagain-ppt-outline business <topic> [slide_count]
bytesagain-ppt-outline ted <topic>
bytesagain-ppt-outline academic <topic> [slide_count]
bytesagain-ppt-outline pitch <product> [audience]
bytesagain-ppt-outline slides <topic> <count>
bytesagain-ppt-outline timer <slides> <minutes>
```

## Commands

- `business` — Executive-style outline with problem/solution/ROI structure
- `ted` — 18-minute narrative arc with hook, idea, evidence, and CTA
- `academic` — Research conference format with methodology and citations
- `pitch` — Investor/sales pitch deck (Guy Kawasaki 10-slide method)
- `slides` — Quick slide-by-slide content outline for any count
- `timer` — Calculate time allocation per slide for your duration

## Examples

```bash
bytesagain-ppt-outline business "Digital Transformation" 15
bytesagain-ppt-outline ted "The Future of Remote Work"
bytesagain-ppt-outline pitch "SaaS Analytics Tool" investors
bytesagain-ppt-outline academic "ML in Healthcare" 20
bytesagain-ppt-outline timer 12 30
```

## Requirements

- bash
- python3

## When to Use

Use when planning a presentation, need a structured outline fast, want speaker timing guidance, or preparing pitch materials for different audiences and formats.
