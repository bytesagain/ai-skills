---
version: "2.0.0"
name: video-script-creator
description: "Short video script generator. 短视频脚本生成器、视频脚本、抖音文案、抖音脚本、快手脚本、口播稿、视频拍摄脚本、YouTube脚本、YouTube Shorts脚本、B站脚本、bilibili脚本、分镜脚本、视频大纲、视频文案、短视频创作、Reels脚本、TikTok脚本、vlog脚本、带货脚本、种草视频脚本、系列视频规划、视频数据复盘、完播率分析、前3秒钩子。Generate complete video scripts with hooks, outlines, titles, tags, CTA, storyboards, series planning, and data review. Use when: (1) creating short video scripts for any platform, (2) writing口播稿/talking-head scripts, (3) generating viral video titles, (4) planning video outlines and storyboards, (5) writing opening hooks (first 3 seconds), (6) generating CTA/ending prompts, (7) planning video series, (8) reviewing video performance data. 适用场景：写短视频脚本、拍摄脚本、口播文案、视频策划、爆款标题、开场钩子、结尾引导、完整分镜、系列规划、数据复盘。 Triggers on: video script creator."
author: BytesAgain
---

# video-script-creator

短视频脚本生成器，支持抖音/快手/YouTube Shorts/B站等主流短视频平台。

## 为什么用这个 Skill？ / Why This Skill?

- **平台适配**：针对抖音、快手、YouTube、B站各平台调性生成不同风格脚本，不是通用模板
- **完整分镜**：不只是文字，还有画面提示、运镜建议、BGM标注
- **前3秒钩子**：专门优化开场，提升完播率
- Compared to asking AI directly: structured output with platform-specific formatting, shot directions, and hook optimization built-in

## Description

生成短视频脚本、分镜提示、口播稿、爆款标题、标签推荐、开场钩子、结尾互动引导（CTA）等内容。纯本地模板生成，不依赖外部API。

**Use when:**
1. 需要生成短视频完整脚本（开场-主体-结尾+分镜提示）
2. 生成短视频开场钩子（前3秒留人）
3. 生成短视频爆款标题
4. 生成视频大纲/结构
5. 生成结尾引导互动文案（CTA）
6. 查看当前热门视频类型和方向
7. 任何与短视频脚本创作相关的任务

**Supported platforms:** 抖音 (douyin)、快手 (kuaishou)、YouTube Shorts (youtube)、B站 (bilibili)

## Commands

Run via `bash <skill_dir>/scripts/video-script.sh <command> [args]`

| Command | Description |
|---------|-------------|
| `script "主题" [--platform douyin\|kuaishou\|youtube\|bilibili] [--duration 30\|60\|90]` | 生成完整脚本（开场-主体-结尾+分镜提示） |
| `hook "主题"` | 生成5个开场钩子（前3秒留人） |
| `title "主题"` | 生成5个爆款标题 |
| `outline "主题"` | 生成视频大纲 |
| `cta "主题"` | 生成结尾引导互动文案 |
| `storyboard "主题" [--platform X] [--duration N]` | 完整分镜脚本（画面+旁白+字幕+BGM） |
| `hook "主题"` | 生成10个不同风格的前3秒开头钩子 |
| `series "主题" "集数"` | 系列视频规划（每集主题+大纲） |
| `review "数据"` | 视频数据复盘（完播率、互动率分析建议） |
| `trending` | 热门视频类型/方向 |
| `help` | 显示帮助信息 |

## Examples

```bash
# 生成抖音60秒脚本
bash scripts/video-script.sh script "如何3分钟做一杯手冲咖啡" --platform douyin --duration 60

# 生成开场钩子
bash scripts/video-script.sh hook "租房避坑指南"

# 生成爆款标题
bash scripts/video-script.sh title "健身新手入门"

# 生成视频大纲
bash scripts/video-script.sh outline "Python学习路线"

# 生成CTA结尾
bash scripts/video-script.sh cta "旅行vlog"

# 查看热门方向
bash scripts/video-script.sh trending
```

### New Commands
```bash
# 完整分镜脚本（画面+旁白+字幕+BGM）
bash scripts/video-script.sh storyboard "产品开箱" --platform bilibili --duration 90

# 10个不同风格的前3秒钩子
bash scripts/video-script.sh hook "理财入门"

# 系列视频规划
bash scripts/video-script.sh series "Python教程" 8

# 视频数据复盘
bash scripts/video-script.sh review "播放量:5000,点赞:200,评论:30,转发:15,完播率:28%"
```

See also: `examples.md` for 10 complete video script examples across different categories.

## Requirements

- bash
- python3 (>= 3.6)
- 无需外部API
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
