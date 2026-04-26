---
name: "BytesAgain Ecommerce SEO Optimizer"
description: "Optimize ecommerce keywords and product copy. Use when building keyword maps, rewriting titles, improving category text, auditing listings, or planning search terms."
version: "1.0.0"
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: ["ecommerce", "seo", "keywords", "product-copy", "category", "listing"]
category: "ecommerce"
---

# BytesAgain Ecommerce SEO Optimizer

Optimize ecommerce keywords and product copy. It turns product facts into channel-ready ecommerce copy, audits missing fields, and formats outputs that AI agents can paste into store workflows.

## Commands

### keywords
Build keyword clusters from seed terms.
```bash
bash scripts/script.sh keywords --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### rewrite
Rewrite product copy with search intent.
```bash
bash scripts/script.sh rewrite --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### category
Generate category-page SEO copy.
```bash
bash scripts/script.sh category --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### audit
Audit title and description coverage.
```bash
bash scripts/script.sh audit --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### calendar
Create a 14-day SEO content plan.
```bash
bash scripts/script.sh calendar --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### demo
Print a sample ecommerce SEO pack.
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
