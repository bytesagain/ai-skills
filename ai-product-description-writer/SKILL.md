---
name: ai-product-description-writer
description: "Generate product descriptions in 4 styles (professional, casual, luxury, SEO) from product name and features using Grok AI. Requires XAI_API_KEY. Use when writing e-commerce listings, creating Shopify/Amazon copy, drafting product marketing content, or generating multi-style product text."
version: "2.0.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [ecommerce, product, copywriting, description, grok]
env:
  - name: XAI_API_KEY
    required: true
    description: "Grok API key from console.x.ai"
---

# AI Product Description Writer

Generate product descriptions in 4 styles from a product name and feature list using Grok AI.

## What This Skill Owns
- Multi-style description generation: professional, casual, luxury, SEO-optimized
- Input: product name + comma-separated features
- Output: ready-to-publish copy for e-commerce listings

## What This Skill Does Not Cover
- Image-based description (use ai-product-description-from-image)
- Bulk/batch processing
- Publishing to Shopify/WooCommerce directly

## Credentials

| Variable | Required | Description |
|----------|----------|-------------|
| XAI_API_KEY | **Yes** | Grok API key from console.x.ai |

## Commands

### write
Generate descriptions from product name and features.

```bash
XAI_API_KEY=your-key bash scripts/script.sh write --product "Wireless Headphones" --features "noise cancelling, 30h battery, foldable"
XAI_API_KEY=your-key bash scripts/script.sh write --product "Running Shoes" --features "lightweight, breathable" --style seo
```

## Styles
- **professional** — Formal, B2B-ready copy
- **casual** — Friendly, conversational tone
- **luxury** — Premium, aspirational language
- **seo** — Keyword-rich for search ranking
- **all** — Generate all 4 styles (default)

## Requirements
- python3 (standard library only)
- Internet connection (calls api.x.ai)

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
