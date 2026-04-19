---
name: "JSON Editor — Advanced Logic Parser & Formatter"
description: "Prettify, minify, and query JSON data with path notation. 支持 JSON 格式美化、压缩及路径提取 (JQ 风格)。Use when debugging APIs, cleaning nested data, or extracting specific fields from logs."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["json", "data-format", "api-debug", "devtools", "formatter", "jq", "数据处理"]
---

# JSON Editor / 楼台 JSON 助手

## Quick Start / 快速开始
Just ask your AI assistant: / 直接告诉 AI 助手：
- "Format this messy JSON file" (美化这个杂乱的 JSON 文件)
- "Extract the 'id' field from results.json" (从 results.json 中提取 id 字段)
- "Minify this configuration for production" (为生产环境压缩此配置)

## Commands / 常用功能
### pretty
Format JSON with 2-space indentation.
```bash
bash scripts/script.sh pretty data.json
```

### get
Query specific data using dot notation (e.g. user.profile.0.id).
```bash
bash scripts/script.sh get data.json "items.0.name"
```

## Requirements
- bash 4+
- python3

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
