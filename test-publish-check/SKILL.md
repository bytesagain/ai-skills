---
version: "2.0.0"
name: Test & Publish Checker
description: "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━. Use when you need test publish check capabilities. Triggers on: test publish check."
  项目发布前检查工具。代码质量检查、API测试、部署检查清单、版本管理、上线前审查、回归测试。Pre-publish quality checker for code, API, deployment, versioning, launch review, regression testing. 发布检查、上线审查、质量保证、QA、测试、部署。Use before releasing any software, website, app, or content to production.
author: BytesAgain
---
# Test & Publish Checker

发布前的最后一道防线。帮你检查代码质量、API状态、部署配置、版本号、上线清单，确保万无一失。

## Commands

- `code` — 代码质量检查清单（代码审查、lint、测试覆盖率、安全扫描）
- `api` — API发布检查（端点测试、认证、限流、文档、版本兼容）
- `deploy` — 部署检查清单（环境变量、数据库迁移、CDN、DNS、SSL）
- `version` — 版本管理指南（语义化版本、CHANGELOG、Git Tag、Release Notes）
- `launch` — 上线日检查清单（回滚方案、监控、告警、灰度、公告）
- `regression` — 回归测试计划（核心流程、边界条件、兼容性、性能基准）

## Usage Examples

```bash
# 检查代码是否准备好发布
test-publish-check code "React电商项目"

# API上线前检查
test-publish-check api "用户认证API v2.0"

# 完整上线日清单
test-publish-check launch "新版本 v3.2.0"
```

1. **发布前至少过一遍 `launch` 清单** — 90%的线上事故可以避免
2. **版本号遵循 SemVer** — MAJOR.MINOR.PATCH，不要乱来
3. **永远有回滚方案** — 没有回滚方案=裸奔上线
4. **灰度发布** — 先1%用户，再10%，再100%
5. **凌晨发布不如工作日上午发布** — 出问题有人能响应

## About

Part of the BytesAgain productivity toolkit. Visit [bytesagain.com](https://bytesagain.com) for more tools.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
