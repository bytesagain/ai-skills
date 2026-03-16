---
version: "2.0.0"
name: image-prompt
description: "AI image prompt optimizer. Generate and enhance prompts for Midjourney, DALL-E, and Stable Diffusion. Includes prompt enhancement, negative prompt generation, style reference library, and batch variant generation. Use when creating or improving AI art prompts. Triggers on: image prompt."
author: BytesAgain
---

# 🎨 Image Prompt — AI Art Prompt Optimizer

> Can't write a good prompt? Go from vague idea to precise description in seconds.

## 🔍 Platform Comparison

| Feature | Midjourney | DALL-E | Stable Diffusion |
|---------|-----------|--------|-----------------|
| Style | Artistic | Balanced | Highly controllable |
| Params | --ar --v --s | Size/Style | CFG/Steps/Sampler |
| Negative prompt | --no | Not supported | Full negative prompt |
| Optimal length | 30-75 words | 20-50 words | 50-150 words |
| Command | Description |
|---------|-------------|
| `midjourney` | MJ-style prompt |
| `dalle` | DALL-E prompt |
| `sd` | Stable Diffusion prompt |
| `enhance` | Enhance existing prompt |
| `negative` | Generate negative prompt |
| `style` | Style reference library |
| `batch` | Batch variants |

## 🛠️ Commands

- **midjourney** — MJ-style prompt with `--ar`, `--v`, `--s` parameters
- **dalle** — Natural language prompt optimized for DALL-E
- **sd** — SD prompt with weight tags and sampler recommendations
- **enhance** — Enhance an existing prompt with details and modifiers
- **negative** — Generate negative prompts to exclude unwanted elements
- **style** — Style reference library for quick art style keywords
- **batch** — Batch generate multiple variants of the same subject

## 💡 Prompt Formula

```
[Subject] + [Environment] + [Style] + [Lighting] + [Camera] + [Quality]
```

Example: `A samurai on a cliff, cherry blossom storm, ukiyo-e style, golden hour, wide angle, 8k detailed`

## 📂 Scripts
- `scripts/prompt.sh` — Main script
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `image-prompt help` to see all available commands.
