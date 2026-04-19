---
name: ai-product-description-from-image
description: "Convert local product images (JPG/PNG/WEBP) to descriptions using Grok Vision AI. Requires XAI_API_KEY. Use when generating e-commerce copy from local photo files, batch processing product image folders, or creating multilingual listings from saved product pictures."
version: "2.0.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [ecommerce, product, image, vision, batch, local]
env:
  - name: XAI_API_KEY
    required: true
    description: "Grok API key from console.x.ai"
---

# AI Product Description from Image (Local Files)

Convert local product images to professional descriptions using Grok Vision AI.

## What This Skill Owns
- Single image description from local file path (JPG/PNG/WEBP)
- Batch processing of all images in a folder
- Output in 4 styles and 3 languages

## What This Skill Does Not Cover
- Image URLs (use ai-product-description-generator-from-image)
- Non-image files (PDF, DOCX, etc.)
- Publishing to Shopify/WooCommerce directly

## Commands

### describe
Generate description from a single local image file.

```
XAI_API_KEY=your-key bash scripts/script.sh describe --image ./product.jpg
XAI_API_KEY=your-key bash scripts/script.sh describe --image ./shoe.png --style luxury --lang zh
```

### batch
Process all images in a folder.

```
XAI_API_KEY=your-key bash scripts/script.sh batch --folder ./product-images
XAI_API_KEY=your-key bash scripts/script.sh batch --folder ./products --style seo
```

## Credentials

| Variable | Required | Description |
|----------|----------|-------------|
| XAI_API_KEY | **Yes** | Grok API key from console.x.ai |

## Requirements
- python3 (standard library only)
- Internet connection (calls api.x.ai)
- Local image files: jpg, jpeg, png, webp

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
