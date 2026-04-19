---
version: "2.0.0"
name: bytesagain-privacy-policy
description: "Generate GDPR/CCPA-compliant privacy policies. Use when scanning data practices, auditing consent flows, checking compliance, drafting policy documents."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Privacy Policy Generator

隐私政策生成器。GDPR/CCPA合规、App/网站隐私政策、合规审计。Privacy policy generator with GDPR, CCPA compliance. 隐私政策、合规。

## 速查表

See commands above.

## 命令列表

| 命令 | 功能 |
|------|------|
| `generate` | generate |
| `gdpr` | gdpr |
| `ccpa` | ccpa |
| `app` | app |
| `website` | website |
| `audit` | audit |

> 💡 小技巧：先用 `help` 查看所有命令，再选择最适合的

---
*Privacy Policy Generator by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `Analytics` — Analytics
- `generate` — company "MyApp" --email "privacy@myapp.com" [--type web|app|both]
- `gdpr` — company "MyApp" --email "dpo@myapp.com"
- `ccpa` — company "MyApp" --email "privacy@myapp.com"

## Examples

```bash
# Show help
privacy-policy help

# Run
privacy-policy run
```

- Run `privacy-policy help` for all commands

## Requirements
- bash 4+
- python3 (standard library only)
