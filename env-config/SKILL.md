---
version: "2.0.0"
name: Env Config Manager
description: "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━. Use when you need env config capabilities. Triggers on: env config."
  环境变量配置管理。.env模板生成(Node/Python/Go/Docker)、验证、环境变量生成、多环境合并、加密建议、文档化。Environment variable config manager with templates, validation, generation, multi-env merge, encryption, documentation. .env、配置管理、环境变量。
author: BytesAgain
---
# Env Config Manager

环境变量配置管理。.env模板生成(Node/Python/Go/Docker)、验证、环境变量生成、多环境合并、加密建议、文档化。Environment variable config manager with templates, validation, generation, multi-env merge, encryption, documentation. .env、配置管理、环境变量。

## 使用场景

> 💡 无论你是新手还是专业人士，都能快速上手

## 可用命令

- **template** — template
- **validate** — validate
- **generate** — generate
- **merge** — merge
- **encrypt** — encrypt
- **document** — document

## 专业建议

- 每个项目都有 `.env.example`（不含真实值）
- `.env` 加入 `.gitignore`
- 变量名全大写下划线分隔: `DATABASE_URL`
- 布尔值用 `true/false` 不用 `1/0`
- 生产环境不要用 .env 文件，用环境变量注入

---
*Env Config Manager by BytesAgain*

## Commands

- `compose` — ============================================
- `decode` — Execute decode
- `diff` — Execute diff
- `encode` — Execute encode
- `fastapi` — ============================================
- `gitignore` — Execute gitignore
- `golang` — ============================================
- `lint` — Execute lint
- `node` — Execute node
- `nodejs` — ============================================
- `nuxt` — ============================================
- `sort` — 🔑 .env.example 中有但 .env 中缺少的键：
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
env-config help

# Run
env-config run
```
