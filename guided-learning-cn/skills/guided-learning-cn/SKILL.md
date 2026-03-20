---
version: "2.0.0"
name: guided-learning-cn
description: "中文引导式学习助手。学习助手、知识学习、学习计划、学习路线、概念讲解、复习备考、考试复习、费曼学习法、循序渐进学习、学科辅导、自学、教程、课程学习、教材学习、知识点总结、记忆卡片、闪卡、Anki、学习方法、一对一辅导、自测试卷、选择题、简答题。Chinese guided learning assistant w."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# 中文内容创作工具 (guided-learning-cn)

中文内容创作一站式命令行工具 — 写作生成、标题创意、大纲规划、文案润色、话题标签、平台适配、热点追踪、模板库、中英互译、校对检查，十大功能覆盖内容创作全流程。

## Commands

All commands are run via `guided-learning-cn <command> [args]`.

| Command | Description | Example |
|---------|-------------|---------|
| `write <topic> [wordcount]` | 写作生成 — 根据主题和字数生成文案 | `guided-learning-cn write "旅行" 800` |
| `title <topic>` | 标题生成 — 为主题生成多个创意标题候选 | `guided-learning-cn title "咖啡"` |
| `outline <topic>` | 大纲生成 — 生成引言/背景/要点/总结/互动五段式大纲 | `guided-learning-cn outline "健身入门"` |
| `polish <text>` | 文案润色 — 提供简洁、有力、口语化、加emoji等润色建议 | `guided-learning-cn polish "这段文字"` |
| `hashtag <topic>` | 话题标签 — 自动生成与主题相关的热门话题标签 | `guided-learning-cn hashtag "美食"` |
| `platform <topic>` | 平台适配 — 针对知乎/小红书/公众号等平台给出内容适配建议 | `guided-learning-cn platform "护肤"` |
| `hot [topic]` | 热点追踪 — 查看微博热搜/知乎热榜/抖音热点 | `guided-learning-cn hot` |
| `template [type]` | 模板库 — 测评/教程/种草/避坑/合集/对比等内容模板 | `guided-learning-cn template` |
| `translate <text>` | 中英互译 — 翻译文本 | `guided-learning-cn translate "hello world"` |
| `proofread <text>` | 校对检查 — 检查错别字/标点/逻辑/敏感词 | `guided-learning-cn proofread "检查这段话"` |
| `help` | 显示帮助信息 | `guided-learning-cn help` |
| `version` | 显示版本号 | `guided-learning-cn version` |

## Data Storage

- **Data directory:** `${GUIDED_LEARNING_CN_DIR}` or `${XDG_DATA_HOME}/guided-learning-cn/` (default: `~/.local/share/guided-learning-cn/`)
- **History log:** `$DATA_DIR/history.log` — all command usage with timestamps are automatically recorded
- **Data log:** `$DATA_DIR/data.log` — persistent data storage
- All directories are auto-created on first run

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail` for strict error handling)
- No external dependencies — pure bash, runs on any Linux/macOS system
- Optional: set `GUIDED_LEARNING_CN_DIR` environment variable to customize data storage location

## When to Use

1. **自媒体创作** — 需要快速为小红书、知乎、公众号等平台生成标题、大纲和文案时
2. **文案润色** — 写完初稿后想让文字更简洁有力、更口语化、加上emoji提升可读性时
3. **热点蹭流量** — 想查看微博热搜/知乎热榜/抖音热点，快速产出追热点内容时
4. **多平台分发** — 同一内容需要适配不同平台风格（知乎长文深度 vs 小红书图文种草 vs 公众号专业输出）时
5. **中英文内容翻译与校对** — 需要中英互译或检查文案中的错别字、标点、逻辑和敏感词时

## Examples

### 生成写作文案

```bash
# 生成500字（默认）的旅行主题文案
guided-learning-cn write "旅行"

# 生成800字的美食主题文案
guided-learning-cn write "美食" 800
```

### 标题创意 + 大纲规划

```bash
# 生成多个标题候选
guided-learning-cn title "咖啡"
# 输出:
#   1. 咖啡全攻略
#   2. 关于咖啡你不知道的事
#   3. 咖啡避坑指南

# 生成五段式大纲
guided-learning-cn outline "咖啡入门"
# 输出: 1. 引言 | 2. 背景 | 3. 要点 | 4. 总结 | 5. 互动
```

### 话题标签与平台适配

```bash
# 生成话题标签
guided-learning-cn hashtag "护肤"
# 输出: #护肤 #护肤分享 #干货 #推荐 #日常

# 查看各平台适配建议
guided-learning-cn platform "护肤"
# 输出: 知乎: 长文深度 | 小红书: 图文种草 | 公众号: 专业输出
```

### 润色与校对

```bash
# 获取文案润色建议
guided-learning-cn polish "这是一段需要改进的文字"
# 输出: 润色建议: 简洁 | 有力 | 口语化 | 加emoji

# 校对检查
guided-learning-cn proofread "检查这段文字有没有问题"
# 输出: 检查: 错别字 | 标点 | 逻辑 | 敏感词
```

### 翻译与热点

```bash
# 中英互译
guided-learning-cn translate "Hello World 你好世界"

# 查看当前热点
guided-learning-cn hot

# 浏览内容模板类型
guided-learning-cn template
# 输出: 测评 | 教程 | 种草 | 避坑 | 合集 | 对比
```

## How It Works

每条命令执行后会自动记录到 `$DATA_DIR/history.log`，格式为 `MM-DD HH:MM command: args`，方便回顾创作历史。所有数据存储在本地，不依赖外部 API，保证隐私安全。

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
