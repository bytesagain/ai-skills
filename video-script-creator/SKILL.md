---
version: "3.0.0"
name: video-script-creator
description: "Short video script generator. 短视频脚本生成器、视频脚本、抖音文案、抖音脚本、快手脚本、口播稿、视频拍摄脚本、YouTube脚本、YouTube Shorts脚本、B站脚本、bilibili脚本、分镜脚本、视频大纲、视频文案、短视频创作、Reels脚本、TikTok脚本、vlog脚本."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [video, script, tiktok, douyin, youtube, content]
category: "media"
---

# video-script-creator

CLI toolkit for generating video scripts, hooks, outlines, intros, CTAs, thumbnails, and shot lists for short-form and long-form video content.

## Commands

### `outline`

Generate a video script outline with intro, key points, and outro structure.

```bash
scripts/script.sh outline "如何3分钟做一杯手冲咖啡" --platform douyin --duration 60
```

### `hook`

Generate attention-grabbing opening hooks for a topic.

```bash
scripts/script.sh hook "租房避坑指南"
```

### `intro`

Generate a video introduction with platform-specific format tips.

```bash
scripts/script.sh intro "Python入门教程"
```

### `cta`

Generate call-to-action endings (subscribe, like, comment prompts).

```bash
scripts/script.sh cta "健身教程"
```

### `outro`

Generate video outro with summary, teaser, and engagement prompts.

```bash
scripts/script.sh outro "投资理财入门"
```

### `script`

Generate a full video script (combines outline with detailed talking points).

```bash
scripts/script.sh script "如何提高工作效率"
```

### `timeline`

Generate a timeline breakdown for a video by duration.

```bash
scripts/script.sh timeline "产品开箱" --duration 120
```

### `brief`

Generate a production brief with platform specs, target audience, and key messages.

```bash
scripts/script.sh brief "美食探店"
```

### `thumbnail`

Generate thumbnail concept ideas with text overlay suggestions.

```bash
scripts/script.sh thumbnail "Python教程"
```

### `shotlist`

Generate a shot list for video production.

```bash
scripts/script.sh shotlist "旅行vlog"
```

### `save`

Save a generated script to local library.

```bash
scripts/script.sh save "my-first-video" "Script content here"
```

### `show`

Display a saved script.

```bash
scripts/script.sh show "my-first-video"
```

### `list`

List all saved scripts.

```bash
scripts/script.sh list
```

### `export`

Export saved scripts.

```bash
scripts/script.sh export txt
```

### `stats`

Show usage statistics.

```bash
scripts/script.sh stats
```

## Examples

```bash
# Quick workflow for a Douyin video
scripts/script.sh hook "租房避坑指南"
scripts/script.sh outline "租房避坑指南" --platform douyin --duration 60
scripts/script.sh cta "租房避坑指南"

# Full production prep for YouTube
scripts/script.sh brief "Python教程"
scripts/script.sh script "Python教程"
scripts/script.sh timeline "Python教程" --duration 600
scripts/script.sh thumbnail "Python教程"
scripts/script.sh shotlist "Python教程"
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `VIDEO_SCRIPT_DIR` | No | Data directory (default: `~/.video-scripts/`) |

## Data Storage

All scripts saved in `~/.video-scripts/`:

- `scripts/` — Saved video scripts
- `history.log` — Generation history

## Requirements

- bash 4.0+
- Standard Unix tools

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
