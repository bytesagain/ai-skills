---
version: "2.0.0"
name: cron-expression
description: "Cron表达式生成、解释、常用示例、验证、下次执行时间、平台转换(Linux/AWS/GitHub Actions). Use when you need cron expression capabilities. Triggers on: cron expression."
author: BytesAgain
---
# cron-expression

Cron表达式生成、解释、常用示例、验证、下次执行时间、平台转换(Linux/AWS/GitHub Actions)

## 核心特点

🎯 **精准** — 针对具体场景定制化输出
📋 **全面** — 多个命令覆盖完整工作流
🇨🇳 **本土化** — 完全适配中文用户习惯

## 可用命令

- **generate** — generate
- **explain** — explain
- **examples** — examples
- **validate** — validate
- **next** — next
- **convert** — convert

## 专业建议

- ```
- ┌──────── 分钟 (0-59)
- │ ┌────── 小时 (0-23)
- │ │ ┌──── 日 (1-31)
- │ │ │ ┌── 月 (1-12)

---
*cron-expression by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `cron-expression help` for all commands

## Commands

Run `cron-expression help` to see all available commands.

## When to Use

- as part of a larger automation pipeline
- when you need quick cron expression from the command line

## Output

Returns results to stdout. Redirect to a file with `cron-expression run > output.txt`.

## Configuration

Set `CRON_EXPRESSION_DIR` environment variable to change the data directory. Default: `~/.local/share/cron-expression/`
