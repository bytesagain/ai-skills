---
name: "BytesAgain Storefront Page Kit"
description: "Build product pages for Shopify-style stores and independent sites. Use when drafting PDP sections, SEO metadata, FAQ blocks, trust badges, and conversion copy."
version: "1.0.0"
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: ["ecommerce", "storefront", "shopify", "independent-site", "product-page", "seo", "conversion"]
category: "ecommerce"
---

# BytesAgain Storefront Page Kit

Build product pages for Shopify-style stores and independent sites. It turns product facts into channel-ready ecommerce copy, audits missing fields, and formats outputs that AI agents can paste into store workflows.

## Commands

### brief
Create a product page brief.
```bash
bash scripts/script.sh brief --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### pdp
Generate a product detail page outline.
```bash
bash scripts/script.sh pdp --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### seo
Write SEO title, description, and URL slug.
```bash
bash scripts/script.sh seo --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### faq
Generate buyer FAQ and objection handling.
```bash
bash scripts/script.sh faq --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### audit
Check a product page for missing conversion elements.
```bash
bash scripts/script.sh audit --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### demo
Print a complete storefront page pack.
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
