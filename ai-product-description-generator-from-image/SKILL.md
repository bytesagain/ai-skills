---
name: ai-product-description-generator-from-image
description: "Analyze a public product image URL and generate descriptions in 4 styles using Grok Vision AI. Requires XAI_API_KEY env var. Use when creating e-commerce copy from product photos, generating Amazon/Shopify listings from image links, or producing multilingual product descriptions from URLs."
version: "2.0.2"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [ecommerce, product, image, vision, description]
requires:
  env:
    - XAI_API_KEY
---

# AI Product Description Generator from Image URL

Analyze a product image URL and generate descriptions in multiple styles using Grok Vision AI. Requires `XAI_API_KEY`.

## What This Skill Owns
- Vision-based description from public image URLs
- Output in 4 styles: professional, casual, luxury, SEO
- Supports English, Chinese, Spanish output

## What This Skill Does Not Cover
- Local image files (use ai-product-description-from-image)
- Private/password-protected image URLs
- Bulk batch processing

## Commands

### describe
Analyze an image URL and generate a product description.

```
XAI_API_KEY=your-key bash scripts/script.sh describe --url "https://example.com/product.jpg"
XAI_API_KEY=your-key bash scripts/script.sh describe --url "https://example.com/shoe.jpg" --style luxury --lang zh
```

## Credentials

| Variable | Required | Description |
|----------|----------|-------------|
| XAI_API_KEY | **Yes** | Grok API key from console.x.ai |

## Requirements
- python3 (standard library only)
- Internet connection (calls api.x.ai)
- Publicly accessible image URL (must start with https://)

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
