---
name: "clawhub-stats"
description: "BytesAgain internal tool: pull ClawHub download stats using account tokens, sync to Supabase, generate reports."
---

# clawhub-stats (内部自用)

用账号 token 拉取 ClawHub 完整下载量，写入 Supabase，生成报告。

## Commands

```bash
bash scripts/script.sh sync      # 同步所有自有skill下载量到Supabase
bash scripts/script.sh report    # 生成下载量报告（Top10 + 账号分布）
bash scripts/script.sh check     # 检查token有效性
bash scripts/script.sh help
```

## Requirements
- python3, requests
- .env 文件含 CLAWHUB_TOKEN_1~9 和 SUPABASE_SERVICE_KEY

Powered by BytesAgain | bytesagain.com
