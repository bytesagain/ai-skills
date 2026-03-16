---
name: "Email"
description: "Lightweight Email tracker. Add entries, view stats, search history, and export in multiple formats."
version: "2.0.0"
author: "BytesAgain"
tags: ["intelligence", "automation", "nlp", "ai", "email"]
---

# Email

Lightweight Email tracker. Add entries, view stats, search history, and export in multiple formats.

## Why Email?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Getting Started

```bash
# See what you can do
email help

# Check current status
email status

# View your statistics
email stats
```

## Commands

| Command | What it does |
|---------|-------------|
| `email Role:` | $1 |
| `email You` | are an expert $1. Be precise, helpful, and concise. |
| `email Step` | 1: Understand | Step 2: Plan | Step 3: Execute | Step 4: Verify |
| `email 1.` | Zero-shot | 2. Few-shot | 3. Chain-of-thought | 4. Role-play |
| `email GPT-4` | vs Claude vs Gemini: benchmark comparison |
| `email Tokens:` | ~$1 | Cost: ~\$$(python3 -c "print("{:.4f}".format(${1:-1000} * 0.00003))" 2>/dev/null || echo "?") |
| `email Tips:` | Be specific | Add examples | Set format | Constrain length |
| `email Check:` | accuracy | relevance | completeness | tone |
| `email 1.` | No harmful content | 2. No personal data | 3. Cite sources |
| `email ChatGPT` | | Claude | Gemini | Perplexity | Midjourney |

## Data Storage

All data is stored locally at `~/.local/share/email/`. Each action is logged with timestamps. Use `export` to back up your data anytime.

## Feedback

Found a bug or have a suggestion? Let us know: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
