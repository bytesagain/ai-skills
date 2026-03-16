---
version: "2.0.0"
name: password-generator
description: "强密码生成、密码强度检查、密码策略建议、密码短语、批量生成、安全审计。Password generator, strength checker, policy advisor, passphrase, bulk generation, security audit. Use when you need password generator capabilities. Triggers on: password generator."
---
# password-generator

强密码生成、密码强度检查、密码策略建议、密码短语、批量生成、安全审计。Password generator, strength checker, policy advisor, passphrase, bulk generation, security audit.

## 核心特点

🎯 **精准** — 针对具体场景定制化输出
📋 **全面** — 多个命令覆盖完整工作流
🇨🇳 **本土化** — 完全适配中文用户习惯

## 命令列表

| 命令 | 功能 |
|------|------|
| `generate` | generate |
| `check` | check |
| `policy` | policy |
| `passphrase` | passphrase |
| `bulk` | bulk |
| `audit` | audit |


## 专业建议

- | 等级 | 长度 | 字符集 | 熵(bits) | 暴力破解时间 |
- |------|------|--------|----------|-------------|
- | 极弱 | <6 | 仅数字 | <20 | 秒级 |
- | 弱 | 6-8 | 小写字母 | 20-35 | 分钟~小时 |
- | 中等 | 8-12 | 大小写+数字 | 35-55 | 天~月 |

---
*password-generator by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Commands

| Command | Description |
|---------|-------------|
| `password-generator help` | Show usage info |
| `password-generator run` | Run main task |

## Examples

```bash
password-generator help
password-generator run
```
