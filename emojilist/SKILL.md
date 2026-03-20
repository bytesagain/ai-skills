---
name: EmojiList
description: "Search emojis by name or category and copy them for instant use. Use when finding emojis, browsing categories, copying codes."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["emoji","unicode","search","reference","symbols","text","chat","developer"]
categories: ["Utility", "Productivity"]
---

# EmojiList

A built-in emoji reference and search tool with a database of 390+ emoji. Search by keyword, browse by category, get random emoji, or see the most popular ones — all from the terminal. No external dependencies required.

## Commands

| Command | Description |
|---------|-------------|
| `emojilist search <keyword>` | Search emoji by name/keyword — matches against names and aliases (e.g. "fire", "heart", "cat") |
| `emojilist category <name>` | List all emoji in a specific category with their names |
| `emojilist random [count]` | Show random emoji (default: 5, max: 50) with names and categories |
| `emojilist popular` | Top 25 most commonly used emoji worldwide, with usage context |
| `emojilist list` | List all available categories with emoji count and sample preview |

## Categories

| Category | Description |
|----------|-------------|
| `faces` | Smileys, expressions, emotions (~67 emoji) |
| `gestures` | Hand signs, thumbs, pointing (~30 emoji) |
| `hearts` | Hearts in all colors and styles (~17 emoji) |
| `animals` | Animals, insects, sea creatures (~53 emoji) |
| `food` | Food, drinks, fruits, meals (~70 emoji) |
| `nature` | Plants, weather, celestial (~26 emoji) |
| `tech` | Computers, devices, tools (~27 emoji) |
| `travel` | Vehicles, buildings, places (~22 emoji) |
| `sports` | Sports, games, trophies (~22 emoji) |
| `symbols` | Signs, shapes, colors, marks (~41 emoji) |
| `flags` | Country and specialty flags (~18 emoji) |

## Requirements

- Bash 4+ (uses arrays)
- Terminal with Unicode/emoji support

## Examples

```bash
# Find fire-related emoji
emojilist search fire

# Browse all animal emoji
emojilist category animals

# Get 10 random emoji for inspiration
emojilist random 10

# See what's most popular
emojilist popular

# See all categories at a glance
emojilist list
```
