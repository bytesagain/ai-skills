---
version: "2.0.0"
name: Changelog Writer
description: "Changelog Writer - CHANGELOG管理工具. Use when you need changelog writer capabilities. Triggers on: changelog writer."
  CHANGELOG生成器。变更日志、版本发布、语义化版本、差异对比、模板。Changelog writer with release notes, semver, diff, templates. CHANGELOG、版本管理。
author: BytesAgain
---
# Changelog Writer

CHANGELOG生成器。变更日志、版本发布、语义化版本、差异对比、模板。Changelog writer with release notes, semver, diff, templates. CHANGELOG、版本管理。

## 与手动操作对比

| | 手动 | 使用本工具 |
|---|---|---|
| 时间 | 数小时 | 几分钟 |
| 专业度 | 取决于经验 | 专业级输出 |
| 一致性 | 易遗漏 | 标准化模板 |

## 可用命令

- **generate** — generate
- **format** — format
- **release** — release
- **semver** — semver
- **diff** — diff
- **template** — template

---
*Changelog Writer by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `keepachangelog` — Keepachangelog
- `simple` — Simple
- `compact` — Compact
- `init` — Init
- `add` — version "1.2.0" [--added "..."] [--changed "..."] [--fixed "..."]
- `format` — style <keepachangelog|simple|compact>
- `unreleased` — added "Feature description"
- `diff` — from "1.0.0" --to "1.1.0" [--file CHANGELOG.md]

## Examples

```bash
# Show help
changelog-writer help

# Run
changelog-writer run
```
