---
version: "2.0.0"
name: color-palette-cn
description: "配色方案生成、色彩和谐(互补/类似/三色)、品牌配色、对比度检查(WCAG)、颜色格式转换(HEX/RGB/HSL)、流行色推荐。Color palette generator with harmony, brand colors, WCAG contrast check, format conversion."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Color Palette CN — 中文内容创作工具

中文内容创作一站式工具，涵盖写作生成、标题优化、大纲规划、文案润色、话题标签、平台适配、热点追踪、模板库、中英互译和校对检查，帮你高效产出优质中文内容。

## 命令列表

| 命令 | 功能说明 |
|------|----------|
| `write <主题> [字数]` | 根据主题生成文章，可指定字数（默认500字） |
| `title <关键词>` | 围绕关键词生成3个标题方案（全攻略/冷知识/避坑指南） |
| `outline <主题>` | 生成五段式大纲：引言 → 背景 → 要点 → 总结 → 互动 |
| `polish <文案>` | 提供润色建议：简洁、有力、口语化、加emoji |
| `hashtag <关键词>` | 生成5个相关话题标签（#关键词 #分享 #干货 等） |
| `platform <内容>` | 根据内容推荐平台适配方案（知乎/小红书/公众号） |
| `hot [关键词]` | 追踪当前热点（微博热搜/知乎热榜/抖音热点） |
| `template [类型]` | 显示可用模板类型（测评/教程/种草/避坑/合集/对比） |
| `translate <文本>` | 中英互译 |
| `proofread <文案>` | 校对检查：错别字、标点、逻辑、敏感词 |
| `help` | 显示帮助信息 |
| `version` | 显示版本号（v2.0.0） |

## 使用方法

```bash
color-palette-cn <命令> [参数]
```

每个命令执行后会自动记录到 `$DATA_DIR/history.log`，方便追溯操作历史。

## 数据存储

- **默认路径**: `$XDG_DATA_HOME/color-palette-cn`（通常为 `~/.local/share/color-palette-cn`）
- **自定义路径**: 设置 `COLOR_PALETTE_CN_DIR` 环境变量
- **存储文件**:
  - `history.log` — 所有操作的时间戳记录
  - `data.log` — 通用数据日志

## 环境要求

- Bash 4+（严格模式：`set -euo pipefail`）
- 无需外部依赖或 API Key
- 仅使用标准 Unix 工具（`date`、`echo`）

## 适用场景

1. **自媒体内容创作** — 用 `write` 快速生成初稿，`title` 优化标题，`hashtag` 生成话题标签，一条龙完成内容生产
2. **多平台分发** — 用 `platform` 获取各平台（知乎长文、小红书图文种草、公众号专业输出）的适配建议
3. **文案质量把控** — 用 `polish` 润色文案，`proofread` 检查错别字和敏感词，确保发布质量
4. **热点追踪与选题** — 用 `hot` 追踪微博/知乎/抖音热点，结合 `outline` 快速搭建文章结构
5. **中英文内容翻译** — 用 `translate` 进行中英互译，适合双语内容创作和跨语言沟通

## 使用示例

```bash
# 根据主题写一篇800字的文章
color-palette-cn write "咖啡拉花技巧" 800

# 生成标题方案
color-palette-cn title "减脂餐"

# 生成文章大纲
color-palette-cn outline "如何开始跑步"

# 润色文案
color-palette-cn polish "这个产品真的很好用推荐大家买"

# 生成话题标签
color-palette-cn hashtag "露营"

# 查看平台适配建议
color-palette-cn platform "科技测评"

# 追踪热点
color-palette-cn hot

# 查看可用模板
color-palette-cn template

# 中英互译
color-palette-cn translate "人工智能正在改变世界"

# 校对文案
color-palette-cn proofread "今天天汽真好，适和出去完"
```

## 输出说明

- 所有输出为纯文本格式，直接打印到 stdout
- 操作历史自动追加到 `$DATA_DIR/history.log`
- 可通过重定向保存输出：`color-palette-cn write "主题" > draft.md`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
