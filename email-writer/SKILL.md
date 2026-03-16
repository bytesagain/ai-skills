---
version: "2.0.0"
name: email-writer
description: "Email writing assistant. 邮件写作、邮件助手、商务邮件、business email、英文邮件、English email、求职邮件、job application email、跟进邮件、follow-up email、冷启动邮件、cold email、道歉邮件、apology email、回复邮件、reply email、邮件模板、email template、外贸邮件、催款邮件、感谢邮件、邀请邮件、通知邮件、邮件序列、email sequence、邮件主题行、subject line、高打开率、拒绝邮件、decline email。Generate business, follow-up, cold outreach, apology, reply emails, email sequences (sales/cooperation/collection/recruitment), template library (thanks/notice/invitation/decline/collection), and high-open-rate subject lines. Use when: (1) writing business/professional emails, (2) crafting follow-up emails, (3) writing cold outreach emails, (4) composing apology emails, (5) replying to emails with appropriate tone, (6) creating email sequences for sales or recruitment, (7) generating email templates for common scenarios, (8) writing high-open-rate subject lines, (9) any email writing task in Chinese or English. 适用场景：写商务邮件、跟进邮件、冷启动邮件、道歉邮件、回复邮件、邮件序列、邮件模板库、主题行优化。中英双语支持。 Triggers on: email writer."
author: BytesAgain
---

# email-writer

邮件写作助手。商务邮件、求职邮件、跟进邮件、道歉邮件。中英双语。

## 为什么用这个 Skill？ / Why This Skill?

- **场景化模板**：商务、跟进、冷启动、道歉、回复——每种邮件有专属结构和语气
- **语气控制**：`--tone formal|friendly` 切换正式/友好语气
- **中英双语**：同一封邮件可以中英文对照输出
- Compared to asking AI directly: purpose-built email templates with tone control, proper business email structure (subject line, greeting, body, CTA, sign-off)

## Usage

Run the script at `scripts/email.sh`:

| Command | Description |
|---------|-------------|
| `email.sh business "收件人" "主题"` | 商务邮件模板 |
| `email.sh followup "主题"` | 跟进邮件模板 |
| `email.sh cold "公司" "目的"` | 冷启动邮件模板 |
| `email.sh apology "原因"` | 道歉邮件模板 |
| `email.sh reply "原文摘要" [--tone formal\|friendly]` | 回复邮件模板 |
| `email.sh series "场景(销售\|合作\|催款\|招聘)"` | 邮件序列（4封自动化） |
| `email.sh template "类型(感谢\|通知\|邀请\|拒绝\|催款)"` | 邮件模板库 |
| `email.sh subject "内容描述"` | 高打开率主题行生成（5种风格） |
| `email.sh help` | 显示帮助信息 |

## Examples

```bash
# 商务邮件
bash scripts/email.sh business "王总" "合作方案"

# 跟进邮件
bash scripts/email.sh followup "上周会议跟进"

# 冷启动邮件
bash scripts/email.sh cold "字节跳动" "技术合作"

# 道歉邮件
bash scripts/email.sh apology "发货延迟"

# 回复邮件（正式语气）
bash scripts/email.sh reply "对方询问报价" --tone formal

# 邮件序列（销售场景4封）
bash scripts/email.sh series "销售"

# 邮件模板（感谢信）
bash scripts/email.sh template "感谢"

# 生成5种风格的主题行
bash scripts/email.sh subject "新产品发布"
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
