---
version: "2.0.0"
name: tiktok
description: "TikTok content strategy and creation system with local analytics tracking. Use when user mentions TikTok videos, content ideas, hooks, scripts, posting strategy, or analytics review. Generates video concepts, writes hooks and scripts, builds posting schedules, and tracks content performance. All strategies are advisory - actual results depend on execution and algorithm factors. Triggers on: tiktok."
---

# TikTok

TikTok content system. Stop the scroll, build your audience.

## Critical Privacy & Safety

### Data Storage (CRITICAL)
- **No TikTok API connection** - manual data entry only
- **No content posting** through this skill
- **No automation** of TikTok interactions
- User controls all data retention and deletion

### Safety Boundaries (NON-NEGOTIABLE)
- ✅ Generate content ideas and hooks
- ✅ Write scripts and captions
- ✅ Build posting strategies
- ✅ Track manually-entered analytics
- ❌ **NEVER guarantee** viral success or growth
- ❌ **NEVER automate** posting or engagement
- ❌ **NEVER replace** creative judgment
- ❌ **NEVER share** content externally

### Content Guidelines
All generated content must comply with TikTok Community Guidelines. User is responsible for final content decisions and posting.

## Quick Start

### Data Storage Setup
TikTok content data stored in your local workspace:
- `memory/tiktok/ideas.json` - Content ideas and hooks
- `memory/tiktok/scripts.json` - Video scripts
- `memory/tiktok/posting_schedule.json` - Posting calendar
- `memory/tiktok/analytics.json` - Performance tracking
- `memory/tiktok/niche.json` - Niche definition and audience

Use provided scripts in `scripts/` for all data operations.

## Core Workflows

### Generate Content Idea
```
User: "Give me video ideas for finance content"
→ Use scripts/generate_ideas.py --niche finance --count 5
→ Generate platform-native ideas with hook angles
```

### Write Hook
```
User: "Write a hook for my sleep tips video"
→ Use scripts/write_hook.py --topic "sleep tips" --style curiosity
→ Generate 5 hook variations with explanations
```

### Create Script
```
User: "Script for 60-second video about investing"
→ Use scripts/create_script.py --topic investing --length 60
→ Write paced script with micro-commitments
```

### Build Posting Schedule
```
User: "Create a posting schedule for next month"
→ Use scripts/build_schedule.py --frequency 3 --days "Mon,Wed,Fri"
→ Generate realistic content calendar
```

### Log Analytics
```
User: "My video got 10K views with 45% completion"
→ Use scripts/log_analytics.py --video-id "VID-123" --views 10000 --completion 45
→ Track performance and identify patterns
```

## Module Reference

For detailed implementation:
- **What Spreads**: See [references/content-dynamics.md](references/content-dynamics.md)
- **Hook Writing**: See [references/hooks.md](references/hooks.md)
- **Script Structure**: See [references/scripts.md](references/scripts.md)
- **Niche Definition**: See [references/niche.md](references/niche.md)
- **Posting Strategy**: See [references/posting-strategy.md](references/posting-strategy.md)
- **Analytics Reading**: See [references/analytics.md](references/analytics.md)
- **Long-Term Growth**: See [references/long-game.md](references/long-game.md)

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `generate_ideas.py` | Generate content ideas for niche |
| `write_hook.py` | Write video hooks |
| `create_script.py` | Create video scripts |
| `build_schedule.py` | Build posting calendar |
| `log_analytics.py` | Log video performance |
| `analyze_performance.py` | Analyze content patterns |
| `define_niche.py` | Define specific audience |
| `batch_content.py` | Plan content batching session |

## Disclaimer

TikTok success depends on many factors including content quality, consistency, timing, and algorithm distribution. No growth is guaranteed. User is responsible for content compliance with platform guidelines.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

| Command | Description |
|---------|-------------|
| `tiktok help` | Show usage info |
| `tiktok run` | Run main task |
