---
version: "2.0.0"
name: code-reviewer-cn
description: "代码审查、重构建议、安全漏洞检查、命名规范、复杂度分析、注释文档生成. Use when you need code reviewer cn capabilities. Triggers on: code reviewer cn, 圈复杂度估算, 嵌套深度检测, 命名风格一致性, 注释率计算与评级, 重复行检测."
author: BytesAgain
---
# code-reviewer-cn

代码审查、重构建议、安全漏洞检查、命名规范、复杂度分析、注释文档生成

## 核心特点

🎯 **精准** — 针对具体场景定制化输出
📋 **全面** — 多个命令覆盖完整工作流
🇨🇳 **本土化** — 完全适配中文用户习惯

## 命令速查

```
  review          review
  refactor        refactor
  security        security
  naming          naming
  complexity      complexity
  document        document
```

## 专业建议

- [ ] 边界条件处理（空值、零、负数、最大值）
- [ ] 错误处理（try-catch、错误码）
- [ ] 并发安全（竞态条件、死锁）
- [ ] 资源释放（文件句柄、数据库连接）
- [ ] 避免N+1查询

---
*code-reviewer-cn by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `code-reviewer-cn help` for all commands

## Commands

Run `code-reviewer-cn help` to see all available commands.

## When to Use

- Quick code tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `code-reviewer-cn run > output.txt`.
