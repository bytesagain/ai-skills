---
name: "BytesAgain Crossborder Product Localizer"
description: "Localize product listings across English and Chinese ecommerce channels. Use when adapting Amazon, Shopify, Taobao, Pinduoduo, TK, or independent-site copy."
version: "1.0.0"
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: ["ecommerce", "localization", "crossborder", "amazon", "shopify", "taobao", "pinduoduo"]
category: "ecommerce"
---

# BytesAgain Crossborder Product Localizer

Localize product listings across English and Chinese ecommerce channels. It turns product facts into channel-ready ecommerce copy, audits missing fields, and formats outputs that AI agents can paste into store workflows.

## Commands

### map
Map source product facts to target channel fields.
```bash
bash scripts/script.sh map --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### localize
Rewrite copy for a target market.
```bash
bash scripts/script.sh localize --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### tone
Generate tone variants for platform norms.
```bash
bash scripts/script.sh tone --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### compliance
Check risky claims and missing disclaimers.
```bash
bash scripts/script.sh compliance --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### bundle
Create a multi-channel launch bundle.
```bash
bash scripts/script.sh bundle --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### demo
Print a bilingual product localization pack.
```bash
bash scripts/script.sh demo --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
## Requirements

- bash 4+
- Standard Unix tools: sed, awk, paste, seq

## Input Formats

- Product facts: `--product`, `--features`, `--keywords`, `--audience`
- Channel: `--channel Amazon|Shopify|Taobao|Pinduoduo|TikTok|IndependentSite`
- Target market: `--target US|CN|EU`, `--lang en|zh`

## Output

- Markdown listing briefs, titles, bullets, SEO metadata, FAQ, scripts, audits, and launch bundles.

## Notes

Use official marketplace policies before publishing claims. This skill drafts and audits copy; it does not upload products or ask for seller credentials.

## Feedback

https://bytesagain.com/feedback/

Powered by BytesAgain | bytesagain.com
