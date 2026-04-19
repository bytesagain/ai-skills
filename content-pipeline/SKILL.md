---
name: content-pipeline
description: "Internal tool: run full content pipeline from a skill list — add use-cases to use-cases.ts + push, write HTML article to Supabase, generate tweet draft."
version: "1.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [internal, content, pipeline, automation]
---

# Content Pipeline (Internal Tool)

⚠️ **自用工具，不发 ClawHub。** 含内部路径、Supabase key、X API key。

从 skill 列表一键跑完三步：use-cases → 文章 → 推文草稿。

## Commands

### run
完整流水线（推荐）。

```bash
XAI_API_KEY=xai-xxx \
SUPABASE_URL=https://jfpeycpiyayrpjldppzq.supabase.co \
SUPABASE_KEY=eyJ... \
SITE_DIR=/home/admin/bytesagain-next \
bash scripts/script.sh run \
  --slugs "skill-a,skill-b,skill-c" \
  --topic "AI tools for X"
```

### usecase
只跑 Step 1：往 `lib/use-cases.ts` 加条目 + git push（触发 Vercel 部署）。

```bash
SITE_DIR=/home/admin/bytesagain-next \
bash scripts/script.sh usecase \
  --slugs "skill-a,skill-b" \
  --topic "topic string"
```

### article
只跑 Step 2：用 Grok 生成 HTML 文章 → 写入 Supabase articles 表。已存在自动跳过。

```bash
XAI_API_KEY=xai-xxx \
SUPABASE_URL=... SUPABASE_KEY=... \
bash scripts/script.sh article \
  --slugs "skill-a,skill-b" \
  --topic "topic string" \
  [--article-slug "custom-slug"]
```

### tweet
只跑 Step 3：用 Grok 生成推文草稿 → 追加到 `/tmp/x-drafts-YYYY-MM-DD.json`。

```bash
XAI_API_KEY=xai-xxx \
bash scripts/script.sh tweet \
  --url "https://bytesagain.com/article/slug" \
  --topic "topic string"
```

## Env Vars

| 变量 | 用于 | 说明 |
|------|------|------|
| XAI_API_KEY | article, tweet, run | Grok API key |
| SUPABASE_URL | article, run | Supabase 项目地址 |
| SUPABASE_KEY | article, run | Supabase service role key |
| SITE_DIR | usecase, run | bytesagain-next 本地路径（默认 /home/admin/bytesagain-next） |
| X_API_KEY / X_API_SECRET / X_ACCESS_TOKEN / X_ACCESS_TOKEN_SECRET | tweet(未用，草稿只存文件) | 暂不需要 |

## Output

- `usecase` → 改 use-cases.ts + push → Vercel 自动部署
- `article` → Supabase articles 表，URL: `https://bytesagain.com/article/<slug>`
- `tweet` → `/tmp/x-drafts-YYYY-MM-DD.json`（追加，用 x-monitor 发布）

## Notes

- use-case slug 自动从 topic 生成（小写+连字符）
- article slug 同上，可用 `--article-slug` 覆盖
- 重复检测：use-case 和 article 都会先 SELECT 确认不存在再写入
