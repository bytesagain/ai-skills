---
version: "2.0.0"
name: Blog Writer
description: "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━. Use when you need blog writer pro capabilities. Triggers on: blog writer pro."
  博客写作助手。完整文章生成(Markdown输出)、多角度大纲、SEO优化诊断、开头段落、系列文章规划、风格改写、CTA文案。Blog writer with full articles, outlines, SEO analysis, hooks, series planning, rewriting, CTA copy. 博客、写作、SEO、内容营销。
author: BytesAgain
---

# Blog Writer

博客写作全流程助手：文章生成、大纲规划、SEO优化、开头段落、系列规划、风格改写、CTA文案。

## 使用方式

Agent会根据用户需求自动调用 `scripts/blog.sh` 脚本。

### 可用命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `write [主题]` | 生成完整博客文章（1500-2000字），输出Markdown | "远程办公的未来" |
| `outline [主题]` | 生成3种不同角度的文章大纲 | "AI对教育的影响" |
| `seo [内容]` | SEO优化建议（标题/关键词/meta/内链） | 粘贴文章内容 |
| `hook [主题]` | 生成5个吸引人的开头段落 | "如何学好编程" |
| `series [主题]` | 系列文章规划（10篇标题+简介+时间表） | "Python从入门到精通" |
| `rewrite [文章] [风格]` | 风格改写（专业/通俗/幽默/学术） | 粘贴文章 + 指定风格 |
| `cta [产品/服务]` | 5种不同风格的CTA文案 | "在线编程课程" |

### 使用提示

1. **write**: 提供主题，生成完整的1500-2000字博客文章（Markdown格式）
2. **outline**: 从不同角度（教程型/观点型/案例型）生成大纲
3. **seo**: 全面的SEO诊断，含可操作的优化建议
4. **hook**: 5种不同风格的开头（故事型/数据型/提问型/反常型/场景型）
5. **series**: 10篇系列文章的完整规划，含发布节奏建议
6. **rewrite**: 保持核心内容不变，转换写作风格
7. **cta**: 紧迫型/价值型/社交证明型/轻松型/数据型CTA

### 参考文档

博客运营指南、SEO基础、爆款标题公式请查看 `tips.md`。

### Agent指引

当用户请求博客写作相关操作时：

1. 确认主题和目标读者
2. 运行对应命令：`bash scripts/blog.sh <command> "<content>"`
3. 展示结果并提供改进建议
4. 对于 `write` 命令，建议后续用 `seo` 命令优化
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `write` — Write
- `outline` — Outline
- `seo` — Seo
- `hook` — Hook
- `series` — Series
- `rewrite` — Rewrite
- `cta` — Cta

## Examples

```bash
# Show help
blog-writer-pro help

# Run
blog-writer-pro run
```
