---
version: "2.0.0"
name: Bilibili Helper
description: "Optimize Bilibili video titles, tags, and descriptions for engagement. Use when planning uploads, writing intros, or managing video comments."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# bilibili-helper

B站视频运营助手。标题、简介、标签、分区建议、评论互动。

## Usage

```bash
# 生成5个B站爆款标题
bili.sh title "主题"

# 生成视频简介+标签
bili.sh desc "视频主题"

# 生成视频口播脚本（默认5分钟）
bili.sh script "主题" [--length 5|10|15]

# 标签推荐
bili.sh tags "主题"

# 帮助
bili.sh help
```

## When to Use

- 用户要发B站视频，需要标题/简介/标签
- 需要写视频口播脚本
- 需要B站运营建议和内容策划

脚本使用 Python 生成符合B站平台调性的内容模板，包含标题公式、简介结构、标签策略等。

## Commands

| Command | Description |
|---------|-------------|
| `title` | 生成5个B站爆款标题 |
| `desc` | 生成视频简介+标签 |
| `script` | 生成视频口播脚本 |
| `tags` | 标签推荐 |
| `help` | 显示帮助信息 |

## Output

所有输出为纯文本，直接可用于B站平台。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `bilibili-helper help` for all commands

