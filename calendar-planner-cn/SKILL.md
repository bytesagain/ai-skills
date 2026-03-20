---
version: "2.0.0"
name: calendar-planner-cn
description: "日程规划工具。周计划、月计划、时间块、会议安排、截止日期管理、工作生活平衡。Calendar planner with weekly, monthly, time-blocking, meeting scheduling, deadline management."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Calendar Planner CN

中文内容创作工具 — 写作生成、标题优化、大纲规划、文案润色、话题标签、平台适配、热点追踪、模板库、中英互译、校对检查。全流程覆盖中文自媒体内容创作。

## 命令列表

| 命令 | 说明 |
|------|------|
| `calendar-planner-cn write <主题> [字数]` | 写作生成 — 按主题生成内容框架，可指定目标字数（默认500字） |
| `calendar-planner-cn title <关键词>` | 标题生成 — 根据关键词生成多个标题变体（全攻略/避坑指南等） |
| `calendar-planner-cn outline <主题>` | 大纲生成 — 生成引言→背景→要点→总结→互动的结构化大纲 |
| `calendar-planner-cn polish <文案>` | 文案润色 — 提供润色建议：简洁、有力、口语化、加emoji |
| `calendar-planner-cn hashtag <关键词>` | 话题标签 — 生成相关话题标签（#关键词 #分享 #干货 #推荐 #日常） |
| `calendar-planner-cn platform <内容>` | 平台适配 — 针对知乎(长文深度)、小红书(图文种草)、公众号(专业输出)给出适配建议 |
| `calendar-planner-cn hot [话题]` | 热点追踪 — 查看微博热搜/知乎热榜/抖音热点 |
| `calendar-planner-cn template [类型]` | 模板库 — 提供测评/教程/种草/避坑/合集/对比等内容模板 |
| `calendar-planner-cn translate <文本>` | 中英互译 — 输入中文或英文进行翻译 |
| `calendar-planner-cn proofread <文案>` | 校对检查 — 检查错别字、标点、逻辑、敏感词 |
| `calendar-planner-cn help` | 显示帮助信息 |
| `calendar-planner-cn version` | 显示版本号 |

## 数据存储

所有操作记录存储在 `~/.local/share/calendar-planner-cn/` 目录下：

- `history.log` — 统一操作日志，记录每条命令的时间戳和内容
- `data.log` — 数据文件

**日志格式:** `MM-DD HH:MM <command>: <value>`

可通过设置 `CALENDAR_PLANNER_CN_DIR` 或 `XDG_DATA_HOME` 环境变量自定义数据目录。

## 环境要求

- **bash** (版本 4+ 推荐)
- 标准 POSIX 工具：`date`, `cat`, `echo`, `grep`
- 无外部依赖，无需网络
- 支持 Linux, macOS, WSL

## 使用场景

1. **自媒体内容创作** — 用 `write` 生成文章框架，`title` 优化标题，`outline` 规划结构，快速产出高质量内容
2. **多平台内容分发** — 用 `platform` 获取知乎、小红书、公众号等不同平台的适配建议，一稿多发
3. **蹭热点快速产出** — 用 `hot` 追踪当前热点话题，结合 `template` 选择合适模板，快速创作热点内容
4. **文案精修与校对** — 用 `polish` 润色文案风格，`proofread` 检查错别字和敏感词，确保内容质量
5. **中英双语内容创作** — 用 `translate` 进行中英互译，支持双语内容同步发布或英文资料本地化

## 示例

```bash
# 生成写作框架
calendar-planner-cn write "如何高效学英语" 800

# 生成多个标题选项
calendar-planner-cn title "时间管理"

# 生成文章大纲
calendar-planner-cn outline "远程办公效率"

# 润色文案
calendar-planner-cn polish "这个产品真的很好用推荐给大家"

# 生成话题标签
calendar-planner-cn hashtag "咖啡推荐"

# 获取平台适配建议
calendar-planner-cn platform "产品测评"

# 查看热点
calendar-planner-cn hot

# 浏览内容模板
calendar-planner-cn template

# 中英互译
calendar-planner-cn translate "人工智能改变生活"

# 校对文案
calendar-planner-cn proofread "这篇文章写的真好，值得推件"
```

## 推荐工作流

```
选题(hot/template) → 标题(title) → 大纲(outline) → 写作(write) → 润色(polish) → 校对(proofread) → 标签(hashtag) → 平台适配(platform) → 发布
```

## 工作原理

Calendar Planner CN 是一个轻量级中文内容创作辅助工具。所有命令通过 bash 脚本直接执行，每次操作都会记录到 `history.log` 中。工具覆盖从选题到发布的完整内容创作流程，适合自媒体运营者、内容创作者和文案工作者使用。

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
