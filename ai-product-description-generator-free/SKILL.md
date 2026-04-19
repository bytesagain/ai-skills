---
name: ai-product-description-generator-free
description: "Generate product descriptions using free AI backends: Ollama (local, offline) or HuggingFace Inference API (free online). Use when creating e-commerce copy without paid API keys, running product description generation offline, or testing AI copy tools for free."
version: "2.0.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [ecommerce, product, description, free, ollama, huggingface]
env:
  - name: HF_TOKEN
    required: false
    description: "HuggingFace API token (optional, free at huggingface.co)"
---

# AI Product Description Generator (Free)

Generate product descriptions using free AI backends — no paid API key required.

## What This Skill Owns
- Product description generation via Ollama (local/offline)
- Product description generation via HuggingFace Inference API (free tier)
- Input: product name + features; Output: ready-to-use copy

## What This Skill Does Not Cover
- Image-based descriptions (use ai-product-description-from-image)
- Paid API backends (OpenAI, Grok, etc.)
- Bulk batch processing

## Credentials

| Variable | Required | Description |
|----------|----------|-------------|
| HF_TOKEN | No | HuggingFace API token (free at huggingface.co/settings/tokens) — only needed for HuggingFace backend |
| OLLAMA_HOST | No | Ollama server URL (default: http://localhost:11434) |
| OLLAMA_MODEL | No | Ollama model name (default: llama3) |

## Commands

### generate
Generate a product description using Ollama (default) or HuggingFace.

```bash
# Ollama backend (local, no key needed)
bash scripts/script.sh generate --product "Wireless Headphones" --features "noise cancelling, 30h battery"

# HuggingFace backend (free online)
HF_TOKEN=hf_xxx bash scripts/script.sh generate --product "Running Shoes" --features "lightweight" --backend huggingface
```

## Backends
- **ollama** — Local inference via Ollama. Requires Ollama running at localhost:11434 (default)
- **huggingface** — Free HuggingFace Inference API. Optionally set HF_TOKEN for higher rate limits

## Requirements
- python3 (standard library only)
- Ollama installed and running (for ollama backend): https://ollama.ai
- Internet connection (for huggingface backend)

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
