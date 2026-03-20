---
version: "2.0.0"
name: email-template
description: "邮件模板库。欢迎邮件、Newsletter、事务邮件、冷启动邮件、跟进邮件、催款邮件模板生成。Email template library with welcome, newsletter, transactional, cold outreach, follow-up."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# email-template

邮件模板库。欢迎邮件、Newsletter、事务邮件、冷启动邮件、跟进邮件、催款邮件模板生成。Email template library with welcome, newsletter, transactional, cold outreach, follow-up, and collection templates.

## 常见问题

**Q: 这个工具适合谁用？**
A: 任何需要email-template的人，无论是个人还是企业用户。

**Q: 输出格式是什么？**
A: 主要输出Markdown格式，方便复制和编辑。

## 命令列表

| 命令 | 功能 |
|------|------|
| `welcome` | welcome |
| `newsletter` | newsletter |
| `transactional` | transactional |
| `cold` | cold |
| `followup` | followup |
| `collection` | collection |

## 专业建议

- Identify which type: welcome / newsletter / transactional / cold / followup / collection
- Run: `bash scripts/emailtpl.sh <type> [industry] [tone]`
- Present the generated template to the user
- Offer customization: subject line variants, CTA options, tone adjustment
- Subject lines matter** — provide 3-5 variants with open-rate optimization tips

---
*email-template by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
email-template help

# Run
email-template run
```

## Commands

Run `email-template help` to see all available commands.

## Requirements
- bash 4+
- python3 (standard library only)
