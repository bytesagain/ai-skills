---
version: "2.0.0"
name: work-report-writer
description: "Work report generator. 工作汇报生成器、周报生成、工作周报、每周总结、weekly report、周报模板、周报怎么写、日报生成、工作日报、daily report、日报模板、月报生成、月度总结、monthly report、项目汇报、年终总结、年度总结、annual review、站会汇报."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Work Report Writer

工作汇报生成器，通过 `scripts/report.sh` 生成结构化的工作汇报。

## 为什么用这个 Skill？ / Why This Skill?

- **结构化输出**：自动分"完成事项→数据成果→下步计划→风险问题"四段式，领导爱看
- **关键词扩展**：输入简短关键词，自动扩展成专业的工作描述，省时省力
- **中英切换**：`--lang en` 一键切换英文输出，适合外企和跨国团队
- Compared to asking AI directly: structured report templates with quantified results sections, automatic keyword expansion, and bilingual support — not just free-form text

## Commands

```bash
SCRIPT="$(dirname "$0")/../skills/work-report-writer/scripts/report.sh"

# 日报
bash "$SCRIPT" daily "完成了用户模块开发,修复了3个bug,review了2个PR"

# 周报
bash "$SCRIPT" weekly "完成用户系统重构,上线支付模块,优化数据库查询性能提升40%"

# 月报
bash "$SCRIPT" monthly "完成Q1核心功能开发,团队扩招2人,用户增长15%"

# 项目汇报
bash "$SCRIPT" project "用户中台" "完成微服务拆分,API网关上线,性能提升60%"

# 年终总结
bash "$SCRIPT" annual "技术升级,团队建设,业务增长,降本增效"

# 站会汇报
bash "$SCRIPT" standup "昨天完成了API重构,今天计划写单元测试,阻塞:等待设计稿"

# OKR报告
bash "$SCRIPT" okr "提升系统稳定性" "可用性达到99.9%,P0故障减少50%,监控覆盖率100%"

# 项目复盘报告
bash "$SCRIPT" review "用户中台" "完成微服务拆分,性能提升60%,上线零故障"

# 帮助
bash "$SCRIPT" help
```

## Options

All commands support optional flags:

- `--lang en` — Output in English (default: Chinese)
- `--lang cn` — Output in Chinese (default)

## Workflow

1. Receive user's work content (bullet points, keywords, or brief description).
2. Run the appropriate `report.sh` subcommand.
3. Present the generated report to the user.
4. Offer to adjust tone, add/remove sections, or switch language.

## Output Structure

All reports include where applicable:

- **工作内容/完成事项** — What was done, with specifics
- **数据与成果** — Quantified results and highlights
- **下步计划** — Next steps and upcoming work
- **风险/问题** — Blockers, risks, or issues to flag

- Encourage users to include numbers and metrics for more impactful reports.
- When content is brief, the script expands keywords into professional descriptions.
- Reports can be further customized after generation.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
