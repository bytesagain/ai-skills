---
description: "Generate platform-optimized video scripts with hooks and timed segments. Use when scripting YouTube tutorials, creating TikTok content, planning Douyin videos, or structuring Bilibili educational videos."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-video-script-creator

Generate ready-to-film video scripts for YouTube, TikTok, Douyin, and Bilibili. Includes hooks, timed segments, camera directions, and platform-specific formatting.

## Usage

```
bytesagain-video-script-creator youtube <topic> [duration_min]
bytesagain-video-script-creator tiktok <topic>
bytesagain-video-script-creator douyin <topic>
bytesagain-video-script-creator bilibili <topic> [duration_min]
bytesagain-video-script-creator hooks <topic>
bytesagain-video-script-creator outline <topic> [sections]
```

## Commands

- `youtube` — Full YouTube script with timed sections, B-roll notes, and CTA
- `tiktok` — 30-60 second TikTok script with hook, content, and hashtags
- `douyin` — 抖音竖屏短视频脚本，含钩子、干货和互动引导
- `bilibili` — B站横屏视频脚本，含分P结构和三连引导
- `hooks` — Generate 12 attention-grabbing hook variations for any topic
- `outline` — Create a timed video outline with customizable section count

## Examples

```bash
bytesagain-video-script-creator youtube "Python for beginners" 10
bytesagain-video-script-creator tiktok "morning routine"
bytesagain-video-script-creator douyin "减肥方法"
bytesagain-video-script-creator hooks "productivity tips"
bytesagain-video-script-creator outline "AI tools" 5
```

## Requirements

- bash
- python3

## When to Use

Use when planning video content, need a script framework fast, want platform-optimized structure, or generating hook ideas for any topic across multiple video platforms.
