---
description: "Generate platform-optimized copy for Twitter, LinkedIn, Instagram, and Weibo. Use when writing tweet threads, creating LinkedIn posts, drafting Instagram captions, or generating A/B test hook variants."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-social-copywriter

Generate platform-optimized social media copy for Twitter/X, LinkedIn, Instagram, and Weibo. Includes A/B test variants, hashtag strategies, and engagement-optimized formatting for each platform.

## Usage

```
bytesagain-social-copywriter twitter <topic> [tone]
bytesagain-social-copywriter linkedin <topic> [type]
bytesagain-social-copywriter instagram <topic>
bytesagain-social-copywriter weibo <topic>
bytesagain-social-copywriter hashtags <topic> <platform>
bytesagain-social-copywriter ab <topic> <platform>
```

## Commands

- `twitter` — Generate 3 tweet variants with tones (professional/casual/funny/inspiring/urgent)
- `linkedin` — Long-form LinkedIn post with hook, body, and engagement prompts
- `instagram` — Caption with hook, body, hashtag block, and Story companion slides
- `weibo` — 微博文案，含钩子、话题标签和发布策略
- `hashtags` — Platform-specific hashtag strategy with size tiers
- `ab` — Generate 5 A/B test hook variations to find top performer

## Examples

```bash
bytesagain-social-copywriter twitter "productivity hacks" casual
bytesagain-social-copywriter linkedin "remote work" insight
bytesagain-social-copywriter instagram "morning routine"
bytesagain-social-copywriter weibo "AI工具"
bytesagain-social-copywriter hashtags "fitness" instagram
bytesagain-social-copywriter ab "crypto investing" twitter
```

## Requirements

- bash
- python3

## When to Use

Use when creating social media content, need platform-specific formatting, want multiple copy variants to test, or need hashtag strategy for a new topic or campaign.
