---
version: "2.0.0"
name: product-listing-generator
description: "电商产品文案生成器。支持全平台上架文案、跨境电商多平台listing、短视频脚本、FAQ生成、组合套装文案、标题优化诊断、用户痛点挖掘。Generate e-commerce product listing copy including titles, selling points, descriptions."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Product Listing Generator

Generate professional e-commerce product listing copy via templated output. No external API required.

## Commands

Run `scripts/product.sh` with the following subcommands:

| Command | Usage | Description |
|---------|-------|-------------|
| `generate` | `product.sh generate "产品名" [--platform taobao\|pdd\|amazon\|shopify]` | Full listing: titles + selling points + description + SEO keywords. Defaults to all platforms if none specified. |
| `title` | `product.sh title "产品名"` | 5 title variants optimized for search and click-through |
| `seo` | `product.sh seo "产品名"` | SEO keyword list (core, long-tail, related) |
| `desc` | `product.sh desc "产品名"` | Complete product description with structure |
| `compare` | `product.sh compare "产品A" "产品B"` | Side-by-side competitive comparison copy |
| `cross-border` | `product.sh cross-border "产品名" "目标市场"` | 跨境电商文案（亚马逊/Shopee/速卖通），含A+内容框架 |
| `video-script` | `product.sh video-script "产品名"` | 完整分镜短视频脚本（画面+旁白+字幕+BGM） |
| `faq` | `product.sh faq "产品名"` | 12个真实高频FAQ + 专业回答 |
| `bundle` | `product.sh bundle "产品1,产品2"` | 组合套装文案（搭配逻辑+定价策略+多平台适配） |
| `optimize` | `product.sh optimize "现有标题"` | 标题优化诊断：分析关键词缺失/顺序/字数/卖点问题，输出5个优化版+布局建议 |
| `pain` | `product.sh pain "产品类别"` | 用户痛点挖掘：TOP10痛点+文案切入角度+差评避雷清单 |
| `help` | `product.sh help` | Show usage instructions |

## Workflow

1. Determine which subcommand matches the user's request.
2. Run the script: `bash scripts/product.sh <subcommand> <args>`
3. Present the output to the user, adjusting tone/detail as needed.

## Platform Adaptation

Each platform has distinct copy conventions:

- **淘宝 (taobao)**: Emoji-rich, benefit-driven, urgency language
- **拼多多 (pdd)**: Price-focused, simple language, value emphasis
- **Amazon**: Feature-bullet format, keyword-dense, professional tone
- **Shopify/独立站**: Brand storytelling, lifestyle imagery, SEO-optimized paragraphs

The `generate` command adapts output style per platform automatically.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
product-listing-generator help

# Run
product-listing-generator run
```
