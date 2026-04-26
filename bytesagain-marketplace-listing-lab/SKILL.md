---
name: "BytesAgain Marketplace Listing Lab"
description: "Generate marketplace listings and SEO copy. Use when writing Amazon, Taobao, Pinduoduo, Shopee, or marketplace product titles, bullets, attributes, and QA checks."
version: "1.0.0"
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: ["ecommerce", "marketplace", "amazon", "taobao", "pinduoduo", "listing", "seo"]
category: "ecommerce"
---

# BytesAgain Marketplace Listing Lab

Generate marketplace listings and SEO copy. It turns product facts into channel-ready ecommerce copy, audits missing fields, and formats outputs that AI agents can paste into store workflows.

## Commands

### brief
Create a listing brief from product facts.
```bash
bash scripts/script.sh brief --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### title
Generate channel-specific product titles.
```bash
bash scripts/script.sh title --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### bullets
Write benefits, bullets, and attributes.
```bash
bash scripts/script.sh bullets --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### compare
Compare copy across Amazon/Taobao/Pinduoduo styles.
```bash
bash scripts/script.sh compare --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### audit
Check a listing for missing fields and risk words.
```bash
bash scripts/script.sh audit --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### demo
Print a sample cross-marketplace listing pack.
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
