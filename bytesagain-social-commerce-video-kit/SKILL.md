---
name: "BytesAgain Social Commerce Video Kit"
description: "Draft TikTok Shop and short-video commerce scripts. Use when creating hooks, UGC scripts, product demos, livestream cues, captions, or creator briefs."
version: "1.0.0"
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: ["ecommerce", "tiktok", "short-video", "ugc", "livestream", "social-commerce"]
category: "ecommerce"
---

# BytesAgain Social Commerce Video Kit

Draft TikTok Shop and short-video commerce scripts. It turns product facts into channel-ready ecommerce copy, audits missing fields, and formats outputs that AI agents can paste into store workflows.

## Commands

### brief
Create a creator brief.
```bash
bash scripts/script.sh brief --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### hook
Generate opening hooks.
```bash
bash scripts/script.sh hook --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### script
Write a 30-60 second product video script.
```bash
bash scripts/script.sh script --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### live
Generate livestream selling cues.
```bash
bash scripts/script.sh live --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### caption
Write captions and CTA variants.
```bash
bash scripts/script.sh caption --product "portable blender" --channel "Amazon" --features "USB-C charging,400ml cup,easy cleaning" --keywords "portable blender,smoothie maker"
```
### demo
Print a sample TikTok Shop launch pack.
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
