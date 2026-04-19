---
name: "skill-publisher"
description: "BytesAgain skill 开发发布全流程工具。用于新建 skill 模板、发布前审核、发布到 ClawHub、同步到网站数据库。仅限内部使用。"
---

# skill-publisher

## Triggers on
发布skill, 新建skill, 审核skill, skill发布流程, publish skill, audit skill, sync skill to website

## 发布流程 v2.1

```
① 开发  →  ② 审核  →  ③ 发布  →  ④ 等审核  →  ⑤ 同步网站
```

## Commands

### create
新建 skill 模板。
```bash
bash scripts/script.sh create <slug> "<description>"
```

### audit
发布前完整审核（6大项17小项，全绿才发）。
```bash
bash scripts/script.sh audit <slug>
```

### publish
发布到 ClawHub（需先 audit 通过）。
```bash
bash scripts/script.sh publish <slug> <token_number> [version]
# token_number: 2=ckchzh 3=xueyetianya 4=bytesagain1 5=loutai0307-prog 7=bytesagain3 8=bytesagain-lab 9=PRESSBYTESAGAIN
```

### check
查询 ClawHub 审核状态（发布后5-10分钟）。
```bash
bash scripts/script.sh check <slug> [owner]
```

### sync
同步到网站数据库（立即上线，不等周一）。
```bash
bash scripts/script.sh sync <slug> [slug2 ...]
```

### full
一键完整流程：audit → publish → check → sync。
```bash
bash scripts/script.sh full <slug> <token_number>
```

### accounts
查看所有 ClawHub 账号状态。
```bash
bash scripts/script.sh accounts
```

### help
显示帮助。
```bash
bash scripts/script.sh help
```

## 标准文档
/home/admin/.openclaw/workspace/SKILL_STANDARD.md

关键章节：
- §11.16 高权限API策略（需要token的skill怎么写）
- §11.17 模板已知缺陷（create后必须修正的地方）
- §11.9 命令对齐规则
- §11.2 审核失败原因表

## Requirements
- bash 4+
- python3
- clawhub CLI
- curl

Powered by BytesAgain | bytesagain.com
