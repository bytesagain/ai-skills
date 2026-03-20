---
version: "2.0.0"
name: zhihu-writer
description: "Zhihu answer and article generator. 知乎回答、知乎文章、知乎专栏、知乎盐选、盐选故事、高赞回答、知乎SEO、知乎涨粉、知乎运营、知乎写作、专栏写作、知乎问答、知乎干货、知乎长文、Zhihu answer、Zhihu article、数据型回答、故事型回答、专业回答、辩论型回答、."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# zhihu-writer

知乎回答和文章生成器。专业回答、故事型回答、数据型回答。

## 为什么用这个 Skill？ / Why This Skill?

- **知乎调性**：专业、有深度、有论据，不是水文——符合知乎社区的高赞回答风格
- **4种风格**：专业型、故事型、数据型、辩论型，适配不同问题类型
- **盐选模式**：内置知乎盐选付费故事开头的写作框架，开头留悬念
- Compared to asking AI directly: Zhihu-specific writing styles, platform-appropriate tone and formatting, Yanxuan story hooks

## Usage

```bash
# 生成知乎回答（默认专业风格）
zhihu.sh answer "问题" [--style professional|story|data|debate]

# 生成知乎专栏文章
zhihu.sh article "主题"

# 生成5个吸引人的标题
zhihu.sh title "主题"

# 知乎盐选风格创作（付费故事开头）
zhihu.sh salt "话题"

# 帮助
zhihu.sh help
```

## When to Use

- 用户想写知乎回答或文章
- 需要不同风格的回答（专业/故事/数据/辩论）
- 需要知乎盐选风格的创作
- 需要吸引人的知乎标题

脚本使用 Python 生成符合知乎平台调性的内容模板，包含结构化框架和写作技巧提示。

## Commands

| Command | Description |
|---------|-------------|
| `answer` | 生成知乎回答，支持4种风格 |
| `article` | 生成知乎专栏文章框架 |
| `title` | 生成5个吸引人的标题 |
| `salt` | 知乎盐选风格创作 |
| `help` | 显示帮助信息 |

## Output

所有输出为纯文本，直接可用于知乎平台。

## 输出示例 / Example Output

### 生成知乎回答
```bash
$ zhihu.sh answer "程序员35岁以后怎么办" --style professional
```
输出包含：开头观点亮明 → 分点论述（3-5个要点）→ 个人经验/案例 → 总结金句。格式符合知乎高赞回答结构。

### 生成盐选故事开头
```bash
$ zhihu.sh salt "职场"
```
输出盐选付费故事风格的开头（800-1200字），含悬念钩子和情节铺垫。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
