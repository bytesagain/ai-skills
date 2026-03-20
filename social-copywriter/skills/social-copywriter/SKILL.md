---
version: "2.0.0"
name: social-copywriter
description: "Social media copywriter. 社交媒体文案、朋友圈文案、朋友圈怎么发、微博文案、微博段子、Twitter文案、tweet、Instagram文案、IG caption、社交媒体文案生成、节日祝福、生日祝福文案、美食文案、旅行文案、心灵鸡汤、日常文案、晒照文案、show off、心情文案、搞笑文."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# social-copywriter

社交媒体文案生成器。朋友圈、微博、Twitter、Instagram文案。支持多种场景和风格。

## 为什么用这个 Skill？ / Why This Skill?

- **平台调性**：朋友圈要有生活感+emoji，微博要带#话题#，Twitter要280字符以内，Instagram要大量hashtags
- **3条备选**：每次生成3条不同风格的文案，选你喜欢的
- **场景丰富**：美食、旅行、生日、节日、心情、日常，覆盖常见场景
- Compared to asking AI directly: platform-specific formatting (Moments emoji style, Weibo hashtag format, Twitter char limit, IG hashtags), multiple options per request

## Usage

When the user wants to generate social media copy/captions, run the appropriate command:

```bash
bash "{{skillPath}}/scripts/copy.sh" <command> [args]
```

## Commands

| Command | Description |
|---------|-------------|

## Examples

- 用户说"帮我发个朋友圈，今天心情不错" → `moments "心情不错" --mood happy`
- 用户说"写个微博关于加班" → `weibo "加班"`
- 用户说"写个Twitter about AI" → `twitter "AI"`
- 用户说"帮我写生日祝福给小明" → `birthday "小明"`
- 用户说"发个美食朋友圈，吃了火锅" → `food "火锅"`
- 用户说"来碗鸡汤" → `daily`

## Style Guide

- 朋友圈：简短精练，配合emoji，有生活感
- 微博：带#话题#格式，可长可短
- Twitter：英文，简洁有力，280字符内
- Instagram：英文+大量hashtags
- 整体追求"高级感"，不俗不腻

## Output

脚本会输出3条备选文案，用户可以选择或要求微调。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
