---
version: "2.0.0"
name: GDPR Checker
description: "GDPR Compliance Checker. Use when you need gdpr checker capabilities. Triggers on: gdpr checker."
  GDPR合规检查。合规审计、用户同意、数据权利、泄露响应、DPA、检查清单。GDPR compliance checker. GDPR、数据保护。
author: BytesAgain
---
# GDPR Checker

GDPR合规检查。合规审计、用户同意、数据权利、泄露响应、DPA、检查清单。GDPR compliance checker. GDPR、数据保护。

## 推荐工作流

```
需求分析 → 选择命令 → 输入描述 → 获取结果 → 调整优化
```

## 命令速查

```
  audit           audit
  consent         consent
  rights          rights
  breach          breach
  dpa             dpa
  checklist       checklist
```

---
*GDPR Checker by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `gdpr-checker help` for all commands

## Commands

Run `gdpr-checker help` to see all available commands.

## When to Use

- to automate gdpr tasks in your workflow
- for batch processing checker operations

## Output

Returns reports to stdout. Redirect to a file with `gdpr-checker run > output.txt`.

## Configuration

Set `GDPR_CHECKER_DIR` environment variable to change the data directory. Default: `~/.local/share/gdpr-checker/`
