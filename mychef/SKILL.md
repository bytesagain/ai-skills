---
version: "2.0.0"
name: mychef
description: "Recipe organizer with meal planning and shopping lists. Use when you need to store recipes, plan weekly meals, generate shopping lists, scale recipes for servings, or get random meal suggestions. Triggers on: recipe, meal plan, cooking, shopping list, ingredients, dinner ideas."
---

# Recipe Book

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/mealie.sh <command>` to use.

## Quick Start

```bash
mealie.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## When to Use

- to automate mychef tasks in your workflow
- for batch processing mychef operations

## Output

Returns structured data to stdout. Redirect to a file with `mychef run > output.txt`.

## Configuration

Set `MYCHEF_DIR` environment variable to change the data directory. Default: `~/.local/share/mychef/`
