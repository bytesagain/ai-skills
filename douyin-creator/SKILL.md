---
version: "2.0.2"
name: douyin-creator
description: "抖音内容创作与运营助手。抖音运营、抖音涨粉、短视频创作、抖音标题、抖音标签、抖音SEO、抖音账号运营、抖音数据分析、抖音选题、抖音脚本、抖音文案、抖音评论区运营、抖音人设定位、抖音发布时间、DOU+投放、抖音流量、短视频运营、视频创意、直播脚本、话题标签策略、合拍翻拍创意、抖音变现、带货星图、Douyin con."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# 抖音创作助手 — 中文内容创作工具

> 中文内容创作辅助工具。提供写作生成、标题创意、大纲规划、文案润色、话题标签、平台适配、热点追踪、模板推荐、中英翻译、校对检查等功能。所有数据本地存储，不连接任何外部API。

## 工作原理

脚本 `scripts/script.sh` 接收命令和参数，输出对应的文本内容模板和建议。每次命令执行会记录到本地日志。脚本本身生成简短的模板化输出，适合作为创作灵感起点。

Data stored in `~/.local/share/douyin-creator/` — 包含 `history.log`（操作日志）和 `data.log`（数据日志）。

## 命令列表

| 命令 | 用法 | 功能说明 |
|------|------|----------|
| `write` | `write <主题> [字数]` | 写作生成。输出主题和目标字数（默认500字）。记录到日志。 |
| `title` | `title <主题>` | 标题生成。为给定主题生成3个标题变体：全攻略、你不知道的事、避坑指南。 |
| `outline` | `outline <主题>` | 大纲生成。输出5段式大纲结构：引言、背景、要点、总结、互动。 |
| `polish` | `polish <文案>` | 文案润色。输出4个润色方向建议：简洁、有力、口语化、加emoji。 |
| `hashtag` | `hashtag <主题>` | 话题标签生成。为主题生成5个话题标签（#主题 #主题分享 #干货 #推荐 #日常）。 |
| `platform` | `platform <主题>` | 平台适配建议。输出3个平台的内容风格建议：知乎（长文深度）、小红书（图文种草）、公众号（专业输出）。 |
| `hot` | `hot [主题]` | 热点追踪。提示查看微博热搜、知乎热榜、抖音热点。不会实际抓取热点数据。 |
| `template` | `template [主题]` | 模板库。输出6种内容模板类型：测评、教程、种草、避坑、合集、对比。 |
| `translate` | `translate <文本>` | 中英互译。输出"翻译: "加上输入文本。实际翻译需要AI agent配合完成。 |
| `proofread` | `proofread <文案>` | 校对检查。输出4个检查维度：错别字、标点、逻辑、敏感词。 |
| `help` | `help` | 显示帮助信息，列出所有可用命令 |
| `version` | `version` | 显示版本号 |

## 使用示例

```bash
# 生成标题
bash scripts/script.sh title "Python学习"

# 生成大纲
bash scripts/script.sh outline "远程办公"

# 话题标签
bash scripts/script.sh hashtag "美食推荐"

# 文案润色
bash scripts/script.sh polish "这个产品很好用"

# 平台适配
bash scripts/script.sh platform "数码测评"
```

## 重要说明

- **模板化输出**：脚本生成的是简短的模板和方向建议，不是完整的长文内容。适合作为创作起点，由AI agent根据模板进一步展开。
- **纯本地运行**：不连接任何外部API或网站。`hot` 命令不会实际抓取热搜数据，只提示用户去哪里看。
- **日志记录**：每个命令执行时会在 `~/.local/share/douyin-creator/history.log` 记录时间戳和操作内容。
- **中文优先**：所有输出均为中文，适合中文内容平台创作场景。

## 数据存储

所有数据本地存储在 `~/.local/share/douyin-creator/`：

- `history.log` — 操作历史日志（时间戳 + 命令 + 参数）
- `data.log` — 数据日志

数据目录可通过 `DOUYIN_CREATOR_DIR` 环境变量或 `XDG_DATA_HOME` 覆盖。

## Requirements

- bash 4+
- 无外部依赖（纯bash脚本）

## Scripts

- `scripts/script.sh` — 主入口脚本
- `scripts/douyin.sh` — Legacy脚本（功能更完整的旧版本）

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
